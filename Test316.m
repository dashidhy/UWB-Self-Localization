clear all; close all; clc;

% Load ground truth(in cm)
gt = load('./data/GT316.mat');
GT = gt.GT;
[num_nodes, ~] = size(GT);

% Convert to m
GT = GT ./ 100;

% Comput relative coordinates
[Cor_gt, count, L] = dhy_adam(GT, 'MDS');


% plot
figure;
plot(Cor_gt(1, 1), Cor_gt(1, 2), 'bo', 'linewidth', 2.0); hold on;
plot(Cor_gt(2, 1), Cor_gt(2, 2), 'ro', 'linewidth', 2.0); hold on;
plot(Cor_gt(3, 1), Cor_gt(3, 2), 'go', 'linewidth', 2.0); hold on;
plot(Cor_gt(4, 1), Cor_gt(4, 2), 'mo', 'linewidth', 2.0); hold on;
plot(Cor_gt(5, 1), Cor_gt(5, 2), 'yo', 'linewidth', 2.0); hold on;
plot(Cor_gt(6, 1), Cor_gt(6, 2), 'co', 'linewidth', 2.0); hold off;
axis equal;
axis([-1, 4, -1.5, 3.5]);
legend('0', '1', '2', '3', '4', '5');
title(['Ground Truth, avg bias: ', num2str(100 * sqrt(L / num_nodes)), ' cm']);
count