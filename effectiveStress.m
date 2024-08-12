function s = effectiveStress(teta)
S00 = 3;
S01 = -0.5;
S11 = -3;
alpha = 0.8;
beta = 0.6;

[rs00 , rs01, rs11] = rotatedStress(S00, S01, S11, teta);


s = alpha .* rs11 .* rs11 + beta .* rs01 .* rs01;
