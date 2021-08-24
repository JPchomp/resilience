function [capctr, kopath] = capctranddij(pathcosts, vnodes, capmatrix,s,t)

capctr = zeros([],4);
kpath = [];
counter = 0;

for j = (1:length(pathcosts))
    for i = (1:length(vnodes(j,(1:vnodes(j,1000))))-1)
        counter = counter+1;
        capctr(counter,:) = [j, vnodes(j,i), vnodes(j,i+1), capmatrix(vnodes(j,i),vnodes(j,i+1))]; %Path number, arc start node , arc end node, capacity
        
        if vnodes(j,vnodes(j,1000)) == vnodes(j,i+1)
            kpath(j,:) = [j, vnodes(j,1), vnodes(j,i+1) ];                                          % This is used later, its to save the start and endpoint of the path
        end
    end
end

kopath = zeros(length(s),[]);

for i = (1:length(pathcosts))
    [a,b] = ismember([kpath(i,2) kpath(i,3)],[s t],'rows');                 % I want to write # of commodity ( = OD Pair)..  
    if a == 1                                                               % and what path (column) satisfies that Commodity
        kopath(b,1)=b;
        kopath(b,i+1)= 1;
    end
end