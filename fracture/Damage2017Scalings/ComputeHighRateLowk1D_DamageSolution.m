function [zDeq1Trial, zDeq1, deltauDeq1, zsigmaMaxTrial, zsigmaMax, DsigmaMax, sigmaMax, phiDeq1] = ComputeHighRateLowk1D_DamageSolution(k, eps)
if nargin < 1
    k = 0.001;
end

if nargin < 2
    eps = 0.0001;
end

zDeq1 = 0;
sqrteps = sqrt(eps);
DsigmaMax = 0;
zsigmaMax = 0;
sigmaMax = 0;
D = @(z) k * sqrt(eps * pi) / 2 * exp(z .* z) .* erf(z);
Dm1 = @(z) D(z) - 1;
zDeq1Trial = sqrt(log(2 / k / sqrt(pi) / sqrteps));
zDeq1 = fsolve(Dm1, zDeq1Trial);
integrand4Delu = @(z) 2 * z .*  D(z);
deltauDeq1 = quad(integrand4Delu, 0, zDeq1);
fun4zDMax = @(z) (1 + 2 * z^2) * D(z) - 1 + k * sqrteps * z;
zsigmaMaxTrial = zDeq1Trial / 2;
zsigmaMax = fsolve(fun4zDMax, zsigmaMaxTrial);
DsigmaMax = D(zsigmaMax);
sigmaMax = (1 - DsigmaMax) * zsigmaMax;

sig = @(z) (1 - D(z)) .* z;
phi = @(z) integrand4Delu(z) .* sig(z);
phiDeq1 = quad(phi, 0, zDeq1);
