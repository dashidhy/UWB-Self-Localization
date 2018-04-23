function Cor_a = dhy_Ctrans_ICP(Cor_r, Cor_ap, Ind)
%{
    SVD ICP algorithm.
 
    Inputs:

    - Cor_r: Relative coordinates, of shape (N, D).

    - Cor_a: Absolute coordinates of anchor nodes, of shape (C, D), where
             C must larger or equal to 3.

    - Ind: Index of anchor nodes, of shape (C,)

    Outputs:

    - Cor_a: The absolute coordinates, of shape (N, D).
%}

% Fetch relative coordinates of anchor nodes
Cor_t = Cor_r(Ind, :);

% Compute and delete mean coordinates
mean_ap = mean(Cor_ap);
mean_t = mean(Cor_t);
Cor_ap = Cor_ap - mean_ap;
Cor_t = Cor_t - mean_t;

% Auxiliary matrix W
W =  Cor_ap.' * Cor_t;

% Compute R and t
[U, ~, V] = svd(W);
R = V * U.';
t = mean_ap - mean_t * R;

% Transform all coordinates
Cor_a = Cor_r * R + t;

end
