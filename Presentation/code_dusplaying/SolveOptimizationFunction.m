function [cplex.Solution.x,cplex.Solution.dual,cplex.Solution.statusstring] = solveoptim(cplex,cplex.Model.sense,pathcosts,capacity,dij,kopath,T,)

try
% Build model
   cplex = Cplex('mincostflow');
   cplex.Model.sense = 'minimize';

% The variables are the amount of flow to send in each path

% Populate by column: the pathcosts obtained and zeros as lower bounds,
% ones as upper bounds.

cplex.addCols(pathcosts, [], zeros(length(pathcosts),1), max(capacity)*ones(length(pathcosts),1));
   
   % Now add the rows to the problem: the flow that effectively uses the
   % links 
   
   for i = 1:length(dij(:,length(dij(1,:))))                                         % Up to the last column of the dij matrix
     %  [0, dij(i,1:(npath)), dij(i,npath+1)]                                
     cplex.addRows(0, dij(i,1:(length(dij(1,:)))-1), dij(i,length(dij(1,:))));                    % Add the multipliers 1 for path uses that arc, 0 for no. Upper bound is the capacity.
   end
   
   for i = 1:nk
     %  [T(i), kopath(i,(2:length(kopath(1,:)))),T(i)]
       cplex.addRows(T(i), kopath(i,(2:length(kopath(1,:)))),T(i));
   end
   
   % Optimize the problem
   cplex.solve();
   
   infcounter=0;
   
   if cplex.Solution.statusstring == 'optimal'
   
   % Write the solution
       fprintf ('\nSolution status = %s\n',cplex.Solution.statusstring);
       fprintf ('Solution value = %f\n',cplex.Solution.objval);
       disp ('Flow Values for path i = ');
       disp (cplex.Solution.x');

       disp ('Duals');
       disp (cplex.Solution.dual');
   
   elseif cplex.Solution.statusstring == 'infeasible'
       infcounter = infcounter + 1;

       [vnodes,pathcosts] = removelinksp(vnodes,pathcosts,capctr,FTCD,s,t); %update the vnodes and pathcosts matrices to consider the new paths

       [kopath,capctr,dij] = setuppathproblem(vnodes,pathcosts,s,t,T,capmatrix,FTCD); %setup the equations for the optimization module

   end

      catch m
          
   disp (m.message);
   throw (m);
   
end