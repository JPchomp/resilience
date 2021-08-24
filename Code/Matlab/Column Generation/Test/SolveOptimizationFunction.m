function [cplex.Solution.x,cplex.Solution.dual,cplex.Solution.statusstring] = solveoptim(cplex,cplex.Model.sense,capacity,T,s,t)

%% Build Paths

[vnodes,pathcosts] = getsp(from,to,distance,s,t);                                % what if there is no path available between source and node? I want inf 

npath = length(pathcosts);
spath = sum(pathcosts);

nk = length(s);

%% Set up the path flow formulation matrices

[kopath,capctr,dij] = setuppathproblem(vnodes,pathcosts,s,t,T,capmatrix,FTCD);   % kopath is the indicator of what path participates for what commodity.
                                                                                 % dij stores what path uses what arc, it only shows a 1 for the path column that uses it, and the capacity at the end.
                                                                                 % capctr stores the path number, the arcs contained and the capacity at the end. (it indicates a path number, not a one in a column)


infcounter=0;

while infcounter < 4
                    
% Build model
   cplex = Cplex('mincostflow');
   cplex.Model.sense = 'minimize';
   
disp("a")
   
    % The variables are the amount of flow to send in each path

    % Populate by column: the pathcosts obtained and zeros as lower bounds,
    % ones as upper bounds.

    cplex.addCols(pathcosts, [], zeros(length(pathcosts),1), max(capacity)*ones(length(pathcosts),1));
   
    % Now add the rows to the problem: the flow that effectively uses the
    % links 
   
   for i = 1:length(dij(:,length(dij(1,:))))                                                      % Up to the last column of the dij matrix
     %  [0, dij(i,1:(npath)), dij(i,npath+1)]                                
     cplex.addRows(0, dij(i,1:(length(dij(1,:)))-1), dij(i,length(dij(1,:))));                    % Add the multipliers 1 for path uses that arc, 0 for no. Upper bound is the capacity.
   end
   disp("b")
   for i = 1:nk
     %  [T(i), kopath(i,(2:length(kopath(1,:)))),T(i)]
       cplex.addRows(T(i), kopath(i,(2:length(kopath(1,:)))),T(i));
     
   end
   
   try 
   disp("c")
   % Optimize the problem
   cplex.solve();
   
   catch ME

   end
           disp(cplex.Solution.statusstring)

           if strcmp(cplex.Solution.statusstring , 'infeasible') 

               disp("Entered Inf")
               infcounter = infcounter + 1;                                                              % How many times have we accessed the infeasible condition? Control

               startrange = npath*(infcounter-1) + 1;                                                    % Starting range to update the other matrices

               [vnodes,pathcosts,FTCDr] = removelinksp(vnodes,pathcosts,capctr,FTCDr,s,t,startrange,npath);    % update the vnodes and pathcosts matrices to consider the new paths

               [kopath,capctr,dij] = setuppathproblem(vnodes,pathcosts,s,t,T,capmatrix,FTCDr);           % setup the equations for the optimization module
                
               check = ((infcounter - 1) * length(s)) + 1 : (infcounter) * length(s);
               
               if sum((dij(check,:)>0) <= length(check))
                   
                   disp("No more SPS!")
                                    
               end
               
           elseif strcmp(cplex.Solution.statusstring , 'optimal')

               infcounter = 5;
               
               disp("Entered FEASIBLE")
                % Write the solution
               fprintf ('\nSolution status = %s\n',cplex.Solution.statusstring);
               fprintf ('Solution value = %f\n',cplex.Solution.objval);
               disp ('Flow Values for path i = ');
               disp (cplex.Solution.x');

               disp ('Duals');
               disp (cplex.Solution.dual');
               [vnodes(1:end,1:4) , cplex.Solution.x, pathcosts]
               disp('YAY!!')
               
           end
 end