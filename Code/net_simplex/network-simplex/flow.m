function [f ] = flow( b )
%This function sets the initial tree solution for the given network.
c=size(b);                          
c=c(1);                             
f=b;                                
for i=1:c-1                         
    for j=1:c-1
        f(i,j)=0;
    end
end
for i=1:c
    for j=1:c                       
        if f(i,j)~=0                
            f(i,j)=f(i,j)-1;
        end
    end
end
end