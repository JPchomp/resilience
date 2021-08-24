function [effs, hets] = effs(DG)

n = length(DG);
%Input a matrix of distances, get:

%Reshape without zeros
dgp = DG; dgp(dgp == 0) = []; dgp = reshape(dgp,n-1,n);
dgp = dgp'; 
%Inverse elementwise
dgp = 1./dgp;


%Efficiency of every node
effs = sum(dgp,2)/(n-1);
effs = round(effs,3);

%Heterogeneity (sdevs of eff)
hets = sqrt(sum(((dgp-effs).^2),2)/((n-1)-1));
hets = round(hets,3);