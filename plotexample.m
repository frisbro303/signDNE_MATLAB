% set-up path:
clear; clc;
%%
pathSetup();
% pathSetup(BaseDirectory) %or provide a specified base directory

% load mesh
meshname = 'data7.ply';
G = Mesh('ply', meshname);G.remove_unref_verts;
G.remove_zero_area_faces;
G.DeleteIsolatedVertex;

load('signedDNE.mat');

% compute ARIADNE
Options.distInfo = 'Geodeisic';
Options.cutThresh = 0;
bandwidth = 0.08;
H = ariaDNE(meshname, bandwidth, Options);
fprintf('ARIADNE for data.ply is %f. \n', H.dne);
fprintf('Positive DNE for data.ply is %f. \n', H.positiveDNE);
fprintf('Negative DNE for data.ply is %f. \n', H.negativeDNE);


figure;
hP = patch('Faces', G.F', 'Vertices', G.V', 'FaceVertexCData', H.localDNE, 'FaceColor','interp');
hP.EdgeColor = 'none';
colormap(CustomColormapbluered)
axis off;
axis equal;
cameratoolbar;
lighting phong;
camlight('headlight');

camlight(180,0);
%caxis([min(H.localDNE) 0.2*max(H.localDNE)]);
caxis([min(H.localDNE)*0.4 max(H.localDNE)]);


