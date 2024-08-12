function [gvI, kvI, AI] = comptuteGvKvAvI(v, nu, cd, cs, cr, scaledv)

kvI = comptuteKv(v, nu, cd, cs, cr, scaledv);
AI = comptuteAI(v, nu, cd, cs, cr, scaledv);

gvI = kvI * kvI * AI;


