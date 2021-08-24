%% We Attempt to get all the paths related to the maximum flow

% Define the size of all the matrices and cells by the num of nodes.

n = numnodes(GC); 

% Define R the matrix of maximum flows possible
% Define mfg the cell with the maximum flow digraphs

R = zeros(n,n); mfg = cell(n,n);

% Define spg, the cell with the maximum flow paths
% Define pcs, the cost of each maximum flow path

spg = cell(n,n); pcs = cell(n,n); 

for i = 1:n
    for j = 1:n
        if i ~= j
            
            % Store the max flows and digraphs
            [R(i,j),mfg{i,j}] = GC.maxflow(i,j);
 
            %Find all paths within the max flow digraph
            spg{i,j} = pathbetweennodes(mfg{i,j}.adjacency , i , j);
           
            %For each path found find the cost:
            for p = 1 : length(spg{i,j})
                
                % a) Initialize the cost as zero
                pcs{i,j}(p,1) = 0;
                
                % For each edge in the path p:
                for k = 1 : length(spg{i,j}{p})-1
                
                    % Cycle through each path and sum each links cost
                     pcs{i,j}(p,1) = pcs{i,j}(p,1) + ...
                         GD.Edges.Weight(findedge( mfg{i,j},spg{i,j}{p}(k),spg{i,j}{p}(k+1))); %Matlab2020 has a faster way for this
                end
            
            
            end
            
        else
        end
    end
end

%             iter = 1;          
%             [spg{i,j}{iter}] = mfg{i,j}.shortestpath(i,j);            
% while numedges(mfg{i,j}) > 0
%     
%             for k = 1:(length(spg{i,j}{iter}) - 1)
%                 mfg{i,j} = rmedge(mfg{i,j},spg{i,j}{iter}(k),spg{i,j}{iter}(k+1));
%             end
%             
%             iter = iter + 1;
%             spg{i,j}{iter} = mfg{i,j}.shortestpath(i,j);
%             
% end

