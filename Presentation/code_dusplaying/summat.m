function [critlinkmat] = critlinks(dualmat)

summat = zeros(6,6);

for i = 1:length(dualmat(1,:,1))
    for j = 1:length(dualmat(1,1,:))
                
        summat=tf2m(dualmat(:,i,j)) + summat;
        
    end
end

critlinkmat = summat;