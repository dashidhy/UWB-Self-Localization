function IoN = IsRobust_t(i, j, k, M, d_min)
%{
    Judge if a given triangle is robust.

    Inputs:

    - i, j, k: The three vertexes of the triangle.

    - M: The adjacent matrix.
    
    - d_min: The threshold, related to the measuring noise.

    Output:
    
    - IoN: 1: Robust; 0: Not Robust
%}

a = M(i,j); b = M(j,k); c = M(k,i);
t = min([a; b; c]);

if t == a
    
    th = a * (1 - ((b ^ 2 + c ^ 2 - a ^ 2) / (2 * b * c)) ^ 2);

elseif t == b
    
    th = b * (1 - ((a ^ 2 + c ^ 2 - b ^ 2) / (2 * a * c)) ^ 2);

else
    
    th = c * (1 - ((b ^ 2 + a ^ 2 - c ^ 2) / (2 * b * a)) ^ 2);

end

if th > d_min
    
    IoN = 1;

else
    
    IoN = 0;

end

end
