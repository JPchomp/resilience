%Trying to solve a mincostflow on cplex, later adapt this part for my
%problem

% Input data:
% lowerf[j]       flows lower bound j 
% upperf[j]       flows upper bound j
% pathcost[j]     cost for a given path j
% capacity[i][j]  capacity of an arc [i][j]
% demand[i][j][k] traffic that wants to go from i to j of type [k]

%
% Modeling variables:
% Buy[j]          amount of food j to purchase
% Objective:
% minimize sum(j) Buy[j] * foodCost[j]
%
% Constraints:
% forall foods i: nutrMin[i] <= sum(j) Buy[j] * nutrPer[i][j] <= nutrMax[j]

%Outputs:
%totalcost        z value of the solution 
%capduals[i][j]   a dual for each capacity constraint
%commdual[k]      a dual for each commodity demand 

%%
%%Data

cd 'C:\Users\Juan Pablo\OneDrive - University of Illinois - Urbana\Thesis\Code\Matlab\Column Generation\Test';

run Load_Data_CG.m

%%
DistList=unique([from,to,distance,capacity],'rows');          %Master List with Network Properties, filtering repeated links.

n=max(max(from),max(to));                                     %Initialize the guiding dimension of everything
distmatrix=sparse(n,n);                                       %Initialize the matrix of distances
capmatrix=sparse(n,n);                                        %Initialize the matrix of capacities


for i=1:length(DistList(:,1))
    
    iter=[DistList(i,1) DistList(i,2)];
    
    distmatrix(iter(1),iter(2))=DistList(i,3);                %Matrix Containing all distances between nodes
    
    capmatrix(iter(1),iter(2))=DistList(i,4);                 %Matrix Containing all capacities between nodes (times 80 as the value provided in the input .csv is assumed to be a density)
end

FTCD = [from to capacity distance ] ;

%%
%What are the nodes of interest and the traffic levels?
T=[1;1;1];

s=[1;1;2] ; t=[6;5;6];

%% Build Paths

[vnodes,pathcosts] = getsp(from,to,distance,s,t);                           %what if there is no path available between source and node? I want inf 

npath = length(pathcosts);
nk = length(s);

%% Set up the path flow formulation matrices

[kopath,capctr,dij] = setuppathproblem(vnodes,pathcosts,s,t,T,capmatrix,FTCD);   % kopath is the indicator of what path participates for what commodity.
                                                                                 % dij stores what path uses what arc, it only shows a 1 for the path column that uses it, and the capacity at the end.
                                                                                 % capctr stores the path number, the arcs contained and the capacity at the end. (it indicates a path number, not a one in a column)

%%

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
       
       FTCDr=FTCD;                                                                      %Set the initial FTCDr matrix to be the full matrix.
       
       infcounter = infcounter + 1;                                                     %How many times have we accessed the infeasible condition?
       
       startrange = length(pathcosts)+1;                                                %Starting range to update the other matrices
        
       [vnodes,pathcosts,FTCDr] = removelinksp(vnodes,pathcosts,capctr,FTCDr,s,t,startrange);%update the vnodes and pathcosts matrices to consider the new paths

       [kopath,capctr,dij] = setuppathproblem(vnodes,pathcosts,s,t,T,capmatrix,FTCD);   %setup the equations for the optimization module

   end

      catch m
          
   disp (m.message);
   throw (m);
   
end