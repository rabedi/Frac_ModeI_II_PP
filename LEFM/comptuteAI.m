function AI = comptuteAI(v, nu, cd, cs, cr, scaledv)

if (v <= 0.01 * cs)
    AI = 1.0;
end
    
if nargin < 6
    scaledv = 1;
end

if (scaledv == 1)
    v = v * cr;
end

sepVal = 0.99;

vRel = v / cr;
if (vRel <= sepVal)
    ad = sqrt(1 - v .* v/cd^2);
    as = sqrt(1 - v .* v/cs^2);
    D = 4 * ad .* as - (1 + as .* as) .* (1 + as .* as);
    AI = v .* v .* ad / (1 - nu) ./ cs ./cs ./ D;
elseif (vRel < 1)
    v = sepVal * cr;
    ad = sqrt(1 - v .* v/cd^2);
    as = sqrt(1 - v .* v/cs^2);
    D = 4 * ad .* as - (1 + as .* as) .* (1 + as .* as);
    AIt = v .* v .* ad / (1 - nu) ./ cs ./cs ./ D;
    AI = (1 - sepVal) / (1 - vRel) * AIt;
else
    AI = inf;
end
    
