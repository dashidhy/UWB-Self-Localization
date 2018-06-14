clear all; close all; clc;

d2 = load('./statistics/statistics_2D.mat');
d3 = load('./statistics/statistics_3D.mat');

figure;
plot(d2.num_nodes, d2.iter_array, 'b', 'linewidth', 2.0); hold on;
plot(d3.num_nodes, d3.iter_array, 'm', 'linewidth', 2.0); hold off;
xlabel('Number of nodes')
ylabel('Number of iterrations (5000 times average)')
legend('2D','3D')
title('Iteration efficiency')

figure;
plot(d3.num_nodes(1:5), d3.time_array_sgd * 1000, 'm--', 'linewidth', 2.0); hold on;
plot(d2.num_nodes(1:5), d2.time_array_sgd * 1000, 'b--', 'linewidth', 2.0); hold on;
plot(d3.num_nodes, d3.time_array * 1000, 'm', 'linewidth', 2.0); hold on;
plot(d2.num_nodes, d2.time_array * 1000, 'b', 'linewidth', 2.0); hold off;
xlabel('Number of nodes')
ylabel('Time (in ms) consumed (5000 times average)')
legend('3D, GD with LR decay', '2D, GD with LR decay', '3D, Adam','2D, Adam')
title('Time efficiency')
axis([10, 100, 0, 50]);

figure;
plot(d3.num_nodes, d3.max_array .* 100, 'm--', 'linewidth', 2.0); hold on;
plot(d2.num_nodes, d2.max_array .* 100, 'b--', 'linewidth', 2.0); hold on;
plot(d3.num_nodes, d3.avg_array .* 100, 'm', 'linewidth', 2.0); hold on;
plot(d2.num_nodes, d2.avg_array .* 100, 'b', 'linewidth', 2.0); hold off;
xlabel('Number of nodes')
ylabel('Bias (cm) (5000 times average)')
legend('3D max bias','2D max bias', '3D avg bias','2D avg bias')
title('Localization Bias (respects to nodes)')