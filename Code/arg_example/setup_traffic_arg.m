        function [s,t,T] = setup_traffic_arg(Tmat,L)
%% This function takes the traffic matrix 

% L Limit to be considered

%Declare the length of everything, could come from T itself?
dim = size(Tmat);
    
    %Check if square
    if dim(1) ~= dim(2)
        disp('non square traffic matrix')
    else
        n = dim(1);
    

%Origins go from 1 to 8 repeatedly, dests are 1111,2222....nnnn
tempo = (1:n)';
origs = repmat(tempo,n,1);
dests = sort(origs);

%Transform traffic matrix into something in a single row
Tmat = Tmat - diag(diag(Tmat));
T_input = [origs,dests,Tmat(:)];

%filter out values with zero traffic (self arcs too)
T_input((T_input(:,3) < L),:) = [];

%Write out in standard format
s = T_input(:,1)';
t = T_input(:,2)';
T = T_input(:,3)';
    end
end