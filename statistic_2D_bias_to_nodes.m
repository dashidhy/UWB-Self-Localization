clear all; close all; clc;

G = CNet(0, 0);

dim = 2;
range = 50;
num_nodes = 10:5:100;
noise_std = 0.1;

num_rep = 5000;
max_array = zeros(1, length(num_nodes));
avg_array = zeros(1, length(num_nodes));

for i = 1:length(num_nodes)
    
    max_b = 0;
    avg_b = 0;
    
    j = 0;
    while j < num_rep
        
        try
            
            G.Reset(num_nodes(i), dim);
            G.Simulate(noise_std, range);
        
            max_b = max_b + G.Max_Bias;
            avg_b = avg_b + G.Avg_Bias;
            
        catch
            
            j = j - 1;
            
        end
        
        j = j + 1;
        
    end
    
    max_array(i) = max_b ./ num_rep;
    avg_array(i) = avg_b ./ num_rep;
    
    clc;
    disp([num2str(100 .* i ./ length(num_nodes)), '%']);
    
end

figure;
plot(num_nodes, max_array .* 100);hold on;
plot(num_nodes, avg_array .* 100);hold off;
legend('max bias', 'avg bias');
xlabel('Number of nodes')
ylabel(['Bias (cm) (', num2str(num_rep), ' times average)'])
title('2D Localization Bias (respects to nodes)');
