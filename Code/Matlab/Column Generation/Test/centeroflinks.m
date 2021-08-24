%I need to find the center of the roads:
function [XC,YC] = centeroflinks(xlocation,ylocation,from,to)

n = length(from);

XF = zeros(n,1);YF = zeros(n,1);
XT = zeros(n,1);YT = zeros(n,1);

for i = 1:n
    
XF(from==from(i)) = xlocation(from(i),1);

YF(from==from(i)) = ylocation(from(i),1);

XT(to==to(i)) = xlocation(to(i),1);

YT(to==to(i)) = ylocation(to(i),1);

end

XC = (XF + XT)/2;
YC = (YF + YT)/2;

end