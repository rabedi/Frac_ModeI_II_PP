function plotSingularRadiiForConstantAndRampLoading(nu, E, rho)

[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);
cr2cd = cr/cd;
v = 0.01:0.01:.99;
rsconst = (1 - v) ./ (1 - cr2cd * v);
rsramp = power((1 - v), (5./3.)) ./ (1 - cr2cd * v);

mpv = getMpVMapping(v, E, nu, rho);
mpv2 = mpv .* mpv;

rvconst = mpv2 .* rsconst;
rvramp = mpv2 .* rsramp;

plot(v, rsconst, v, rsramp);
legend({'rsconst', 'rsramp'});
print('-dpdf', 'rsConstRamp.pdf');


plot(v, rvconst, v, rvramp);
legend({'rvconst', 'rVramp'});
print('-dpdf', 'rvConstRamp.pdf');


plot(v, rsconst, v, rvconst);
legend({'rsconst', 'rvconst'});
print('-dpdf', 'rsvConst.pdf');

plot(v, rsramp, v, rvramp);
legend({'rsramp', 'rvramp'});
print('-dpdf', 'rsvramp.pdf');

