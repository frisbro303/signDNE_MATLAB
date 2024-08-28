% set-up path:
clear; clc;
pathSetup();
% pathSetup(BaseDirectory) %or provide a specified base directory

% compute ariaDNE
%values = zeros(6:3);
Options.distInfo = 'Geodesic';
Options.cutThresh = 0;
bandwidth = 0.08;

H = ariaDNE("data/smooth.ply", bandwidth, Options);
disp(H.DNE);
disp(H.positiveDNE);
disp(H.negativeDNE);