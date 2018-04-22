clear all; close all; clc;

num_nodes = 30;
noise_std = 0.5;
range = 10;

G = CNet(num_nodes, 2);
[iter, time] = G.Simulate(noise_std, range);

figure;
plot(G.Loc_gt(:, 1), G.Loc_gt(:, 2), 'ro', 'markersize', 6); hold on;
plot(G.Loc_anchor(:, 1), G.Loc_anchor(:, 2), 'go', 'Marker', 'square', 'markersize', 12, 'linewidth', 3.0); hold on;
plot(G.Loc_cp(:, 1), G.Loc_cp(:, 2), 'bx', 'markersize', 10); hold on;
axis equal;
axis([-0.5, G.Range + 0.5, -0.5, G.Range + 0.5]);
legend('Ground Truth', 'Anchor nodes', 'Sim');
title([num2str(G.Num_nodes), ' nodes; Noise std: ', num2str(G.Noise_std * 100), ' cm; Avg bias: ', num2str(G.Bias .* 100), ' cm']);

disp('2D simulation:');
disp(['Iteration: ', num2str(iter)]);
disp(['Time: ', num2str(time), ' s']);
disp(' ');

G.Reset(num_nodes, 3);
[iter, time] = G.Simulate(noise_std, range);

figure;
plot3(G.Loc_gt(:, 1), G.Loc_gt(:, 2), G.Loc_gt(:, 3), 'ro', 'markersize', 6); hold on;
plot3(G.Loc_anchor(:, 1), G.Loc_anchor(:, 2), G.Loc_anchor(:, 3), 'go', 'Marker', 'square', 'markersize', 12, 'linewidth', 3.0); hold on;
plot3(G.Loc_cp(:, 1), G.Loc_cp(:, 2), G.Loc_cp(:, 3), 'bx', 'markersize', 10); hold on;
axis equal;
axis([-0.5, G.Range + 0.5, -0.5, G.Range + 0.5, -0.5, G.Range + 0.5]);
legend('Ground Truth', 'Anchor nodes', 'Sim');
title([num2str(G.Num_nodes), ' nodes; Noise std: ', num2str(G.Noise_std * 100), ' cm; Avg bias: ', num2str(G.Bias .* 100), ' cm']);

disp('3D simulation:');
disp(['Iteration: ', num2str(iter)]);
disp(['Time: ', num2str(time), ' s']);
disp(' ');