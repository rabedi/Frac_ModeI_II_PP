function gv = comptuteGv(v, cr, scaledv)

if nargin < 6
    scaledv = 1;
end

if (scaledv == 0)
    v = v / cr;
end

gv = 1 - v;
