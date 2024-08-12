function [S11, Smax, TauMax, Steta, TauTeta, V1, V2, Vs] = getKScalingValues(v, E, nu, rho, resolution)

if (nargin < 5)
     resolution = 200;
end

normalization2cs = 0;
normalizeVbymu = 2; % normalized by cd
[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);


[teta, s11, s22, s12, stet, tautet, smax, smin, taumax, v1, v2, vs] = getCrackTipFields(E, nu, rho, resolution, v, normalization2cs, normalizeVbymu);
num = length(teta);

S11(1) = max(abs(s11));
S11(2) = getAverage(abs(s11));
S11(3) = abs(s11(1));
S11(4) = abs(s11(num));

Smax(1) = max(abs(smax));
Smax(2) = getAverage(abs(smax));
Smax(3) = abs(smax(1));
Smax(4) = abs(smax(num));

TauMax(1) = max(abs(taumax));
TauMax(2) = getAverage(abs(taumax));
TauMax(3) = abs(taumax(1));
TauMax(4) = abs(taumax(num));

Steta(1) = max(abs(stet));
Steta(2) = getAverage(abs(stet));
Steta(3) = abs(stet(1));
Steta(4) = abs(stet(num));

TauTeta(1) = max(abs(tautet));
TauTeta(2) = getAverage(abs(tautet));
TauTeta(3) = abs(tautet(1));
TauTeta(4) = abs(tautet(num));

if (v == 0)
    V1 = zeros(1, 4);
    V2 = zeros(1, 4);
    Vs = zeros(1, 4);
else
    V1(1) = max(abs(v1));
    V1(2) = getAverage(abs(v1));
    V1(3) = abs(v1(1));
    V1(4) = abs(v1(num));

    V2(1) = max(abs(v2));
    V2(2) = getAverage(abs(v2));
    V2(3) = abs(v2(1));
    V2(4) = abs(v2(num));

    Vs(1) = max(abs(vs));
    Vs(2) = getAverage(abs(vs));
    Vs(3) = abs(vs(1));
    Vs(4) = abs(vs(num));
end
