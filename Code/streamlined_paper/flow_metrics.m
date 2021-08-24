%%flow metrics for ppt

run initialization.m %GC and GD are defined here

[FTCD , distmatrix , capmatrix ] = adj_mats_s(fd, td, cdd, dd); 

n = max(max(fd),max(td));   % Get number of nodes
nl = length(fd) ;           % Get number of links, no repeated links.

% If you define a traffic matrix, you are already defining the O-D of
% interest and the quantities of each commodity

    % Format for input data:
    % s = [1,1,2,2,3,3,4,4,5,5,6,6,7,7,8];
    % t = [8,7,6,5,4,2,1,8,7,6,4,3,2,1,1];
    % T = [500,100,100,500,20,50,400,200,200,400,500,0,200,300,40]*1;

    % Def 2: Traffic, and origin destination pairs.
    Tmat = rand(n,n) * 100;
    Tmat = Tmat - diag(diag(Tmat));
    [s,t,T] = setup_traffic(Tmat);

% This function yields
% The matrix of maximum flows MF
% The paths that produce the maximum flow
% Costs of the paths found 
[MF , paths , pcosts] = maxflowpaths_st(GC,GD,s,t);

%%
MFp = zeros(n,n);
Os = cell(n,n);
Ds = cell(n,n);

for i = 1:n
    for j = 1:n
        if i ~= j
            [MFp(i,j),~,Os{i,j},Ds{i,j}] = maxflow(GC,i,j);
        else
        end
    end
end

%%
maxflo = max(MFp)';
sumflo = sum(MFp,2);
meanflo = mean(MFp,2);
sdevflo = std(MFp,0,2);

%%
plot_nodal_weights(UGC,xlocation, ylocation, centrality(UGC,'degree','Importance',UGD.Edges.Weight))

plot_nodal_weights(UGC,xlocation, ylocation, maxflo)

plot_nodal_weights(UGC,xlocation, ylocation, meanflo)

plot_nodal_weights(UGC,xlocation, ylocation, sdevflo)

%%
counter = [];

for i = 1:n
    for j = i:n
        if i ~= j
            temp = [Os{i,j},repmat(Ds{i,j},length(Os{i,j}),1)];
            counter = [counter ; temp ];
        else
        end
    end
end


cmatrix = distances(UGC).*adjacency(UGC);
% Calculate Edge Centrality
[nc,ec] = betweenness_centrality(cmatrix);
%Define characteristics
ec = (ec + ec')./2;
temgraph = graph(ec);
LWidths = 5*temgraph.Edges.Weight/max(temgraph.Edges.Weight);
%Open figure
figure(5)
set(gcf, 'Position',  posize);
set(gcf,'color',color);
p5 =plot(temgraph,'XData',xlocation,'YData',ylocation,...
        'NodeLabel', 1:length(xlocation),...
        'EdgeLabel', temgraph.Edges.Weight,...
        'LineWidth',LWidths);...
        title('Edge Centrality');
        set(gca,'FontSize',  fsize)
% nl = p5.NodeLabel;
plot_edge_weights(UGC,xlocation, ylocation, LWidths)







