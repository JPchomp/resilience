function [critlinkmat] = critlinks(dualmat)

summat = zeros(6,6);

for i = 1:length(dualmat(1,:,1))
    for j = 1:length(dualmat(1,1,:))
                
        summat=tf2m(dualmat(:,i,j)) + summat;
        
    end
end

critlinkmat = summat;

%How do i talk about what would be probabilistically the expected value of
%capacity increase i need?

%I am getting the amount of vehicle-miles that couldve been averted by
%increasing capacity

%How about also dividing by T, and i get the extra distance, decreased
%performance, due to this link capacity.