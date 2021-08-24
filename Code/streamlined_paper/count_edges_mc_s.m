n = length(paths);
mclist = [];

for i = 1:n
                        
            %For each path found find the cost:
            for k = 1 : length(paths{i})-1
                               
                    % Cycle through each path and sum each links cost
                    mclist = [ mclist; paths{i}(k) , paths{i}(k+1) ];
                    
            end
            
end

check  = unique(mclist,'rows');
tabchk = table(check);

for i = 1 : length(check(:,1))
    
    a = mclist == tabchk.check(i,:);
    tabchk.count(i) = sum(a(:,1).*a(:,2));
    
end
    
tabchk

%Fortunately order is preserved
plot_edge_weights(GD,xlocation, ylocation, tabchk.count)

plot_edge_weights(UGD,xlocation, ylocation, tabchk.count(1:12))