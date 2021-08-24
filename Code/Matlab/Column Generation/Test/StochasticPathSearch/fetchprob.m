function [pvec] = fetchprob(D,j,cand,t)

n = length(cand);

tempd = [];
pvec = [];

for i = 1:n                                                 %j is the node at which we are making the decision to where to move
    tempd(i) = D(cand(i),t) + D(j,cand(i));                    % This returns the SP distances of each adjacent to the destination t, idxr becomes the path index: idxc(i)
end

for i = 1:n
    
    if tempd(i)>0
        tempe(i) = 1./tempd(i);                     % first take the inverse of the distances (efficiency)
    
    else
        tempe(i) = 0;                               % IF i am already standing on the node, the count it as zero. Eliminate its prob.
        
    end

end

for i = 1:n
    pvec(i) = tempe(i)./sum(tempe);               % then take the relative weights of each.(prob of j). In each Path i
end