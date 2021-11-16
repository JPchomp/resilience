function [L,R]=FLOYD(w,s,t)

n=size(w,1);
D=w;
Path=zeros(n,n);

% below is the standard floyd algorithm

for i=1:n
 for j=1:n
 if D(i,j)~=inf
 Path(i,j)=j;
 end
 end
end

for k=1:n
 for i=1:n
 for j=1:n
 if D(i,k)+D(k,j)<D(i,j)
 D(i,j)=D(i,k)+D(k,j);
 Path(i,j)=Path(i,k);
 end
 end
 end
end

L=zeros(0,0);
R=s;

while 1
 if s==t
 L=fliplr(L);
 L=[0,L];
 return
 end

 L=[L,D(s,t)];
 R=[R,Path(s,t)];
 s=Path(s,t);

end