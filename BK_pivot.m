function [max_cliques, num_cliques] = BK_pivot(M_bool)
%{
    Bron–Kerbosch algorithm with pivoting.

    Input:

    - m_bool: The adjacent matrix with each element 1 or 0 which means connected or not.
 
    Output:

    - max_cliques: All maximal cliques in the graph.
%}

% Initialization
global cliques;
global num_c;
cliques = cell(1, 1);
num_c = 0;

[N, ~] = size(M_bool); 
R = [];
P = 1:N;
X = [];

% Begin recurring
BK_recur(M_bool, R, P, X);

% Return
max_cliques = cliques;
num_cliques = num_c;

clear global cliques;
clear global num_c;

end

function BK_recur(M_bool, R, P, X)
%{
    The recurring body of BK algorithm. For reference, see https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm#cite_note-4
%}

global cliques;
global num_c;

if isempty(P) && isempty(X)
    
    num_c = num_c + 1;
    cliques{num_c} = R;
    return;
    
end

u = union(P, X);
u = u(1);
P_m_Nu = setdiff(P, Neighbor(u, M_bool));

for i = 1:length(P_m_Nu)
    
    v = P_m_Nu(i);
    Nv = Neighbor(v, M_bool);
    BK_recur(M_bool, union(R, v), intersect(P, Nv), intersect(X, Nv));
    
    P = setdiff(P, v);
    X = union(X, v);
    
end

end

function N = Neighbor(A, M_bool)
%{
    Find the neighbor set of node A
%}

N = find(M_bool(A, :) == 1);

end