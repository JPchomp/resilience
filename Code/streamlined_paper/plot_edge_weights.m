function [] = plot_edge_weights(UGD,xlocation, ylocation, edgeweights)


color = 'w';
fsize = 10;
posize = [100,100,500,250];

set(gcf, 'Position',  posize);
set(gcf,'color',color);
title('Node Degree')
set(gca,'FontSize',  fsize)

%Input some weighting scheme for the nodes, plot

p=plot(UGD,'XData',xlocation,'YData',ylocation,...%'EdgeLabel',UGD.Edges.Weight,...
'NodeLabel', 1:numnodes(UGD),...
'LineWidth',2);...

UGD.Edges.EdgeColors = edgeweights;
p.EdgeCData = UGD.Edges.EdgeColors;

% nl = p.EdgeLabel;
% p.EdgeLabel = '';
% xd = get(p, 'XData');
% yd = get(p, 'YData');
% text(xd, yd, nl, 'FontSize',10,...
% 'HorizontalAlignment','right', 'VerticalAlignment','bottom')

pbaspect([2 1 1])
set(gca,'FontSize', fsize)

colormap(flipud(autumn)); colorbar
set(gcf,'color','w');


