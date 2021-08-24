function [cplex] = solve_MCF_arg_s(pathcosts, dij ,kopath)

nk = length(kopath(:,1));

% Build model

   cplex = Cplex('mincostflow');
   cplex.DisplayFunc = [];
   cplex.Model.sense = 'minimize';
   
    % The variables are the amount of flow to send in each path

    % Populate by column: the pathcosts obtained and zeros as lower bounds,
    % ones as upper bounds.

    cplex.addCols(pathcosts, [], zeros(length(pathcosts),1), max(dij(:,end))*ones(length(pathcosts),1));
        
    % Now add the rows to the problem: the flow that effectively uses the
    % links
   
   for i = 1:length(dij(:,length(dij(1,:))))                                                      % Up to the last column of the dij matrix
                                
     cplex.addRows(0, dij(i,1:(length(dij(1,:)))-1), dij(i,length(dij(1,:))));                    % Add the multipliers 1 for path uses that arc, 0 for no. Upper bound is the capacity.
   
   end
      
    % Add the flow requirements constraints, OD Flow = T
   
   for i = 1:nk
    
     cplex.addRows(kopath(i,1), kopath(i,(2:end-1)),kopath(i,end));
     
   end
   
   cplex.solve();
   
end