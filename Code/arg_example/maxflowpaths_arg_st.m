function [R , spgf , pcsf ] = maxflowpaths_arg_st(GC,GD,s,t) %Input the graph with capacities and distances and origin destinations

%% We Attempt to get all the paths related to the maximum flow

% T is the traffic for each s,t pair

% Define the size of all the matrices and cells by the num of nodes.

n = length(s); 

R = zeros(1,n) ; mfg = {};

% Define spg, the cell with the maximum flow paths
% Define pcs, the cost of each maximum flow path

spg = cell(n,1); pcs = cell(n,1); 

h = waitbar(0,'Beginning');

for i = 1:n
             

    
            % Store the max flows and digraphs
            [R(i),mfg{i}] = GC.maxflow(s(i),t(i));
 
            %Find all paths within the max flow digraph
            spg{i} = pathbetweennodes(mfg{i}.adjacency , s(i) , t(i));
           
            %For each path found find the cost:
            for p = 1 : length(spg{i})
                
                % a) Initialize the cost as zero
                pcs{i}(p,1) = 0;
                
                % For each edge in the path p:
                for k = 1 : length(spg{i}{p})-1
                
                    % Cycle through each path and sum each links cost
                     pcs{i}(p,1) = pcs{i}(p,1) + ...
                         GD.Edges.Weight(findedge(GD,spg{i}{p}(k),spg{i}{p}(k+1))); %Matlab2020 has a faster way for this % used to be mfg{i}
                end
            
            
            end
            
waitbar(i/n, h, sprintf('Calculating..%d',(i/n)*100))
end
close(h)
%% Considering its use will be for inputting later as a full thing
% This looks very inefficient

spgf = {};
pcsf = {};

for i = 1:length(spg)
    spgf = [ spgf ; spg{i} ] ;
    pcsf = [ pcsf ; pcs{i} ] ;
end
