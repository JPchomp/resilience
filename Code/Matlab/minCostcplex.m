function [mincost]=minCost(f,A,B,Aeq,Beq,lb,ub,options)

% Just get the Size for later

Nf = size(f); Nf = Nf(1);

Nc = size ( Cp); Nc = Nc(1);

%%Model
   % Build model
   cplex = Cplex('flow');
   
   % We will use the path formulation to have ready the column Generation
   % Multicommodity too
   % Possibility soon. Or Should i start with a vanilla flow with cplex?
   
   cplex.Model.sense = 'minimize';
   
   obj   = [f;Cp];                                                          % f is the flow for a path P. Cp the cost of the path.
   lb    = zeros (Nf , 1);                                                  % Vector of 0 size Nf
   ub    = ones (Nf, 1);                                                    % Vector of ones size Nf
   ctype = char (ones (1, Nf*('C')));                                        % define the decision variables as continuous                   
   
   cplex.addCols(obj, [], lb, ub, ctype);
   
   % Each client must be assigned to one location
   for i = 1:Nf
      supply = zeros (1, nbLocations + nbLocations*nbClients);              %Initialize all zeros
      supply((i*nbLocations+1):(i*nbLocations+nbLocations)) = ...
         ones (1, nbLocations);
      cplex.addRows(1, supply, 1);
   end
   
   % The number of clients assigned to a location must be less than the
   % capacity of the location.  The capacity is multiplied by the open
   % variable to model that the capacity is zero if the location is not
   % opened.
   
   for i = 1:nbLocations
      v    = zeros (1, nbLocations + nbLocations*nbClients);
      v(i) = -capacity(i);
      v(i + nbLocations:nbLocations:i+nbClients*nbLocations) = ...
         ones(1, nbClients);
      cplex.addRows(-inf, v, 0);
   end
   
    cplex.solve();

    [~,mincost]=cplex.Solution.objval;

end

