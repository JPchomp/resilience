function [ s ] = short( f,T )
n=size(f);                  
n=n(1);                     
s=zeros(n,n);               
s(T)=1;                     
for i=1:n
    for j=1:n
        if s(i,j)==1        
            s(j,i)=1;       
        end
    end
end
end