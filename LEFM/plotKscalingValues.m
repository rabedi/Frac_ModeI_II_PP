function plotKscalingValues(nu, E, rho, resolution, v)

if nargin < 2
    E = 1;
end

if nargin < 3
    rho = 1;
end

if nargin < 4
    resolution = 200;
end

if nargin < 5
   v = [0.001 0.05:0.05:.9 0.91:0.005:.99 .991:0.001:.999]; 
end

vlen = length(v);
for nv = 1:vlen
    [S11(nv,:), Smax(nv,:), TauMax(nv,:), Steta(nv,:), TauTeta(nv,:), V1(nv,:), V2(nv,:), Vs(nv,:)] = getKScalingValues(v(nv), E, nu, rho, resolution);
end

plot(v, S11(:, 1), v, S11(:, 2), v, S11(:, 3), v, S11(:, 4));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'S11Scales.pdf');

plot(v, Smax(:, 1), v, Smax(:, 2), v, Smax(:, 3), v, Smax(:, 4));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'SmaxScales.pdf');

plot(v, TauMax(:, 1), v, TauMax(:, 2), v, TauMax(:, 3), v, TauMax(:, 4));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'TauMaxScales.pdf');

plot(v, Steta(:, 1), v, Steta(:, 2), v, Steta(:, 3), v, Steta(:, 4));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'StetaScales.pdf');

plot(v, TauTeta(:, 1), v, TauTeta(:, 2), v, TauTeta(:, 3), v, TauTeta(:, 4));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'TauTetaScales.pdf');

plot(v, V1(:, 1), v, V1(:, 2), v, V1(:, 3), v, V1(:, 4));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'V1Scales.pdf');

plot(v, V2(:, 1), v, V2(:, 2), v, V2(:, 3), v, V2(:, 4));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'V2Scales.pdf');

plot(v, Vs(:, 1), v, Vs(:, 2), v, Vs(:, 3), v, Vs(:, 4));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'VsScales.pdf');



plot(v, S11(:, 1), v, S11(:, 2), v, S11(:, 3), v, S11(:, 4));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'S11Scales.pdf');

plot(v, log10(Smax(:, 1)), v, log10(Smax(:, 2)), v, log10(Smax(:, 3)), v, log10(Smax(:, 4)));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'LogSmaxScales.pdf');

plot(v, log10(TauMax(:, 1)), v, log10(TauMax(:, 2)), v, log10(TauMax(:, 3)), v, log10(TauMax(:, 4)));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'LogTauMaxScales.pdf');

plot(v, log10(Steta(:, 1)), v, log10(Steta(:, 2)), v, log10(Steta(:, 3)), v, log10(Steta(:, 4)));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'LogStetaScales.pdf');

plot(v, log10(TauTeta(:, 1)), v, log10(TauTeta(:, 2)), v, log10(TauTeta(:, 3)), v, log10(TauTeta(:, 4)));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'LogTauTetaScales.pdf');


plot(v, log10(V1(:, 1)), v, log10(V1(:, 2)), v, log10(V1(:, 3)), v, log10(V1(:, 4)));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'log_V1Scales.pdf');

plot(v, log10(V2(:, 1)), v, log10(V2(:, 2)), v, log10(V2(:, 3)), v, log10(V2(:, 4)));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'log_V2Scales.pdf');

plot(v, log10(Vs(:, 1)), v, log10(Vs(:, 2)), v, log10(Vs(:, 3)), v, log10(Vs(:, 4)));
legend({'max', 'ave', '0d', '180d'});
print('-dpdf', 'log_VsScales.pdf');

close(gcf);
