function [gvII, kvII, AII] = comptuteGvKvAvII(v, nu, cd, cs, cr, scaledv)

kvII = comptuteKvII(v, nu, cd, cs, cr, scaledv);
AII = comptuteAII(v, nu, cd, cs, cr, scaledv);

gvII = kvII * kvII * AII;


