function [vnodes,pathcosts,FTCDr] = removelinksp(vnodes,pathcosts,capctr,FTCD,s,t,startrange,npath)

FTCDr = FTCD;                                                                   % There is still the problem that the removal order is not optimal...

for k = startrange : (startrange + npath -1)
    
    currentpath = capctr((capctr(:,1) == k),:);                                 % Filters the links that belong to path k
                                                                                % Of the matrix that has path number, from, to, capacity
    %Find the candidate for removal
    %index in the vector
    mclpi = find(currentpath(:,4) == min(currentpath(:,4)));                    % mincaplinkpathindex
    
    % Removal FT candidate  
    
    a = (currentpath(mclpi,2));b = (currentpath(mclpi,3));                      % From and to nodes for that link (a and b)
    
    [~,c] = ismember([a,b],FTCDr(:,(1:2)),'rows');                              % Finds the rows (From and to values) with the minimum capacity
    
    c = c(c>0);
    
    if c ~= 0       
      
        
        FTCDr(c(1),:) = [];                                                     % New FTCD with removed low capacity links WHY REMOVE ONLY THE FIRST ONE??? [PAS AUF]
        
        %rlist = [rilst ; a b];

        [nsp, csp] = getsp(FTCDr(:,1),FTCDr(:,2),FTCDr(:,4),s,t);               % Actually should change this SP function to one that a) does not multiply by the large number b)just removes the links of interest instead of re creating the graph
        
        %[nsp, csp] = getsp(FTCDr(:,1),FTCDr(:,2),FTCDr(:,4),s,t,rlist,G);
        %%Bring in the master Graph object, and remove rlist from it.
        %H = rmedge(G,rlist(:,1),rlist(:,2))
        
    else
        
        [nsp, csp] = getsp(FTCD(:,1),FTCD(:,2),FTCD(:,4),s,t);                  % If there is no link that actually works,
        
        %FTCDr = FTCD;
        
    end
    
    vnodes = [vnodes ; nsp ];                                                   % Update both the nodes and the pathcosts
     
    pathcosts = [pathcosts ; csp ]; 
    
end
% temp = [vnodes , pathcosts]
% ttemp = unique(temp,'rows','stable')

