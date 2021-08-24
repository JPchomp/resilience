function [] = plot_nodal_weights(UGD,xlocation, ylocation, nodeweights)
%Input some weighting scheme for the nodes, plot

p=plot(UGD,'XData',xlocation,'YData',ylocation,...
'EdgeLabel',UGD.Edges.Weight,...
'NodeLabel', 1:numnodes(UGD),...
'LineWidth',2);...

nodeweights  = 8*nodeweights/max(nodeweights) + 1;

UGD.Nodes.EdgeColors = nodeweights;
p.MarkerSize = UGD.Nodes.EdgeColors;

nl = p.NodeLabel;
p.NodeLabel = '';
xd = get(p, 'XData');
yd = get(p, 'YData');
text(xd, yd, nl, 'FontSize',10,...
'HorizontalAlignment','right', 'VerticalAlignment','bottom')

pbaspect([2 1 1])
set(gcf,'color','w');

% colormap(flipud(autumn)); colorbar


