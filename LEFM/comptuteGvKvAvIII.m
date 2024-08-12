function [gvIII, kvIII, AIII] = comptuteGvKvAvIII(v, nu, cd, cs, cr, scaledv)

if (scaledv == 1)
    v = v * cr;
end
v = v / cs;

if (v > 0.9999)
    kvIII = 0;
    AIII = NaN;
    gvIII = 0;
else
    kvIII = sqrt(1 - v);
    AIII = 1 / sqrt(1 - v^2);
    gvIII = kvIII * kvIII * AIII;
end

