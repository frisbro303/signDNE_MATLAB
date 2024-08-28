function [H] = ariaDNE(meshname, bandwidth, Options)

% This function computes the ariaDNE value of a mesh surface.
% ariaDNE is a robustly implemented algorithm for Dirichlet Normal
% Energy, which measures how much a surface deviates from a plane.


% default options
H.Opts.distInfo = 'Geodeisic';
H.Opts.distance = [];
H.Opts.bandwidth = bandwidth;
H.Opts.cutThresh = 0;
H.Opts.smoothing = 0;

if(nargin < 2)
    bandwidth = [];
    Options = struct();
end

if(isempty(bandwidth))
    bandwidth = 0.08;
end

% load user specified options
fn = fieldnames(Options);
for j = 1 : length(fn)
    name = fn{j};
    value = getfield(Options,name);
    
    if       strcmpi(name,'distance')      H.Opts.distance = value;
    elseif   strcmpi(name,'distInfo')      H.Opts.distInfo = value;
    elseif   strcmpi(name,'cutThresh')     H.Opts.cutThresh = value;
    %elseif   strcmpi(name,'smoothing')     H.Opts.smoothing = value;
    else     fprintf('ARIADNE.m: invalid options "%s" ignored. \n', name);
    end
end


parts = split(meshname, '.');

G = Mesh('ply', meshname);
watertight_meshname = parts{1} + "_watertight." + parts{2};

filePath = which(watertight_meshname);
if ~isempty(filePath)
    G_watertight = Mesh('ply', filePath);
else
    G_watertight = G;
end

Centralize(G, G_watertight, 'ScaleArea');

watertight_points = G_watertight.V';
watertight_faces = G_watertight.F';


py.importlib.import_module('numpy');

py.importlib.import_module('trimesh');

numpy_vertices = py.numpy.array(watertight_points);

numpy_faces = py.numpy.array(watertight_faces - 1); % Convert to 0-based indexing for Python

% Create a Trimesh mesh instance
mesh_watertight = py.trimesh.Trimesh(numpy_vertices, numpy_faces);



% mesh preparation: centeralize, normalize the mesh to have surface area 1,
% compute an initial estimate of normals 

[~, face_area] = ComputeSurfaceArea(G);
vert_area = (face_area'*G.F2V)/3;
[vnorm, ~] = ComputeNormal(G);
if size(vnorm,1) < size(vnorm,2)
    vnorm = vnorm';
end

points = G.V';

numPoints = G.nV;

normals = zeros(numPoints,3);
curvature = zeros(numPoints,1);
curvature_nn = zeros(numPoints,1);

% compute or load pairwise distnace
if isempty(H.Opts.distance) 
    if strcmpi(H.Opts.distInfo, 'Geodesic') 
        d_dist = distances(graph(Triangulation2AdjacencyWeighted(G))); % compatible with the latest Matlab version
        %d_dist = graphallshortestpaths(Triangulation2AdjacencyWeighted(G)); % works for Matlab 2020a and before
    elseif strcmpi(H.Opts.distInfo, 'Euclidean')
        d_dist = squareform(pdist(points));
    else
        fprintf('ARIADNE.m: invalid distInfo options "%s" ignored. \n', H.Opts.distInfo);
    end
else 
    d_dist = H.Opts.distance;
end

% define the weight matrix
K = exp(-d_dist.^2/(bandwidth^2));

% for each vertex in the mesh, estimate its curvature via PCA
for jj = 1:numPoints
    neighbour = find(K(jj,:) > H.Opts.cutThresh);
    numNeighbours = length(neighbour);
    if numNeighbours <= 3
     fprintf('ARIADNE.m: Too few neighbor on vertex %d. \n', jj);
    end
    p = repmat(points(jj,1:3),numNeighbours,1) - points(neighbour,1:3);
    w = K(jj, neighbour);

    % build covariance matrix for PCA
    C = zeros(1,6);
    C(1) = sum(p(:,1).*(w').*p(:,1),1);
    C(2) = sum(p(:,1).*(w').*p(:,2),1);
    C(3) = sum(p(:,1).*(w').*p(:,3),1);
    C(4) = sum(p(:,2).*(w').*p(:,2),1);
    C(5) = sum(p(:,2).*(w').*p(:,3),1);
    C(6) = sum(p(:,3).*(w').*p(:,3),1);
    C = C ./ sum(w);
    
    Cmat = [C(1) C(2) C(3);...
        C(2) C(4) C(5);...
        C(3) C(5) C(6)];

    
    % compute its eigenvalues and eigenvectors
    [v,d] = eig(Cmat);
    d = diag(d);
    
    % find the eigenvector that is closest to the vertex normal 
    v_aug = [v -v];
    diff = v_aug - repmat(vnorm(jj,:)',1,6);
    q = sum(diff.^2,1);
    [~,k] = min(q);
    
    % use that eigenvector to give an updated estimate to the vertex normal
    normals(jj,:) = v_aug(:,k)';
    k = mod(k-1,3)+1;

    % determine the sign of the curvature
    neighbour_centroid = sum(points(neighbour, 1:3).*(w'))./sum(w);

    numpy_centroid = py.numpy.array(neighbour_centroid, pyargs('dtype', 'float64'));
    
    % Check if the point is inside the mesh
    inside = mesh_watertight.ray.contains_points(py.list({numpy_centroid}));
    
    inside = double(py.array.array('d', py.numpy.nditer(inside)));
    % Convert the result to MATLAB data type
    
    inside = inside*2 - 1;
    
    % use the eigenvalue of that eigenvector to estimate the curvature
    lambda = d(k);
    curvature(jj) = (lambda/sum(d))*inside;
    curvature_nn(jj) = (nnz(w>max(w)*1e-4))*inside;
end

localDNE = curvature.*vert_area';

positive_indices = localDNE>0;
negative_indices = localDNE<0;


H.DNE = sum(abs(localDNE));
H.positiveDNE = sum(localDNE(positive_indices));
H.negativeDNE = sum(localDNE(negative_indices));
H.localDNE = localDNE;
H.curvature = curvature;
end

