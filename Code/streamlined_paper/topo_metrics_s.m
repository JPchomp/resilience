function[p1,p2,p3] = topo_metrics_s(GD,GC,xlocation,ylocation)

figure(1)
set(gcf, 'Position',  [100, 100, 1000, 500]);
set(gcf,'color','w');
p1 = plot(GD,'MarkerSize',5); %'XData',xlocation,'YData',ylocation,
title('Trial Network')
ucc = centrality(GD,'outcloseness');
p1.NodeCData = ucc;
colormap jet
colorbar
title('Closeness Centrality Scores - Unweighted')
pbaspect([2 1 1])

figure(2)
set(gcf, 'Position',  [100, 100, 1000, 500]);
set(gcf,'color','w');
p2 = plot(GC,'XData',xlocation,'YData',ylocation,'MarkerSize',5);
title('Trial Network')
uccd = centrality(GC,'outcloseness','Cost',GC.Edges.Weight);
p2.NodeCData = uccd;
colormap jet
colorbar
title('Closeness Centrality Scores - Weighted')
pbaspect([2 1 1])

figure(3)
set(gcf, 'Position',  [100, 100, 1000, 500]);
set(gcf,'color','w');
p3 = plot(GD,'XData',xlocation,'YData',ylocation,'MarkerSize',5);
title('Trial Network')
wbc = centrality(GD,'betweenness','Cost',GD.Edges.Weight);
n = numnodes(GD);
p3.NodeCData = 2*wbc./((n-2)*(n-1));
colormap(flip(autumn,1));
title('Betweenness Centrality Scores - P(node in shortest path)')
pbaspect([2 1 1])
colorbar

distmatrix = distances(GD).*adjacency(GD);
% Calculate Edge Centrality
[nc,ec] = betweenness_centrality(distmatrix);
%Define characteristics
ec = (ec + ec')./2;
temgraph = graph(ec);
LWidths = 5*temgraph.Edges.Weight/max(temgraph.Edges.Weight);
%Open figure
figure(4)
set(gcf, 'Position',  [100, 100, 1000, 500]);
set(gcf,'color','w');
p1 =plot(temgraph,'XData',xlocation,'YData',ylocation,...
        'NodeLabel', 1:length(xlocation),...
        'EdgeLabel', temgraph.Edges.Weight,...
        'LineWidth',LWidths);...
        title('Edge Centrality');
    
figure(5)
set(gcf, 'Position',  [100, 100, 1000, 500]);
set(gcf,'color','w');
bar(degree(UGD))
title('Trial Network')
ucc = centrality(GD,'outcloseness');
p1.NodeCData = ucc;
colormap jet
colorbar
title('Closeness Centrality Scores - Unweighted')
pbaspect([2 1 1])