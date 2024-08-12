function kv = comptuteKvII(v, nu, cd, cs, cr, scaledv)

if (scaledv == 0)
    v = v/cr;
%    scaledv = 1;
end

if v < 0.01
    kv = 1.0;
    return;
elseif ((1 - v) < 1e-3)
    kv = 0.0;
    return;
end

kv = (1 - v) / sqrt( 1 - v * cr / cs);

% AI = comptuteAI(v, nu, cd, cs, cr, scaledv);
% gv = comptuteGv(v, cr, scaledv);
% 
% 
% kv = sqrt(gv / AI);