function [flows,mincost,lambda]=minCost(f,A,B,Aeq,Beq,lb,ub,options)

[flows,mincost,~,~,lambda]=linprog(f,A,B,Aeq,Beq.',lb,ub,options);



end

