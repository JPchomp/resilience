% DM, Tv are given.
% I want to check what happens with increasing intensity of the hazard, 
% Hv?




%%
% store number of nodes, will be used
n = numnodes(GD);


 %############## FLOW ####################################
% Define Maximum T
T = 3000;

% Define Resolution
r = 20;

% Define the vector of traffics to be analysed in each point
Tv=linspace(1,T,r);

 %############## HAZARD ##################################
% Define the shape of the hazard to be used, and the maximum intensity
 % The intensity at the peak 
R = 100; 
 % The standard deviation of a normally shaped rainfall
SD = 15;
 % Obtain the link centres
[XC,YC] = centeroflinks(xlocation,ylocation,from,to);
 % This returns a rainfall intensity at each link!
H = hzsim(XC , YC, xlocation, ylocation, R, SD);
 % Define resolution
rr = 10;
 % Vector of hazard intensities   
Hv = linspace(1,R,rr);

% Define nodes to be used in the stress test as OD pairs
s = 1:n; t = 1:n; 

%%
% The distances Matrix
DM = zeros(n,n,r,rr);

% Master paths cell, master pathcosts cell
MP = cell(n);
MPC = cell(n);
MFTCD = cell(n);
DS = cell(n,n);
DDS = cell(n,n,r,rr);

% 
ErrCell = {};

% 
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
for ii = 1:rr
    
    capacity_h = cap_hazard( H*(ii-1)/(rr) , capacity );                      % Update the capacities according to hazard intensity
    capacity_h = [capacity_h;capacity_h];                                     % Return in directed mode  
    
    [~,~ , capmatrix ] = adj_mats_s(fd, td, capacity_h , dd);                 % I need to update the capmatrix (lazy)
    
    for k = 1:r

        % First flow level to be analysed
        Tij = Tv(k);

        % Temporary value to be stored
        M = zeros(n,n);

        %Errorcounter
        ErrCount = 0;

for idx = 1:length(s)
    
    i = s(idx);
    
    for idx2 = 1:i % length(t)

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

DM(:,:,k,ii) = dmat;
DDS(:,:,k,ii) = DS;

    end
waitbar(ii/rr, h, sprintf('Calculating..%d',(ii/rr)*100))
end
close(h)

%%
% meshgrid(Hv,Tv)