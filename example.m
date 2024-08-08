% set-up path:
clear; clc;
pathSetup();
% pathSetup(BaseDirectory) %or provide a specified base directory

% compute ariaDNE
%values = zeros(6:3);
Options.distInfo = 'Euclidean';
Options.cutThresh = 0;
bandwidth = 0.08;

mesh_names = ["normal", "low", "high", "noise1", "noise2", "smooth"]

for i = 3:length(mesh_names)
    meshname = mesh_names(i) + ".ply";
    watertight_meshname = mesh_names(i) + "_watertight.ply";
    H = ariaDNE(meshname, watertight_meshname, bandwidth, Options);
    DNEs(i) = H.dne;
    positives(i) = H.positiveDNE;
    negatives(i) = H.negativeDNE;
end

DNEs = round(DNEs, 4);
positives = round(positives, 4);
negatives = round(negatives, 4);

disp("DNEs:");
disp(DNEs);

disp("positives:");
disp(positives);

disp("negatives:");
disp(negatives);

%writematrix(values', "positives.csv");
