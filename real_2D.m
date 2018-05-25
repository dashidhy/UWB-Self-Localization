clear all; close all; clc;

load('./data/data525.mat');
plot(Cor_a(:, 1), Cor_a(:, 2), 'ro', 'markersize', 8, 'linewidth', 1.2); hold on;
plot(Cor_gt(:, 1), Cor_gt(:, 2), 'bx', 'markersize', 12, 'linewidth', 2.0); hold off;
axis equal;
axis([-5, 8, -1, 7.5]);
title('A real test');
legend('Located', 'Ground Truth');
xlabel('m');
ylabel('m');
bias = sqrt(sum((Cor_a - Cor_gt) .^ 2, 2));
text(Cor_gt(1,1) - 2, Cor_gt(1, 2) + 0.5, ['bias 0: ', num2str(bias(1)*100), ' cm']);
text(Cor_gt(2,1) - 1, Cor_gt(2, 2) + 0.5, ['bias 1: ', num2str(bias(2)*100), ' cm']);
text(Cor_gt(3,1) - 1, Cor_gt(3, 2) + 0.5, ['bias 2: ', num2str(bias(3)*100), ' cm']);
text(Cor_gt(4,1) - 2, Cor_gt(4, 2) + 0.5, ['bias 3: ', num2str(bias(4)*100), ' cm']);
text(Cor_gt(5,1) - 1, Cor_gt(5, 2) + 0.5, ['bias 4: ', num2str(bias(5)*100), ' cm']);
text(Cor_gt(6,1) - 2, Cor_gt(6, 2) + 0.5, ['bias 5: ', num2str(bias(6)*100), ' cm']);