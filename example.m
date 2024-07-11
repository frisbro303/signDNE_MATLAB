% set-up path:
clear; clc;
pathSetup();
% pathSetup(BaseDirectory) %or provide a specified base directory

% compute ariaDNE
Options.distInfo = 'Euclidean';
Options.cutThresh = 0;
meshname = 'normal.ply';
bandwidth = 0.08;
H = ariaDNE(meshname, bandwidth, Options);
%fprintf('ariaDNE for normal.ply is %f. \n', H.dne);
disp("normal:")
disp(H.dne)
disp("positive:");
disp(H.positiveDNE);
disp("negative:");
disp(H.negativeDNE);

%writematrix(H.localDNE, "localDNE.csv");
%dlmwrite('localDNE.csv', H.localDNE, 'precision', '%.15f');
meshname = 'low.ply';
bandwidth = 0.08;
H = ariaDNE(meshname, bandwidth, Options);
disp("low:")
disp(H.dne)
disp("positive:");
disp(H.positiveDNE);
disp("negative:");
disp(H.negativeDNE);


meshname = 'high.ply';
bandwidth = 0.08;
H = ariaDNE(meshname, bandwidth, Options);
disp("high:")
disp(H.dne)
disp("positive:");
disp(H.positiveDNE);
disp("negative:");
disp(H.negativeDNE);

meshname = 'smooth.ply';
bandwidth = 0.08;
H = ariaDNE(meshname, bandwidth, Options);
disp("smooth:")
disp(H.dne)
disp("positive:");
disp(H.positiveDNE);
disp("negative:");
disp(H.negativeDNE);
%fprintf('ariaDNE for smooth.ply is %f. \n', H.dne);

meshname = 'noise1.ply';
bandwidth = 0.08;
H = ariaDNE(meshname, bandwidth, Options);
disp("noise1:")
disp(H.dne)
disp("positive:");
disp(H.positiveDNE);
disp("negative:");
disp(H.negativeDNE);

meshname = 'noise2.ply';
bandwidth = 0.08;
H = ariaDNE(meshname, bandwidth, Options);
disp("noise2:")
disp(H.dne)
disp("positive:");
disp(H.positiveDNE);
disp("negative:");
disp(H.negativeDNE);



