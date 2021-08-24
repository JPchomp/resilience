function[p1,p2,p3,p4] = topo_metrics_arg_s(UGD,UGC,xlocation,ylocation)

figure(1)
set(gcf, 'Position',  [100, 100, 1000, 500]);
set(gcf,'color','w');
p1 = plot(UGD,'MarkerSize',5, 'XData',xlocation,'YData',ylocation);
title('Trial Network')
ucc = centrality(UGD,'closeness');
p1.NodeCData = ucc;
colormap jet
colorbar
title('Closeness Centrality Scores - Unweighted')
pbaspect([1 2 1])

figure(2)
set(gcf, 'Position',  [100, 100, 1000, 500]);
set(gcf,'color','w');
p2 = plot(UGD,'XData',xlocation,'YData',ylocation,'MarkerSize',5);
title('Trial Network')
uccd = centrality(UGD,'closeness','Cost',UGD.Edges.Weight);
p2.NodeCData = uccd;
colormap jet
colorbar
title('Closeness Centrality Scores - Weighted')
pbaspect([1 2 1])

figure(3)
set(gcf, 'Position',  [100, 100, 1000, 500]);
set(gcf,'color','w');
p3 = plot(UGD,'XData',xlocation,'YData',ylocation,'MarkerSize',5);
title('Trial Network')
wbc = centrality(UGD,'betweenness','Cost',UGD.Edges.Weight);
n = numnodes(UGD);
p3.NodeCData = 2*wbc./((n-2)*(n-1));
colormap(flip(autumn,1));
title('Betweenness Centrality Scores - P(node in shortest path)')
pbaspect([1 2 1])
colorbar

distmatrix = distances(UGD).*adjacency(UGD);
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
p4 =plot(temgraph,'XData',xlocation,'YData',ylocation,'MarkerSize',1,...%'NodeLabel', 1:length(xlocation),...        %'EdgeLabel', temgraph.Edges.Weight,...
        'LineWidth',LWidths,...
        'EdgeCData',temgraph.Edges.Weight);...
        title('Edge Centrality');
        pbaspect([1 2 1])
        colormap(flip(autumn,1));
        colorbar