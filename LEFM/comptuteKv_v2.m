function kv = comptuteKv_v2(v, nu, E, rho, scaledv)
[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);

if (nargin < 5)
    scaledv = 1;
end

if (scaledv == 0)
    v = v/cr;
    scaled = 1;
end


if v < 0.01
    kv = 1.0;
    return;
elseif (v > 0.99)
    kv = 0.0;
    return;
end

AI = comptuteAI(v, nu, cd, cs, cr, scaledv);
gv = comptuteGv(v, cr, scaledv);



kv = sqrt(gv ./ AI);