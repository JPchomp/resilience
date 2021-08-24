%% Imagine i already have the previous paths

%T = []
ErrCell = {};
    tempo = (1:n)';
    origs = repmat(tempo,n,1);
    dests = sort(origs);


M = zeros(n,n) ;
ErrCount = 0   ;    

sn=1;
en=n;                                                               % Override to calculate only the first to last terms

%                                                                   ss = clock;
% 
%                                                                    esttime=(en-sn)*(en-sn);



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
                [ M(i,j) , ~, DS{i,j} , ~ , ~, ~, ~, ~] = solveoptim( from, to, distance, capacity, T(:)' ,origs',dests',capmatrix,FTCD,MFTCD,8,MV,MPC,0,0);
                                          
            catch ME
                    
                ErrCount = ErrCount + 1;
                
                ErrCell{ErrCount} = {ErrCount,i,j,T(i,j), ME.identifier, ME.message};
                           
             end

        elseif i == j 
                
                M(i,j) = 0; A{i,j}=0; B{i,j}=0; C{i,j}=0; D{i,j} = 0;
                
        end
                                                                                                                                                                            
    end
%                         if  s == sn && t == sn+1
%                             esttime=etime(clock,ss)*(en-sn)* (lT - k);
%                             
%                         %['remaining time =',num2str(esttime*(1-((s-1)/(en-sn))),'%4.1f'),'sec' ] %esttime-etime(clock,ss)
%                             
%                         elseif s == sn && t == en                           % This module yields the progress bar    
%                             is = etime(clock,ss);                           % Calculates after a full s loop, first t value
%                             esttime = is * (en-sn) * (lT - k);
%                         end
% 
%                         ["remaining time = ", num2str(esttime*(1-((s-sn-1)/(en-sn))),'%4.1f'),'sec' ] %esttime-etime(clock,ss)
 
end

% Normalize the matrix by the traffic value and print
dmat=M;

% 
idx = eye(size(dmat))==1;
dmat(idx) = 0;

if dir == 1
    dmat = dmat + dmat';
else
end
