%%Data

cd 'C:\Users\Juan Pablo\OneDrive - University of Illinois - Urbana\Thesis\Code\Matlab\Column Generation\Test';

run Load_Data_CG.m

undir()
%%
DistList=unique([from,to,distance,capacity],'rows');          % Master List with Network Properties, filtering repeated links.

n=max(max(from),max(to));                                     % Initialize the guiding dimension of everything
distmatrix=sparse(n,n);                                       % Initialize the matrix of distances
capmatrix=sparse(n,n);                                        % Initialize the matrix of capacities

for i=1:length(DistList(:,1))
    
    iter=[DistList(i,1) DistList(i,2)];
    
    distmatrix(iter(1),iter(2)) = DistList(i,3);              % Matrix Containing all distances between nodes
    
    capmatrix(iter(1),iter(2))  = DistList(i,4);              % Matrix Containing all capacities between nodes 
end

FTCD = [ from to capacity distance ] ;                        % Condensed Data matrix

FTCDr=FTCD;                                                   % Set the initial FTCD reduced matrix to be the full matrix. 
%%
ErrCount = 0;
T = [1];
M = zeros(6,6,length(T));

for T = 1

for i = 1:6
    for j = 1:6

        if i~=j 
try
    
    [ M(i,j,T) , ~ , ~ , ~ , ~ ] = solveoptim(from, to, distance, capacity, T , [i], [j], capmatrix, FTCD,5,0);
    
    
catch ME
    
    disp("There was an error")
    ErrCount = ErrCount + 1;
    
end

        elseif i == j 
                
                M(i,j) = 0;
        end

    end
end

end

    