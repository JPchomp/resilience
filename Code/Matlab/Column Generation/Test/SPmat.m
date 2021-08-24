function [spmatrix]=SPmat(from,distmatrix,dmat)
     %This Function will run SP function for every node pair
    %And store it as an "SPMatrix"
    
    % inputs: 
    % our function has to run every node as source, and store it.
    
n=max(from);
    
    for i=1:n
        for j=1:n
                dmat(i,j)=SP(distmatrix,i,j);
            end
        end
        spmatrix=dmat;
end