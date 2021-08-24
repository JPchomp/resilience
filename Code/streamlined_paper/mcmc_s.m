%% Load Data and set up paths

run initialization.m

[FTCD , distmatrix , capmatrix ] = adj_mats_s(fd, td, cdd, dd);

nn = max(max(fd),max(td));      % Get number of nodes
nl = length(fd) ;               % Get number of links, no repeated links.

    % Def 2: Traffic, and origin destination pairs.
    Tmat = rand(nn,nn) * 300;
    Tmat = Tmat - diag(diag(Tmat));
    [s,t,T] = setup_traffic(Tmat);
    
    % This function yields
    % The matrix of maximum flows MF
    % The paths that produce the maximum flow
    % Costs of the paths found 
    [MF , paths , pcosts] = maxflowpaths_st(GC,GD,s,t); 

    % Obtain the shortest paths and costs 
    [nsp,csp] = getsp_s(fd,td,dd,s,t);
    
    % Ok, so we have the paths to be used.
    
%%
%number of simulations to run
n = 10000;

%counter of acceptance rate in MCMC
counter = 0;

%Topology of the network data:
    %Obtain the central location of every link
[XC,YC] = centeroflinks(xlocation,ylocation,from,to);

    %Obtain the SP distance in the original G
    DG =  distances(GD);

%Historical Rainfall load
if exist('HH','var') == 0
    
    HH=xlsread("C:\Users\Juan Pablo\OneDrive - University of Illinois - Urbana\Spring 2020\CEE598UQ - Uncertainty Quantification\Term Project\hist_rainfall.xlsx",'B:B');
    fit = gevfit(HH); k = fit(1); sigma = fit(2); mu = fit(3);

else
end

%Historical Traffic: Here its simulated in the absence of data
% if exist('TT','var') == 0
%     HH=xlsread("C:\Users\Juan Pablo\OneDrive - University of Illinois - Urbana\Spring 2020\CEE598UQ - Uncertainty Quantification\Term Project\hist_traffic.xlsx",'B:B');
%     [meantt, sdtt] = lognfit(TT);
% else
% end
% meantt=log((mmtt^2)/sqrt(stt + mmtt^2)); 
% sdtt = sqrt(log((stt/(mmtt^2))+1));

% What would the traffic for each link look like. Something increasing for the whole matrix? 

mmtt = 0.0001; stt = 0.0001;

%initialize results empty vectors
res = zeros(n,1);
Rvec = zeros(n,1);
Tvec = zeros(n,1);
Pf = zeros(n,1);
Pfv = zeros(n,1);
DS={}; 
CDS=zeros(nl,1);

%display a progress bar
h = waitbar(0,'Please wait...');

for trial = 1:n

if trial == 1                                                              %%%%%%%%%%% TRIAL = 1: Initialization
%% Sample simulation
        
        R = gevrnd(k,sigma,mu);  % Rainfall intensity  ~100mm
    
        H = hzsim(XC , YC, xlocation, ylocation, R, 15);
    
        Tparam = mmtt + exprnd(stt); %lognrnd(meantt,sdtt); % Small numbers

%% Event produced from Simulation

        Tmat = gentraffics(population, DG,Tparam); % Traffic Event k

        capacity_h = cap_hazard( H , capacity ); % Rainfall Event k
 
        [FTCD , distmatrix , capmatrix ] = adj_mats_s(fd, td, [capacity_h;capacity_h], dd);
        
%% Obtention of the Routing Cost Matrix

        [s,t,T] = setup_traffic(Tmat);
        
        [kopath,capctr,dij,pathcosts,linklist,kpath] = setuppathproblem_s([paths;nsp], [pcosts;csp], capmatrix ,s,t,T); 

%Solve the LP problem in Cplex
        [sol] = solve_MCF_s(pathcosts, dij ,kopath);

%Handle the solution vector, considering feasibility
        [link_flows, link_duals, comm_duals, D, F] = sol_handle_s(sol,dij,linklist,nl,nn,pathcosts,kpath);
     
%% Average Veh. Cost Calculation and storage of results for each mcmc trial

        res(trial) = abs(sum(sum(D-DG.*Tmat))); 
        
        Rvec(trial) = R;
        
        Tvec(trial) = Tparam;
        
        DS{trial} = link_duals(:,4);
        
else                                                                       %%%%%%%%%%%%%%%% TRIAL = >1: 
    
    rng shuffle
    
    %% Sample simulation    
        R = gevrnd(k,sigma,mu);  % Rainfall intensity  ~100mm

        Tparam = mmtt + exprnd(stt); %lognrnd(meantt,sdtt); % Small numbers

            p = log(gevpdf(R,k,sigma,mu)) + log(exppdf(Tparam -mmtt,stt));
            p1 = log(gevpdf(Rvec(trial-1),k,sigma,mu)) + log(exppdf(Tvec(trial-1) - mmtt, stt));

        if rand() < exp(p-p1)                                                                                %MCMC
               
                counter = counter + 1;
                
                H = hzsim(XC , YC, xlocation, ylocation, R, 15);

                 %% Event produced from Simulation 

                Tmat = gentraffics(population,DG,Tparam);  % Traffic Event k

                capacity_h = cap_hazard( H , capacity ); % Rainfall Event k

                [FTCD , distmatrix , capmatrix ] = adj_mats_s(fd, td, [capacity_h;capacity_h], dd);

                 %% Obtention of the Routing Cost Matrix 
                [s,t,T] = setup_traffic(Tmat);
                [kopath,capctr,dij,pathcosts,linklist,kpath] = setuppathproblem_s([paths;nsp], [pcosts;csp], capmatrix ,s,t,T); 


                %Solve the LP problem in Cplex
                [sol] = solve_MCF_s(pathcosts, dij ,kopath);

                %Handle the solution vector, considering feasibility
                [link_flows, link_duals, comm_duals, D, F] = sol_handle_s(sol,dij,linklist,nl,nn,pathcosts,kpath);
        
                % Average Veh. Cost Calculation and storage of results
                res(trial) = abs(sum(sum(D-DG.*Tmat)));                                                               
                Rvec(trial) = R;
                Tvec(trial) = Tparam;
                DS{trial} = link_duals(:,4);

    
        else
        %Stay at previous
            res(trial) = res(trial-1);
            Rvec(trial) = Rvec(trial-1);
            Tvec(trial) = Tvec(trial-1);
            DS{trial} = DS{trial-1};

        end
    
    %Empirical Pf and Variance
        Pf(trial) = sum(res(1:trial) == Inf)/trial;
        Pfv(trial) = var(Pf(1:trial));  
        
end
%CDS = CDS./trial; % sample mean of cumulative costs

waitbar(trial/ n)
end

Tvec = Tvec * 4000;

close(h)

%%%
%% Figures Block

color = 'w';
fsize = 10;
posize = [100,100,500,250];


% 3D Histogram of sampled events
figs(1) = figure(1);

set(gcf,'color','w');
X = [Rvec,Tvec];
hist3(X,'CDataMode','auto','FaceColor','interp')
xlabel('IM')
ylabel('Flow Demand')
title('Distribution of F/IM Sampled')
view(135,45)
hold off;

% 2D histogram of expected yearly costs
figs(2) = figure(2);  
set(gcf,'color','w');
nhist(res,'title','Distribution of Extra Km-Vehicle travelled', 'xlabel', 'Extra Vehicle-Km','ylabel','Count')
hold off;

% %histogram for the storm data
% figs(3) = figure(3);
% set(gcf,'color','w');
% bins = 0:5:max(HH);
% h = histfit(HH,20,'gev');
% %h = bar(bins,histc(HH,bins)/length(HH),'histc');hold on;
% h(1).FaceColor = [.9 .9 .9];
% % ygrid = linspace(min(HH),max(HH),100);
% % line(ygrid,gevpdf(ygrid,k,sigma,mu));
% xlabel('Maximum');
% ylabel('Probability Density');
% % xlim([min(HH) max(HH)]);


% Define the link labels correctly
lab = string([]);
for  i = 1 : length(linklist)
    ll = string([linklist(i,1),linklist(i,2)]);
    lab(i) = strcat("(",ll(1),",",ll(2),")");
end

% Post event capacity sample
figs(4) = figure(4);
set(gcf,'color','w');
x = [1:length(capacity)];
vals = [capacity(x), capacity_h(x)];
b = bar(x,vals);
set(gca,'XLim',[0 length(capacity)+1],'XTick',[1:1:length(capacity)]);
xlabel('Link ID');
set(gca,'xticklabel',lab);
ylabel('Capacity');
legend('Original Capacity','Post-Event Capacity',...
       'Location','NE')

DDS = [DS{:,:}];

% Mean "cost averted by unit capacity" bargraph 
figs(5) = figure(5);
set(gcf, 'Position',  posize);
set(gcf,'color','w');
b = bar(abs(sum(DDS,2)));
set(gca,'XLim',[1 24],'XTick',[1:1:24])
xlabel('Link ID');
set(gca,'xticklabel',lab)
set(gca,'xticklabelrotation',35)
ylabel('Accumulated dual costs (veh-km)');
pbaspect([2 1 1])
set(gca,'FontSize', fsize)
...legend('Original Capacity','Post-Event Capacity','Location','NW')
    

set(gcf, 'Position',  posize);
set(gcf,'color','w');
p3 = plot(GD,'XData',xlocation,'YData',ylocation,'MarkerSize',5);
p3.EdgeCData = abs(sum(DDS,2));
colormap(jet);
pbaspect([2 1 1])
set(gca,'FontSize', fsize)
colorbar
% plot(digraph(linklist(1,:),linklist(2,:),abs(sum(DDS,2)))


    
% Autocorrelation of MCMC
figs(6) = figure(6);
set(gcf,'color','w');
[c,lags] = xcorr(Rvec);
stem(lags,c)
xlabel('Lag');
ylabel('Correlation');
legend('Autocorrelation of MCMC','Location','NW')

%figure7
run plotpf.m;

% % set(gcf,'color','w');
% % ecdf(rres)
% % xlabel('Performance Cost');
% % ylabel('F(x)');
% % legend('P(c<C)','Location','NW')

savefig(figs,pwd)
