G=graph(DistList(:,1),DistList(:,2),DistList(:,3));

PL=dmat(sn:en,sn:en);
[row,col] = find(PL==Inf);

ss=plot(G,'XData',xlocation,'YData',ylocation);title('Seaside, Oregon');
highlight(ss,[sn:en],'nodecolor','r')
labelnode(ss,[sn:en],string([sn:en]))

for i=1:length(row)
    path=shortestpath(G,row(i),col(i));
    highlight(ss,path,'NodeColor','b','EdgeColor','r')
end