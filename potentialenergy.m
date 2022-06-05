function Ue = potentialenergy(V)

s = 1;
N = size(V,1); 

% Compute geodesic distances between the points
DOT = V*V';       % dot product 
DOT(DOT<-1) = -1; 
DOT(DOT>1) = 1;
GD = acos(DOT);   % geodesic distance

% Evaluate potential energy
GD(1 : (N+1) : end) = Inf; % set diagonal entries of GD to Inf
Ue_ij = 1./((GD .^ s) + eps);
Ue_i = sum(Ue_ij, 2);
Ue = sum(Ue_i);