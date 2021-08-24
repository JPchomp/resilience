%%Data Loading Module
%This script will grab all the Data from the network
%And finally output a network

cd 'C:\Users\jpb6\OneDrive - University of Illinois - Urbana\Thesis\Code\Matlab\Column Generation\Test';

%What is the current local path:
currentFolder = pwd;
addpath(genpath(pwd));
%Concatenate the current path and the Network Data
path=pwd+"\"+"Seasidedatatest.xlsx"

DATA=xlsread(path);

%% REVISED (Now optimized) Data Loading
global from to distance capacity dir DistList
dir=0;DistList=[];

from=DATA(:,3);from=from(isnan(from)==0);
to=DATA(:,4);to=to(isnan(to)==0);
edgelist=DATA(:,5);edgelist=edgelist(isnan(edgelist)==0);
distance=DATA(:,6);distance=distance(isnan(distance)==0);
altitude=DATA(:,7);altitude=altitude(isnan(altitude)==0);
linkid=DATA(:,8);linkid=linkid(isnan(linkid)==0);
capacity=DATA(:,14);capacity=capacity(isnan(capacity)==0);

%Topographic Data for Node Location, in this case just positions in x,y to graph it.
xlocation=DATA(:,9);xlocation=xlocation(isnan(xlocation)==0);
ylocation=DATA(:,10);ylocation=ylocation(isnan(ylocation)==0);