E = 300; nu = 0.27; rho = 3.985;
[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);
ZIns = [cd * rho, cs * rho];
Eo = 200; nuo = 0.27; rhoo = 8.00;
[cdo, cso, cro]  = computeCrackVelocities(Eo, nuo, rhoo);
ZOuts = [cdo * rhoo, cso * rhoo];

Z = ZIns(1);
Zo = ZOuts(1);
f = 2 * Z / (Z + Zo);
L = 0.1 / f
vo = L / Zo

so = -0.1;
so = -L

% for transmitting BC
%ZOuts = ZIns;
%so = 0.0;

L(1) = 2 * so;
L(2) = 0.0;

s = [-0.05,	0.2];
%v = [0.0,	0.1];
v = [-0.2,	0.1];

s = [0.0,	0.0];
%v = [0.0,	0.1];
v = [0.0,	0.0];

si = 1;
vi = 2;

for i = 1:2
    Z = ZIns(i);
    Zo = ZOuts(i);
    sval = s(i);
    vval = v(i);
    ZInv = 1.0 / (Z + Zo);
    m(si, si) = Zo * ZInv;
    m(si, vi) = - Z * Zo * ZInv;
    m(vi, si) = -ZInv;
    m(vi, vi) = Z * ZInv;
    cnst(si) = L(i) * Z * ZInv;
    cnst(vi) = L(i) * ZInv;
    ss = m(si, si) * sval + m(si, vi) * vval + cnst(si);
    vs = m(vi, si) * sval + m(vi, vi) * vval + cnst(vi);
    m
    cnst
    ss
    vs
end   