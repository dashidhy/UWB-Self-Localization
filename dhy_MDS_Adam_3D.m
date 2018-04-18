function [Cor, iter] = dhy_MDS_Adam_3D(M, Converge)
%{
    Compute node location by MDS initialization and Adam gradient descent
    in 3D space.
    
    Inputs:

    - M: Adjacent matrix of nodes in the network, of shape (N, N), where 
         M(i, j) is the raw distance between node i and j, measured by 
         sensors.

    - Converge: Converge parameter.
    
    Outputs:

    - Cor: Node locations, of shape (N, 3), where Cor(i, :) is node i's
           coordinate (x_i, y_i, z_i).

    - iter: Number of iterations when converge.

%}

[n, ~] = size(M);
lr = 0.05;
beta1 = 0.9;
beta2 = 0.999;
m = zeros(n, 3);
v = zeros(n, 3);

% MDS initialization  
Cor = dhy_MDS(M, '3D');
Cor = Cor - Cor(1, :);
mo = sqrt(sum(Cor(2, 2:3) .^ 2));
c = Cor(2, 2) / mo;
s = Cor(2, 3) / mo;
Cor(:, 2:3) = Cor(:, 2:3) * [c, -s; s, c];
mo = sqrt(sum(Cor(2, 1:2) .^ 2));
c = Cor(2, 1) / mo;
s = Cor(2, 2) / mo;
Cor(:, 1:2) = Cor(:, 1:2) * [c, -s; s, c];
mo = sqrt(sum(Cor(3, 2:3) .^ 2));
c = Cor(3, 2) / mo;
s = Cor(3, 3) / mo;
Cor(:, 2:3) = Cor(:, 2:3) * [c, -s; s, c];

% Start iteration
iter = 0;
while 1
    
    iter = iter + 1;
    
    % Compute new adjacent matrix
    Cor_square = sum(Cor .^ 2, 2);
    M_t = (-2 * (Cor * Cor.') + Cor_square) + Cor_square.';
    M_t(M_t < 0) = 0;
    M_t = sqrt(M_t);
    
    % Compute gradients
    M_t = M_t + eye(n); % Avoid divided by zero.
    
    dM = M_t - M;
    dx = Cor(:, 1) - Cor(:, 1).';
    dy = Cor(:, 2) - Cor(:, 2).';
    dz = Cor(:, 3) - Cor(:, 3).';
    g = zeros(n, 3);
    g(:, 1) = sum((dM .* dx) ./ M_t, 2);
    g(:, 2) = sum((dM .* dy) ./ M_t, 2);
    g(:, 3) = sum((dM .* dz) ./ M_t, 2);
    
    % Adam update
    m = beta1 .* m + (1 - beta1) .* g;
    v = beta2 .* v + (1 - beta2) .* g .* g;
    m_unbias = m ./ (1 - beta1 .^ iter);
    v_unbias = v ./ (1 - beta2 .^ iter);
    update = lr .* m_unbias ./ (sqrt(v_unbias) + 1e-8);
    Cor = Cor - update;
    
    % Constraint
    Cor(1, :) = 0;
    Cor(2, 2:3) = 0;
    Cor(3, 3) = 0;
    
    % If converge
    if max(max(abs(update))) < Converge
        break;
    end
    
end

end

