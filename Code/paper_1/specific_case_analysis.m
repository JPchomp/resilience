   
%%Data

%Change folder path
cd 'C:\Users\Juan Pablo\OneDrive - University of Illinois - Urbana\Thesis\Code\paper_1';

%Load Data
run Load_Data_CG.m

%Store the initial undirected graph
UG=graph(from,to,distance);

%Convert to directed
undir();

%Write the main graph Object:
if dir==1
    
    G=digraph(DistList(:,1),DistList(:,2),DistList(:,3));
    
else
    
    G=graph(from,to,distance);

end

%G.Nodes.pop = population;
%G.Nodes.ele = elevation;

%%
DistList=unique([from,to,distance,capacity],'rows');          % Master List with Network Properties, filtering repeated links.

n=max(max(from),max(to));                                     % Initialize the guiding dimension of everything
distmatrix=sparse(n,n);                                       % Initialize the matrix of distances
capmatrix=sparse(n,n);                                        % Initialize the matrix of capacities

for i=1:length(DistList(:,1))
    
    iter=[DistList(i,1) DistList(i,2)];
    
    distmatrix(iter(1),iter(2))=DistList(i,3);                % Matrix Containing all distances between nodes
    
    capmatrix(iter(1),iter(2))=DistList(i,4);                 % Matrix Containing all capacities between nodes 
end

FTCD = [ from to capacity distance ] ;                        % Condensed Data matrix FTCD

FTCDr=FTCD;                                                   % The Reduced FTCD is already allocated as the original FTCD
ErrCount = 0;
ErrCell = {};                   
%% Generalized SP Matrix With CG (GSP_CG)
n=height(G.Nodes);
%verbose = 1;

%Matrix where the duals will be stored
%dualmat = zeros(length(f),1);
%Matrix where the flows will be stored
%flowmat = zeros(length(f),1);
DM = zeros(n,n,lT);
INDICATOR = 0;

MV = cell(n);
MPC = cell(n);
MFTCD = cell(n);

%%
h = waitbar(0,'Beginning');

for k = 1:lT

T = Tv(k);    
M = zeros(n,n);
ErrCount = 0;

sn=1;
en=n;                                                               % Override to calculate only the first to last terms

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
            
            try
                %objval, flowsol, dualsol, solsummary ,status
                [ M(i,j) , A{i,j}, DS{i,j,k}, C{i,j} , D{i,j}, MV{i,j}, MPC{i,j}, MFTCD{i,j}] = solveoptim(from, to, distance, capacity, T(i,j) ,[i],[j],capmatrix,FTCD,MFTCD,8,MV,MPC,0,INDICATOR);
                                          
            catch ME
                    
                ErrCount = ErrCount + 1;
                
                ErrCell{ErrCount} = {ErrCount,i,j,T, ME.identifier, ME.message};
                           
             end

        elseif i == j 
                
                M(i,j) = 0; A{i,j}=0; B{i,j}=0; C{i,j}=0; D{i,j} = 0;
                
        end
                                                                                                                                                                            
    end
                        if  s == sn && t == sn+1
                            esttime=etime(clock,ss)*(en-sn)* (lT - k);
                            
                        %['remaining time =',num2str(esttime*(1-((s-1)/(en-sn))),'%4.1f'),'sec' ] %esttime-etime(clock,ss)
                            
                        elseif s == sn && t == en                           % This module yields the progress bar    
                            is = etime(clock,ss);                           % Calculates after a full s loop, first t value
                            esttime = is * (en-sn) * (lT - k);
                        end
                        m1 = "remaining sec = %s"; m2 =  num2str(esttime*(1-((sn)/(en-sn))),'%4.1f');
                        waitbar(k/lT,h,sprintf(m1,m2)) %esttime-etime(clock,ss)
 
end

%Normalize the matrix by the traffic value and print
dmat=M/T;

if dir == 1
    dmat=dmat+dmat';
else
end

DM(sn:en,sn:en,k) = dmat(sn:en,sn:en);
disp(['At Traffic Level ',num2str(T)]);

INDICATOR = 1;
end
close(h)

DM

D0 = DM(:,:,1);

%plotallmetrics(DM,lT,20)