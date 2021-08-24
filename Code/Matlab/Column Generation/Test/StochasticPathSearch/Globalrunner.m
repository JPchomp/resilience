% Initialization

% I already have WA
% I already have D 

    %pathlist with the origin
%s=2; t=6;
%pathlist = s;
tolerance = 0.3;                 %Probability tolerance for the paths

%Prob with 1
%prob = 1;

    % A very long vector to store paths
    % newpath = zeros(1,20);
    
pathlist = newpath(:,k);
prob = P;

k = k + 1;
runpath(pathlist,t,tolerance, prob,WA,D)

[NPAT, NPRO] =  runpath(NPAT       ,4  ,tolerance,   NPRO   ,WA,D);
