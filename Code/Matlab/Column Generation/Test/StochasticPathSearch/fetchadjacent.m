function [AO] = fetchadjacent(O,WA)
%FetchAdjacent Function
[~,AO] = find(WA(O,:)>0);