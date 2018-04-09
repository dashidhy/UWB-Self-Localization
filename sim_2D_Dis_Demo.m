clear all; close all; clc;

% Simulation parameters
num_nodes = 1000;
n_std = 0.1;

% Generate ground truth (G.T.)
Cor_gt = 100 * rand(num_nodes, 2);
Cor_gt(1:4, :) = [100, 0; 100, 100; 0, 0; 0, 100];

% Adjacent matrix of G.T. 
M_gt = zeros(num_nodes);

for i = 1:(num_nodes-1)
    for j = (i+1):num_nodes
        
        M_gt(i, j) = sqrt(sum((Cor_gt(i, :) - Cor_gt(j, :)) .^ 2));
        M_gt(j, i) = M_gt(i, j);
        
    end    
end

% Adjacent matrix of simulated measurement with Gaussion noise
noise = n_std * sqrt(2) * randn(num_nodes, num_nodes);
noise = ((noise + noise.') / 2) .* (1- eye(num_nodes));
M_sim = M_gt + noise;

% Comupte coordinates
t = tic;
Cor_sim_r = dhy_MDS_Adam_2D_Dis_Demo(M_sim, 32, 5, 1e-5);
Ind = [1, 2, 3, 4];
Cor_sim_a = dhy_Ctrans_ICP(Cor_sim_r, Cor_gt(Ind, :), Ind);
t_e = toc(t);

% Some statistics
bias = sum(sqrt(sum((Cor_sim_a - Cor_gt) .^ 2, 2))) / num_nodes;

% Plot result
figure;
plot(Cor_gt(:, 1), Cor_gt(:, 2), 'ro', 'markersize', 6); hold on;
plot(Cor_gt(Ind, 1), Cor_gt(Ind, 2), 'go', 'Marker', 'square', 'markersize', 12, 'linewidth', 3.0); hold on;
plot(Cor_sim_a(:, 1), Cor_sim_a(:, 2), 'bx', 'markersize', 10); hold on;
axis equal;
axis([-0.5, 100.5, -0.5, 100.5]);
legend('Ground Truth', 'Anchor nodes', ['Sim, ', num2str(t_e), ' s']);
title([num2str(num_nodes), ' nodes; Noise std: ', num2str(n_std * 100), ' cm; Avg bias: ', num2str(bias * 100), ' cm']);
