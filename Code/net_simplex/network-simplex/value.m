function [ va ] = value( minf , g )
%this function computes the value of the cost, for the given flow
z=find(minf>0);
i=1;
va=0;
for i=1:length(z)
    va=va+minf(z(i))*g(z(i));
end
end