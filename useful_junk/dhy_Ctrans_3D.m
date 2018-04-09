function [Cor_a, count, L] = dhy_Ctrans_3D(Cor_r, Cor_ap, Ind, conv)
%{
    Transfor relative coordinates to absolute coordinates in 3D space.
 
    Inputs:

    - Cor_r: Relative coordinates, of shape (N, 3).

    - Cor_ap: Absolute coordinates of anchor nodes, of shape (C, 3), where
              C must larger or equal to 4.

    - Ind: Index of anchor nodes, of shape (C,).

    - conv: Converge parameter.

    Outputs:

    - Cor_a: The absolute coordinates, of shape (N, 3).
%}

C = length(Ind);
lr = 0.001;

Cor_r = Cor_r - mean(Cor_r(Ind, :));
Cor_t = Cor_r(Ind, :);

% Judge chirality
va_12 = Cor_ap(2, :) - Cor_ap(1, :);
va_13 = Cor_ap(3, :) - Cor_ap(1, :);
va_14 = Cor_ap(4, :) - Cor_ap(1, :);
d_a = cross(va_12, va_13) * va_14.';

vr_12 = Cor_t(2, :) - Cor_t(1, :);
vr_13 = Cor_t(3, :) - Cor_t(1, :);
vr_14 = Cor_t(4, :) - Cor_t(1, :);
d_r = cross(vr_12, vr_13) * vr_14.';

% Correct chirality
if (d_a * d_r) < 0
    
    Cor_t(:, 3) = -Cor_t(:, 3);
    Cor_r(:, 3) = -Cor_r(:, 3);
    
end

% Initialize transition parameters
para = [mean(Cor_ap), 0.9, 0.1, 0.1, pi / 2 , 0.1];

% Optimize parameters
count = 0;
while 1
    
    count = count + 1;
    e = para(4:6);
    c = cos(para(7));
    s = sin(para(7));
    l = para(8);
    e_c_r = cross(repmat(e, C, 1), Cor_t, 2);
    e_d_r = Cor_t * e.';
    
    % Compute loss
    D = ((c .* Cor_t + s .* e_c_r + (1 - c) .* (e_d_r * e)) + para(1:3)) - Cor_ap;
    L = sum(sum(D .^ 2)) / C;
    
    % Compute gradients
    dpara = zeros(1, 8);
    dpara(1:3) = sum(D);
    dpara(4) = sum(sum(D .* ([(1 - c) .* e_d_r, -s .* Cor_t(:, 3), s .* Cor_t(:, 2)] + (1 - c) .* (Cor_t(:, 1) * e)))) + l * e(1);
    dpara(5) = sum(sum(D .* ([s .* Cor_t(:, 3), (1 - c) .* e_d_r, -s .* Cor_t(:, 1)] + (1 - c) .* (Cor_t(:, 2) * e)))) + l * e(2);
    dpara(6) = sum(sum(D .* ([-s .* Cor_t(:, 2), s .* Cor_t(:, 1), (1 - c) .* e_d_r] + (1 - c) .* (Cor_t(:, 3) * e)))) + l * e(3);
    dpara(7) = sum(sum(D .* (-s .* Cor_t + c .* e_c_r + s .* (e_d_r * e))));
    dpara(8) = (e * e.' -1) / 2;
    
    % Vanilla G.D. update, don't know why but works much better than other G.D. variants in this case.
    update = lr .* dpara;
    para = para - update;
    
    % If converge
    if max(max(update)) < conv
        break;
    end
    
end

% Convert relative coordinates to absolute ones
e = para(4:6);
c = cos(para(7));
s = sin(para(7));
[N, ~] = size(Cor_r);
e_c_r = cross(repmat(e, N, 1), Cor_r, 2);
e_d_r = Cor_r * e.';

Cor_a = (c .* Cor_r + s .* e_c_r + (1 - c) .* (e_d_r * e)) + para(1:3);

end
