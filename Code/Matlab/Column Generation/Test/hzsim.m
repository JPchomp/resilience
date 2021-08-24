    function [H,loc_storm] = hzsim(XC , YC, xlocation, ylocation,INT,SD) 
% XC = Center of link locations (x)
% YC = Center of link locations (y)
% xlocations of nodes (x)
% ylocations of nodes (y)
% INT = intensity of the storm

% I want to get a vector of new capacities affected by the hazard
% In this case i consider a rain with some storm center at loc_storm
% Generated randomly

cx = mean(xlocation);
cy = mean(ylocation);

rng(42)
loc_storm.x = normrnd(cx, SD); loc_storm.y = normrnd(cy,SD);                 % UQ1

% Considering this center, we want a certain mm on each link
% So having the center of each link, we define how many mm they received

% Do i want to define a normally distributed storm? It could be, given a
% center, compute how far away I am from center, and even then a random
% value for the energy

disthz = @(x,y) sqrt(((x-loc_storm.x).^2)+(((y-loc_storm.y).^2)));

Chz = disthz(XC,YC); %Defines the distance of the link center from the hazard
%You should have ran centeroflinks(xlocation,ylocation,from,to)

% Calculate the "energy" of being at that distance

rng(42)
H = INT*100*normpdf(Chz, 0 , SD);

%Consider a normal distribution of INT mm, normally decreasing
% according to distance form the center

% H = V .* normrnd(INT,INT*0.1,[length(V),1]);

% So with this you have a level of mm on your road, according to distance
% from the storm center

end