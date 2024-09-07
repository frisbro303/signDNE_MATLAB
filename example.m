% set-up path:
clear; clc;
pathSetup();
% pathSetup(BaseDirectory) %or provide a specified base directory

% compute ariaDNE
Options.distInfo = 'Euclidean';
Options.cutThresh = 0;
bandwidth = 0.08;

H = ariaDNE("data/normal.ply", bandwidth, Options);
disp(H.DNE);
disp(H.positiveDNE);
disp(H.negativeDNE);