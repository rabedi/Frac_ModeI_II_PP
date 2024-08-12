function produceLEFMrelatedDataPostProcess()

maxPowerRatio = 6;
returnInfs = 1;

subName = '';
tVcR = load('../../tVcR.txt');
inputTimes = tVcR(:, 1);
vcrIn = tVcR(:, 2);


resolution = 200;
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


maxValRatios = power(10.0, maxPowerRatio);

[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);
T = plateWidth / cd / rho;

ShiftTime = 1;

[arrestTime, nucleationTime, time, Load, SigmaForce, KIstatic, KIdynamic, ldotCrack, lCrack, StaticRadius, DynamicRadius,...
    DynamicRadiusSigmaAdjusted , DynamicRadiusVelocitySigmaAdjusted, flags, T] = ...
getLEFMCrackTipFieldsForSemiInfiniteDomain(rampTime, p0, alpha, finalLoadFactor, plateWidth, E, rho, nu, loadType, loadScaled, ...
FractureEnergy, finalTime, numPtPerT, numPtPerRamp, normalizelDot2cR, drSigAdjMethod, drVelAdjMethod, drVelAdjDir, ShiftTime, inputTimes);

numFlag = length(flags);

LoadRed = Load(flags);
SigmaForceRed = SigmaForce(flags);
KIstaticRed = KIstatic(flags);
KIdynamicRed = KIdynamic(flags);
ldotCrackRed = ldotCrack(flags);
lCrackRed = lCrack(flags);
StaticRadiusRed = StaticRadius(flags);
DynamicRadiusRed = DynamicRadius(flags); 
DynamicRadiusSigmaAdjustedRed = DynamicRadiusSigmaAdjusted(flags);
DynamicRadiusVelocitySigmaAdjustedRed = DynamicRadiusVelocitySigmaAdjusted(flags);

processZoneIn = DynamicRadiusRed;


for i = 1:numFlag
    [KIdynamicVlMdfdRed(i), DynamicRadiusVlMdfdRed(i), DynamicRadiusSigmaAdjustedVlMdfdRed(i), DynamicRadiusVelocitySigmaAdjustedVlMdfdRed(i)] = ...
        getVelocityAdjustedProcessZoneSizes(KIstaticRed(i), StaticRadiusRed(i), vcrIn(i), cd, cs, cr, E, nu, rho, resolution, ...
    drSigAdjMethod, drVelAdjMethod, drVelAdjDir);     
end

KIstaticRedRelative = computeRatioTwoSided(processZoneIn, KIstaticRed, maxValRatios, returnInfs);
DynamicRadiusRedRelative = computeRatioTwoSided(processZoneIn, DynamicRadiusRed, maxValRatios, returnInfs);
DynamicRadiusSigmaAdjustedRedRelative = computeRatioTwoSided(processZoneIn, DynamicRadiusSigmaAdjustedRed, maxValRatios, returnInfs);
DynamicRadiusVelocitySigmaAdjustedRedRelative = computeRatioTwoSided(processZoneIn, DynamicRadiusVelocitySigmaAdjustedRed, maxValRatios, returnInfs);
DynamicRadiusVlMdfdRedRelative = computeRatioTwoSided(processZoneIn, DynamicRadiusVlMdfdRed, maxValRatios, returnInfs);
DynamicRadiusSigmaAdjustedVlMdfdRedRelative = computeRatioTwoSided(processZoneIn, DynamicRadiusSigmaAdjustedVlMdfdRed, maxValRatios, returnInfs);
DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelative = computeRatioTwoSided(processZoneIn, DynamicRadiusVelocitySigmaAdjustedVlMdfdRed, maxValRatios, returnInfs);









    
figure(300);
plot(inputTimes, log10(KIstaticRed), ...
    inputTimes, log10(DynamicRadiusRed), inputTimes, log10(DynamicRadiusSigmaAdjustedRed), inputTimes, log10(DynamicRadiusVelocitySigmaAdjustedRed), ...
    inputTimes, log10(DynamicRadiusVlMdfdRed), inputTimes, log10(DynamicRadiusSigmaAdjustedVlMdfdRed), inputTimes, log10(DynamicRadiusVelocitySigmaAdjustedVlMdfdRed) );
legend({'rsSTAT', 'rsStrs', 'rsStrsMod', 'rsVelMod', 'rsStrsRUNVel', 'rsStrsModRUNVel', 'rsVelModRUNVel'});
legend('boxoff');
title('LEFM dynamic process zone size expanded');
xlabel('time');
ylabel('rs');
print('-dpdf', [subName, 'Expanded_dynamic_LEFM_processZoneSize.pdf']);
close(300);

figure(300);
plot(inputTimes, log10(KIstaticRedRelative), ...
    inputTimes, log10(DynamicRadiusRedRelative), inputTimes, log10(DynamicRadiusSigmaAdjustedRedRelative), inputTimes, log10(DynamicRadiusVelocitySigmaAdjustedRedRelative), ...
    inputTimes, log10(DynamicRadiusVlMdfdRedRelative), inputTimes, log10(DynamicRadiusSigmaAdjustedVlMdfdRedRelative), inputTimes, log10(DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelative) );
legend({'rsSTAT', 'rsStrs', 'rsStrsMod', 'rsVelMod', 'rsStrsRUNVel', 'rsStrsModRUNVel', 'rsVelModRUNVel'});
legend('boxoff');
title('LEFM dynamic process zone size expanded');
xlabel('time');
ylabel('rs');
print('-dpdf', [subName, 'Relative_Expanded_dynamic_LEFM_processZoneSize.pdf']);
close(300);


plotLEFMHistories(time, Load, SigmaForce, KIstatic, KIdynamic, ldotCrack, lCrack, StaticRadius, DynamicRadius, DynamicRadiusSigmaAdjusted , DynamicRadiusVelocitySigmaAdjusted, subName, flags);
