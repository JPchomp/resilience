function [] = print_net_results(GC, link_res,xlocation,ylocation,Tmat)

color = 'w';
fsize = 10;
posize = [100,100,500,250];


% Define graph with results
GR = digraph(link_res(:,1),link_res(:,2),link_res(:,4));
GRC = digraph(link_res(:,1),link_res(:,2),link_res(:,3)-link_res(:,4));

%Define characteristics
LWidths = 5*GR.Edges.Weight/max(GR.Edges.Weight);

%Open figure
figure('Units', 'pixels', ...
    'Position', [100 100 1000 375]);

set(gcf, 'Position',  posize);
set(gcf,'color',color);

subplot(1,2,1);
set(gcf,'color','w');
p1 = plot(GR,'XData',xlocation,'YData',ylocation,...
        'NodeLabel', 1:length(xlocation),...
        'LineWidth',LWidths);...
        %title('Optimal Flows');
    
        % Remove NodeLabels
        p1.NodeLabel = {}; 
        % Define upper and lower labels (they can be numeric, characters, or strings)
        outgoing = sum(Tmat,2);
        incoming = sum(Tmat,1)'; 
        % label each node and offset the labels in the North and South directions. 
        % You can play around with this offset values ------
        labelpoints(p1.XData, p1.YData, outgoing, 'N', 0.3, 'FontSize', 10, 'Color', 'b');
        labelpoints(p1.XData, p1.YData, incoming, 'S', 0.3, 'FontSize', 10, 'Color', 'r');
        labelpoints(p1.XData, p1.YData, 1:8, 'E', 0.4, 'FontSize', 10, 'Color', 'k');
        
    p1.NodeCData=outgoing - incoming;
    data = min(p1.NodeCData) + p1.NodeCData;
    p1.MarkerSize = 1*data/max(data);
    
    hcb = colorbar;
    colorTitleHandle = get(hcb,'Title');
    titleString = 'Net Outflow';
    set(colorTitleHandle ,'String',titleString);
    pbaspect([2 1 1])
set(gca,'FontSize', fsize)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Residual Capacities    
colormap(flipud(jet));
    subplot(1,2,2);
    set(gcf,'color','w');
    p2 =plot(GRC,'XData',xlocation,'YData',ylocation,...
            'NodeLabel', 1:length(xlocation),...
            'EdgeLabel', GRC.Edges.Weight,...
            'LineWidth',LWidths);...
            title('Residual Capacities');

        p2.EdgeCData = GRC.Edges.Weight;

        hcb = colorbar;
        colorTitleHandle = get(hcb,'Title');
        titleString = 'Residual Capacity';
        set(colorTitleHandle ,'String',titleString);
        pbaspect([2 1 1])
set(gca,'FontSize', fsize)
end

        
        
