function [kopath,capctr,dij,pathcosts,linklist,kpath] = setuppathproblem_s(paths, pathcosts, capmatrix ,s,t,T) %Input Traffic, origin set, destination set, 

% Make the pathcosts usable for the cplex opt module
pathcosts = cell2mat(pathcosts);

%% Get the capacities that are relevant for the path.
% Each path will be a column 

capctr = [];
kpath = [];

len = length(paths);

for j = (1:len)
    
    for i = 1 : length(paths{j}) - 1
        
        temp = paths{j}(i); temp2 = paths{j}(i+1); temp3 = full(capmatrix(temp,temp2));
             
        capctr = [capctr ; [j, temp, temp2, temp3 ] ];                      % Path number, arc start node , arc end node, capacity
        
    end
    
        kpath = [kpath ; [j, paths{j}(1), paths{j}(end) ]];                 % This is used later, Saves the start and endpoint of the path
    
end


%% I want to get the number of times a link is used for each path
% dij is the matrix where each path is a column 
% indicating 1 if the path uses that link, and 0 if it does not.
% and the capacity constraint in the last column

        %This will write the constriants of the LP directly.

linklist = unique([capctr(:,[2,3,4])],'rows');

dij = zeros([],max(capctr(:,1))+1);

for i = (1:length(capctr(:,1)))
    [a,b] = ismember(capctr(i,[2,3,4]),linklist,'rows');
    if a == 1   
        dij(b,capctr(i,1))= 1;
        dij(b,length(dij(1,:))) = capctr(i,length(capctr(1,:)));
    end
end

%% We need the commodity - path incidence matrix
    % This is checking for all the unique origin-destinations (each is a commodity)
    
    comm = [s',t',T'];
    nk = length(T);
            
kopath = zeros(nk,len);        %Theres going to be T(i) before and after

for i = 1:nk
    kopath(i,1:end) = (ismember(kpath(:,2:3),comm(i,1:2),'rows'))';
end

kopath = [T' , kopath, T']; 

 
    