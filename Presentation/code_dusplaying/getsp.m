function [nsp,csp] = getsp(from,to,weights,s,t) %Input a column of sources and destinations.

%% this function gets the shortest path, but also handles negative...
% weights which are an issue in matlabs SP. 
% 1) Sum M to all edges
% 2) Find SP 
% 3) Restore original sum as the csp = cost of spath (Cost - N*M) N = num
% of edges = num of nodes - 1
% 4) Keep the nodes visited in the 1000 column matrix, with the number of
% nodes at the end.

nsp=zeros(length(s),1000);
csp=zeros(length(s),1);

m=max(weights)*100;                                             %Big number considering the maximum, and multiplied. Could be the case however that given a VERY negative number this is not enough!

Gtem=graph(from,to,weights+m);                                  %Create graph with positive edges

for i = 1:length(s)
    [v1,csp(i)] = Gtem.shortestpath(s(i),t(i));
    
    nsp(i,1:length(v1)) = v1;                                   %Store the node path
    
    csp(i) = csp(i) - m*(length(v1)-1);          %Deduct m and store the cost                   
    nsp(i,1000) = length(v1);                    %embed the length of the shortest path at the "end" of the matrix
    
end
    

                        % Observe that for nsp , nsp(1,1:nsp(1000)) returns a row with the nodes of
                        %the sp
