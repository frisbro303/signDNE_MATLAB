% set-up path:
clear; clc;
%%
pathSetup();
% pathSetup(BaseDirectory) %or provide a specified base directory


%noise_level = 0.05;%0.001;
% load mesh


load('W_colormap.mat');
load('CurvingMapFinal.mat');
load('H_colormap.mat');
load('CustomColormapbluered.mat');


%%
% new dne
% figure;
%colormap(jet(4096));

IDList = [1 2 3 4 5 6];
nIDs = length(IDList);
mesh_names = {'normal', 'low', 'high', 'smooth', '10^{-3} noise', '2 \cdot 10^{-3} noise'};

positiveDNEs = zeros(nIDs, 1);
negativeDNEs = zeros(nIDs, 1);
%DNEratio = zeros(nIDs,1);
%smoothDNEratio = zeros(nIDs,1);

t = tiledlayout(1, 6, "TileSpacing", "tight");
noise_level = 0.001 * [1:3];
for idCnt = 1:nIDs
    disp(idCnt)
    if idCnt < 5
        load(sprintf('G%d.mat',idCnt));
    else
        load('G1.mat');
        NV = G.V + noise_level(idCnt-4) * randn(size(G.V));
        G = Mesh('VF', NV, G.F);
    end
    
    % compute ARIADNE
    Options.distInfo = 'Geodeisic';
    Options.cutThresh = 0;
    bandwidth = 0.06;
    %Options.smoothing = 1;
    %meshname = [mesh_names(idCnt) '.ply'];

    G.Centralize('ScaleArea');

    H = ariaDNE(G, bandwidth, Options);
    disp(H.dne);
    positiveDNEs(idCnt) = H.positiveDNE;
    negativeDNEs(idCnt) = H.negativeDNE;
    
    
   
    %subplot(1, 6, idCnt)
    %tight_subplot(1, 6, [0.3, 0.3]);
    nexttile
    
    hP = patch('vertices',G.V','faces',G.F');
    
    hP.FaceVertexCData = H.signed_localDNE;
    hP.EdgeColor = 'none';
    hP.FaceColor = 'interp';

    axis off;

    axis equal;
    cameratoolbar;

    lighting phong;
    camlight('headlight');
    camlight(180,0);

    hDNE(1,idCnt) = gca;
end

linkPropH = linkprop(hDNE(:), {'CameraUpVector', 'CameraPosition', 'CameraTarget', 'CameraViewAngle', 'ColorMap'});
% hDNE(2,1).CLim = [0 2000];


%linkPropCLim = linkprop(hDNE(:), 'CLim');
%hDNE(2,1).CLim = [0 2000];
%colormap(H_colormap);
%
colormap(CustomColormapbluered)

positiveDNE_norm = positiveDNEs/positiveDNEs(1);
negativeDNE_norm = negativeDNEs/negativeDNEs(1);
%%
figure;
bar(mesh_names, positiveDNE_norm)

legend('positive');

figure;
bar(mesh_names, negativeDNE_norm)

legend('negative');
%colormap(winter);
%colormap(H_colormap);

