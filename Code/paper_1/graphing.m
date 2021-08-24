%%
%Results  Debugging

vnodes = ans;

cplex.Solution.x = A{1,3} ; pathcosts = MPC{1,3};
%[vnodes(1:end,1:4) , cplex.Solution.x , pathcosts];

L = length(vnodes(1,:));

pth = cell(0);

for i = 1:length(vnodes(:,1))
    pth(i,:) =  {vnodes(i,1:vnodes(i,L))};
    src(i)   =   vnodes(i,1);
    snk(i)   =   vnodes(i,vnodes(i,L));
end

%%Plot Path between two nodes
%UG = graph(from,to,distance);
figure;
set(gcf,'color','w');
for ii = 1:length(pth)
        
    subplot(2,ceil(length(pth)/2),ii);  
                                                                            h(ii) = plot(UG, 'XData',xlocation,'YData',ylocation,...
                                                                                        'edgecolor', 'k', 'nodecolor', 'k',...
                                                                                        ...'EdgeLabel',UG.Edges.Weight,...
                                                                                        'NodeLabel',1:8); %length(table2array(G.Nodes))
                                                                                    
        highlight(h(ii), pth{ii}, 'edgecolor', 'b', 'nodecolor', 'b', 'LineWidth',2); 
        highlight(h(ii), src(ii), 'nodecolor', 'g');
        highlight(h(ii), snk(ii), 'nodecolor', 'r');
        title("Path length: " + pathcosts(ii) + "km")
        
end

%%
%Draw Results

%invoke graph structure w distances
G=graph(from,to,distance);
UG.Nodes.pop = population;
UG.Edges.cap = capacity;




%This is a network displaying the distances, and the chosen path
p = plot(G,'XData',xlocation,'YData',ylocation,...
        'EdgeLabel',G.Edges.Weight,...
        'NodeLabel', 1:8,...
        'LineWidth',1);...
        title('Distance');
highlight(p,capctr(:,2),capctr(:,3),...
    'EdgeColor','k','LineWidth',1.5,...
    'NodeColor','k');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%invoke the graph structure with capacities as weights:
%H=graph(from,to,capacity);
%Similarly, a plot but displaying capacities.
NSizes = (4*G.Nodes.pop)/max(G.Nodes.pop) + 3;

    set(gcf,'color','w');
g = plot(UG,'XData',xlocation,'YData',ylocation,...
        'EdgeLabel',1:12,...
        'MarkerSize',NSizes,...
        'NodeLabel', 1:8,...
        'LineWidth',1);...
        title('Critical Links');
highlight(g,[1,1,1],[2,3,5],...
        'EdgeColor','r','LineWidth',1.5,...
        'NodeColor','r');
    
    %%%%%%%%%%%%%%%%%%%%%%%
    set(gcf,'color','w');
    NSizes = (4*G.Nodes.pop)/max(G.Nodes.pop) + 3;
%plot(G,'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths, 'MarkerSize', NSizes)    
    
        p = plot(UG,'XData',xlocation,'YData',ylocation,...
        ...'EdgeLabel',distance,...
        'MarkerSize',NSizes,...
        ... % 'NodeLabel', []
        'LineWidth',1);...
        ...title('Sample Network');
        xlabel('km');
        ...p.EdgeCData = G.Edges.cap;

        nl = p.NodeLabel;
        p.NodeLabel = '';
        xd = get(p, 'XData');
        yd = get(p, 'YData');
        text(xd, yd, nl, 'FontSize',10, 'HorizontalAlignment','right', 'VerticalAlignment','bottom')
        ...colormap jet; colorbar
