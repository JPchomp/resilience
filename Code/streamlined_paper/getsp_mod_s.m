function [nsp,csp] = getsp_mod_s(from,to,weights,s,t,results) 

%% this function gets the shortest path, but also handles negative...
%  weights which are an issue in matlabs SP. 
%  1) Sum M to all edges
%  2) Find SP 
%  3) Restore original sum as the csp = cost of spath (Cost - N*M) N = num
%  of edges = num of nodes - 1

csp={};
nsp={};

w_ij = results.dual(1:length(from));
%sigma_k = results.dual(length(from)+1:end);

modweights = weights+w_ij;


for i = 1:length(s)
    
    if s(i) == t(i)
        
    else
        
    %modweightsk = modweights;% - sigma_k(i);                         % Deduct the path dual cost from all the links  
    
    m=abs(max(modweights))*10;                                        % Make the graph positive with an m value  
    
    Gtem=digraph(from,to,modweights + m);                             % Create graph with positive edges, defined on the reduced costs
    
    [nsp{i,1},cst] = Gtem.shortestpath(s(i),t(i));                    % The path is already stored here  
       
     csp{i,1} = cst - m*(length(nsp{i,1})-1);                         % Deduct m and store the cost 
    
    end
end
