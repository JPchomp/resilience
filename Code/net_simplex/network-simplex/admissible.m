function [ adf ] = admissible( f )
% This function returns the minimum cost flow for the original network if there is no flow on
% the additional arcs in the flow of the new network computed  by the fuction simplex, and else return 0
n=size(f);              
n=n(1);                 
a=max(f(n,:));          
b=max(f(:,n));          
c=max(a,b);             
if c==0                 
    adf=f;
    adf(n,:)=[];
    adf(:,n)=[];
else                    
    adf=0;
end