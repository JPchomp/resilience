function [A,P] = filtreps(AF, PF)

AF
P = PF'
temp = [AF , P]

idxdel = any(diff(sort(AF,2),[],2)==0,2);

temp(idxdel,:)=[];


%Use sort to sort the values in each row
%Use diff to get the difference between consecutive values in each row
%Use any to check if any of those differences equal zero (indicating a duplicate values)
%Use the output of the any command, which is a logical index, to delete the rows that have duplicates

n = length(temp(1,:));

A = temp(:,1:(n-1));

P = (temp(:,n))';

