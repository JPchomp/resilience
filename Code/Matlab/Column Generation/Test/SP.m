function [spcost] = SP(distmatrix, s, t)

% inputs: 
    % costmatrix with costs for i,j
    % n: the number of nodes in the network; 
    % s: source node index; 
    % t: destination node index;
    
    
n=rank(distmatrix);  % Updated to Rank to allow for sparse matrix
S(1:n) = 0;          % vector, set of visited vectors (s,somewhere)
dist(1:n) = inf;     % it stores the shortest distance between the source and each other node; 
prev(1:n) = n+1;     % Previous node, informs about the best previous node known to reach each network node


dist(s) = 0;

while sum(S)~=n 
    candidate=[]; 
    for i=1:n 
        if S(i)==0 
        candidate=[candidate, dist(i)]; 
        else 
        candidate=[candidate, inf]; 
        end 
    end 
[~, u]=min(candidate); 
S(u)=1; 
for i=1:n 
    if distmatrix(u,i)>0            % ignore non-existing links 
        if(dist(u)+distmatrix(u,i))<dist(i)     
            dist(i)=dist(u)+distmatrix(u,i); 
            prev(i)=u; 
        end 
    end 
end 
end 
spcost = dist(t);
end