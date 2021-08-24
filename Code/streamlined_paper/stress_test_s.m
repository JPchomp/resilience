% function[DMAT] = stress_test_s(s,t,MP)
% s = Origins of interest...or all?
% t = Destinations of interest
% MP = Master path list. cell containing the paths for each OD
% 
%
run initialization.m
%if exist(maxflow)
[FTCD , distmatrix , capmatrix ] = adj_mats_s(fd, td, cdd, dd); 
% Assume we have initialization.
%%
% store number of nodes, will be used
n = numnodes(GD);

% Define Maximum T
T = 3000;

% Define Resolution
r = 20;

% Define the vector of traffics to be analysed in each point
Tv=linspace(1,T,r);

% Define nodes to be used in the stress test as OD pairs
s = 1:n; t = 1:n; 

% The distances Matrix
DM = zeros(n,n,r);

% Master paths cell, master pathcosts cell
MP = cell(n);
MPC = cell(n);
MFTCD = cell(n);
DS = cell(n,n);
DDS = cell(n,n,r);

%
ErrCell = {};

%% Initialize paths: Try shortest paths from all OD pairs
for idx = 1:length(s)
    
    i = s(idx);
    
    for idx2 = 1:length(t)

        j=t(idx2);
        
        if i~=j
        
        [MP{i,j},MPC{i,j}] = getsp_s(fd,td,dd,i,j);
        [MF , paths , pcosts] = maxflowpaths_st(GC,GD,i,j);
        
        MP{i,j} = [MP{i,j} ; paths];
        MPC{i,j} = [MPC{i,j} ; pcosts];
        
        else
        end
        
    end
    
end

%%
h = waitbar(0,'Beginning');

for k = 1:r

    % First flow level to be analysed
    Tij = Tv(k);
    
    % Temporary value to be stored
    M = zeros(n,n);
    
    %Errorcounter
    ErrCount = 0;

for idx = 1:length(s)
    
    i = s(idx);
    
    for idx2 = 1:i%length(t)

        j=t(idx2);
        
        if i~=j 
            
            %try
                %
                [kopath,capctr,dij,pathcosts,linklist,kpath] = setuppathproblem_s(MP{i,j}, MPC{i,j}, capmatrix ,i,j,Tij); 

                %Solve the LP problem in Cplex
                [sol] = solve_MCF_s(pathcosts, dij ,kopath);

                %Returns the solution part of cplex.Solution structure
                results = sol.Solution; 
                
                if strcmp(sol.Solution.statusstring, 'optimal')
               
                    %Store the relevant values
                    M(i,j)  = results.objval;
                    DS{i,j} = results.dual;
                
                else
                    
                    M(i,j)  = Inf;
                    
                end
                              
            %catch ME
                    
               % ErrCount = ErrCount + 1;
                
               % ErrCell{ErrCount} = {ErrCount,i,j,T, ME.identifier, ME.message};
                           
             %end

        else
                %if i == j
                
                M(i,j) = 0; DS{i,j} = 0;
                
        end
                                                                                                                                                                            
    end  
 
end

%Normalize the matrix by the traffic value and print
dmat=M/Tij;

%I am using a symmetric matrix, so always use this to have a square matrix:
dmat=dmat+dmat';

DM(:,:,k) = dmat;
DDS(:,:,k) = DS;

waitbar(k/r, h, sprintf('Calculating..%d',(k/r)*100))

end

close(h)

%%
stress_test_results(DM,Tv)

