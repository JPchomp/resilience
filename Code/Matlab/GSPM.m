function [dmat] = GSPM(T)

global f A B Aeq Beq options

for s = 1:n
    for t = 1:n

        i=s;
        j=t;
        
        Beq=zeros(n,1); %Reset the origin/demand vector
        
% This rewrites the demand/supply vector such that it changes for each s,t
% pair 
        if i~=j
    
            for i = 1:n
                if i == s
                    Beq(i)=T;
                elseif i==t
                    Beq(i)=-T;
                else
                end
            end
            [x,GSPmatrix(s,t)]=linprog(f,A,B,Aeq,Beq,zeros(1,36),[],options); %Run the solver for (s,t)
                                                                              %DIF=[DIF,B'-x]; This was meant to be the difference vector between the capacity and used flow
        else 
            GSPmatrix(s,t)=0;
            
        end
 
    end
end

%Normalize the matrix by the traffic value and print
dmat=GSPmatrix/T