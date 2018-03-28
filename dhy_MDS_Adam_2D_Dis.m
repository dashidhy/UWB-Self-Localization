function Cor = dhy_MDS_Adam_2D_Dis(M, size_sub, overlap, conv)
%{
    A distributed localization algorithm for 2D networks.

    Inputs:

    - M: Adjacent matrix of nodes in the network, of shape (N, N), where 
         M(i, j) is the raw distance between node i and j, measured by 
         sensors.

    - size_sub: The size of subsets of M.

    - overlap: The size of overlap for splicing the subsets. At least 3 in
               2D condition.

    - conv: Converge parameter.

    Output:

    - Cor: Node locations, of shape (N, 2), where Cor(i, :) is node i's
           coordinate (x_i, y_i).
%}

[N, ~] = size(M);

% Compute the number of sub blocks
num_block = ceil((N - overlap) / (size_sub - overlap));

% Allocate storage space for coordinates
Cor = zeros(N, 2);

% Start locating and splicing
s = 1;
e = s + size_sub -1;
[Cor(s:e, :), ~, ~] = dhy_MDS_Adam_2D(M(s:e, s:e), conv);

for i = 2:(num_block-1)
    
    s = s + size_sub -overlap;
    e = s + size_sub -1;
    
    [Cor_t, ~, ~] = dhy_MDS_Adam_2D(M(s:e, s:e), conv);
    [Cor_t, ~, ~] = dhy_Ctrans_2D(Cor_t, Cor(s:(s + overlap -1), :), 1:overlap, conv);
    Cor(s:e, :) = Cor_t;
    
end

s = s + size_sub -overlap;
e = N;
[Cor_t, ~, ~] = dhy_MDS_Adam_2D(M(s:e, s:e), conv);
[Cor_t, ~, ~] = dhy_Ctrans_2D(Cor_t, Cor(s:(s + overlap -1), :), 1:overlap, conv);
Cor(s:e, :) = Cor_t;

end

