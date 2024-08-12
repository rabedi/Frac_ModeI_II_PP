function [time, ldotCrack, lCrack] = getSemiInfiniteConstantLoadingWithInitialRampResponse(nu, rampTimeRatio, alphaPower, numPtPerRamp, numPtPerT)

if (nargin < 1)
    nu = 0.35;
end

if (nargin < 2)
    rampTimeRatio = 0.00;
end

if (nargin < 3)
    alphaPower = 1.0;
end

if (nargin < 4)
    numPtPerRamp = 100;
end

if (nargin < 5)
    numPtPerT = 10;
end


p0 = 0.5;
sigmaForce = 2.0 * p0;
loadStep = 0.0;
E = 1.0;
rho = 1.0;
mu = E / 2 / (1 + nu);
loadType = 2;
loadScaled = 1;
FractureEnergy = 1;
[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);

tau = pi / 8.0 / (1 + nu) * E * cd * FractureEnergy / (cs * sigmaForce)^2;
rampTime = rampTimeRatio * tau;
%Final Time
finalLoadFactor = power(10, alphaPower) * tau;
finalTime = finalLoadFactor;
plateWidth = inf;
normalizelDot2cR = 1;
drSigAdjMethod = 0;
drVelAdjMethod = 0;
drVelAdjDir = 0;
ShiftTime = 0;
inputTimes = [];
sigmaC = 1;
fvalPZ = 1;

[arrestTime, nucleationTime, time, Load, SigmaForce, KIstatic, KIdynamic, ldotCrack, lCrack, ...
    StaticRadius, DynamicRadius, DynamicRadiusSigmaAdjusted, DynamicRadiusVelocitySigmaAdjusted, flags, T] = ...
    getLEFMCrackTipFieldsForSemiInfiniteDomain(rampTime, p0, loadStep, finalLoadFactor, plateWidth, E, rho, nu, loadType, loadScaled, ...
    FractureEnergy, finalTime, numPtPerT, numPtPerRamp, normalizelDot2cR, drSigAdjMethod, drVelAdjMethod, drVelAdjDir, ShiftTime, ...
    inputTimes, sigmaC, fvalPZ);

time = time / tau;

% figure(1);
% plot(time, ldotCrack);

lCrack = lCrack / cr / tau;

% figure(2);
% plot(time, lCrack);
