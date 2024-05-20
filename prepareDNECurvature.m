% set-up path:
clear; clc;
%%
pathSetup();


load('W_colormap.mat');
load('CurvingMapFinal.mat');
load('H_colormap.mat');
load('CustomColormapbluered.mat');



IDList = [1 2 3 4 5 6];
nIDs = length(IDList);
mesh_names = {'normal', 'low', 'high', 'smooth', '10^{-3} noise', '2 \cdot 10^{-3} noise'};

positiveDNEs = zeros(nIDs, 1);
negativeDNEs = zeros(nIDs, 1);

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

    G.Centralize('ScaleArea');

    H = ariaDNE(G, bandwidth, Options);
    positiveDNEs(idCnt) = H.positiveDNE;
    negativeDNEs(idCnt) = H.negativeDNE;
    
    % Patch the tooth
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


