function [mincost]=minCostCCplex(f,A,B,Aeq,Beq,lb,ub,options)

[~,mincost]=cplexlp(f,A,B,Aeq,Beq.',lb,ub,[],[]);


end

