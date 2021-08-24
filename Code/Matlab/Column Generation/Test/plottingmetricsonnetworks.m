% plot several interrupted networks for first slides of ppt
FTD = [from to distance];
G=graph(from,to,distance);
DG = distances(G);
MDG = sum(DG,2)/(length(DG)-1);
dgp = DG;dgp(dgp == 0) = []; dgp = reshape(dgp,5,6);dgp = dgp'; SDG = sqrt(sum(((dgp-MDG).^2)/(length(dgp)),2));SDG = round(SDG,2);
    
    FTD2 = FTD; FTD2(1,:) = [];
    G2 = graph(FTD2(:,1), FTD2(:,2) , FTD2(:,3));
    DG2 = distances(G2);
    MDG2 = sum(DG2,2)/(length(DG2)-1);
dgp = DG2;dgp(dgp == 0) = []; dgp = reshape(dgp,5,6);dgp = dgp'; SDG2 = sqrt(sum(((dgp-MDG2).^2)/(length(dgp)),2));SDG2 = round(SDG2,2);
    
    FTD3 = FTD; FTD3([2,5,6,7,8],:)=[];
    G3 = graph(FTD3(:,1), FTD3(:,2) , FTD3(:,3));
    DG3 = distances(G3); DG3(DG3 == Inf) = 20;
    MDG3 = sum(DG3,2)/(length(DG3)-1);
dgp = DG3; dgp(dgp == 0) = []; dgp = reshape(dgp,5,6);dgp = dgp'; SDG3 = sqrt(sum(((dgp-MDG3).^2)/(length(dgp)),2)); SDG3= round(SDG3,2);
    
    %%%%%
    
        p = plot(G,'XData',xlocation,'YData',ylocation,...
            'EdgeLabel',G.Edges.Weight,...
            'NodeLabel', 1:8,...
            'LineWidth',1);...
            title('Distance');

highlight(p,capctr(:,2),capctr(:,3));
        
        G.Nodes.NodeColors = MDG;
        p.NodeCData = G.Nodes.NodeColors;

        nl = p.NodeLabel;
        p.NodeLabel = '';
        xd = get(p, 'XData');
        yd = get(p, 'YData');
        text(xd, yd, nl, 'FontSize',10,...
        'HorizontalAlignment','right', 'VerticalAlignment','bottom')
        colormap jet; colorbar
    

        p = plot(G,'XData',xlocation,'YData',ylocation,...
        'EdgeLabel',distance,...
        'NodeLabel', SDG,...
        'LineWidth',1);...
        title('Sample Network');      
        G.Nodes.NodeColors = SDG;
        p.NodeCData = G.Nodes.NodeColors;

        nl = p.NodeLabel;
        p.NodeLabel = '';
        xd = get(p, 'XData');
        yd = get(p, 'YData');
        text(xd, yd, nl, 'FontSize',10, 'HorizontalAlignment','right', 'VerticalAlignment','bottom')
        colormap jet; colorbar


    %%%%%%
    
                    p2 = plot(G2,'XData',xlocation,'YData',ylocation,...
                    'EdgeLabel',FTD2(:,3),...
                    'NodeLabel', MDG2,...
                    'LineWidth',1);...
                    title('Sample Network');      
                G2.Nodes.NodeColors = MDG2;
                p2.NodeCData = G2.Nodes.NodeColors;
                
                        nl = p2.NodeLabel;
        p2.NodeLabel = '';
        xd = get(p2, 'XData');
        yd = get(p2, 'YData');
        text(xd, yd, nl, 'FontSize',10, 'HorizontalAlignment','right', 'VerticalAlignment','bottom')
        colormap jet; colorbar
        

    
    
                    p2 = plot(G2,'XData',xlocation,'YData',ylocation,...
                    'EdgeLabel',FTD2(:,3),...
                    'NodeLabel', SDG2,...
                    'LineWidth',1);...
                    title('Sample Network');      
                G2.Nodes.NodeColors = SDG2;
                p2.NodeCData = G2.Nodes.NodeColors;
                
                        nl = p2.NodeLabel;
        p2.NodeLabel = '';
        xd = get(p2, 'XData');
        yd = get(p2, 'YData');
        text(xd, yd, nl, 'FontSize',10, 'HorizontalAlignment','right', 'VerticalAlignment','bottom')
        colormap jet; colorbar
        
   
    
                %%%%%%%%%%%%%%%%%%%%%%%%%
                
p3 = plot(G3,'XData',xlocation,'YData',ylocation,...
'EdgeLabel',FTD3(:,3),...
'NodeLabel', MDG3,...
'LineWidth',1);...
title('Sample Network');      
G3.Nodes.NodeColors = MDG3;
p3.NodeCData = G3.Nodes.NodeColors;

        nl = p3.NodeLabel;
        p3.NodeLabel = '';
        xd = get(p3, 'XData');
        yd = get(p3, 'YData');
        text(xd, yd, nl, 'FontSize',10, 'HorizontalAlignment','right', 'VerticalAlignment','bottom')
        colormap jet; colorbar

p3 = plot(G3,'XData',xlocation,'YData',ylocation,...
'EdgeLabel',FTD3(:,3),...
'NodeLabel', SDG3,...
'LineWidth',1);...
title('Sample Network');      
G3.Nodes.NodeColors = SDG3;
p3.NodeCData = G3.Nodes.NodeColors;

nl = p3.NodeLabel;
p3.NodeLabel = '';
xd = get(p3, 'XData');
yd = get(p3, 'YData');
text(xd, yd, nl, 'FontSize',10, 'HorizontalAlignment','right', 'VerticalAlignment','bottom')
colormap jet; colorbar


                
                
                
                
                
                
                
                
                
                
                
%Plot Network unweighted with distances
plot(G,'XData',xlocation,'YData',ylocation,...
    'EdgeLabel',distance,... 
    'LineWidth',2,...
    'NodeColor','r');...
    title('Sample Network');    

%Plot Network with nodes as connectivity
plot(G,'XData',xlocation,'YData',ylocation,...
    'EdgeLabel',distance,... 
    'LineWidth',2,...
    'NodeColor','r');...
    title('Sample Network')


