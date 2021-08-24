function [ minf ] = simplex( a,d,g )  
% This function computes the minimum cost flow by a network simplex algorithm.
% The input is the adjacency matrix, the demand function, and the cost function.
n=size(a);                                       
n=n(1);                                          
M=1+n*max(max(g))/2;                            
b=[a zeros(n,1)];                                
b=[b;zeros(1,n+1)];                             
g=[g zeros(n,1)];                               
g=[g;zeros(1,n+1)];                            
pi=zeros(1,n+1);                                
C=0;
for i=1:n                                        

    if d(i)>0                                   
        b(n+1,i)=d(i)+1;                       
        g(n+1,i)=M;                            
        pi(i)=M;                              

    else                                       
        b(i,n+1)=-d(i)+1;                        
        g(i,n+1)=M;                              
        pi(i)=-M;                                
    end
end
pi(n+1)=0;                                       
d(n+1)=0;                                    
n=size(b);                                     
n=n(1);                                         
f=flow(b);                                     
E=find(b~=0);                                 
T=find(g==M);                                  
L=setxor(E,T);                                
U=[];                                           
z=zanyo(b,f);                                    
p= potential( L,pi,g,n );                  
e= find(p<0);                                    
eee=L(e(1));
while ~isempty(e)                                
    s=short(f,T);                               
    s(eee)=Inf;                                  
    rrr=rem(eee,n);
        if rrr==0
            rrr=n;
        end
    x= cy(s,rrr,ceil(eee/n));                    

    X=length(x);
    x(X+1)=x(1);                                  
    if C==1                                      
        if rem(X+1,2)==1                         
            for CC=1:X/2
                tmp=x(CC);
                x(CC)=x(X-CC+2);
                x(X-CC+2)=tmp;
            end
        else
            for CCC=1:(X+1)/2
                tmp=x(CCC);
                x(CCC)=x(X-CCC+2);
                x(X-CCC+2)=tmp;
            end
        end
    end
    i=1;
    y=[];
    while i<=X                                    
        y(i)=z(x(i),x(i+1));
        i=i+1;
    end
    af=min(y);                                   
    aff=find(af==y);                         
    if length(aff)>1                          
        afs=short(f,T);                     
        www=wf(afs);
        www=www(n,:);
        www1=min(www(x));
        www2=find(www(x)==www1);
        if length(www2)>1
            www2=www2(1);
        end
        vvv=x(www2);                            
        x(X+1)=[];			                 
        xxxxx=circshift(x,[1,-www2+1]);
        xxxxx(X+1)=xxxxx(1);
        x=xxxxx;
        i=1;
        while i<=X                              
            y(i)=z(xxxxx(i),xxxxx(i+1));
            i=i+1;
        end
        aff=find(af==y);                        
        aff=max(aff);
    end
    T=[T;eee];                                
                                                 
    q= find (T==vertex(x(aff),x(aff+1),n));      
    if size(q)==[0,1]
        q=find(T==vertex(x(aff+1),x(aff),n));
        L=[L;T(q)];                              
        T(q)=[];                               
    else
        U=[U;T(q)];                             
        T(q)=[];                             
    end
    i=1;
    while i<=X                                
        f(x(i),x(i+1))=f(x(i),x(i+1))+af;
        i=i+1;
    end

    for i=1:n                                 
        for j=1:n                               
            if f(i,j)>0                           
                if f(j,i)>0                     
                    if f(i,j)>f(j,i)
                        f(i,j)=f(i,j)-f(j,i);
                        f(j,i)=0;
                    else
                        f(j,i)=f(j,i)-f(i,j);
                        f(i,j)=0;
                    end
                end
            end
        end
    end                                        
    z=zanyo(b,f);                              
    pi=pt(T,g,M);                              
    p = potential( L,pi,g,n );               
    C=0;
    e= find(p<0);                            
    if isempty(e)                           
        p1=potential(U,pi,g,n);                 
        e= find(p1>0);                         
        if isempty(e)
            break
        end
        C=1;
        eee=U(e(1));                             
        U(e(1))=[];                              
    else
        eee=L(e(1));
        L(e(1))=[];
    end                                         
end
minf=admissible(f);                             
end