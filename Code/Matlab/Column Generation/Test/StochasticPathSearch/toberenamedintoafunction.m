function [newpath, newprob] = runpath(pathlist,t,tolerance, prob)

for i = 1 : length(pathlist(:,1))       %For every path in our solutionset
    
    i
    
    currentpath = pathlist(i,:);        %current path under evaluation
    finalindex = sum(currentpath>0);    %The last value where the path has reeached    
    O = pathlist(i,finalindex);         %Becomes our origin
    
  
        cand = fetchadjacent(O,WA);     %Find possible candidates
        P    = fetchprob(D,cand,t);     %get the probability for ea candidate
        
        sp = length(newpath(:,1)) - 1;  %Starting point to avoid overwriting newpaths
        
        counter = 0;                    %Restart the counter
        
        
    for j = 1:length(cand)
        
        j
        
        if prob(i)*P(j) > tolerance
            
            counter = counter + 1;
            
            newpath(counter,1) = O(i);
            newpath(counter+sp, 1:length(currentpath)) = currentpath;
            newpath(counter+sp, length(currentpath)+1) = cand(j);
            newprob(counter+sp) = prob(i)*P(j);
            
        else
        end
        
    
    
    end
end
    
        
        
    
    
    
