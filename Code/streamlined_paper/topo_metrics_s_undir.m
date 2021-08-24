function[p1,p2,p3,p4,p5,p6] = topo_metrics_s_undir(UGD,UGC,xlocation,ylocation)

color = 'w';
fsize = 10;
posize = [100,100,500,250];
lwidth = 2;

figure(1)
set(gcf, 'Position',  posize);
set(gcf,'color',color);
p1 = plot(UGD,'XData',xlocation,'YData',ylocation,'MarkerSize',5); %'XData',xlocation,'YData',ylocation,
ucc = centrality(UGD,'closeness');
p1.NodeCData = ucc;
colormap jet
colorbar

pbaspect([2 1 1])
set(gca,'FontSize', fsize)
% nl = p1.NodeLabel;
% p1.NodeLabel = '';
% xd = get(p1, 'XData');
% yd = get(p1, 'YData');
% text(xd, yd, nl, 'FontSize',fsize, 'FontWeight','bold', 'HorizontalAlignment','left', 'VerticalAlignment','middle')
title('Closeness Centrality Scores')

figure(2)
set(gcf, 'Position',  posize);
set(gcf,'color',color);
p2 = plot(UGD,'XData',xlocation,'YData',ylocation,'MarkerSize',5); %'XData',xlocation,'YData',ylocation,
ucc = centrality(UGD,'degree');
p2.NodeCData = ucc;
colormap jet
colorbar
title('Node Degree')
pbaspect([2 1 1])
set(gca,'FontSize',  fsize)
% nl = p2.NodeLabel;
% p2.NodeLabel = '';
% xd = get(p2, 'XData');
% yd = get(p2, 'YData');
% text(xd, yd, nl, 'FontSize',fsize, 'FontWeight','bold', 'HorizontalAlignment','left', 'VerticalAlignment','middle')


figure(3)
set(gcf, 'Position',  posize);
set(gcf,'color',color);
p3 = plot(UGC,'XData',xlocation,'YData',ylocation,'MarkerSize',5);
uccd = centrality(UGD,'closeness','Cost',UGD.Edges.Weight);
p3.NodeCData = uccd;
colormap jet
colorbar
pbaspect([2 1 1])
% nl = p3.NodeLabel;
% p3.NodeLabel = '';
% xd = get(p3, 'XData');
% yd = get(p3, 'YData');
% text(xd, yd, nl, 'FontSize',fsize, 'FontWeight','bold', 'HorizontalAlignment','left', 'VerticalAlignment','middle')
title('Closeness Centrality Scores - Distance Weighted')


figure(4)
set(gcf, 'Position',  posize);
set(gca,'FontSize',  fsize)
set(gcf,'color',color);
p4 = plot(UGD,'XData',xlocation,'YData',ylocation,'MarkerSize',5);
title('Trial Network')
wbc = centrality(UGD,'betweenness','Cost',UGD.Edges.Weight);
n = numnodes(UGD);
p4.NodeCData = 2*wbc./((n-2)*(n-1));
colormap(flip(autumn,1));
title('Betweenness Centrality Scores - P(node in shortest path)')
pbaspect([2 1 1])
colorbar
set(gca,'FontSize',  fsize)
% nl = p4.NodeLabel;
% p4.NodeLabel = '';
% xd = get(p4, 'XData');
% yd = get(p4, 'YData');
% text(xd, yd, nl, 'FontSize',fsize, 'FontWeight','bold', 'HorizontalAlignment','left', 'VerticalAlignment','middle')


%%%%%%%%%%%%%%%%%%%%%
cmatrix = distances(UGC).*adjacency(UGC);
% Calculate Edge Centrality
[nc,ec] = betweenness_centrality(cmatrix);
%Define characteristics
ec = (ec + ec')./2;
temgraph = graph(ec);
LWidths = 5*temgraph.Edges.Weight/max(temgraph.Edges.Weight);


%Open figure
figure(5)
set(gcf, 'Position',  posize);
set(gcf,'color',color);
set(gcf, 'Position',  posize);
set(gcf,'color',color);
p5 =plot(temgraph,'XData',xlocation,'YData',ylocation,...
        'NodeLabel', 1:length(xlocation),...%'EdgeLabel', temgraph.Edges.Weight,
        'EdgeCData',LWidths,... 
        'LineWidth',2);...
        %title('Edge Centrality');
        set(gca,'FontSize',  fsize)
        colormap(flip(autumn,1));
        pbaspect([2 1 1])
colorbar
set(gca,'FontSize',  fsize)
              
    
figure(6)
set(gcf, 'Position',  posize);
set(gcf,'color',color);
bar(degree(UGD))
title('Node Degree')
set(gca,'FontSize',  fsize)

figure(7)
set(gcf, 'Position',  posize);
set(gcf,'color',color);
p6 = plot(UGD,'XData',xlocation,'YData',ylocation,...
        'NodeLabel', 1:length(xlocation));
        title('General Layout');
        
figure(8)
set(gcf, 'Position',  posize);
set(gca,'FontSize',  fsize)
set(gcf,'color',color);
p7 = plot(UGC,'XData',xlocation,'YData',ylocation,'MarkerSize',5);
wbc = centrality(UGC,'degree','Importance',UGD.Edges.Weight);
p7.NodeCData = wbc;
colormap(flip(autumn,1));
title('Weighted Degree by Capacity')
pbaspect([2 1 1])
colorbar
set(gca,'FontSize',  fsize)
