function [mincost]=minCost(f,A,B,Aeq,Beq,lb,ub,options)

[~,mincost]=linprog(f,A,B,Aeq,Beq.',lb,ub,options);



end

