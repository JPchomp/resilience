function [vnodes,pathcosts,FTCDr] = removelinksp(vnodes,pathcosts,capctr,FTCD,s,t,startrange)

for k = startrange:length(pathcosts)

    currentpath = capctr((capctr(:,1) == k),:);                             %Filters the links that belong to path k
    
    %Find the candidate for removal
    %index in the vector
    mclpi = find(currentpath(:,4) == min(currentpath(:,4)));                %mincaplinkpathindex
    
    %Removal FT candidate
    
    a = (currentpath(mclpi,2));b = (currentpath(mclpi,3));
    
    [~,c] = ismember([a,b],FTCD(:,(1:2)),'rows');                           %Finds the rows (From and to values) with the minimum capacity
    
    FTCDr = FTCD;
    
    FTCDr(c,:) = [];                                                        %New FTCD with removed low capacity links
    
    [nsp,csp] = getsp(FTCDr(:,1),FTCDr(:,2),FTCDr(:,4),s,t);                %Actually should change this SP function to one that a) does not multiply by the large number b)just removes the links of interest instead of re creating the graph
    
end
    
    vnodes = [vnodes ; nsp ] ;                                              %update both the nodes and the pathcosts
    
    pathcosts = [pathcosts ; csp ] ;