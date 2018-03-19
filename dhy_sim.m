clear all; close all; clc;

num_nodes = 50;
Cor_gt = 10 * rand(num_nodes, 2);
Cor_gt(1:4, :) = [0, 0; 10, 0; 10, 10; 0, 10];

Cor_square = sum(Cor_gt .^ 2, 2);
M_gt = sqrt((Cor_square - 2 * (Cor_gt * Cor_gt.')) + Cor_square.');

n_std = 0.2;
noise = n_std * sqrt(2) * randn(num_nodes, num_nodes);
noise = ((noise + noise.') / 2) .* (1- eye(num_nodes));
M_sim = M_gt + noise;

[Cor_sim_r, count, L] = dhy_adam(M_sim, 'MDS');
Ind = [1, 2, 3, 4, 5, 6];
Cor_sim_a = Ctrans(Cor_sim_r, Cor_gt(Ind, :), Ind);
bias = sum(sqrt(sum((Cor_sim_a - Cor_gt) .^ 2, 2))) / num_nodes;

% plot
figure;
plot(Cor_gt(:, 1), Cor_gt(:, 2), 'ro', 'markersize', 4); hold on;
plot(Cor_gt(Ind, 1), Cor_gt(Ind, 2), 'go', 'Marker', 'square', 'markersize', 12, 'linewidth', 3.0); hold on;
plot(Cor_sim_a(:, 1), Cor_sim_a(:, 2), 'bx', 'markersize', 8); hold on;
axis equal;
axis([-0.5, 10.5, -0.5, 10.5]);
legend('GT', 'Anchor nodes', ['Sim, iter: ', num2str(count)]);
title([num2str(num_nodes), ' nodes; Noise std: ', num2str(n_std * 100), ' cm; Avg bias: ', num2str(bias * 100), ' cm']);