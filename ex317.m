clear all; close all; clc;

% Load ground truth(in m)
gt = load('./data/GT317.mat');
GT = gt.GT;
[num_nodes, ~] = size(GT);

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
title(['Ground Truth, avg bias: ', num2str(100 * sqrt(L / (num_nodes * (num_nodes-1)))), ' cm']);

% Decode raw data
M_0 = decode('./data/dist317/dist317_0.dat');
M_1 = decode('./data/dist317/dist317_1.dat');
M_2 = decode('./data/dist317/dist317_2.dat');
M_3 = decode('./data/dist317/dist317_3.dat');
M_4 = decode('./data/dist317/dist317_4.dat');
M_5 = decode('./data/dist317/dist317_5.dat');
M_r = M_0 + M_1 + M_2 + M_3 + M_4 + M_5;

% Correct raw data
M_c = (Corr(M_r) ./ 100);


[Cor, ~, L] = dhy_adam(M_c, 'MDS');

% plot
figure;
plot(Cor_gt(:, 1), Cor_gt(:, 2), 'ro'); hold on;
plot(Cor(1, 1), Cor(1, 2), 'bx', 'linewidth', 2.0); hold on;
plot(Cor(2, 1), Cor(2, 2), 'rx', 'linewidth', 2.0); hold on;
plot(Cor(3, 1), Cor(3, 2), 'gx', 'linewidth', 2.0); hold on;
plot(Cor(4, 1), Cor(4, 2), 'mx', 'linewidth', 2.0); hold on;
plot(Cor(5, 1), Cor(5, 2), 'yx', 'linewidth', 2.0); hold on;
plot(Cor(6, 1), Cor(6, 2), 'cx', 'linewidth', 2.0); hold off;
axis equal;
axis([-1, 4, -1.5, 3.5]);
legend('GT', '0', '1', '2', '3', '4', '5');
title(['Ex data, avg bias: ', num2str(100 * sqrt(L / (num_nodes * (num_nodes-1)))), ' cm']);