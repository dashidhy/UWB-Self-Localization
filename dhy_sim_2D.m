clear all; close all; clc;

% Simulation parameters
num_nodes = 50;
n_std = 0.1;

% Generate ground truth (G.T.)
Cor_gt = 10 * rand(num_nodes, 2);
Cor_gt(1:4, :) = [10, 0; 10, 10; 0, 0; 0, 10];

% Adjacent matrix of G.T. 
Cor_square = sum(Cor_gt .^ 2, 2);
M_gt = sqrt((Cor_square - 2 * (Cor_gt * Cor_gt.')) + Cor_square.');

% Adjacent matrix of simulated measurement with Gaussion noise
noise = n_std * sqrt(2) * randn(num_nodes, num_nodes);
noise = ((noise + noise.') / 2) .* (1- eye(num_nodes));
M_sim = M_gt + noise;

% Comupte coordinates
[Cor_sim_r, count, ~] = dhy_MDS_Adam_2D(M_sim, 1e-5);
Ind = [1, 2, 3, 4];
[Cor_sim_a, count_c, ~] = dhy_Ctrans_2D(Cor_sim_r, Cor_gt(Ind, :), Ind, 1e-5);

% Some statistics
bias = sum(sqrt(sum((Cor_sim_a - Cor_gt) .^ 2, 2))) / num_nodes;

% Plot result
figure;
plot(Cor_gt(:, 1), Cor_gt(:, 2), 'ro', 'markersize', 6); hold on;
plot(Cor_gt(Ind, 1), Cor_gt(Ind, 2), 'go', 'Marker', 'square', 'markersize', 12, 'linewidth', 3.0); hold on;
plot(Cor_sim_a(:, 1), Cor_sim_a(:, 2), 'bx', 'markersize', 10); hold on;
axis equal;
axis([-0.5, 10.5, -0.5, 10.5]);
legend('Ground Truth', 'Anchor nodes', ['Sim, loc iter: ', num2str(count), ', trans iter: ', num2str(count_c)]);
title([num2str(num_nodes), ' nodes; Noise std: ', num2str(n_std * 100), ' cm; Avg bias: ', num2str(bias * 100), ' cm']);
