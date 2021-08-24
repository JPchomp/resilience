%% import datas
% Each varname is latitude and longitude
fromlist = [VialSimplifi.VarName1 , VialSimplifi.VarName2];
tolist   = [VialSimplifi.VarName3 , VialSimplifi.VarName4];
nodelist = [c.LONGITUDE, c.LATITUDE];
%
fromlist = round(fromlist,6);
tolist   = round(tolist,6);
nodelist = round(nodelist,6);
%
fromlist = fromlist * 1000000;
tolist   = tolist * 1000000;
nodelist = nodelist * 1000000;
%
[h,j,k] = intersect(nodelist,fromlist,'rows');
[hh,jj,kk] = intersect(nodelist,tolist,'rows');

fromlist = [VialSimplifi.VarName1, VialSimplifi.VarName2, zeros(length(VialSimplifi.VarName2),1)];
tolist   = [VialSimplifi.VarName3, VialSimplifi.VarName4, zeros(length(VialSimplifi.VarName3),1)];
nodelist = [nodelist , zeros(length(nodelist),1)];

fromlist(k,3) = j;  tolist(kk,3) = jj;

nodelist=nodelist./1000000;

[h,j,k] = intersect(nodelist,fromlist,'rows');
[hh,jj,kk] = intersect(nodelist,tolist,'rows');

fromlist(k,3) = j;  tolist(kk,3) = jj;

[h,j,k] = intersect(nodelist,fromlist,'rows');
[hh,jj,kk] = intersect(nodelist,tolist,'rows');

fromlist(k,3) = j;  tolist(kk,3) = jj;

%%%%

% Putting name to all others

%create a unique list of nodes
tempfrom = fromlist;
tempto = tolist;

tempfrom(fromlist(:,3) > 0,:) = [];
tempto(tolist(:,3) > 0,:) = [];

tempcode = [tempfrom; tempto];

tempcode = unique(tempcode,'rows');

[h,j,k] = intersect(tempcode,fromlist,'rows');
[hh,jj,kk] = intersect(tempcode,tolist,'rows');

j = j+123; jj = jj + 123;

fromlist(k,3) = j;  tolist(kk,3) = jj;

[h,j,k] = intersect(tempcode,fromlist,'rows');
[hh,jj,kk] = intersect(tempcode,tolist,'rows');

j = j+123; jj = jj + 123;

fromlist(k,3) = j;  tolist(kk,3) = jj;

[h,j,k] = intersect(tempcode,fromlist,'rows');
[hh,jj,kk] = intersect(tempcode,tolist,'rows');

j = j+123; jj = jj + 123;

fromlist(k,3) = j;  tolist(kk,3) = jj;

%%%%
%Create unique nodelist with location
temp = unique([fromlist;tolist],'rows');

temp = sortrows(temp,3);

GA = graph(fromlist(:,3), tolist(:,3));

p = plot(GA,'XData',temp(:,1),...
            'YData',temp(:,2),...
            'LineWidth',1);...
    title('Argentina Network');


%%%%% ORIGIN 
NodeWeight = zeros(length(temp),1);
nweighs = sum(ODs,2);
NodeWeight(1:length(nweighs)) = nweighs;

nw = (6 * NodeWeight./max(NodeWeight));
nnw = (NodeWeight>0);

msize = (6 * NodeWeight./max(NodeWeight)) + 0.5;

p2 = plot(GA,'XData',temp(:,1),...
            'YData',temp(:,2),...
            'NodeCData',nnw,...
            'MarkerSize',msize,...
            'LineWidth',1);...
     title('Argentina Network');
colormap(flip(autumn,1))
colorbar;
 
%%%%   DESTINATIONS
NodeWeight = zeros(length(temp),1);
nweighs = (sum(ODs,1))';
NodeWeight(1:length(nweighs)) = nweighs;

nw = ((NodeWeight./max(NodeWeight)));
nnw = (NodeWeight>0);

msize = (6 * NodeWeight./max(NodeWeight)) + 0.5;

p2 = plot(GA,'XData',temp(:,1),...
            'YData',temp(:,2),...
            'NodeCData',nnw,...
            'MarkerSize',msize,...
            'LineWidth',1);...
     title('Argentina Network');
colormap(flip(autumn,1))
colorbar;
    