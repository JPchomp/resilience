function [] = pretty_graph_plot_s( GC , xlocation , ylocation ) 

%Prettyup function to standarize the graphs of stuff

color = 'w';
fsize = 10;
posize = [100,100,500,250];
markersize = 3;
nodecolor = 1;
edgewidths = 1.5;
edgecolors = 5*GC.Edges.Weight/max(GC.Edges.Weight);

figure('Units', 'pixels', ...
       'Position', posize)

hold on;

p = plot(GC,'XData',xlocation,'YData',ylocation);

% General Attributes
% title(tit);
xlabel("x [km]");
ylabel("y [km]");

% Node attributes
p.MarkerSize = markersize;
% p.NodeCData = nodecolor;
p.Marker = 'o';

%Edge attributes
p.LineWidth = edgecolors;
%p.EdgeCData = edgecolors;

%colormap jet
%colorbar
pbaspect([2 2 1])

set(gcf, 'Position',  posize);
set(gcf,'color',color);
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...  'YTick'       , 0:500:2500, ...'LineWidth'   , 1         , ...
  'FontSize'    , fsize     );
