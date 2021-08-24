function [] = print_net(UGC,UGD,xlocation,ylocation)


%Define characteristics
LWidths = 5*UGC.Edges.Weight/max(UGC.Edges.Weight);

%Open figure
figure('Units', 'pixels', ...
    'Position', [100 100 1000 375]);

subplot(1,2,1);
set(gcf,'color','w');
plot(UGC,'XData',xlocation,'YData',ylocation,...
        'NodeLabel', 1:length(xlocation),...
        'EdgeLabel', UGC.Edges.Weight,...
        'LineWidth',LWidths);...
        title('Capacities');

subplot(1,2,2); 
set(gcf,'color','w');
plot(UGD,'XData',xlocation,'YData',ylocation,...
        'NodeLabel', 1:length(xlocation),...
        'EdgeLabel', UGD.Edges.Weight);
        title('Distances');
