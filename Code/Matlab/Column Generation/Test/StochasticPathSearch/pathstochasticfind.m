Load_Data_CG

G = graph(from,to,distance);

D = distances(G);

A = full(adjacency(G));

global G D A
 
%%
DistList=unique([from,to,distance,capacity],'rows');          %Master List with Network Properties, filtering repeated links.

n=max(max(from),max(to));                                     %Initialize the guiding dimension of everything
distmatrix=sparse(n,n);                                       %Initialize the matrix of distances
capmatrix=sparse(n,n);                                        %Initialize the matrix of capacities

for i=1:length(DistList(:,1))
    
    iter=[DistList(i,1) DistList(i,2)];
    
    distmatrix(iter(1),iter(2))=DistList(i,3);                %Matrix Containing all distances between nodes
    
    capmatrix(iter(1),iter(2))=DistList(i,4);              %Matrix Containing all capacities between nodes (times 80 as the value provided in the input .csv is assumed to be a density)
end
%%
WA = full(distmatrix); WA = WA + WA';

global WA

%%

%s = origin node
%t = destination node

[idxr,idxc] = find(WA(s,:)>0);                  % This yields a vector stating what nodes are adjacent to the one we are standing on. idxr is the nodes we stand on.

npaths = sum(idxr>0);

tempd = [];
for i = 1:npaths
    tempd(i) = D(idxc(i),t);                    % This returns the SP distances of each adjacent to the destination t, idxr becomes the path index: idxc(i)
end

for i = 1:length(tempd)
    
    tempe(i) = 1./tempd(i);                     % first take the inverse of the distances
    pj(i) = tempe(i)./sum(tempe);               % then take the relative weights of each.(prob of j). In each Path i

end

for i = 1:npaths
    pathnodes(i,:) = a;
end

%%

        p = plot(G,'XData',xlocation,'YData',ylocation,...
            'LineWidth',1);...
            title('Sample Network');   
   %'NodeLabel', MDG,...
   %'EdgeLabel',distance,...
   
c = NPAT(90,:);   
highlight(p,[c destination],'NodeColor','g')







