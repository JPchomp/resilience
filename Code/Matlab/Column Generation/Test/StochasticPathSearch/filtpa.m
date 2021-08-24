function [A,P] = filtpa(AF, PF, t)

selvec = (any(AF == t,2) + AF(:,length(AF(1,:)))~=0);

A = AF(selvec,:);
P = PF';
P = P(selvec) ;

temp = [A , P];

temp = unique(temp,'rows');

%Select the index for the last col

n = length(temp(1,:));

A = temp(:,1:(n-1));

P = (temp(:,n))';

A(any(diff(sort(A,2),[],2)==0,2),:)=[];

%Use sort to sort the values in each row
%Use diff to get the difference between consecutive values in each row
%Use any to check if any of those differences equal zero (indicating a duplicate values)
%Use the output of the any command, which is a logical index, to delete the rows that have duplicates