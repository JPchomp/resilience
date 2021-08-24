function [capacity_h] = cap_hazard(H , capacity ) %, altitude
%% this function should return the modified capacities due to the 
%  Hazard level perceived by each link: H
%  According to a hazard-resistance attribute of the link : A
%  Thus: Cap' = f(H,A,Original Capacity)

% Here we adopt the depth disruption curve provided in 
% Pregnolato, M., Ford, A., Wilkinson, S. M., & Dawson, R. J. (2017). 
% The impact of flooding on road transport: A depth-disruption function. 
% doi:10.1016/j.trd.2017.06.020 

%The maximum depth allowed is 300mm
lim = @(h) min(h,300);

% for an h in mm, the velocity in km/h:
v = @(h) 0.0009.*(lim(h).^2) - 0.5529.*lim(h) + 86.9448 - normrnd(0,1);

% Now to link this speed with flow capacity we consider the upper
% (uncongested) section of the speed-flow curve. (or lower of t(q) )

capacity_h = (max(v(H),0)./86.9448).*capacity;

%The idea is the whole V - Q diagram shrunk proportionally.
end
