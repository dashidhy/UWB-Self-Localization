clear all; close all; clc;

d2 = load('./statistics/statistics_2D.mat');
d3 = load('./statistics/statistics_3D.mat');

figure;
plot(d2.num_nodes, d2.iter_array, 'color', 'b', 'linewidth', 2.0); hold on;
plot(d3.num_nodes, d3.iter_array, 'color', 'm', 'linewidth', 2.0); hold off;
xlabel('Number of nodes')
ylabel('Number of iterrations (5000 times average)')
legend('2D','3D')
title('Iteration efficiency')

figure;
plot(d2.num_nodes, d2.time_array * 1000, 'color', 'b', 'linewidth', 2.0); hold on;
plot(d3.num_nodes, d3.time_array * 1000, 'color', 'm', 'linewidth', 2.0); hold off;
xlabel('Number of nodes')
ylabel('Time (in ms) consumed (5000 times average)')
legend('2D','3D')
title('Time efficiency')