function rQuads = find_quads(M)
%{
    Find all robust quads in a given graph.

    Input:
    
    - M: Adjacent matrix of current graph. M(i, j) is the distance measured 
         between i and j.

    Output:

    - rQuads: All robust quadrilaterals, shape(N, 4), each row is the four 
              vertex of a robust quad.
%}

counter = 0;
[n,~] = size(M);
cache = zeros(n * (n - 1) * (n - 2) * (n - 3) / 24, 4);

% traverse all quads
for i = 1:(n - 3)
    for j = (i + 1):(n - 2)
        for k = (j + 1):(n - 1)
            for l = (k + 1):n
                if IsRobust(i, j, k, l, M)
                    counter = counter + 1;
                    cache(counter, :) = [i, j, k, l];
                end
            end
        end
    end
end

rQuads = cache(1:counter, :);

end