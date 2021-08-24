function [ pr ] = cy( A,i,j )
% If one add an arc to a tree, there arise the unique circuit.
% this function "cy" compurtes this unique circuit for the input data:
% A : adjacency matrix of the graph obtained from the tree by adding new arc
% between two vertices in the tree with an infinite cost.
% i,j : two specified vertices in the tree
% This function "cy" uses Dijkstra's Algorithm in the shortest path problem 
% essentially.
n=size(A);
n=n(1);
y=A(i,:);
q= y==0;
y(q)=Inf;
prev=[i*ones(i,n)];
B=y;
Set=[zeros(1,n)];
Set(i)=1;
for R=1:n
    v=find(Set==0);
    if size(v) == [1 0]
        break
    end
    t=y(v);
    a= t>0;
    t=t(a);
    s=min(t);
    z=y;
    w= Set==1;
    z(w)=0;
    a=find(z==s);
    if length(a)~=1
        a=a(1);
    end
    D=A(a,:);
    E=D+s;
    F=find(E>s);
    G=size(F);
    G=G(2);
    for g=1:G
        if E(F(g))<y(F(g))
            y(F(g))=E(F(g));
            prev(F(g))=a;
        end
    end
    Set(a)=1;
end
y=y(j);
z=1;
h=j;                    
pr(1)=j;                
for q=1:n               
    pr(1+q)=prev(h);    
    if prev(h)==i       
        break
    end
    h=prev(h);          
end
end