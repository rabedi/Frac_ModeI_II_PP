function [D, Ddot] = computeDDdot(v, cd, cs)

ad = sqrt(1 - (v/cd).^2);
as = sqrt(1 - (v/cs).^2);

D = 4 * ad * as - (1 + as * as)^2;
Ddot = 4 * v * ( - as / ad / cd^2  - ad / as / cs^2 + 1 / cs^2 * (1 + as^2));

