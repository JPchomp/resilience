function [nsp,csp] = getsp_s(from,to,weights,s,t) 

%% this function gets the shortest path, but also handles negative...
% weights which are an issue in matlabs SP. 
% 1) Sum M to all edges
% 2) Find SP 
% 3) Restore original sum as the csp = cost of spath (Cost - N*M) N = num
% of edges = num of nodes - 1

csp={};
nsp={};

m = 1 ;% m=max(weights)*100;                                          % Big number considering the maximum, and multiplied. Could be the case however that given a VERY negative number this is not enough!

%Gtem = rmedge(G,rlist)
Gtem=digraph(from,to,weights+m);                                      % Create graph with positive edges

for i = 1:length(s)
    
    if s(i) == t(i)
        
    else
    
    [nsp{i,1},cst] = Gtem.shortestpath(s(i),t(i));                    % The path is already stored here  
       
     csp{i,1} = cst - m*(length(nsp{i,1})-1);                         % Deduct m and store the cost 
    
    end
end
