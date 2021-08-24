function [ d ] = wf( A )
%This function computes the shortest path by Warshall-Floyd Algorithm.
n=size(A);                              
m=n(1);                                 
d=A;                                    
d(A==0)=Inf;                            
p=zeros(n);                             
for s=1:m
    p(s,:)=s;                           
end
for k=1:m                               
    for i=1:m
        for j=1:m			
            if d(i,j)>d(i,k)+d(k,j)     
                d(i,j)=d(i,k)+d(k,j);   
                p(i,j)=k;               
            end
        end
    end
end