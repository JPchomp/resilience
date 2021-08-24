function [nsp,csp] = getsuperedges_s(gamma,s,t) 

idx = length(s);

csp=cell(idx,1);
nsp=cell(idx,1);

for i = 1:idx
    
    if s(i) == t(i)
        
    else
    
    nsp{i,1} = [s(i), t(i)];
    csp{i,1} = gamma;
    
    end
end
