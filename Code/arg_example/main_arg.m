%% Compiler of the streamlined code

run initialization_arg.m %GC and GD are defined here

%%
[FTCD , distmatrix , capmatrix ] = adj_mats_s(fd, td, cdd, dd); 

n = max(max(fd),max(td));   % Get number of nodes
nl = length(fd) ;           % Get number of links, no repeated links.

% If you define a traffic matrix, you are already defining the O-D of
% interest and the quantities of each commodity

    % Format for input data:
    % s = [1,1,2,2,3,3,4,4,5,5,6,6,7,7,8];
    % t = [8,7,6,5,4,2,1,8,7,6,4,3,2,1,1];
    % T = [500,100,100,500,20,50,400,200,200,400,500,0,200,300,40]*1;

    % Def 2: Traffic, and origin destination pairs.
    %Load the matlabbed format origin destination table
    L =  6000; % Define the traffic threshold to calculate
    
    load("C:\Users\Juan Pablo\OneDrive - University of Illinois - Urbana\Thesis\Code\arg_example\OD.mat");
    Tmat = OD;
    [s,t,T] = setup_traffic_arg(Tmat,L);
    
    %Scale for usefulness
    T = T.*(500./max(T));
    
% This function yields
% The matrix of maximum flows MF
% The paths that produce the maximum flow
% Costs of the paths found 

[MF , paths , pcosts] = maxflowpaths_arg_st(GC,GD,s,t);

% Obtain the shortest paths and costs 
[nsp,csp] = getsp_s(fd,td,dd,s,t);

% Define the superedges for unfulfilled demand
%[nspSE, cspSE] =  getsuperedges_s(10000,s,t) ;

    %Set up the matrices for cplex; 
    %kopath: kommodity - path incidence matrix
    %capctr: list every link and its capacity, and the path it belongs to
    %dij: path - arc incidence matrix
    %pathcosts: the coefficients row for the objective
    %linklist: The sorted link list used in the constraints
    %[kopath,capctr,dij,pathcosts,linklist,kpath] = setuppathproblem_s([paths;nsp], [pcosts;csp], capmatrix ,s,t,T); 
    [kopath,capctr,dij,pathcosts,linklist,kpath] = setuppathproblem_s([paths], [pcosts], capmatrix ,s,t,T); %Can you improve this?

    
%Solve the LP problem in Cplex
[sol] = solve_MCF_s(pathcosts, capacity, dij ,kopath);

%Returns the solution part of cplex.Solution structure
results = sol.Solution; 

% Results tidied up for plotting
link_res = [linklist , dij(:,1:end-1) * results.x ];

%Add outstanding capacity
link_res = [link_res , link_res(:,3)-link_res(:,4) ];

%Print the flows:
print_net_results_arg(GC, link_res,xlocation,ylocation,Tmat)

