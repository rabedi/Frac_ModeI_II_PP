
nu = 0.3;
resolution = 200;
E = 1;
rho = 1;
[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);


normalizeVbymu = 0;
normalization2cs = 0;
v = [0.01:0.01:0.9 0.91:0.002:0.99];

delt = (pi / resolution);
teta = 0:delt: pi;

siz = length(teta);

for i = 1:siz
    if (abs(teta(i) - pi/2) < delt / 10)
        teta(i) = teta(i) - delt / 2.0;
    end
end


numv = length(v);
for nv = 1:numv
    [teta, s11, s22, s12, stet, tautet, smax, smin, taumax, v1, v2, vs] = getCrackTipFields(E, nu, rho, resolution, v(nv), normalization2cs, normalizeVbymu);
    v1max(nv) = max(abs(v1));
    v2max(nv) = max(abs(v2));
    vmax(nv) = max(vs);
    
    v1ave(nv) = sum(abs(v1)) / length(v1);
    v2ave(nv) = sum(abs(v2)) / length(v2);
    vsave(nv) = sum(abs(vs)) / length(vs);
    
    v1_0d(nv) = abs(v1(1));
    v2_0d(nv) = abs(v2(1));
    vs_0d(nv) = abs(vs(1));
    
    len = length(v1);
    v1_180d(nv) = abs(v1(len));
    v2_180d(nv) = abs(v2(len));
    vs_180d(nv) = abs(vs(len));
    
    
    
    V = v(nv) * cr;
    ad = sqrt(1 - V * V / cd / cd);
    as = sqrt(1 - V * V / cs / cs);
    D = 4 * ad * as - (1 + as * as)^2;
    Vconst(nv) = V /D / cd;
    D_(nv) = D;
    
    vSimplified(nv) = Vconst(nv) * (V / cs)^2;
    
    for j = 1:siz
        tt = teta(i);
        gd = sqrt(1 - (V * sin(tt) / cd)^2);
        gs = sqrt(1 - (V * sin(tt) / cs)^2);
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

        V1v_(j) = - ((1 + as^2) * chtd / sgd - 2.0 * ad * as * chts / sgs);
        V2v_(j) = - ad * ((1 + as^2)* shtd / sgd - 2.0 * shts / sgs) ;
        Vmv_(j) = sqrt(V1v_(j)^2 + V2v_(j)^2);
    
    end
    v1v(nv) = max(abs(V1v_));
    v2v(nv) = max(abs(V2v_));
    vmv(nv) = max(abs(Vmv_));
    
end

plot(v, log(v1max), v, log(v2max), v, log(vmax));
legend({'v1Max', 'v2Max', 'vMax'},'Location', 'SouthWest');
print('-dpdf', 'absoluteVmaxVals.pdf');

figure(2);
plot(v, log(v1ave), v, log(v2ave), v, log(vsave));
legend({'v1ave', 'v2ave', 'vsave'},'Location', 'SouthWest');
print('-dpdf', 'absoluteVaveVals.pdf');

figure(3);
plot(v, Vconst);
legend({'vconst'}, 'Location', 'Best');
print('-dpdf', 'vConst.pdf');
figure(4);
plot(v, v1v, v, v2v, v, vmv);
legend({'v1varMax', 'v2varMax', 'vsvarMax'},'Location', 'Best');
print('-dpdf', 'vVarParts.pdf');
figure(5);
plot(v, v1v);
legend({'v1varMax'});
print('-dpdf', 'v1Var.pdf');

figure(6);
plot(v, v2v);
legend({'v2varMax'});
print('-dpdf', 'v2Var.pdf');

figure(7);
plot(v, D_);
legend({'D'});
print('-dpdf', 'D.pdf');

figure(8);
plot(v, log10(vmax), v, log10(vsave), v, log10(vs_0d), v, log10(vs_180d), v, log10(vSimplified));
legend({'vmax', 'vave', 'vs0', 'vs180', 'vSimplified'},'Location', 'Best');
print('-dpdf', 'allVScalars.pdf');
    
    
    
    


for i = 1:8 
    close(i);
end