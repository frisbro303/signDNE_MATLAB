% set-up path:
clear; clc;
pathSetup();
% pathSetup(BaseDirectory) %or provide a specified base directory

% compute ariaDNE
values = zeros(6:3);
Options.distInfo = 'Euclidean';
Options.cutThresh = 0;
bandwidth = 0.08;

% Normal
meshname = 'normal.ply';
watertight_meshname = 'normal_watertight.ply';
H = ariaDNE(meshname, watertight_meshname, bandwidth, Options);

positives(1) = H.positiveDNE;
negatives(1) = H.negativeDNE;

% Low
meshname = 'low.ply';
watertight_meshname = 'low_watertight.ply';
H = ariaDNE(meshname, watertight_meshname, bandwidth, Options);

% High
positives(2) = H.positiveDNE;
negatives(2) = H.negativeDNE;

meshname = 'high.ply';
watertight_meshname = 'high_watertight.ply';
H = ariaDNE(meshname, watertight_meshname, bandwidth, Options);

positives(3) = H.positiveDNE;
negatives(3) = H.negativeDNE;

% 10^{-3} Noise
meshname = 'noise1.ply';
watertight_meshname = 'noise1_watertight.ply';
H = ariaDNE(meshname, watertight_meshname, bandwidth, Options);

positives(4) = H.positiveDNE;
negatives(4) = H.negativeDNE;

% 2*10^{-3} Noise
meshname = 'noise2.ply';
watertight_meshname = 'noise2_watertight.ply';
H = ariaDNE(meshname, watertight_meshname, bandwidth, Options);

positives(5) = H.positiveDNE;
negatives(5) = H.negativeDNE;

% Smooth
meshname = 'smooth.ply';
watertight_meshname = 'smooth_watertight.ply';
H = ariaDNE(meshname, watertight_meshname, bandwidth, Options);

positives(6) = H.positiveDNE;
negatives(6) = H.negativeDNE;

disp("positives:")
disp(positives);
disp("negatives:")
disp(negatives);
%writematrix(values', "positives.csv");
