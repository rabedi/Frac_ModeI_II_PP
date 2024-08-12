function mpv = getMpVMapping(v, E, nu, rho)
%m'(v) is the mapping needed in computing velocity singular zone relative
%to stress singular zone in LEFM. The relation is:

% rv = rs * m'(v)^2
% input to the function is a vector of velocities normalized by cR

[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);

len = length(v);

for i = 1:len
    V = v(i) * cr;
    [D, Ddot] = computeDDdot(V, cd, cs);
    ad = sqrt(1 - (V/cd)^2);
    mpv(i)  = cd / cs * (V / cs)^3 * ad / D;
end
