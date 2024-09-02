function [yDeq1Trial, zDeq1, tpDeq1, yDeq1, tprDeq1, deltauDeq1, zsigmaMax, tpsigmaMax, ysigmaMax, tprsigmaMax, DsigmaMax, sigmaMax, ysigmaMax2yDeq1, phiDeq1] = ComputeLowRateLowk1D_DamageSolution(k, r, c)
% r is load rate normalized = wDot tauV / \tilde{sigma}
if nargin < 1
    k = 0.001;
end

if nargin < 2
    r = 0.0001;
end

if nargin < 3
% brittleness factor    
    c = 0.8;
end

cDivsqrtr = c / sqrt(r);
cDivsqrtr2 = cDivsqrtr * cDivsqrtr;
cor = c / r;
% z = sqrt(r) * tPrime
% tPrime = t / tauV
% y = tPrime - c / r
% z 
%D = @(y) k / 2.0 / (1 - c) * (exp(r * y .* y + 2 * c * y) - 1.0 + c * sqrt(pi / r) * exp(r * (y + cor) .* (y + cor)) * (erf(cDivsqrtr) - erf(sqrt(r) * (y + cor))));
D = @(y) k / 2.0 / (1 - c) * (exp(r * y .* y + 2 * c * y) - 1.0 - 2 * c * y .* (1 + c * y + r * y .* y)); 
% D2 is bad approxumation exp(2cy) is very large!
%D2 = @(y) k / 2.0 / (1 - c) * (r * y .* y + 0.5 * r * r * power(y, 4));

if 0
    xs = 0:0.01:5;
    ys = D(xs);
    plot(xs, ys);
end

yDeq1Trial = 1 / 2 /  c * log((2 * (1 - c) / k));
Dm1 = @(y) D(y) - 1;
yDeq1 = fsolve(Dm1, yDeq1Trial);
tpDeq1 = yDeq1 + cor;
tprDeq1 = tpDeq1 * r;
zDeq1 = sqrt(r) * tpDeq1;

acceptable = 1;
if (tprDeq1 > 1)
    fprintf(1, 'tprDeq1 = %f > 1\n', tprDeq1);
    acceptable = 0;
end
integrand4Delu = @(y) 2 * (r * y + c) .*  D(y);
deltauDeq1 = quad(integrand4Delu, 0, yDeq1);

fun4zDMax = @(y) (1 + 2 * r * (y + cor) .* (y + cor)) * D(y) - 1 + k * y / (1 - c) * (r * y + c);
ysigmaMaxTrial = yDeq1 / 2;
ysigmaMax = fsolve(fun4zDMax, ysigmaMaxTrial);
tpsigmaMax = ysigmaMax + cor;
tprsigmaMax = tpsigmaMax * r;
zsigmaMax = sqrt(r) * tpsigmaMax;

DsigmaMax = D(ysigmaMax);
sigmaMax = (1 - DsigmaMax) * zsigmaMax * sqrt(r);
if (sigmaMax < c)
    sigmaMax = c;
end

if 0
    funsigma = @(y) (1 - D(y)) .* (r * y + c);
    xs = 0:0.01:1;
    xs = xs * yDeq1;
    sigmas = funsigma(xs);
    plot(xs, sigmas);
end

ysigmaMax2yDeq1 = ysigmaMax / yDeq1;

sig = @(y) (1 - D(y)) .* (r .* y + c);
phi = @(y) integrand4Delu(y) .* sig(y);
phiDeq1 = quad(phi, 0, yDeq1);


if (acceptable == 0)
    yDeq1Trial = nan;
    zDeq1 = nan;
    tpDeq1 = nan;
    yDeq1 = nan;
    tprDeq1 = nan;
    deltauDeq1 = nan;
    zsigmaMax = nan;
    tpsigmaMax = nan;
    ysigmaMax = nan;
    tprsigmaMax = nan;
    DsigmaMax = nan;
    sigmaMax = nan;
    ysigmaMax2yDeq1 = nan;
    phiDeq1 = nan;
end