function [tfvector] = tf2m(input)

n = sqrt(length(input));
tfvector = zeros(n,n);

for i=1:(n)
    for j=1:(n)
        tfvector(i,j) = input((i-1)*n+j,1);                                                                      
    end
end