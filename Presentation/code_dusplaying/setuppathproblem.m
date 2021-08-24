function [kopath,capctr,dij] = setuppathproblem(vnodes,pathcosts,s,t,T,capmatrix, FTCD) %Input Traffic, origin set, destination set, 

%% Get the capacities that are relevant for the path. Each path will be a
% column 

capctr = zeros([],4);
kpath = [];
counter = 0;

for j = (1:length(pathcosts))
    for i = (1:length(vnodes(j,(1:vnodes(j,1000))))-1)
        counter = counter+1;
        capctr(counter,:) = [j, vnodes(j,i), vnodes(j,i+1), capmatrix(vnodes(j,i),vnodes(j,i+1))]; %Path number, arc start node , arc end node, capacity
        
        if vnodes(j,vnodes(j,1000)) == vnodes(j,i+1)
            kpath(j,:) = [j, vnodes(j,1), vnodes(j,i+1) ];                                          % This is used later, Saves the start and endpoint of the path
        end
        
    end
end

%% I want to get the number of times a link is used for each path
% dij is the matrix where each path is a column indicating 1 if the path 
% uses that link, and 0 if it does not.

%This will write the constriants of the LP directly.

check = unique([capctr(:,[2,3,4])],'rows');

dij = zeros([],max(capctr(:,1))+1);

for i = (1:length(capctr(:,1)))
    [a,b] = ismember(capctr(i,[2,3,4]),check,'rows');
    if a == 1
        dij(b,capctr(i,1))= 1;
        dij(b,length(dij(1,:))) = capctr(i,length(capctr(1,:)));
    end
end

%dij expanded : For
%aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaall
%links not used in any path add them as 0 0 0 use and their capacity

FTC = [FTCD(:,1) FTCD(:,2) FTCD(:,3)];

capacity = FTCD(:,3);

for i = (1:length(capacity))
    [a,~] = ismember(FTC(i,:),capctr(:,[2,3,4]),'rows');
    if a == 0
        dij(length(dij(:,1))+1,length(dij(1,:))) = capacity(i);
    end
end


 % Considering each path a column, we obtain if the path uses it or not, and write the capacity at the end..   
 
 %% Now i need to build the constraints for every origin-destination pair, a new commodity is created

% Demand between node A and B, is of X traffic.

demand = [s t T];
OD = [s t];

kopath = zeros(length(OD(:,1)),[]);

for i = (1:length(pathcosts))
    [a,b] = ismember([kpath(i,2) kpath(i,3)],OD,'rows');                    % I want to write # of commodity ( = OD Pair)..  
    if a == 1                                                               % and what path (column) satisfies that Commodity
        kopath(b,1)=b;
        kopath(b,i+1)= 1;
    end
end
 
    