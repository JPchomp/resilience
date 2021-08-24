%%Create the Network Model and Display it

if dir==1
    G=graph(DistList(:,1),DistList(:,2),DistList(:,3));
    
else
    G=digraph(from,to,distance);
end

plot(G,'XData',xlocation,'YData',ylocation,'EdgeLabel',G.Edges.Weight);title('Network Schematic');

%%
                                                                                                                %I run the distances between nodes into a list, and then compose a matrix

                                                                                                                % n=max(from);
                                                                                                                % distmatrix=zeros(n);
                                                                                                                % DistList=[from,to,distance];
                                                                                                                % for i=1:n
                                                                                                                %     for j=1:n
                                                                                                                %         for rown=1:length(from)
                                                                                                                %         if ismember(i,DistList(rown,1)) && ismember(j,DistList(rown,2)) 
                                                                                                                %         distmatrix(i,j)=DistList(rown,3);
                                                                                                                %         else
                                                                                                                %         end
                                                                                                                %         end
                                                                                                                %     end
                                                                                                                % end

n=max(max(from),max(to));
distmatrix=zeros(n);
%Initialize the matrix
DistList=[from,to,distance];  %Here we adpot a flow velocity of 90 just to be uncapacitated OBS CAPACITY IS DEFINED FOR EACH LINK OF FOR EACH FROM-TO PAIR

for i=1:length(from)
    distmatrix(DistList(i,1),DistList(i,2))=DistList(i,3);
end


%Same with the capacities

n=max(max(from),max(to));
capmatrix=zeros(n);
%Initialize the matrix
capList=[from,to,capacity*80];  %Here we adpot a flow velocity of 90 just to be uncapacitated OBS CAPACITY IS DEFINED FOR EACH LINK OF FOR EACH FROM-TO PAIR

for i=1:length(from)
    capmatrix(capList(i,1),capList(i,2))=capList(i,3);
end

%%
%Building the flow conservation conditions from the connectivity matrix:
% Flow Balance Constraint Matrix

Aeq=zeros(n,n*n); %Each row is each node, each column is each possible flow X11, x12,x13,....xn1 xn2..xnn
FT = [ from to ];

for i = 1:n
    for j = 1:n

	test=(FT(:,1)==i & FT(:,2)==j);
    
        if sum(test)>0
            Aeq(i,n*(i-1)+j)=1;
            Aeq(j,n*(i-1)+j)=-1;
            %I add the following to account for bidirectionality
%              Aeq(i,n*(j-1)+i)=-1;
%              Aeq(j,n*(j-1)+i)=1;            
            
        else
        end
    end
    
end

                        %I Believe i could implement using the adjacency or
                        %incidende matrix here instead.
                    
%% Write The positiveness requirement of each flow:

%A = eye(n*n,n*n); %%Replace with 

A=speye(n*n);

% Capacity Constraint Model: We need to have the capacity constraint of
% each link, with this script we get this list.
B = zeros(1,n*n);  %A is just 1 for each flow, and B will be the <=B side

for i=1:(n)
    for j=1:(n)
        B(1,(i-1)*n+j)=capmatrix(i,j);
                                        % B(1,(j-1)*n+i)=capmatrix(i,j);
    end
end

% Objective Function Costs (Distances)
f = zeros(1,n*n);

for i=1:(n)
    for j=1:(n)
        f(1,(i-1)*n+j)=distmatrix(i,j);
                                      %  f(1,(j-1)*n+i)=distmatrix(i,j); %I add this for bidirectionality
    end
end

%% Generalized SP Matrix (GSP)
options = optimoptions('linprog','Display','none');

%Set the Traffic Level that we want to analyse
T=1000;

%Initialize GSP
GSPmatrix=zeros(n,n);

%%
function [dmat] = GSPM(T)

for s = 1:n
    for t = 1:n

        i=s;
        j=t;
        
        Beq=zeros(n,1); %Reset the origin/demand vector
        
% This rewrites the demand/supply vector such that it changes for each s,t
% pair 
        if i~=j
    
            for i = 1:n
                if i == s
                    Beq(i)=T;
                elseif i==t
                    Beq(i)=-T;
                else
                end
            end
            [x,GSPmatrix(s,t)]=linprog(f,A,B,Aeq,Beq.',zeros(1,length(f)),repmat(max(max(capmatrix)),1,length(f)),options); %Run the solver for (s,t)
                                                                            %DIF=[DIF,B'-x]; This was meant to be the difference vector between the capacity and used flow
        else 
            GSPmatrix(s,t)=0;
            
        end
 
    end
end

%Normalize the matrix by the traffic value and print
dmat=GSPmatrix/T

