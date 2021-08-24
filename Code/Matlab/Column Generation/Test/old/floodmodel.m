%run the simulation of increasing flood height

k = 10;                                                                         % number of steps for fragility;

H = linspace(0.9*min(altitude),max(altitude),k);                                % Flood height vector

FMATS = zeros(6,6,k);
flowmat = [];
dualmat = [];
fcmat = zeros(length(altitude),1);                                              % Failure count matrix

FMATSSP = zeros(6,6,k);

for i = 1:k
    
    fh = from; th = to; dh = distance; ch = capacity;lh = linkid; eh = edgelist;% Temp 
    
                                                rnor = normrnd(0.1,0.1,[length(altitude),1])  ;

                                                				% rnor = zeros((altitude),1);
                                                ah = altitude - rnor;

                                              
                                                
    fh(H(i)>ah) = [];
    th(H(i)>ah) = [];
    dh(H(i)>ah) = [];                             
    ch(H(i)>ah) = [];                                                     % Erase link data for those flooded.

                                                			  % ch = (1-(i/(k-10))) * ch  ;                       %Use to show capacity effect
                                

    Gtemp = digraph(fh,th,dh);
       
    [FMATS(:,:,i),flowmat(:,:,i),dualmat(:,:,i)] = getfloodmat(fh,th,dh,ch,dir,2);                              % The last number is the traffic value
    FMATSSP(:,:,i) = distances(Gtemp);
    
    if sum(sum(FMATSSP(:,:,i))) > 30
         fcmat = fcmat + (ah < H(i)) 
    else
    end

end

critlinks(dualmat)
