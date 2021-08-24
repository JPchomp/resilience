function p = netplot(M,T,xlocation,ylocation,FTCD,DS)

G = digraph(FTCD(:,1) , FTCD(: , 2), FTCD(: , 3) );

d = zeros(24,1);
for i = 1:length(xlocation)
    for j = i:length(xlocation)
        if i ~= j
            d = d + DS{i,j,3}(1:length(FTCD(: , 4)));
        else
        end
    end
end

G.Edges.Duals  = d;

    p = plot(G,'XData',xlocation,'YData',ylocation,...
        'EdgeLabel',G.Edges.Duals,...
        'NodeLabel', 1:8,...
        'LineWidth',1);...
        title('Guidotti Network');
    
        p = plot(G,'XData',xlocation,'YData',ylocation,...
        'EdgeLabel',G.Edges.Weight,...
        'NodeLabel', 1:8,...
        'LineWidth',1);...
        title('Guidotti Network');