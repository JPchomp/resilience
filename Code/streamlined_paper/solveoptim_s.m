function [objval, flowsol, dualsol, solsummary ,status, MVi, MPCi, MFTCDi] =  solveoptim_s(from,to,distance,capacity,T,s,t, capmatrix, FTCD , MFTCD , breadth ,MV,MPC,verbose,INDICATOR)

%% We take the network structure and 

FTCDr = FTCD;

%% Build Paths

if     INDICATOR == 0 

    [vnodes,pathcosts] = getsp(from,to,distance,s,t);                

elseif INDICATOR == 1

    vnodes = MV{s,t}    ;
    pathcosts = MPC{s,t};
    FTCDr = MFTCD{s,t}  ;
    
end

    npath = length(pathcosts);
    spath = sum(pathcosts)   ;
    nk = length(s)           ; 

    %FTCDr = FTCD; JUST TO AVOID THE GETTING STUCK REMOVE NO PROB

    
%% Set up the path flow formulation matrices

[kopath,capctr,dij] = setuppathproblem(vnodes,pathcosts,s,t,T,capmatrix,FTCD);   % kopath is the indicator of what path participates for what commodity.
                                                                                 % dij stores what path uses what arc, it only shows a 1 for the path column that uses it, and the capacity at the end.
                                                                                 % capctr stores the path number, the arcs contained and the capacity at the end. (it indicates a path number, not a one in a column)
                                                                                 
%% Get ready to loop and find more paths

infcounter=0;

while infcounter < breadth
   
    sol = solve_MCF_s(pathcosts, capacity, dij ,kopath);
   
           if strcmp(sol.statusstring , 'infeasible') 
               
               infcounter = infcounter + 1 ;                                                                    % How many times have we accessed the infeasible condition? Control

               startrange = npath*(infcounter-1) + 1 ;                                                          % Starting range to update the matrices accordingly

               [vnodes,pathcosts,FTCDr] = removelinksp(vnodes,pathcosts,capctr,FTCDr,s,t,startrange,npath);     % update the vnodes and pathcosts matrices to consider the new paths

               [kopath,capctr,dij] = setuppathproblem(vnodes,pathcosts,s,t,T,capmatrix,FTCDr) ;                 % setup the equations for the optimization module
                    
               if (sum(vnodes(end,:)) == 0)
                   
                   %disp("No more SPS!")                                                                        %If no more alternatives are found, then the whole thing is infeasible.
                   infcounter = breadth;                                                                        %Set the search to end.
                                    
               end
               
           elseif strcmp(cplex.Solution.statusstring , 'optimal')

               infcounter = breadth;
                             
           end
end
 

%%
if strcmp(cplex.Solution.statusstring , 'optimal')
    objval = cplex.Solution.objval;
    flowsol = cplex.Solution.x;
    dualsol = cplex.Solution.dual;
    solsummary = {vnodes(1:end,1:4) , cplex.Solution.x, pathcosts};
    status =  cplex.Solution.statusstring;
    
    
elseif strcmp(cplex.Solution.statusstring , 'infeasible')
    objval = Inf;
    flowsol = zeros(1, length(pathcosts));
    dualsol = zeros(length(capacity),1);
    solsummary = {vnodes(1:end,1:4) , flowsol, pathcosts};
    status =  cplex.Solution.statusstring;  
    
end

MVi = vnodes(sum(vnodes,2)>0,:);
MPCi = pathcosts(sum(pathcosts,2)<Inf,:);
MFTCDi = FTCDr;

end
