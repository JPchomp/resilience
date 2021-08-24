%%Create the Network Model and Display it

if dir==1
    G=digraph(DistList(:,1),DistList(:,2),DistList(:,3));
    
else
    G=graph(from,to,distance);
end

%Plot Network unweighted with distances
plot(G,'XData',xlocation,'YData',ylocation,...
    'EdgeLabel',distance,... 
    'LineWidth',2,...
    'NodeColor','r',...
    'NodeLabel',[1,2,3,4,5,6]);
    title('Sample Network');    

%Plot Network with nodes as connectivity
plot(G,'XData',xlocation,'YData',ylocation,...
    'EdgeLabel',distance,... 
    'LineWidth',2,...
    'NodeColor','r');...
    title('Sample Network')

%Plot network with capacity as widths
LWidths = 5*capacity/max(capacity);
plot(G,'XData',xlocation,'YData',ylocation,...
    'EdgeLabel',capacity,'LineWidth',LWidths);...
    title('Sample Network');                                             %,'EdgeLabel',G.Edges.Weight too messy to display

%plot inundation susceptibility as colormap
BWidths = 5*altitude/max(altitude);colormap winter;
plot(G,'XData',xlocation,'YData',ylocation,...
    'EdgeCData',altitude,'NodeColor','r',...
    'EdgeLabel',altitude,'LineWidth',LWidths);...
    title('Sample Network');colorbar;         
 

%%
DistList=unique([from,to,distance,capacity],'rows');          %Master List with Network Properties, filtering repeated links.

n=max(max(from),max(to));                                     %Initialize the guiding dimension of everything
distmatrix=sparse(n,n);                                       %Initialize the matrix of distances
capmatrix=sparse(n,n);                                        %Initialize the matrix of capacities


for i=1:length(DistList(:,1))
    
    iter=[DistList(i,1) DistList(i,2)];
    
    distmatrix(iter(1),iter(2))=DistList(i,3);                %Matrix Containing all distances between nodes
    
    capmatrix(iter(1),iter(2))=DistList(i,4);              %Matrix Containing all capacities between nodes (times 80 as the value provided in the input .csv is assumed to be a density)
end

%%
%Building the flow conservation conditions from the connectivity matrix:
% Flow Balance Constraint Matrix

Aeq=sparse(n,n*n); %Each row is each node, each column is each possible flow X11, x12,x13,....xn1 xn2..xnn

for i = 1:n
    for j = 1:n

	test=(DistList(:,1)==i & DistList(:,2)==j);
    
        if sum(test)>0
            Aeq(i,n*(i-1)+j)=1;
            Aeq(j,n*(i-1)+j)=-1;
                                                                                                %I add the following to account for bidirectionality
                                                                                    %              Aeq(i,n*(j-1)+i)=-1;
                                                                                    %              Aeq(j,n*(j-1)+i)=1;            for now i chose to pursue modifying the input data
            
        else
        end
    end
    
end

                                                                                        %I Believe i could implement using the adjacency or
                                                                                        %incidence matrix of the Graph function of matlab.
                    
%% Write The positiveness requirement of each flow:

A=speye(n*n);

% Capacity Constraint Model: We need to have the capacity constraint of
% each link, with this script we get this list.                                 Ax<=Cap

B = sparse(1,n*n);  %A is just 1 for each flow, and B will be the <=B side

for i=1:(n)
    for j=1:(n)
        B(1,(i-1)*n+j)=capmatrix(i,j);
                                                                            % B(1,(j-1)*n+i)=capmatrix(i,j); %I add this for bidirectionality
    end
end

% Objective Function Costs (Distances)
f = sparse(1,n*n);

for i=1:(n)
    for j=1:(n)
        f(1,(i-1)*n+j)=distmatrix(i,j);
                                                                            %  f(1,(j-1)*n+i)=distmatrix(i,j); %I add this for bidirectionality
    end
end

%% Generalized SP Matrix (GSP)
n=6;
options = optimoptions('linprog','Display','none');

%Set the Traffic Level that we want to analyse
T=5;

%Matrix where the duals will be stored
dualmat = zeros(length(f),1);
%Matrix where the flows will be stored
flowmat = zeros(length(f),1);

counter = 0;
%Initialize GSP
GSPmatrix=zeros(n,n);

        lb=sparse(1,length(f));                                             % Lower bound of zero value
        ub=repmat(max(max(capmatrix)),1,length(f));                         % Upper bound Matrix made of Top Capacity in the network

%%
        sn=1;
        en=6;                                                               % Override to calculate only the first to last terms

h = waitbar(0,'Starting...');

ss = clock;

esttime=(en-sn)*(en-sn);



for s = sn:en
    
    if dir == 0
    ssn=sn;
    elseif dir == 1                                                         % This block checks that the network is undirected, then it only calculates the upper diagonal
    ssn=s;
    end

    for t = ssn:en                                                          % If you start from s here we can calculate only the upper/lower diag and save time (Only for Undirected Network).
          
        i=s;
        j=t;
        
        if i~=j
            
            counter = counter + 1;                                          % Counter
            
            Beq=sparse(n,1);                                                % Reset the origin/demand vector CHECK IF SPARSE IS OK
            
            Beq(s)=T;                                                       % This rewrites the demand/supply vector such that it changes for each s,t
            Beq(t)=-T;

            [flows,MC,duals]=minCost(f,A,B,Aeq,Beq,lb,ub,options);                        % Try cplexlp !!!!          % [x,GSPmatrix(s,t)]=linprog(f,A,B,Aeq,Beq.',lb,ub,options); %Run the solver for (s,t)
                                                                            % DIF=[DIF,B'-x]; This was meant to be the difference vector between the capacity and used flow
            if isempty(MC) == 1                                             % This ifblock checks that the LP can 
                                                                            % be solved, otherwise assigns inf for
                                                                            % []    
                GSPmatrix(s,t) = Inf;
                dualmat(:,counter) = zeros(length(f),1);
                flowmat(:,counter) = zeros(length(f),1); 
            else
                GSPmatrix(s,t) = MC;                                        % Store the solution value, duals for capacity and flows per solution 
                dualmat(:,counter) = duals.ineqlin;
                flowmat(:,counter) = flows;
            end
                                                                            

                                                                            
        else 
            GSPmatrix(s,t)=0;                                               % zeros accross the diagonal
                      
        end
                        if  s == sn && t == sn+1
                            esttime=etime(clock,ss)*(en-sn);
                            
                        h = waitbar((s-sn)/(en-sn),h,...
                        ['remaining time =',num2str(esttime*(1-((s-1)/(en-sn))),'%4.1f'),'sec' ]); %esttime-etime(clock,ss)
                            
                        elseif s == sn && t == en                           % This module yields the progress bar    
                            is = etime(clock,ss);                           % Calculates after a full s loop, first t value
                            esttime = is * (en-sn);
                        end

                        h = waitbar((s-sn)/(en-sn),h,...
                        ['remaining time =',num2str(esttime*(1-((s-sn-1)/(en-sn))),'%4.1f'),'sec' ]); %esttime-etime(clock,ss)
    end
end

close(h)

%Normalize the matrix by the traffic value and print
dmat=GSPmatrix/T;

if dir == 1
    dmat=dmat+dmat';
else
end

dmat(sn:en,sn:en)
disp(['At Traffic Level ',num2str(T)])

