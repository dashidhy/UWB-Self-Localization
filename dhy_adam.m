function [Cor, count, L] = dhy_adam(M, ini)
%{
    Compute node location by Adam gradient descent. More than 10 times faster 
    than vanilla gradient descent when lr = 0.05.
    
    Inputs:

    - M: Adjacent matrix of nodes in the network, of shape (N, N), where 
         M(i, j) is the raw distance between node i and j, measured by 
         sensors.

    - ini: Method for initialization.
    
    Outputs:

    - Cor: Node locations, of shape (N, 2), where Cor(i, :) is node i's
           coordinate (x_i, y_i).

    - count: Number of iterations when converge.
    
    - L: Final loss.
%}

[n,~] = size(M);
lr = 0.05;
beta1 = 0.9;
beta2 = 0.999;
m = zeros(n, 2);
v = zeros(n, 2);

% initial
if strcmp(ini, 'rQuads')

    rQuads = find_quads(M);
    [Cor,~] = Localization(rQuads, M);
    
elseif strcmp(ini, 'MDS')
    
    Cor = MDS(M, '2D');
    Cor = Cor - Cor(1, :);
    mo = sqrt(sum(Cor(2, :) .^ 2));
    c = Cor(2, 1) / mo;
    s = Cor(2, 2) / mo;
    x = Cor(:, 1) * c + Cor(:, 2) * s;
    y = Cor(:, 2) * c - Cor(:, 1) * s;
    Cor(:, 1) = x;
    Cor(:, 2) = y;
    Cor(2, :) = [mo, 0];
    if Cor(3, 2) < 0
        Cor(:, 2) = -Cor(:, 2);
    end
    
end

% Start iteration
count = 0;
while 1
    
    count = count+1;
    
    % Compute new adjacent matrix
    Cor_square = sum(Cor.^2, 2);
    M_t = sqrt((Cor_square - 2 * (Cor * Cor.')) + Cor_square.');
    
    % Compute loss
    L = 0.25 * sum(sum((M_t - M) .^ 2));
    
    % Compute gradients
    M_t = M_t + eye(n); % Avoid divided by zero.
    
    dM = M_t - M;
    dx = Cor(:, 1) - Cor(:, 1).';
    dy = Cor(:, 2) - Cor(:, 2).';
    g = zeros(n, 2);
    g(:, 1) = sum((dM .* dx) ./ M_t, 2);
    g(:, 2) = sum((dM .* dy) ./ M_t, 2);
    
    % Adam update
    m = beta1 .* m + (1 - beta1) .* g;
    v = beta2 .* v + (1 - beta2) .* g .* g;
    m_unbias = m ./ (1 - beta1 .^ count);
    v_unbias = v ./ (1 - beta2 .^ count);
    update = lr .* m_unbias ./ (sqrt(v_unbias) + 1e-8);
    Cor = Cor - update;
    Cor(1, :) = 0;
    Cor(2, 2) = 0;
    
    % if converge
    if sum(sum(abs(update))) < 1e-10
        break;
    end
    
end

if Cor(2, 1) < 0
    Cor(:, 1) = -Cor(:, 1);
end

if Cor(3, 2) < 0
    Cor(:, 2) = -Cor(:, 2);
end

end

