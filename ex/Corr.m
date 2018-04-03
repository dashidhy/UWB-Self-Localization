function M_c = Corr(M_r)
%{
    Correct raw data with correction table

    Input:

    - M_r: Adjacent matrix consists of raw data.

    Output:

    - M_c: Adjacent matrix consists of corrected data.

%}

T = load('./ctable.mat');
table = T.table;
[n_t, ~] = size(table);
[n_s, ~] = size(M_r);
M_c = zeros(n_s, n_s);


for i = 1:(n_s - 1)
    for j = (i + 1):n_s
        
        for k = 2:n_t
            
            if M_r(i, j) < table(k, 1)
                
                M_c(i, j) = table(k - 1, 2) + (table(k, 2) - table(k - 1, 2)) * ((M_r(i, j) - table(k - 1, 1)) / (table(k, 1) - table(k - 1, 1)));
                M_c(j, i) = M_c(i, j);
                break;
                
            end
            
        end
        
    end
end

end

