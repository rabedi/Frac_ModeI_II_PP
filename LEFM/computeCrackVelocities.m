function [cd, cs, cr]  = computeCrackVelocities(E, nu, rho)

if nargin < 1
    E = 3.24;
end

if nargin < 2
    nu = 0.35;
end

if nargin < 3
    rho = 1.19;
end

lambda = E * nu / (1 + nu) / (1 - 2. * nu);
mu = E / 2 / (1 + nu);
cd = sqrt((lambda + 2 * mu) / rho);
cs = sqrt(mu / rho);

%cr1 = sqrt(2 / (16 - (cd / cs)^2) * (3 * cd^2 + 4 * cs^2 + 2 * sqrt(3 * cd^4 - 6 * cs^2 * cd^2 + 4 * cs^4)))
%cr2 = sqrt(2 / (16 - (cd / cs)^2) * (3 * cd^2 + 4 * cs^2 - 2 * sqrt(3 * cd^4 - 6 * cs^2 * cd^2 + 4 * cs^4)))

cr = cs * (0.862 + 1.14 * nu) / (1.0 + nu);


p(1) = 1 / power(cs, 8);
p(2) = -8.0 / power(cs, 6);
p(3) = 8.0 / power(cs, 2) * (3.0 / power(cs, 2) - 2.0 / power(cd, 2));
p(4) = 16 * (1.0 / power(cd, 2) - 1.0 / power(cs, 2));
sol = roots(p);

len = length(sol);
cntr = 1;
for i = 1:len
    if (sol(i) >= 0.0)
        ps(cntr) = sqrt(sol(i));
    end
end

[minDiff, ind] = min(abs(ps - cr));
cr = ps(ind);

%[Dcr, Ddot] = computeDDdot(cr, cd, cs);
