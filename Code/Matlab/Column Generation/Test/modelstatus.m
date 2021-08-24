function[] = modelstatus(cplex)

disp("Objective and constraints")
cplex.Model.obj
[cplex.Model.lb , cplex.Model.ub]

disp("Objective and constraints")
[cplex.Model.lhs, full(cplex.Model.A), cplex.Model.rhs]



