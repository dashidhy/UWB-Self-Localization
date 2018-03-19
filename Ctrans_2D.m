function [Cor_a, count, L] = Ctrans_2D(Cor_r, Cor_ap, Ind)
%{
    Transfor relative coordinates to absolute coordinates.
 
    Inputs:

    - Cor_r: Relative coordinates, of shape (N, 2).

    - Cor_ap: Absolute coordinates of anchor nodes, of shape (C, 2), where
              C must larger or equal to 3 in 2D condition.

    - Ind: Index of anchor nodes, of shape (C,).

    Outputs:

    - Cor_a: The absolute coordinates, of shape (N, 2).

%}

C = length(Ind);
lr = 0.05;
beta1 = 0.9;
beta2 = 0.999;
m = zeros(1, 3);
v = zeros(1, 3);

Cor_r = Cor_r - mean(Cor_r(Ind, :));
Cor_t = Cor_r(Ind, :);
y_flip = 1;

% Judge chirality
va_12 = [Cor_ap(2, :) - Cor_ap(1, :), 0];
va_13 = [Cor_ap(3, :) - Cor_ap(1, :), 0];
d_a = cross(va_12, va_13);

vr_12 = [Cor_t(2, :) - Cor_t(1, :), 0];
vr_13 = [Cor_t(3, :) - Cor_t(1, :), 0];
d_r = cross(vr_12, vr_13);

% Correct chirality
if (d_a * d_r.') < 0
    
    Cor_t(:, 2) = -Cor_t(:, 2);
    vr_12(2) = -vr_12(2);
    y_flip = -1;
    
end

% Initialize transition parameters
para = [mean(Cor_ap), sign(sum(cross(va_12, vr_12))) * acos((va_12 * vr_12.') / (norm(va_12) * norm(vr_12)))];

% Optimize parameters
count = 0;
while 1
    
    count = count + 1;
    c = cos(para(3));
    s = sin(para(3));
    
    % Compute loss
    D = Cor_t * [c, -s; s, c] + para(1:2) - Cor_ap;
    L = sum(sum(D .^ 2)) / C;
    
    % Compute gradients
    dpara = [sum(D), sum(sum(D .* (Cor_t * [-s, -c; c, -s])))];
    
    % Adam update
    m = beta1 .* m + (1 - beta1) .* dpara;
    v = beta2 .* v + (1 - beta2) .* dpara .* dpara;
    m_unbias = m ./ (1 - beta1 .^ count);
    v_unbias = v ./ (1 - beta2 .^ count);
    update = lr .* m_unbias ./ (sqrt(v_unbias) + 1e-8);
    para = para - update;
    
    % If converge
    if sum(abs(update)) < 1e-11 * 3 
        break;
    end
    
end

% Convert relative coordinates to absolute ones
c = cos(para(3));
s = sin(para(3));

Cor_r(:, 2) = Cor_r(:, 2) * y_flip;
Cor_a = Cor_r * [c, -s; s, c] + para(1:2);

end

