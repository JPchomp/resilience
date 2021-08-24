%% Full Network
DG = distances(GD);
[diam,eccs] = diams(DG);
[eff, hets] = effs(DG);
num = numnodes(GD);
% cmap = flipud(autumn);
weights = ones(length(UGD.Edges.Weight),1);
weights = weights * 4;
%% Plotting    
set(gcf, 'Position',  posize);
set(gcf,'color',color);

lwidth = 3*UGC.Edges.Weight/max(UGC.Edges.Weight));

figure(1)

subplot(2,2,1) %%%%%%%%%%%%%%
p=plot(UGC,'XData',xlocation,'YData',ylocation,...
'EdgeLabel',UGC.Edges.Weight,...
'NodeLabel', 1:num,...
'LineWidth',lwidth;...
title('Nodal Diameters');

UGD.Nodes.NodeColors = diam;
p.NodeCData = UGD.Nodes.NodeColors;

nl = p.NodeLabel;
p.NodeLabel = '';
xd = get(p, 'XData');
yd = get(p, 'YData');
text(xd, yd, nl, 'FontSize',10,...
'HorizontalAlignment','right', 'VerticalAlignment','bottom')
colormap autumn; colorbar
    
subplot(2,2,2) %%%%%%%%%%%%%%
p=plot(UGD,'XData',xlocation,'YData',ylocation,...
'EdgeLabel',UGD.Edges.Weight,...
'NodeLabel', 1:num,...
'LineWidth',lwidth);...
title('Nodal Eccentricities');

UGD.Nodes.NodeColors = eccs;
p.NodeCData = UGD.Nodes.NodeColors;

nl = p.NodeLabel;
p.NodeLabel = '';
xd = get(p, 'XData');
yd = get(p, 'YData');
text(xd, yd, nl, 'FontSize',10,...
'HorizontalAlignment','right', 'VerticalAlignment','bottom')
colormap autumn; colorbar


subplot(2,2,3) %%%%%%%%%%%%%%
p=plot(UGD,'XData',xlocation,'YData',ylocation,...
'EdgeLabel',UGD.Edges.Weight,...
'NodeLabel', 1:num,...
'LineWidth',lwidth);...
title('Nodal Efficiencies');

UGD.Nodes.NodeColors = eff;
p.NodeCData = UGD.Nodes.NodeColors;

nl = p.NodeLabel;
p.NodeLabel = '';
xd = get(p, 'XData');
yd = get(p, 'YData');
text(xd, yd, nl, 'FontSize',10,...
'HorizontalAlignment','right', 'VerticalAlignment','bottom')
colormap autumn; colorbar

subplot(2,2,4) %%%%%%%%%%%%%%
p=plot(UGD,'XData',xlocation,'YData',ylocation,...
'EdgeLabel',UGD.Edges.Weight,...
'NodeLabel', 1:num,...
'LineWidth',lwidth);...
title('Nodal Heterogeneities');

UGD.Nodes.NodeColors = hets;
p.NodeCData = UGD.Nodes.NodeColors;

nl = p.NodeLabel;
p.NodeLabel = '';
xd = get(p, 'XData');
yd = get(p, 'YData');
text(xd, yd, nl, 'FontSize',10,...
'HorizontalAlignment','right', 'VerticalAlignment','bottom')
colormap autumn; colorbar

