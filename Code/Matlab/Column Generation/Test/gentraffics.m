function [T] = gentraffics(population,DG,K)

n = length(population); T = zeros(n,n);

for i = 1:n
    for j = 1:n
        
        if i ~= j
                T(i,j) = population(i)*population(j)*K / DG(i,j);
        else
                T(i,j) = 0;
        end
        
    end
end
