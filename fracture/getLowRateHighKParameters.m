function [timeDeq1xepsDivtauScale, deltuxepsDivdeluScale, timeMaxStressxepsDivtauScale, D4sigmaMaxDivsigmaScale, sigmaMaxDivsigmaScale] = getLowRateHighKParameters(c)
% epsilon = wdot * tau_s / \tilde{sigma}
tmp = sqrt(2 * (1 - c));
timeDeq1xepsDivtauScale = tmp + c;
deltuxepsDivdeluScale = tmp * (3 * tmp + 4) / 12;
z = (sqrt(c * c + 16 * (1 - c)) - c) / 4;
timeMaxStressxepsDivtauScale = z + c;
D4sigmaMaxDivsigmaScale = 1 / 2 / (1 - c) * z * z;
sigmaMaxDivsigmaScale = (1 - D4sigmaMaxDivsigmaScale) * (c + z);



