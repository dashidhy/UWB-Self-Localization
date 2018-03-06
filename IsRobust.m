function IoN = IsRobust(i, j, k, l, M)
%{
    Judge if a given quad is robust.
    
    Inputs:
    
    - i, j, k, l: The four vertexes of the quad.

    - M: The adjacent matrix of current graph.

    Output:
    
    - IoN: 1: Robust; 0: Not Robust
%}

IoN = 0;

if IsRobust_t(i,j,k,M) && IsRobust_t(j,k,l,M) && IsRobust_t(k,l,i,M) && IsRobust_t(l,i,j,M)
    
    IoN = 1;

end

end

