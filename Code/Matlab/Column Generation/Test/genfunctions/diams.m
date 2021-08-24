function [diams, eccs] = diams(DG)

n = length(DG);
%Input a matrix of distances, get:

%diameter of every node
diams = sum(DG,2)/(n-1); %Zeros are already ignored with this
diams = round(diams,3);

%Eccentricity (sdevs of diam)
dgp = DG; dgp(dgp == 0) = []; dgp = reshape(dgp,n-1,n); dgp = dgp'; %Reshaped without diagonal zeros.
eccs = sqrt(sum((dgp-diams).^2,2)./((n-1)-1));
eccs = round(eccs,3);

