function [teta, s11, s22, s12, stet, tautet, smax, smin, taumax, v1, v2, vs] = getCrackTipFields(E, nu, rho, resolution, normalizedV, normalization2cs, normalizeVbymu)

lambda = E * nu / (1 - nu * nu);
mu = E / 2 / (1 + nu);
[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);

if (normalization2cs == 1)
    v = normalizedV * cs;
else
    v = normalizedV * cr;
end
if (normalizeVbymu == 1)
    muv = mu;
elseif (normalizeVbymu == 2)
    muv = cd;
else
    muv = 1;
end

delt = (pi / resolution);
teta = 0:delt: pi;

siz = length(teta);

for i = 1:siz
    if (abs(teta(i) - pi/2) < delt / 10)
        teta(i) = teta(i) - delt / 2.0;
    end
end
s11 = zeros(1, siz);
s22 = zeros(1, siz);
s12 = zeros(1, siz);
stet = zeros(1, siz);
tautet = zeros(1, siz);
smax = zeros(1, siz);
smin = zeros(1, siz);
taumax = zeros(1, siz);
v1 = zeros(1, siz);
v2 = zeros(1, siz);
vs = zeros(1, siz);

ad = sqrt(1 - v * v / cd / cd);
as = sqrt(1 - v * v / cs / cs);
D = 4 * ad * as - (1 + as * as)^2;

for i = 1:siz
    tt = teta(i);
    gd = sqrt(1 - (v * sin(tt) / cd)^2);
    gs = sqrt(1 - (v * sin(tt) / cs)^2);
    tant = tan(tt);
    td = atan(tant * ad);
    tant = tan(tt);
    ts = atan(tant * as);
    if ((tt >= pi / 2) && (tt <= pi))
        td = td + pi;
        ts = ts + pi;
    elseif ((tt >= pi) && (tt <= 3 * pi / 2))
        td = td + pi;
        ts = ts + pi;
    elseif ((tt >= 3 * pi / 2) && (tt <= 2 * pi))
        td = td + 2 * pi;
        ts = ts + 2 * pi;
    end    
    htd = td / 2.0;
    hts = ts / 2.0;
    chtd = cos(htd);
    shtd = sin(htd);
    chts = cos(hts);
    shts = sin(hts);
    sgd = sqrt(gd);
    sgs = sqrt(gs);
    S11 = 1/D * ((1 + as^2) * (1 + 2.0 * ad^2 - as^2) * chtd / sgd - 4.0 * as * ad * chts / sgs);
    S12 = 2 * ad * (1 + as^2)/D * (shtd / sgd - shts / sgs);
    S22 = - 1/D * ((1 + as^2)^2 * chtd / sgd - 4.0 * ad * as * chts / sgs);
    Save = 0.5 * (S11 + S22);
    Sdiff = 0.5 * (S11 - S22);
    tauM = sqrt(Sdiff^2 + S12^2);
    SMax = Save + tauM;
    SMin = Save - tauM;
    Stet = Save  +  Sdiff * (-cos(2 * tt))  + S12 * (-sin(2 * tt));
    Ttet =          Sdiff * ( sin(2 * tt))  + S12 * (-cos(2 * tt));
    V1 = - v / muv / D * ((1 + as^2) * chtd / sgd - 2.0 * ad * as * chts / sgs) / cd;
    V2 = - v * ad / muv / D * ((1 + as^2)* shtd / sgd - 2.0 * shts / sgs) / cd;
    VS = sqrt(V1^2 + V2^2);
    s11(i) = S11;
    s12(i) = S12;
    s22(i) = S22;
    stet(i) = Stet;
    tautet(i) = Ttet;
    smax(i) = SMax;
    smin(i) = SMin;
    taumax(i) = tauM;
    v1(i) = V1;
    v2(i) = V2;
    vs(i) = VS;
end