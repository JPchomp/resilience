%% Compiler of the streamlined code

run initialization.m %GC and GD are defined here

[FTCD , distmatrix , capmatrix ] = adj_mats_s(fd, td, cdd, dd); 
%%
n = max(max(fd),max(td));   % Get number of nodes
nl = length(fd) ;           % Get number of links, no repeated links.

% If you define a traffic matrix, you are already defining the O-D of
% interest and the quantities of each commodity

    % Format for input data:
    % s = [1,1,2,2,3,3,4,4,5,5,6,6,7,7,8];  
    % t = [8,7,6,5,4,2,1,8,7,6,4,3,2,1,1];
    % T = [500,100,100,500,20,50,400,200,200,400,500,0,200,300,40]*1;

    % Def 2: Traffic, and origin destination pairs.
    Tmat = rand(n,n) * 100;
    Tmat = Tmat - diag(diag(Tmat));
    [s,t,T] = setup_traffic(Tmat);

% This function yields
% The matrix of maximum flows MF
% The paths that produce the maximum flow
% Costs of the paths found 
[MF , paths , pcosts] = maxflowpaths_st(GC,GD,s,t);

% Obtain the shortest paths and costs 
%[nsp,csp] = getsp_s(fd,td,dd,s,t);

% Define the superedges for unfulfilled demand
% This could be just addding path = {s , t}; pcost = {gamma};
%[nspSE, cspSE] =  getsuperedges_s(10000,s,t) ;

    %Set up the matrices for cplex; 
    %kopath: kommodity - path incidence matrix
    %capctr: list every link and its capacity, and the path it belongs to
    %dij: path - arc incidence matrix
    %pathcosts: the coefficients row for the objective
    %linklist: The sorted link list used in the constraints
    %[kopath,capctr,dij,pathcosts,linklist,kpath] = setuppathproblem_s([paths;nsp], [pcosts;csp], capmatrix ,s,t,T); 
    [kopath,capctr,dij,pathcosts,linklist,kpath] = setuppathproblem_s([paths], [pcosts], capmatrix ,s,t,T); 

    
%Solve the LP problem in Cplex
[sol] = solve_MCF_s(pathcosts, dij ,kopath);

%Returns the solution part of cplex.Solution structure
results = sol.Solution; 

% Results tidied up for plotting
link_res = [linklist , dij(:,1:end-1) * results.x , results.dual(1:nl)];

%Print the flows:
print_net_results(GC, link_res,xlocation,ylocation,Tmat)

%% Plot the paths?
D = zeros(n,n);
for idx = 1:length(pathcosts)
    D(kpath(idx,2), kpath(idx,3)) = D(kpath(idx,2), kpath(idx,3)) + results.x(idx) * pathcosts(idx);
end

%% Reduced costs
[nsp,csp] = getsp_mod_s(fd,td,dd,s,t,results);

%%
[kopath,capctr,dij,pathcosts,linklist,kpath] = setuppathproblem_s([paths;nsp], [pcosts;csp], capmatrix ,s,t,T);

%Solve the LP problem in Cplex
[sol] = solve_MCF_s(pathcosts, dij ,kopath);

%Returns the solution part of cplex.Solution structure
results = sol.Solution; 

% Results tidied up for plotting
link_res = [linklist , dij(:,1:end-1) * results.x , results.dual(1:nl)];

%Print the flows:
print_net_results(GC, link_res,xlocation,ylocation,Tmat)

%Obtain the Cost Matrix
D = zeros(n,n);
for idx = 1:length(pathcosts)
    D(kpath(idx,2), kpath(idx,3)) = D(kpath(idx,2), kpath(idx,3)) + results.x(idx) * pathcosts(idx);
end