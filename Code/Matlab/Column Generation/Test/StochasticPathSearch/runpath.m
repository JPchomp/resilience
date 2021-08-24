function [newpath, newprob] = runpath(pathlist,t,tol, prob,WA,D, v)

newpath = pathlist;

newprob = prob;

for i = 1 : length(pathlist(:,1))       %For every path in our solutionset
    
    currentpath = pathlist(i,:) ;       % current path under evaluation
    finalindex = sum(currentpath>0);    % The last value where the path has reached    
    O = pathlist(i,finalindex) ;        % Becomes our origin
    
    counter = 0;                    % Restart the counter                                                                        
    sp = length(newpath(:,1));  % Starting point to avoid overwriting newpaths
                                                                                    if O ~= t
  
        cand = fetchadjacent(O,WA)  ;   % Find possible candidates
        
        
        P    = fetchprob(D,O,cand,t)   ;  % get the probability for ea candidate
        
        
        

        
        
    for j = 1:length(cand)
               
                                                                                    if v == 1  % Verbose Block

                                                                                     ["i=" i;
                                                                                     "currentpath=" num2str(currentpath(1,:)); 
                                                                                     "j=" j;
                                                                                     "from =" O;
                                                                                     "cand=" cand(j);
                                                                                     "ProbPath=" prob(i);
                                                                                     "Prob Cand=" P(j);
                                                                                     "NewProb=" prob(i)*P(j)]
                                                                                 
                                                                                    else
                                                                                    end
        
        
        if P(j) == 0
            
            counter = counter + 1;
            
            newpath(counter+sp, 1:length(currentpath)) = currentpath(1,:);
            newpath(counter+sp, length(currentpath)+1) = cand(j);
            newprob(counter+sp) = prob(i);
            
        elseif prob(i)*P(j) > tol
            
            counter = counter + 1;
            
            if currentpath(length(currentpath)) == 0 %If the last number is a zero: Just keep all as is, add a zero.
                
            newpath(counter+sp, 1:length(currentpath)) = currentpath(1,:);
            newpath(counter+sp, length(currentpath)+1) = 0;
            newprob(counter+sp) = prob(i);
            
            else                                     %If the last number is a value, then we want to add the next candidate!
            newpath(counter+sp, 1:length(currentpath)) = currentpath(1,:);
            newpath(counter+sp, length(currentpath)+1) = cand(j);
            newprob(counter+sp) = prob(i)*P(j);
            
            end
        else
            
        end
        
        
    end
                                                                                    else
                                                                                
                                                                                
                                                                                        if v == 1  % Verbose Block

                                                                                     ["i=" i;
                                                                                     "currentpath=" num2str(currentpath(1,:)); 
                                                                                     "j=" "NO J";
                                                                                     "from =" O;
                                                                                     "cand=" "NoCand";
                                                                                     "ProbPath=" prob(i);
                                                                                     "Prob Cand=" "No";
                                                                                     "NewProb=" prob(i)]
                                                                                 
                                                                                    else
                                                                                        end
                                                                                    
                                                                                        
                                                                                            counter = counter + 1;

                                                                                            newpath(counter+sp, 1:length(currentpath)) = currentpath(1,:);
                                                                                            newprob(counter+sp) = prob(i);
                                                                                
   
                                                                            end
                                                                            
                                                                            [newpath, newprob] = filtpa(newpath, newprob, t);
                                                                            [newpath, newprob] = filtreps(newpath, newprob);
                                                                            
                                                                            
end
    
        
        
    
    
    
