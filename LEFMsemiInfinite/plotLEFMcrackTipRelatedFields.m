function [arrestTime, nucleationTime, time, Load, SigmaForce, KIstatic, KIdynamic, ldotCrack, lCrack, StaticRadius, DynamicRadius, DynamicRadiusSigmaAdjusted, DynamicRadiusVelocitySigmaAdjusted] = plotLEFMcrackTipRelatedFields()

rampTime = 0.1;
p0 = 0.015;
plateWidth = 3;
E = 3.24;
rho = 1.19;
nu = 0.35;
loadType = 0;
loadScaled = 0;
FractureEnergy = 3.5229e-004;
finalTime = 12;

numPtPerT = 200;
numPtPerRamp = 10;
alpha = 0;
finalLoadFactor = inf;
normalizelDot2cR = 1;

drSigAdjMethod = 1;
drVelAdjMethod = 1;
drVelAdjDir = 2;

inputTimes = 0:0.5:10;
ShiftTime = 0;


[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);
T = plateWidth / cd / rho;

inputTimes = inputTimes + T + 0.25;
ShiftTime = 1;

[arrestTime, nucleationTime, time, Load, SigmaForce, KIstatic, KIdynamic, ldotCrack, lCrack, StaticRadius, DynamicRadius,...
    DynamicRadiusSigmaAdjusted , DynamicRadiusVelocitySigmaAdjusted, flags, T] = ...
getLEFMCrackTipFieldsForSemiInfiniteDomain(rampTime, p0, alpha, finalLoadFactor, plateWidth, E, rho, nu, loadType, loadScaled, ...
FractureEnergy, finalTime, numPtPerT, numPtPerRamp, normalizelDot2cR, drSigAdjMethod, drVelAdjMethod, drVelAdjDir, ShiftTime, inputTimes);

subName = '';
plotLEFMHistories(time, Load, SigmaForce, KIstatic, KIdynamic, ldotCrack, lCrack, StaticRadius, DynamicRadius, DynamicRadiusSigmaAdjusted , DynamicRadiusVelocitySigmaAdjusted, subName, flags);
