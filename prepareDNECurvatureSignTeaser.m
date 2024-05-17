% set-up path:
clear; clc;
%%
pathSetup();
% pathSetup(BaseDirectory) %or provide a specified base directory

% load mesh
meshname = 'normal.ply';
G = Mesh('ply', meshname);G.remove_unref_verts;
G.remove_zero_area_faces;
G.DeleteIsolatedVertex;

% compute ARIADNE
Options.distInfo = 'Geodeisic';
Options.cutThresh = 0;
bandwidth = 0.08;
H = ariaDNE(meshname, bandwidth, Options);
fprintf('ARIADNE for data.ply is %f. \n', H.dne);
fprintf('Positive DNE for data.ply is %f. \n', H.positiveDNE);
fprintf('Negative DNE for data.ply is %f. \n', H.negativeDNE);


G.Centralize('ScaleArea');

load('W_colormap.mat');
load('H_colormap.mat');
%%
% new dne
figure;

disp(H_colormap);

curve_colormap = [0 0 0;
                  0 1 0.4];
colormap(curve_colormap);

hP = patch('vertices',G.V','faces',G.F');
hP.FaceVertexCData = H.curvature.*H.curveSigns;
%hP.FaceVertexCData = H.curveSigns;
hP.EdgeColor = 'none';
hP.FaceColor = 'flat';
%hP.SpecularStrength = SpecularStrength;

axis off;
axis equal;
cameratoolbar;

lighting phong;
camlight('headlight');
camlight(180,0);