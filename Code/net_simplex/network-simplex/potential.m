function [ p ] = potential( L,pi,g,n )
%reduced cost by the potential pi
m=length(L);                                
for i=1:m                                   
    e=edge(L(i),n);                         
    p(i)= g(e(1),e(2))+pi(e(1))-pi(e(2));   
end
end