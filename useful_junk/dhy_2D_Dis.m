function Cor = dhy_2D_Dis(sub_size, overlap)

global M;
[N, ~] = size(M);
sub_size = sub_size - 1;
overlap = overlap - 1;

% Some setup
pin_s = 1; % Subset header
pin_e = 1;
count = 0;

while 1 % Each loop finds a clique
    
    while 1 % Each loop swaps 2 nodes
        
        flag = 1;
        
        for i = (pin_e + 1):N
            
            if isempty(find(M(pin_s:pin_e, i) == -1, 1))
                
                pin_e = pin_e + 1;
                dhy_swap(pin_e, i);
                flag = 0;
                break;
                
            end
            
        end
        
        if flag || (pin_e - pin_s) == sub_size
            
            break;
            
        end
        
    end
    
    if count == 0 || Cor(count, 2) ~= pin_e
        
        count = count + 1;
        Cor(count, :) = [pin_s, pin_e];
        pin_s = pin_e - overlap;
        
    elseif pin_e ~= N
        
        pin_s = pin_e + 1;
        pin_e = pin_s;
        
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
