%%Heatmap

X = linspace(min(xlocation)-1, max(xlocation)+1, 20);

Y = linspace(min(ylocation)-1, max(ylocation)+1, 20);

[a,b] = meshgrid(X,Y);

[cx,cy] = centeroflinks(xlocation,ylocation,from,to);

loc_storm.x = normrnd(mean(cx), 3); loc_storm.y = normrnd(mean(cy),3);

disthz = @(x,y) sqrt(((x-loc_storm.x).^2)+(((y-loc_storm.y).^2)));

Z = random(fit2).*normpdf(disthz(a,b),0,5);

set(gcf,'color','w');
   pcolor(X,Y,Z);
   shading interp 
   view(2);
   hold on;
   plot(UG,'XData',xlocation,'YData',ylocation,...
        'EdgeLabel',UG.Edges.Weight,...
        'EdgeColor','k',...
        'NodeLabel', 1:8,...
        'LineWidth',2);
   colorbar