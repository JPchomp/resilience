function [ pi ] = pt( T,g,M )
% This function computes the potentials at all vertices for the given tree.
% In the computation, Warshall-Floyd Algorithm in the shortest path problem
% is essentially used 
n=size(g);                          
n=n(1);                             
t=zeros(n,n);                       
t(T)=1;                             
for i=1:n                           
    if t(n,i)>0
        t(n,i)=M;
    end
    if t(i,n)>0
        t(i,n)=M;
    end
end                                 
for j=1:n                           
    for k=1:n
        if t(j,k)>0
            t(j,k)=g(j,k);
            t(k,j)=-g(j,k);
        end
    end
end
W=wf(t);                            
pi=W(n,:);                          
end