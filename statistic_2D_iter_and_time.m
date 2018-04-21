clear all; close all; clc;

G = CNet(0, 0);

dim = 2;
range = 50;
num_nodes = 10:5:100;
noise_std = 0.1;

num_rep = 5000;
iter_array = zeros(1, length(num_nodes));
time_array = zeros(1, length(num_nodes));

for i = 1:length(num_nodes)
    
    iter_t = 0;
    time_t = 0;
    
    j = 0;
    while j < num_rep
        
        try
            
            G.Reset(num_nodes(i), dim);
            [iter, time] = G.Simulate(noise_std, range);
        
            iter_t = iter_t + iter;
            time_t = time_t + time;
            
        catch
            
            j = j - 1;
            
        end
        
        j = j + 1;
        
    end
    
    iter_array(i) = iter_t ./ num_rep;
    time_array(i) = time_t ./ num_rep;
    
    clc;
    disp([num2str(100 .* i ./ length(num_nodes)), '%']);
    
end

figure;
plot(num_nodes, iter_array);
xlabel('Number of nodes')
ylabel(['Number of iterrations (', num2str(num_rep), ' times average)'])
title('Iteration efficiency')

figure;
plot(num_nodes, time_array);
xlabel('Number of nodes')
ylabel(['Time consumed (', num2str(num_rep), ' times average)'])
title('Time efficiency')
