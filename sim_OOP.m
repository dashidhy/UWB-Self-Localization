clear all; close all; clc;

G = SimNets(50, 2);
[iter, ~] = G.Simulate(0.1, 10);

figure;
plot(G.Loc_gt(:, 1), G.Loc_gt(:, 2), 'ro', 'markersize', 6); hold on;
plot(G.Loc_anchor(:, 1), G.Loc_anchor(:, 2), 'go', 'Marker', 'square', 'markersize', 12, 'linewidth', 3.0); hold on;
plot(G.Loc_cp(:, 1), G.Loc_cp(:, 2), 'bx', 'markersize', 10); hold on;
axis equal;
axis([-0.5, G.Range + 0.5, -0.5, G.Range + 0.5]);
legend('Ground Truth', 'Anchor nodes', ['Sim, loc iter: ', num2str(iter)]);
title([num2str(G.Num_nodes), ' nodes; Noise std: ', num2str(G.Noise_std * 100), ' cm; Avg bias: ', num2str(G.Bias .* 100), ' cm']);


G.Reset(50, 3);
[iter, ~] = G.Simulate(0.1, 10);

% Plot result
figure;
plot3(G.Loc_gt(:, 1), G.Loc_gt(:, 2), G.Loc_gt(:, 3), 'ro', 'markersize', 6); hold on;
plot3(G.Loc_anchor(:, 1), G.Loc_anchor(:, 2), G.Loc_anchor(:, 3), 'go', 'Marker', 'square', 'markersize', 12, 'linewidth', 3.0); hold on;
plot3(G.Loc_cp(:, 1), G.Loc_cp(:, 2), G.Loc_cp(:, 3), 'bx', 'markersize', 10); hold on;
axis equal;
axis([-0.5, G.Range + 0.5, -0.5, G.Range + 0.5, -0.5, G.Range + 0.5]);
legend('Ground Truth', 'Anchor nodes', ['Sim, loc iter: ', num2str(iter)]);
title([num2str(G.Num_nodes), ' nodes; Noise std: ', num2str(G.Noise_std * 100), ' cm; Avg bias: ', num2str(G.Bias .* 100), ' cm']);