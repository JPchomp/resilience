function [ z ] = zanyo( A,B )
%compute the auxiliary network
z=A-B+B.';
end