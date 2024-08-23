% set-up path:
clear; clc;
pathSetup();
% pathSetup(BaseDirectory) %or provide a specified base directory

% compute ariaDNE
%values = zeros(6:3);
Options.distInfo = 'Euclidean';
Options.cutThresh = 0;
bandwidth = 0.08;

H = ariaDNE("smooth.ply", bandwidth, Options);