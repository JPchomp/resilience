function [link_flows, link_duals, comm_duals, D, F] = sol_handle_s(sol,dij,linklist,nl,nn,pathcosts,kpath)

%% to make simpler the main.m file
% grab the solution cplex throws and check
% Does .x exist? Store the duals.
% Was the answer feasible?

% F = Indicator of feasibility of solution
% D = HyperDistances matrix
% link_flows

D = zeros(nn,nn);

if strcmp(sol.Solution.statusstring,'optimal')
    
    F = 0;
    
    link_flows = [linklist , dij(:,1:end-1) * sol.Solution.x ];
    link_duals = [linklist , sol.Solution.dual(1:nl)];
    comm_duals = [sol.Solution.dual(nl+1:end)];
    
    % Build the hyperdistances matrix
    for idx = 1:length(pathcosts)
        D(kpath(idx,2), kpath(idx,3)) = D(kpath(idx,2), kpath(idx,3)) + sol.Solution.x(idx) * pathcosts(idx);
    end

else
    
    if exist('results.x','var')
        
        F = 1;
        
        link_flows = [linklist , dij(:,1:end-1) * sol.Solution.x ];
        link_duals = [linklist , sol.Solution.dual(1:nl)];
        comm_duals = [sol.Solution.dual(nl+1:end)];
        
        D(:,:) = Inf;
        
    else
        
        F = 2;
        
        link_flows = [linklist , zeros(length(linklist),1) ];
        link_duals = [linklist , zeros(length(linklist),1) ];
        comm_duals = [zeros(length(linklist),1)];
        
        D(:,:) = Inf;        
    end
    
end

end
    
    