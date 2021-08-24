function [fromdir,todir,distancedir,capacitydir] = undir()
%%The following makes the network data be undirected.

global from to distance capacity dir DistList;

if dir == 0
    
    fromdir=from;todir=to;distancedir=distance;capacitydir=capacity; %Save originals for directed network

    from=cat(1,from,todir);
    to=cat(1,to,fromdir);
    distance=cat(1,distance,distancedir);
    capacity=cat(1,capacity,capacitydir);
    dir=1;
    
    DistList=unique([from,to,distance,capacity],'rows');
     
else
    disp('Already Dir') 
end

