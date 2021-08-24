function [hplot] = histplot(mat)

%grab a matrix form thing and count to plot histogram

counter = 0;
hplot = [];

for i = 1:length(mat(:,1))
    for j = 1:length(mat(1,:))
        if mat(i,j) ~= 0
        counter = counter + 1;
        hplot(counter,:) = [i j mat(i,j)];
        end
    end
end
