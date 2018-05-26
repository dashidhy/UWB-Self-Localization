clear all; close all; clc;

% Initial
Index_anchor = 1:4;
Loc_anchor = [10, 0; 10, 10; 0, 10; 0, 0];
Loc_tag = [8, 5; 5, 8; 2, 5; 5, 2];
Loc_tag2 = [-1, 0] + Loc_tag;
center = [5, 5];
num_node = 1;

Noise_std = 0.05;
Num_nodes = length(Loc_anchor) + length(Loc_tag) + length(Loc_tag2);
Dim = 2;

vel_c = [0.5, 0]; % m/s
vel_r = 0.3; % rad/s
vel_r2 = -0.6; % rad/s

frame = 150; % fps
sim_time = 36; % s

R = [cos(vel_r ./ frame), -sin(vel_r ./ frame); sin(vel_r ./ frame), cos(vel_r ./ frame)];
R2 = [cos(vel_r2 ./ frame), -sin(vel_r2 ./ frame); sin(vel_r2 ./ frame), cos(vel_r2 ./ frame)];

G = CNet(Num_nodes, Dim);
h_fig = figure('Visible', 'on');

r = 0.5;
p = 0.0001;
x_k_1 = zeros(Num_nodes, Dim);
x_k_2 = zeros(Num_nodes, Dim);

x_bias = zeros(1, frame * sim_time);
y_bias = zeros(1, frame * sim_time);
x_bias_1 = zeros(1, frame * sim_time);
y_bias_1 = zeros(1, frame * sim_time);

for i = 1:(frame * sim_time)
    
    e = 0;

    Loc_gt = [Loc_anchor; Loc_tag; Loc_tag2];
    Cor_square = sum(Loc_gt .^ 2, 2);
    M_gt = (-2 .* (Loc_gt * Loc_gt.') + Cor_square) + Cor_square.';
    M_gt(M_gt < 0) = 0;
    M_gt = sqrt(M_gt);
    noise = Noise_std .* sqrt(2) .* randn(Num_nodes, Num_nodes);
    noise = ((noise + noise.') ./ 2) .* (1 - eye(Num_nodes));
    G.M = M_gt + noise;
    G.Loc_anchor = Loc_anchor;
    G.Index_anchor = Index_anchor;
    
    try
        
        G.Localize();
        
    catch
        
        e = 1;
        
    end
    
    if i > 2
        
        x_k = 2 .* x_k_1 - x_k_2;
        p = 4 * p;
        
        g = p / (p + r);
        
        if e == 1
            
            G.Loc_cp = x_k;
            x_bias_1(i) = G.Loc_cp(num_node, 1) - Loc_gt(num_node, 1);
            y_bias_1(i) = G.Loc_cp(num_node, 2) - Loc_gt(num_node, 2);
            
        else
            
            x_bias_1(i) = G.Loc_cp(num_node, 1) - Loc_gt(num_node, 1);
            y_bias_1(i) = G.Loc_cp(num_node, 2) - Loc_gt(num_node, 2);
            G.Loc_cp = g .* x_k + (1 - g) .* G.Loc_cp;
            
        end
        p = (1 - g) * p;
        
    end
    
    x_k_2 = x_k_1;
    x_k_1 = G.Loc_cp;
    
    x_bias(i) = G.Loc_cp(num_node, 1) - Loc_gt(num_node, 1);
    y_bias(i) = G.Loc_cp(num_node, 2) - Loc_gt(num_node, 2);
    
    Loc_tag2 = (Loc_tag2 - Loc_tag) * R2;
    Loc_tag = (Loc_tag - center) * R + center;
    Loc_anchor = Loc_anchor + vel_c ./ frame;
    Loc_tag = Loc_tag + vel_c ./ frame;
    Loc_tag2 = Loc_tag2 + Loc_tag;
    center = center + vel_c ./ frame;
    
end

subplot(2, 1, 1)
plot(zeros(1, frame * sim_time));hold on;
plot(x_bias_1, 'color', 'b');
plot(x_bias, 'color', 'r');hold off;
subplot(2, 1, 2)
plot(zeros(1, frame * sim_time));hold on;
plot(y_bias_1, 'color', 'b');
plot(y_bias, 'color', 'r');hold off;


