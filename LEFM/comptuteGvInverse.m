function v = comptuteGvInverse(gv, cr, scaledv)

if nargin < 3
    scaledv = 1;
end

if (gv > 1)
    v = 0.0;
elseif (gv < 0)
    v = cr;
else
    v = 1 - gv;
end

if (scaledv == 0)
    v = v * cr;
end
