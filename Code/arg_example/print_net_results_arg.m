function [] = print_net_results_arg(GC, link_res,xlocation,ylocation,Tmat)

% Define graph with results
GR = digraph(link_res(:,1),link_res(:,2),link_res(:,5));
GRC = digraph(link_res(:,1),link_res(:,2),link_res(:,4));

%Define characteristics
LWidths = 5*(GR.Edges.Weight/max(GR.Edges.Weight) + 0.01).^2;

% Node C Data
nodecdata = sum(Tmat,2);
nodecdata = [nodecdata; zeros(height(GR.Nodes)-length(nodecdata),1)];
nodecdata = 5*nodecdata/max(nodecdata) + 0.5;

%Open figure
figure('Units', 'pixels', ...
    'Position', [100 100 1000 375]);
%subplot(1,2,1);
set(gcf,'color','w');
p1 = plot(GR,'XData',xlocation(1:1421),'YData',ylocation(1:1421),...
        'MarkerSize',nodecdata,...
        'EdgeCData',LWidths,...
        'LineWidth',LWidths)
        title('Capacity Strained Links for OD');
pbaspect([1 2 1])
colorbar
colormap(flipud(autumn))



% STRAINED capacities
figure('Units', 'pixels', ...
    'Position', [100 100 1000 375]);
%subplot(1,2,1);
set(gcf,'color','w');
p1 = plot(GR,'XData',xlocation(1:1421),'YData',ylocation(1:1421),...
        'MarkerSize',nodecdata,...
        'EdgeCData',LWidths,...
        'LineWidth',LWidths)
        title('Capacity Strained Links for OD');
pbaspect([1 2 1])
colorbar
colormap(flipud(autumn))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Define characteristics
LWidths = 5*exp(-(GRC.Edges.Weight/max(GRC.Edges.Weight))) + 0.01;

% Node C Data
nodecdata = sum(Tmat,2);
nodecdata = [nodecdata; zeros(height(GRC.Nodes)-length(nodecdata),1)];
nodecdata = 5*nodecdata/max(nodecdata) + 0.5;


white = repmat([0,0,0],1893,1);

% ORIGIN DEMAND 
figure('Units', 'pixels', ...
    'Position', [100 100 1000 375]);
%subplot(1,2,1);
set(gcf,'color','w');
p1 = plot(GRC,'XData',xlocation(1:1421),'YData',ylocation(1:1421),...
        'MarkerSize',nodecdata,...
        'EdgeCData',white);
        title('');
pbaspect([1 2 1])
colorbar
colormap(flipud(autumn))

h = scatter(xlocation(1:1421), ylocation(1:1421), nodecdata.^2);











%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



        % Remove NodeLabels
        p1.NodeLabel = {}; 
        % Define upper and lower labels (they can be numeric, characters, or strings)
        outgoing = sum(Tmat,2);
        incoming = sum(Tmat,1)'; 
        % label each node and offset the labels in the North and South directions. 
        % You can play around with this offset values ------
        labelpoints(p1.XData, p1.YData, outgoing, 'N', 0.3, 'FontSize', 10, 'Color', 'b');
        labelpoints(p1.XData, p1.YData, incoming, 'S', 0.3, 'FontSize', 10, 'Color', 'r');    
    p1.NodeCData=outgoing - incoming;
    
    hcb = colorbar;
    colorTitleHandle = get(hcb,'Title');
    titleString = 'Net Outflow';
    set(colorTitleHandle ,'String',titleString);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Residual Capacities    
colormap(flipud(jet));
    subplot(1,2,2);
    set(gcf,'color','w');
    p2 =plot(GRC,'XData',xlocation,'YData',ylocation,...
            'NodeLabel', 1:length(xlocation),...
            'EdgeLabel', GC.Edges.Weight,...
            'LineWidth',LWidths);...
            title('Residual Capacities');

        p2.EdgeCData = GRC.Edges.Weight;

        hcb = colorbar;
        colorTitleHandle = get(hcb,'Title');
        titleString = 'Residual Capacity';
        set(colorTitleHandle ,'String',titleString);
end
%%%%%%%%%%%%%%%%%%%
% 
% nodecdata = sum(Tmat,1)';
% nodecdata = [nodecdata; zeros(height(GR.Nodes)-length(nodecdata),1)];
% nodecdata = 5*nodecdata/max(nodecdata) + 0.5;
% 
% 
% p1 =plot(UGD,'XData',xlocation,'YData',ylocation,...
%         'MarkerSize',[nodecdata;0.1;0.1;0.1;0.1;0.1].^1.2,...
%         'NodeCData', [nodecdata;0.1;0.1;0.1;0.1;0.1].^1.2, ...
%         'LineWidth',0.1)
%         
% pbaspect([1 2 1])
% colorbar
% colormap(flipud(autumn))
%         set(gcf,'color','w');
        
