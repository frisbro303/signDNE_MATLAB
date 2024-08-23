% This is an example computing ariaDNE for a user-specified folder

% set-up path:
clear; clc;
pathSetup();
% pathSetup(BaseDirectory) %or provide a specified base directory

% compute ARIADNE
Options.distInfo = 'Euclidean';
Options.cutThresh = 0;
foldername = [pwd '/data'];
bandwidth = 0.08;
result = computeDNEfolder(foldername, bandwidth, Options);
disp(result);
save('result.m', 'result')
fprintf('Computation is complete. Results are saved in result.m');

