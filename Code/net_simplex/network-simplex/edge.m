function [ e ] = edge( L,n )
rr=rem(L,n);
if rr==0
    rr=n;
end
e= [rr,ceil(L/n)];
end