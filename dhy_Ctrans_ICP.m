function Cor_a = dhy_Ctrans_ICP(Cor_r, Cor_ap, Ind)
%{
    3D-3D SVD ICP algorithm.
 
    Inputs:

    - Cor_r: Relative coordinates, of shape (N, 3).

    - Cor_a: Absolute coordinates of anchor nodes, of shape (C, 3), where
             C must larger or equal to 3.

    - Ind: Index of anchor nodes, of shape (C,)

    Outputs:

    - Cor_a: The absolute coordinates, of shape (N, 2).
%}

[C, D] = size(Cor_ap); 
Cor_t = Cor_r(Ind, :);

% Compute and delete mean coordinates
mean_ap = mean(Cor_ap);
mean_t = mean(Cor_t);
Cor_ap = Cor_ap - mean_ap;
Cor_t = Cor_t - mean_t;

% Auxiliary matrix W
W = zeros(D);
for i = 1:C
    
    W = W + Cor_ap(i, :).' * Cor_t(i, :);
    
end

% Compute R and t
[U, ~, V] = svd(W);
R = V * U.';
t = mean_ap - mean_t * R;

% Transtor all coordinates
Cor_a = Cor_r * R + t;

end
