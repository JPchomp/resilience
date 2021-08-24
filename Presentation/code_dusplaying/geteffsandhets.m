%% Efficiency and Heterogeneity

function [EffMat, Effplot, HetMat, Hetplot] = diameters(from,to,distance)

FTD = [from to distance];
G=graph(from,to,distance);
DG = 1./distances(G);
dgp = DG;dgp(dgp == Inf) = []; dgp = reshape(dgp,5,6);DG = dgp';

EffMat = sum(DG,2)/(length(DG)-1);
HetMat = sqrt(sum(((DG-EffMat).^2)/(length(DG)),2));HetMat = round(HetMat,2);

        Effplot = plot(G,'XData',xlocation,'YData',ylocation,...
            'EdgeLabel',distance,...
            'NodeLabel', MDG,...
            'LineWidth',1);...
            title('Sample Network');      

        G.Nodes.NodeColors = MDG;
        Effplot.NodeCData = G.Nodes.NodeColors;

        nl = Effplot.NodeLabel;
        Effplot.NodeLabel = '';
        xd = get(Effplot, 'XData');
        yd = get(Effplot, 'YData');
        text(xd, yd, nl, 'FontSize',10, 'HorizontalAlignment','right', 'VerticalAlignment','bottom')
        colormap jet; colorbar
    

        Hetplot = plot(G,'XData',xlocation,'YData',ylocation,...
        'EdgeLabel',distance,...
        'NodeLabel', HetMat,...
        'LineWidth',1);...
        title('Sample Network');      
        G.Nodes.NodeColors = HetMat;
        Hetplot.NodeCData = G.Nodes.NodeColors;

        nl = Hetplot.NodeLabel;
        Hetplot.NodeLabel = '';
        xd = get(Hetplot, 'XData');
        yd = get(Hetplot, 'YData');
        text(xd, yd, nl, 'FontSize',10, 'HorizontalAlignment','right', 'VerticalAlignment','bottom')
        colormap jet; colorbar