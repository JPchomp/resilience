%% Build the graphs here

% clear all
% clc

%Change folder path
cd 'C:\Users\Juan Pablo\OneDrive - University of Illinois - Urbana\Thesis\Code\arg_example';

%Load Data
run Load_Data_CG.m

%Store the initial undirected graph for capacity and distance
UGD = graph(from,to,distance);
UGC = graph(from,to,capacity);

    % Undirect all
    
    fd = [from; to];
    td = [to ; from];
    cdd = [capacity ; capacity];
    dd = [distance ; distance];

%Store the directed versions, for OR analysis.

    % The distance graph
    
    GD = digraph(fd,td,dd);
    
    %The Capacity graph
    
    GC = digraph(fd,td,cdd);
    
    % Now calling weight for any calls the QoI of each.
    
    