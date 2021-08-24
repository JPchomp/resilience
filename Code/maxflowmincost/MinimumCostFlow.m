function [f,MinCost,MaxFlow]=MinimumCostFlow(a,c,V,s,t)
%% MinimumCostFlow.m
% minimum cost maximum flow algorithm universal Matlab function
%% ford and Fulkerson superposition algorithm based on Floyd shortest path algorithm
% Basic idea: Consider the cost of unit flow on each arc as a certain length, and use Floyd to find the shortest path to determine a
% The shortest path from V1 to Vn; then use this shortest path as an expandable path, and use the method to solve the maximum flow problem
% The amount of % increases to the maximum possible value; and after the flow on the shortest path increases, the cost per unit of flow on each arc is renewed.
% OK, so many iterations, and finally get the minimum cost maximum flow.
%% input parameter list
% a cost matrix for unit flow
% c link capacity matrix
% V The default value of the maximum stream, which can be infinite
% s source node
% t destination node
%% output parameter list
% f link traffic matrix
% MinCost minimum fee
% MaxFlow maximum flow
%% Step 1: Initialize

w = a;
[L,R]=FLOYD(w,s,t);

BV=999;

N=size(a,1); % node number
f = zeros (N, N); % flow matrix, initially zero flow
MaxFlow = sum(f(s,:));% max flow, initially zero
Flag=zeros(N,N);% true forward side should be remembered

for i=1:N
 for j=1:N
 if i~=j&&c(i,j)~=0
 Flag(i,j)=1;% forward edge marker
 Flag(j,i)=-1;% reverse edge marker
 end
 if a(i,j)==inf
 a(i,j)=BV;
 w(i,j)=BV;     % is to improve the robustness of the program, replacing infinity with a finite large number
 end
 end
end

if L(end)<BV
 RE=1;          % if the path length is less than the large number, the path exists.
else
 RE=0;
end
 
 
%% Step 2: Iterative process
while RE==1 && MaxFlow<=V % stop condition is the preset value of the maximum flow or the shortest path from s to t
 % below is the update network structure
 MinCost1=sum(sum(f.*a));
 MaxFlow1=sum(f(s,:));
 F1=f;
 TS=length(R)-1; % the number of hops the % path passes through
 LY=zeros(1,TS); % flow margin
 for i=1:TS
 LY(i)=c(R(i), R(i+1));
 end
 maxLY=min(LY);  % the minimum value of the % flow margin, that is, the maximum flow that can be increased
 for i=1:TS
 u=R(i);
 v=R(i+1);
 if Flag(u,v)==1&&maxLY<c(u,v)% when this edge is a forward edge and is an unsaturated edge
 f(u,v)=f(u,v)+maxLY;% record flow value
 w(u,v)=a(u,v);% update weight value
c(v,u)=c(v,u)+maxLY;% reverse link traffic margin update
 elseif Flag(u,v)==1&&maxLY==c(u,v)% When this edge is a forward edge and is a saturated edge
 w(u,v)=BV;% update weight value
 c(u,v)=c(u,v)-maxLY;% update flow margin value
 w(v,u)=-a(u,v);% reverse link weight update
 elseif Flag(u,v)==-1&&maxLY<c(u,v)% when this edge is a reverse edge and is an unsaturated edge
 w(v,u)=a(v,u);
 c(v,u)=c(v,u)+maxLY;
 w(u,v)=-a(v,u);
 elseif Flag(u,v)==-1&&maxLY==c(u,v)% when this edge is a reverse edge and is a saturated edge
 w(v,u)=a(v,u);
 c(u,v)=c(u,v)-maxLY;
 w(u,v)=BV;
 else
 end
 end
 MaxFlow2=sum(f(s,:));
 MinCost2=sum(sum(f.*a));
 if MaxFlow2<=V
 MaxFlow=MaxFlow2;
 MinCost=MinCost2;
 [L,R]=FLOYD(w,s,t);
 else
 f=f1+prop*(f-f1);
 MaxFlow=V;
 MinCost=MinCost1+prop*(MinCost2-MinCost1);
 return
 end
 if L(end)<BV
 RE=1;% if the path length is less than the large number, the path exists.
 else
 RE=0;
 end
end

