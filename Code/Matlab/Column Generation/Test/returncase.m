function [casemat] = returncase(k,f,flowmat,dualmat,B)

%casemat = zeros(length(flowmat(:,k)),4)

casemat = [flowmat(:,k),dualmat(:,k),full(B)',full(f)',full(B)'-flowmat(:,k)];