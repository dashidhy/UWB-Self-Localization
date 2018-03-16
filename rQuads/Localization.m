function [Locs,flag_cor] = Localization(rQuads,M)

[M_o,n_o] = Overlap_graph(rQuads); % get overlap graph
[n,~] = size(M);% number of vertexes
flag_rQ = zeros(n_o,1); % if the rQuad has been visited

Locs = zeros(n,2); % max location set
count_cor = 0; % max location number

% traverse all sub overlap graph
for i = 1:n_o
    if ~flag_rQ(i) % the start point of a new overlap graph
        flag_cor_t = zeros(n,1); % if the vertex has been located
        Locs_t = zeros(n,2); % temporary location set
        count_t = 4; % temporary location number
        
        % relatively locate the first rQuad
        a = rQuads(i,1);b = rQuads(i,2);c = rQuads(i,3);d = rQuads(i,4);
        d_ab = M(a,b);d_ac = M(a,c);d_bc = M(b,c);
        Locs_t(a,:) = [0,0]; % origin
        Locs_t(b,:) = [d_ab,0]; % x axis
        alpha = (d_ab^2+d_ac^2-d_bc^2)/(2*d_ab*d_ac);
        Locs_t(c,:) = [d_ac*alpha,d_ac*sqrt(1-alpha^2)]; % y axis
        flag_cor_t(a) = 1;flag_cor_t(b) = 1;flag_cor_t(c) = 1; % a, b, c located
        
        % locate d
        cor_d = Trilaterate(a,b,c,d,M,[Locs_t(a,1);Locs_t(a,2);Locs_t(b,1);Locs_t(b,2);Locs_t(c,1);Locs_t(c,2)]);
        Locs_t(d,:) = [cor_d(1),cor_d(2)];
        flag_cor_t(d) = 1; % d located
        flag_rQ(i) = 1; % rQuad i visited
        
        % queue for breadth-first search into the overlap graph
        queue = zeros(n_o,1);
        q_head = 1;q_tail = 2;
        
        % squeeze all i's neighbours into the queue
        for j = 1:n_o
            if M_o(i,j)&&(~flag_rQ(j))
                queue(q_tail) = j;
                q_tail = q_tail+1;
            end
        end
        
        q_head = q_head+1;
        
        % search when queue is not empty
        while q_head ~= q_tail
            cur = queue(q_head);
            
            for j = 1:n_o
                if M_o(cur,j)&&(~flag_rQ(j))
                    queue(q_tail) = j;
                    q_tail = q_tail+1;
                end
            end
            
            % visit head, locate the vertex which has not been located
            a = rQuads(cur,1);b = rQuads(cur,2);c = rQuads(cur,3);d = rQuads(cur,4);
            if ~flag_cor_t(a)
                cor_a = Trilaterate(b,c,d,a,M,[Locs_t(b,1);Locs_t(b,2);Locs_t(c,1);Locs_t(c,2);Locs_t(d,1);Locs_t(d,2)]);
                Locs_t(a,:) = [cor_a(1),cor_a(2)];
                flag_cor_t(a) = 1;
            elseif ~flag_cor_t(b)
                cor_b = Trilaterate(a,c,d,b,M,[Locs_t(a,1);Locs_t(a,2);Locs_t(c,1);Locs_t(c,2);Locs_t(d,1);Locs_t(d,2)]);
                Locs_t(b,:) = [cor_b(1),cor_b(2)];
                flag_cor_t(b) = 1;
            elseif ~flag_cor_t(c)
                cor_c = Trilaterate(a,b,d,c,M,[Locs_t(a,1);Locs_t(a,2);Locs_t(b,1);Locs_t(b,2);Locs_t(d,1);Locs_t(d,2)]);
                Locs_t(a,:) = [cor_c(1),cor_c(2)];
                flag_cor_t(c) = 1;
            else 
                cor_d = Trilaterate(a,b,c,d,M,[Locs_t(a,1);Locs_t(a,2);Locs_t(b,1);Locs_t(b,2);Locs_t(c,1);Locs_t(c,2)]);
                Locs_t(d,:) = [cor_d(1),cor_d(2)];
                flag_cor_t(d) = 1;
            end
            count_t = count_t+1; % one more vertex located
            flag_rQ(cur) = 1; % current rQuad visited
            
            % pop head
            q_head = q_head+1;
        end
        
        % update max location set
        if count_t>count_cor
            Locs = Locs_t;
            count_cor = count_t;
            flag_cor = flag_cor_t;
        end    
    end
end

end

