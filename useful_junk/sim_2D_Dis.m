clear all; close all; clc;

global M;
global Ind;

% Simulation parameters
num_nodes = 1000;
Cor = zeros(num_nodes, 2);
n_std = 0.1;
range = 40;

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

% Adjacent matrix of simulated measurement with Gaussion noise and limited communication range
noise = n_std * sqrt(2) * randn(num_nodes, num_nodes);
noise = ((noise + noise.') / 2) .* (1- eye(num_nodes));
M = M_gt + noise;
figure;
imshow(M == -1);
M(M > range) = -1;
figure;
imshow(M == -1);
Ind = 1:num_nodes;

size_sub = 20;
overlap = 4;

% Reconstruct M
Ind_c = dhy_2D_Dis2(size_sub, overlap);

figure;
imshow(M == -1);

flag = 0;

for i = 1:length(Ind_c(:, 1))
    
    s = Ind_c(i, 1);
    e = Ind_c(i, 2);
    
    if s < flag
        
        [Cor_t, ~, ~] = dhy_MDS_Adam_2D(M(s:e, s:e), 1e-5);
        Cor_t = dhy_Ctrans_ICP(Cor_t, Cor(s:(s + overlap -1), :), 1:overlap);
        
    elseif (e - s) > (overlap -1)
        
        [Cor_t, ~, ~] = dhy_MDS_Adam_2D(M(s:e, s:e), 1e-5);
        Cor_a = zeros(overlap, 2);
        
        for j = s:(s + overlap - 1)
            
            
            
        end
        
        Cor_t = dhy_Ctrans_ICP(Cor_t, Cor_a, 1:overlap);
        
    end
    
    Cor(s:e, :) = Cor_t;
    flag = e;
    
end

Ind_a = [find(Ind == 1), find(Ind == 2), find(Ind == 3), find(Ind == 4)];
Cor = dhy_Ctrans_ICP(Cor, Cor_gt([1, 2, 3, 4], :), Ind_a);

% Some statistics
bias = sum(sqrt(sum((Cor - Cor_gt) .^ 2, 2))) / num_nodes;

% Plot result
figure;
plot(Cor_gt(:, 1), Cor_gt(:, 2), 'ro', 'markersize', 6); hold on;
plot(Cor_gt([1, 2, 3, 4], 1), Cor_gt([1, 2, 3, 4], 2), 'go', 'Marker', 'square', 'markersize', 12, 'linewidth', 3.0); hold on;
plot(Cor(:, 1), Cor(:, 2), 'bx', 'markersize', 10); hold on;
axis equal;
axis([-0.5, 100.5, -0.5, 100.5]);
legend('Ground Truth', 'Anchor nodes', ['Sim, ', num2str(t_e), ' s']);
title([num2str(num_nodes), ' nodes; Noise std: ', num2str(n_std * 100), ' cm; Avg bias: ', num2str(bias * 100), ' cm']);
