function [AO,Olist] = FA(O,WA)
%FetchAdjacent Function
%returns the adjacent nodes to the ones im standing on.
%plus the Olist, which is which node im standing. From to.

[idxr,AO] = find(WA(O,:)>0);

Olist = O(idxr)';




%My problem is writing the adjacent nodes, but keeping from which node i
%moved originally. That is the O matrix, 