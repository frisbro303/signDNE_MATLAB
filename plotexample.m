% set-up path:
clear; clc;
%%
pathSetup();
% pathSetup(BaseDirectory) %or provide a specified base directory

% load mesh
meshname = 'data.ply';
G = Mesh('ply', meshname);
G.remove_unref_verts;
G.remove_zero_area_faces;
G.DeleteIsolatedVertex;


% compute ARIADNE
Options.distInfo = 'Geodesic';
Options.cutThresh = 0;
bandwidth = 0.08;
H = ariaDNE(meshname, bandwidth, Options);
fprintf('ariaDNE for normal.ply is %f. \n', H.DNE);
fprintf('Positive DNE for data.ply is %f. \n', H.positiveDNE);
fprintf('Negative DNE for data.ply is %f. \n', H.negativeDNE);

red = [0 0 1];    % Blue
white = [247 240 213]./255;
blue = [1 0 0];    % Red

% Number of colors in the colormap
num_colors = 256;

% Create linear interpolation
% Interpolate between color1 and color2
first_half = interp1([0, 0.5], [red; white], linspace(0, 0.5, num_colors/2), 'linear');

% Interpolate between color2 and color3
second_half = interp1([0.5, 1], [white; blue], linspace(0.5, 1, num_colors/2), 'linear');

% Combine the two halves
CustomColormapbluered = [first_half; second_half];


colormap_min = 0;   % Minimum value of the colormap range
colormap_max = 100;

figure;
hP = patch('Faces', G.F', 'Vertices', G.V', 'FaceVertexCData', H.curvature, 'FaceColor','interp');
hP.EdgeColor = 'none';
colormap(CustomColormapbluered)
axis off;
axis equal;
cameratoolbar;
lighting phong;
camlight('headlight');

camlight(180,0);
caxis([min(H.curvature) max(H.curvature)]);
%caxis([min(H.localDNE)*0.4 max(H.localDNE)]);


