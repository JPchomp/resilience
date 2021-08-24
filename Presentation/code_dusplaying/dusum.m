function [dualsum] = dusum(dualmat,event)

%Adds the values of the duals for a specific case 

dualsum = tf2m(sum(dualmat(:,:,event),2));

