function Cor = dhy_2D_matrix_reconstruct(sub_size, overlap)
%{
    A method for matrix reconstruction when communication range is limited.
    (May move to OOP code in the future.)

    Global:

    - M: The adjacent matrix of the whole network. Some of its element may
         be missing because of limited communication range.

    Inputs:

    - sub_size: The maximum size for finding a clique.

    - overlap: Number of overlap nodes for splicing subnetworks.

    Output:

    - Cor: Index of cliques.

%}

% Some setup
global M;
[N, ~] = size(M);
sub_size = sub_size - 1;
overlap = overlap - 1;
pin_s = 1; % Subset header
pin_e = 1;
count = 0;
count_s = 1;

while 1 % Each loop finds a clique
    
    while 1 % Each loop swaps 2 nodes
        
        flag = 1; % Tag if swap happens
        
        max_dis = 0;
        for i = (pin_e + 1):N
            
            if isempty(find(M(pin_s:pin_e, i) == -1, 1)) % if a new node fully connected to previous nodes in current clique
                
                % Swap happens
                flag = 0;
                
                % to make sure current node far enough from nodes in previous cliques
                dis = sum(M(1:(pin_s - 1), i) == -1); 
                if dis >= max_dis
                    
                    max_dis = dis;
                    t = i;
                    
                end
                
            end
            
        end
        
        % If swap happened, do the swap
        if ~flag
            
            pin_e = pin_e + 1;
            dhy_swap(pin_e, t);
            
        end
        
        % If swap didn't happen or clique large enough, break;
        if flag || (pin_e - pin_s) == sub_size
            
            break;
            
        end
        
    end
    
    % If found a new clique, add it to output and reset pins
    if count == 0 || Cor(count, 2) ~= pin_e
        
        count = count + 1;
        Cor(count, :) = [pin_s, pin_e];
        pin_s = pin_e - overlap;
        
    % If didn't find a new clique and didn't reach the end, create a new subgraph
    elseif pin_e ~= N
        
        pin_s = pin_e + 1;
        pin_e = pin_s;
        count_s = count_s + 1;
        
    else
        
        break;
        
    end
    
end

end

function dhy_swap(a, b)

global M;
global Ind;
t = M(:, a);
M(:, a) = M(:, b);
M(:, b) = t;
t = M(a, :);
M(a, :) = M(b, :);
M(b, :) = t;
t = Ind(a);
Ind(a) = Ind(b);
Ind(b) = t;

end
