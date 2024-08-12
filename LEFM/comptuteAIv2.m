function AI = comptuteAIv2(v, nu, E, rho, scaledv)
if (nargin < 5)
    scaledv = 1;
end
[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);
AI = comptuteAI(v, nu, cd, cs, cr, scaledv);


