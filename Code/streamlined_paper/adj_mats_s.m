function [FTCD , distmatrix , capmatrix ] = adj_mats_s(from, to, capacity, distance)

FTCD = [ from to capacity distance ] ;                        % Condensed Data matrix FTCD

DistList=unique(FTCD,'rows');         			      % Master List with Network Properties, filtering repeated links.

n=max(max(from),max(to));                                     % Initialize the guiding dimension of everything
distmatrix=sparse(n,n);                                       % Initialize the matrix of distances
capmatrix=sparse(n,n);                                        % Initialize the matrix of capacities

    for i=1:length(DistList(:,1))

        iter=[DistList(i,1) DistList(i,2)];

        capmatrix(iter(1),iter(2))=DistList(i,3);                % Matrix Containing all distances between nodes

        distmatrix(iter(1),iter(2))=DistList(i,4);                 % Matrix Containing all capacities between nodes 
    end

end