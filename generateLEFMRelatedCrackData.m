function [data, names] = generateLEFMRelatedCrackData(dataTimeVcR, velFD, flagDataFileTemp, normalizedEnergyReleasesRate)

global FValuePZSize;
global pz_rpFactor;
fvalPZ = FValuePZSize;


returnInfs = 1;
normalizelDot2cR = 0;


global cnfg;
global ImaxPowerRatioRelativeProcessZoneSize;
global I_LEFMAngle_resolution;
global I_LEFMnumPtPerT;
global I_LEFMnumPtPerRamp;
global I_LEFM_rSigMethod;
global I_LEFM_rVelMethod;
global I_LEFM_rVelDir;


global startTimeIndex;
global endTimeIndex;
global timeIncrementInex;
global EIndex;
global rhoIndex;
global nuIndex;
global plainStrainIndex;
global CdIndex;
global CsIndex;
global CrIndex;
global sigma0Index;
global rampTimeIndex;
global plateWidthIndex;
global loadTypeIndex;
global loadIncrementFactorInex;
global loadFinalTimeIndex;

global plateTimeScale;

global fracEneryIndex;			   	
global cdRhoInvIndex;
global csRhoInvIndex;
global cdRhoIndex;
global csRhoIndex;
global tauLEFMIndex;    
global lengthLEFMIndex;
global sigmaNcohIndex;

global startCohFaceIndex;
global endCohFaceIndex;
global lengthCohFaceIndex;

ctTimes = dataTimeVcR(:, 1);
ctVel = dataTimeVcR(:, 2);
processZoneSize = dataTimeVcR(:, 3);

maxPowerRatio = cnfg{ImaxPowerRatioRelativeProcessZoneSize};

%modifying with normalized energy release rate: G/phic
[m, n] = size(normalizedEnergyReleasesRate);
for i = 1:m
    for j = 1:n
        a = normalizedEnergyReleasesRate(i, j);
        if ((~isfinite(a)) ||(a < 0))
            normalizedEnergyReleasesRate(i, j) = NaN;
        end
    end
end
% taking the "total normalized energy release rate"
nG = normalizedEnergyReleasesRate(:, n);
nGs = sqrt(nG);
nGi = ones(m, 1) * NaN;
minRatio = power(10.0, -maxPowerRatio);
for i = 1:m
    if (nG(i) > minRatio)
        nGi(i) = 1.0 / nG(i);
    end
end
%_nG stands for all the fields that are "corrected" using nG






resolution = cnfg{I_LEFMAngle_resolution};
numPtPerT = cnfg{I_LEFMnumPtPerT};
numPtPerRamp = cnfg{I_LEFMnumPtPerRamp};
drSigAdjMethod = cnfg{I_LEFM_rSigMethod} ;
drVelAdjMethod = cnfg{I_LEFM_rVelMethod};
drVelAdjDir = cnfg{I_LEFM_rVelDir};



rampTime = flagDataFileTemp(rampTimeIndex);
p0 = flagDataFileTemp(sigma0Index);
plateWidth = flagDataFileTemp(plateWidthIndex);
E = flagDataFileTemp(EIndex);
rho = flagDataFileTemp(rhoIndex);
nu = flagDataFileTemp(nuIndex);
loadType = flagDataFileTemp(loadTypeIndex);
loadScaled = 1;
FractureEnergy = flagDataFileTemp(fracEneryIndex);
sigmaC = flagDataFileTemp(sigmaNcohIndex);
startCrackPos = flagDataFileTemp(startCohFaceIndex);
alpha = flagDataFileTemp(loadIncrementFactorInex);
finalLoadFactor = flagDataFileTemp(loadFinalTimeIndex); % inf;

if (rampTime < 0)
    rampTime = 0.0;
    alpha = p0;
    p0 = 0;
end
    
% global endCohFaceIndex;
% global lengthCohFaceIndex;

% cd = flagDataFileTemp(CdIndex);
% cs = flagDataFileTemp(CsIndex);
% cr = flagDataFileTemp(CrIndex);
% tstart = flagDataFileTemp(startTimeIndex);
% deltaT =flagDataFileTemp(timeIncrementInex);

plainStrainType = flagDataFileTemp(plainStrainIndex);
if (plainStrainType ~= -3)
    fprintf(1, 'generateLEFMRelatedCrackData requires plain strain\n');
    pause;
end

[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);
T = plateWidth / cd;

finalTime = (flagDataFileTemp(endTimeIndex) - T) * 1.20;



maxValRatios = power(10.0, maxPowerRatio);
ShiftTime = 1;



[arrestTime, nucleationTime, time, Load, SigmaForce, KIstatic, KIdynamic, ldotCrack, lCrack, StaticRadius, DynamicRadius,...
    DynamicRadiusSigmaAdjusted , DynamicRadiusVelocitySigmaAdjusted, flags, T] = ...
getLEFMCrackTipFieldsForSemiInfiniteDomain(rampTime, p0, alpha, finalLoadFactor, plateWidth, E, rho, nu, loadType, loadScaled, ...
FractureEnergy, finalTime, numPtPerT, numPtPerRamp, normalizelDot2cR, drSigAdjMethod, drVelAdjMethod, drVelAdjDir, ShiftTime, ...
ctTimes, sigmaC, fvalPZ);

lCrack = lCrack + startCrackPos;

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




scaledvMdfd = 0;
glDotMdfd = -1;
AIlDotMdfd = -1;
klDotMdfd = -1;

for i = 1:numFlag
    sigmaForceVal = SigmaForceRed(i);


    [staticRadiusMdfd, dynamicRadiusMdfd, dynamicRadiusSigmaAdjustedMdfd, dynamicRadiusVelocitySigmaAdjustedMdfd, ...
        t_cohProcessZoneSize, t_rprss, t_rprsv, t_rsvrss, t_rstat_rss, vMax2sigFrce2Crho, vMax2cD, klDotComp, vMax2sigFrce2Crho_nG, vMax2cD_nG] = ...
        getAllFractureProcessRadii(ctVel(i), cd, cs, cr, E, nu, rho, resolution, drSigAdjMethod, drVelAdjMethod, drVelAdjDir,... 
        FractureEnergy, sigmaForceVal, scaledvMdfd, sigmaC, glDotMdfd, AIlDotMdfd, klDotMdfd, fvalPZ, nGs(i));
    
    DynamicRadiusVlMdfdRed(i) = dynamicRadiusMdfd;
    DynamicRadiusSigmaAdjustedVlMdfdRed(i) = dynamicRadiusSigmaAdjustedMdfd;
    DynamicRadiusVelocitySigmaAdjustedVlMdfdRed(i) = dynamicRadiusVelocitySigmaAdjustedMdfd;
    
    KIdynamicVlMdfdRed(i) = KIstaticRed(i) * klDotComp;

    t_rprssRed(i) = t_rprss;
    t_rprsvRed(i) = t_rprsv;
    t_rsvrssRed(i) = t_rsvrss;
    t_rstat_rssRed(i) = t_rstat_rss;
    t_cohProcessZoneSizeRed(i) = t_cohProcessZoneSize;
    
    vMax2sigFrce2CrhoRed(i) = vMax2sigFrce2Crho;
    vMax2cDRed(i) = vMax2cD;

    vMax2sigFrce2CrhoRed_nG(i) = vMax2sigFrce2Crho_nG;
    vMax2cDRed_nG(i) = vMax2cD_nG;

    
% Finite Difference Velocity
    [staticRadiusMdfdFD, dynamicRadiusMdfdFD, dynamicRadiusSigmaAdjustedMdfdFD, dynamicRadiusVelocitySigmaAdjustedMdfdFD, ...
        t_cohProcessZoneSizeFD, t_rprssFD, t_rprsvFD, t_rsvrssFD, t_rstat_rssFD, vMax2sigFrce2CrhoFD, vMax2cDFD, klDotCompFD, ...
        vMax2sigFrce2CrhoFD_nG, vMax2cDFD_nG] = ...
        getAllFractureProcessRadii(velFD(i), cd, cs, cr, E, nu, rho, resolution, drSigAdjMethod, drVelAdjMethod, drVelAdjDir,... 
        FractureEnergy, sigmaForceVal, scaledvMdfd, sigmaC, glDotMdfd, AIlDotMdfd, klDotMdfd, fvalPZ, nGs(i));
    
    DynamicRadiusVlMdfdRedFD(i) = dynamicRadiusMdfdFD;
    DynamicRadiusSigmaAdjustedVlMdfdRedFD(i) = dynamicRadiusSigmaAdjustedMdfdFD;
    DynamicRadiusVelocitySigmaAdjustedVlMdfdRedFD(i) = dynamicRadiusVelocitySigmaAdjustedMdfdFD;
    
    KIdynamicVlMdfdRedFD(i) = KIstaticRed(i) * klDotCompFD;

    t_rprssRedFD(i) = t_rprssFD;
    t_rprsvRedFD(i) = t_rprsvFD;
    t_rsvrssRedFD(i) = t_rsvrssFD;
    t_rstat_rssRedFD(i) = t_rstat_rssFD;
    t_cohProcessZoneSizeRedFD(i) = t_cohProcessZoneSizeFD;
    
    vMax2sigFrce2CrhoRedFD(i) = vMax2sigFrce2CrhoFD;
    vMax2cDRedFD(i) = vMax2cDFD;

    vMax2sigFrce2CrhoRedFD_nG(i) = vMax2sigFrce2CrhoFD_nG;
    vMax2cDRedFD_nG(i) = vMax2cDFD_nG;
    
    
    
%     [KIdynamicVlMdfdRed(i), DynamicRadiusVlMdfdRed(i), DynamicRadiusSigmaAdjustedVlMdfdRed(i), DynamicRadiusVelocitySigmaAdjustedVlMdfdRed(i)] = ...
%         getVelocityAdjustedProcessZoneSizes(KIstaticRed(i), StaticRadiusRed(i), ctVel(i), cd, cs, cr, E, nu, rho, resolution, ...
%     drSigAdjMethod, drVelAdjMethod, drVelAdjDir);     
end

ldotCrackRed = ldotCrackRed';
lCrackRed = lCrackRed';
KIstaticRed = KIstaticRed';
KIdynamicRed = KIdynamicRed';
KIdynamicVlMdfdRed = KIdynamicVlMdfdRed';
LoadRed = LoadRed';
SigmaForceRed = SigmaForceRed';

StaticRadiusRed = StaticRadiusRed';
DynamicRadiusRed = DynamicRadiusRed';
DynamicRadiusSigmaAdjustedRed = DynamicRadiusSigmaAdjustedRed';
DynamicRadiusVelocitySigmaAdjustedRed = DynamicRadiusVelocitySigmaAdjustedRed';
DynamicRadiusVlMdfdRed = DynamicRadiusVlMdfdRed';
DynamicRadiusSigmaAdjustedVlMdfdRed = DynamicRadiusSigmaAdjustedVlMdfdRed';
DynamicRadiusVelocitySigmaAdjustedVlMdfdRed = DynamicRadiusVelocitySigmaAdjustedVlMdfdRed';



DynamicRadiusVlMdfdRedFD = DynamicRadiusVlMdfdRedFD';
DynamicRadiusSigmaAdjustedVlMdfdRedFD = DynamicRadiusSigmaAdjustedVlMdfdRedFD';
DynamicRadiusVelocitySigmaAdjustedVlMdfdRedFD = DynamicRadiusVelocitySigmaAdjustedVlMdfdRedFD';


t_rprssRed = t_rprssRed';
t_rprsvRed = t_rprsvRed';
t_rsvrssRed = t_rsvrssRed';
t_rstat_rssRed = t_rstat_rssRed';
t_cohProcessZoneSizeRed = t_cohProcessZoneSizeRed';


t_cohProcessZoneSizeRedFD = t_cohProcessZoneSizeRedFD';
t_rprssRedFD = t_rprssRedFD';
t_rprsvRedFD = t_rprsvRedFD';
t_rsvrssRedFD = t_rsvrssRedFD';
t_rstat_rssRedFD = t_rstat_rssRedFD';




vMax2sigFrce2CrhoRed = vMax2sigFrce2CrhoRed';
vMax2cDRed = vMax2cDRed';

vMax2sigFrce2CrhoRed_nG = vMax2sigFrce2CrhoRed_nG';
vMax2cDRed_nG = vMax2cDRed_nG';


vMax2sigFrce2CrhoRedFD = vMax2sigFrce2CrhoRedFD';
vMax2cDRedFD = vMax2cDRedFD';

vMax2sigFrce2CrhoRedFD_nG = vMax2sigFrce2CrhoRedFD_nG';
vMax2cDRedFD_nG = vMax2cDRedFD_nG';

%processZoneSize = processZoneSize';
[r_ , ind] = find(processZoneSize > 1e7);
processZoneSize(ind) = inf;
StaticRadiusRedRelative  = computeRatioTwoSided(processZoneSize, StaticRadiusRed, maxValRatios, returnInfs);
DynamicRadiusRedRelative = computeRatioTwoSided(processZoneSize, DynamicRadiusRed, maxValRatios, returnInfs);
DynamicRadiusSigmaAdjustedRedRelative = computeRatioTwoSided(processZoneSize, DynamicRadiusSigmaAdjustedRed, maxValRatios, returnInfs);
DynamicRadiusVelocitySigmaAdjustedRedRelative = computeRatioTwoSided(processZoneSize, DynamicRadiusVelocitySigmaAdjustedRed, maxValRatios, returnInfs);
DynamicRadiusVlMdfdRedRelative = computeRatioTwoSided(processZoneSize, DynamicRadiusVlMdfdRed, maxValRatios, returnInfs);
DynamicRadiusSigmaAdjustedVlMdfdRedRelative = computeRatioTwoSided(processZoneSize, DynamicRadiusSigmaAdjustedVlMdfdRed, maxValRatios, returnInfs);
DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelative = computeRatioTwoSided(processZoneSize, DynamicRadiusVelocitySigmaAdjustedVlMdfdRed, maxValRatios, returnInfs);

StaticRadiusRedRelative  = StaticRadiusRedRelative';
DynamicRadiusRedRelative = DynamicRadiusRedRelative';
DynamicRadiusSigmaAdjustedRedRelative = DynamicRadiusSigmaAdjustedRedRelative';
DynamicRadiusVelocitySigmaAdjustedRedRelative = DynamicRadiusVelocitySigmaAdjustedRedRelative';
DynamicRadiusVlMdfdRedRelative = DynamicRadiusVlMdfdRedRelative';
DynamicRadiusSigmaAdjustedVlMdfdRedRelative = DynamicRadiusSigmaAdjustedVlMdfdRedRelative';
DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelative = DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelative';

DynamicRadiusVlMdfdRedRelativeFD = computeRatioTwoSided(processZoneSize, DynamicRadiusVlMdfdRedFD, maxValRatios, returnInfs);
DynamicRadiusSigmaAdjustedVlMdfdRedRelativeFD = computeRatioTwoSided(processZoneSize, DynamicRadiusSigmaAdjustedVlMdfdRedFD, maxValRatios, returnInfs);
DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelativeFD = computeRatioTwoSided(processZoneSize, DynamicRadiusVelocitySigmaAdjustedVlMdfdRedFD, maxValRatios, returnInfs);

DynamicRadiusVlMdfdRedRelativeFD = DynamicRadiusVlMdfdRedRelativeFD';
DynamicRadiusSigmaAdjustedVlMdfdRedRelativeFD = DynamicRadiusSigmaAdjustedVlMdfdRedRelativeFD';
DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelativeFD = DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelativeFD';



%vmaxVForce_rpRunrsvModified = (1.0 +
%power(DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelative, -0.5) /
%sqrt(fvalPZ));

vmaxVForce_rpRunrsvModified = power(DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelativeFD, -0.5) / sqrt(fvalPZ * pz_rpFactor);
%vmaxVForce_rpRunrsvModified = power(DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelativeFD, 1);
DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelativeFD_nG = nGi .* DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelativeFD;
vmaxVForce_rpRunrsvModified_nG = power(DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelativeFD_nG, -0.5) / sqrt(fvalPZ * pz_rpFactor);


data{1} = [ldotCrackRed     lCrackRed   KIstaticRed     KIdynamicRed        KIdynamicVlMdfdRed      LoadRed     SigmaForceRed vmaxVForce_rpRunrsvModified vmaxVForce_rpRunrsvModified_nG];
names{1} = {'ldotCrackRed', 'lCrackRed', 'KIstaticRed', 'KIdynamicRed', 'KIdynamicVlMdfdRed', 'LoadRed', 'SigmaForceRed', 'vMaxFEMVForce_rpFEMrsvFEMVel', 'vMaxFEMVForce_rpFEMrsvFEMVel_nG'};

data{2} = [StaticRadiusRed     DynamicRadiusRed   DynamicRadiusSigmaAdjustedRed   DynamicRadiusVelocitySigmaAdjustedRed    ...
    DynamicRadiusVlMdfdRed      DynamicRadiusSigmaAdjustedVlMdfdRed     DynamicRadiusVelocitySigmaAdjustedVlMdfdRed ...
    DynamicRadiusVlMdfdRedFD      DynamicRadiusSigmaAdjustedVlMdfdRedFD     DynamicRadiusVelocitySigmaAdjustedVlMdfdRedFD];
names{2} = {'StaticRRcd', 'DRRcd', 'DRSigmaAdjustedRcd', 'DRVelocitySigmaAdjustedRcd', ...
'DRVlMdfdRcd', 'DRSigmaAdjustedVlMdfdRcd', 'DRVelocitySigmaAdjustedVlMdfdRcd',...
'DRVlMdfdRcdFD', 'DRSigmaAdjustedVlMdfdRcdFD', 'DRVelocitySigmaAdjustedVlMdfdRcdFD'};


data{3} = [StaticRadiusRedRelative     DynamicRadiusRedRelative   DynamicRadiusSigmaAdjustedRedRelative   DynamicRadiusVelocitySigmaAdjustedRedRelative    ...
    DynamicRadiusVlMdfdRedRelative      DynamicRadiusSigmaAdjustedVlMdfdRedRelative     DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelative, ...
    DynamicRadiusVlMdfdRedRelativeFD      DynamicRadiusSigmaAdjustedVlMdfdRedRelativeFD     DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelativeFD];

names{3} = {'StaticRRcdRlv', 'DRRcdRlv', 'DRSigmaAdjustedRcdRlv', 'DRVelocitySigmaAdjustedRcdRlv', ...
'DRVlMdfdRcdRlv', 'DRSigmaAdjustedVlMdfdRcdRlv', 'DRVelocitySigmaAdjustedVlMdfdRcdRlv', ...
'DRVlMdfdRcdRlvFD', 'DRSigmaAdjustedVlMdfdRcdRlvFD', 'DRVelocitySigmaAdjustedVlMdfdRcdRlvFD'};


% theoretical values computed 08/11/09
data{4} = [t_rprssRed     t_rprsvRed   vMax2sigFrce2CrhoRed     vMax2cDRed ...
           t_rsvrssRed   t_rstat_rssRed    t_cohProcessZoneSizeRed];
names{4} = {'Theory_rprss', 'Theory_rprsv', 'vMax2sigFrce2Crho', 'vMax2cD',...
 'Theory_rsvrss', 'Theory_rstat_rss', 'Theory_pzSize'};


data{5} = [t_rprssRedFD     t_rprsvRedFD   vMax2sigFrce2CrhoRedFD     vMax2cDRedFD ...
           t_rsvrssRedFD   t_rstat_rssRedFD    t_cohProcessZoneSizeRedFD];
names{5} = {'Theory_rprssFD', 'Theory_rprsvFD', 'vMax2sigFrce2CrhoFD', 'vMax2cDFD',...
 'Theory_rsvrssFD', 'Theory_rstat_rssFD', 'Theory_pzSizeFD'};














StaticRadiusRed = nG .* StaticRadiusRed;
DynamicRadiusRed = nG .* DynamicRadiusRed;
DynamicRadiusSigmaAdjustedRed = nG .* DynamicRadiusSigmaAdjustedRed;
DynamicRadiusVelocitySigmaAdjustedRed = nG .* DynamicRadiusVelocitySigmaAdjustedRed;
DynamicRadiusVlMdfdRed = nG .* DynamicRadiusVlMdfdRed;
DynamicRadiusSigmaAdjustedVlMdfdRed = nG .* DynamicRadiusSigmaAdjustedVlMdfdRed;
DynamicRadiusVelocitySigmaAdjustedVlMdfdRed = nG .* DynamicRadiusVelocitySigmaAdjustedVlMdfdRed;
DynamicRadiusVlMdfdRedFD = nG .* DynamicRadiusVlMdfdRedFD;
DynamicRadiusSigmaAdjustedVlMdfdRedFD = nG .* DynamicRadiusSigmaAdjustedVlMdfdRedFD;
DynamicRadiusVelocitySigmaAdjustedVlMdfdRedFD = nG .* DynamicRadiusVelocitySigmaAdjustedVlMdfdRedFD;

data{6} = [StaticRadiusRed     DynamicRadiusRed   DynamicRadiusSigmaAdjustedRed   DynamicRadiusVelocitySigmaAdjustedRed    ...
    DynamicRadiusVlMdfdRed      DynamicRadiusSigmaAdjustedVlMdfdRed     DynamicRadiusVelocitySigmaAdjustedVlMdfdRed ...
    DynamicRadiusVlMdfdRedFD      DynamicRadiusSigmaAdjustedVlMdfdRedFD     DynamicRadiusVelocitySigmaAdjustedVlMdfdRedFD];
names{6} = {'StaticRRcd_nG', 'DRRcd_nG', 'DRSigmaAdjustedRcd_nG', 'DRVelocitySigmaAdjustedRcd_nG', ...
'DRVlMdfdRcd_nG', 'DRSigmaAdjustedVlMdfdRcd_nG', 'DRVelocitySigmaAdjustedVlMdfdRcd_nG',...
'DRVlMdfdRcdFD_nG', 'DRSigmaAdjustedVlMdfdRcdFD_nG', 'DRVelocitySigmaAdjustedVlMdfdRcdFD_nG'};


StaticRadiusRedRelative = nGi .* StaticRadiusRedRelative;
DynamicRadiusRedRelative = nGi .* DynamicRadiusRedRelative;
DynamicRadiusSigmaAdjustedRedRelative = nGi .* DynamicRadiusSigmaAdjustedRedRelative;
DynamicRadiusVelocitySigmaAdjustedRedRelative = nGi .* DynamicRadiusVelocitySigmaAdjustedRedRelative;
DynamicRadiusVlMdfdRedRelative = nGi .* DynamicRadiusVlMdfdRedRelative;
DynamicRadiusSigmaAdjustedVlMdfdRedRelative = nGi .* DynamicRadiusSigmaAdjustedVlMdfdRedRelative;
DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelative = nGi .* DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelative;
DynamicRadiusVlMdfdRedRelativeFD = nGi .* DynamicRadiusVlMdfdRedRelativeFD;
DynamicRadiusSigmaAdjustedVlMdfdRedRelativeFD = nGi .* DynamicRadiusSigmaAdjustedVlMdfdRedRelativeFD;
DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelativeFD = nGi .* DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelativeFD;

               


data{7} = [StaticRadiusRedRelative     DynamicRadiusRedRelative   DynamicRadiusSigmaAdjustedRedRelative   DynamicRadiusVelocitySigmaAdjustedRedRelative    ...
    DynamicRadiusVlMdfdRedRelative      DynamicRadiusSigmaAdjustedVlMdfdRedRelative     DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelative, ...
    DynamicRadiusVlMdfdRedRelativeFD      DynamicRadiusSigmaAdjustedVlMdfdRedRelativeFD     DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelativeFD];

names{7} = {'StaticRRcdRlv_nG', 'DRRcdRlv_nG', 'DRSigmaAdjustedRcdRlv_nG', 'DRVelocitySigmaAdjustedRcdRlv_nG', ...
'DRVlMdfdRcdRlv_nG', 'DRSigmaAdjustedVlMdfdRcdRlv_nG', 'DRVelocitySigmaAdjustedVlMdfdRcdRlv_nG', ...
'DRVlMdfdRcdRlvFD_nG', 'DRSigmaAdjustedVlMdfdRcdRlvFD_nG', 'DRVelocitySigmaAdjustedVlMdfdRcdRlvFD_nG'};


% theoretical values computed 08/11/09
t_rprssRed = nGi .* t_rprssRed;
t_rprsvRed = nGi .* t_rprsvRed;


data{8} = [t_rprssRed     t_rprsvRed   vMax2sigFrce2CrhoRed_nG     vMax2cDRed_nG];% ...
%            t_rsvrssRed   t_rstat_rssRed    t_cohProcessZoneSizeRed];
names{8} = {'Theory_rprss_nG', 'Theory_rprsv_nG', 'vMax2sigFrce2Crho_nG', 'vMax2cD_nG'};% ,...
% 'Theory_rsvrss_nG', 'Theory_rstat_rss_nG', 'Theory_pzSize_nG'};


t_rprssRedFD = nGi .* t_rprssRedFD;
t_rprsvRedFD = nGi .* t_rprsvRedFD;


data{9} = [t_rprssRedFD     t_rprsvRedFD   vMax2sigFrce2CrhoRedFD_nG     vMax2cDRedFD_nG];% ...
%            t_rsvrssRedFD   t_rstat_rssRedFD    t_cohProcessZoneSizeRedFD];
names{9} = {'Theory_rprssFD_nG', 'Theory_rprsvFD_nG', 'vMax2sigFrce2CrhoFD_nG', 'vMax2cDFD_nG'};% ,...
% 'Theory_rsvrssFD_nG', 'Theory_rstat_rssFD_nG', 'Theory_pzSizeFD_nG'};

%     
% subName = '';
% figure(300);
% plot(ctTimes, log10(KIstaticRed), ...
%     ctTimes, log10(DynamicRadiusRed), ctTimes, log10(DynamicRadiusSigmaAdjustedRed), ctTimes, log10(DynamicRadiusVelocitySigmaAdjustedRed), ...
%     ctTimes, log10(DynamicRadiusVlMdfdRed), ctTimes, log10(DynamicRadiusSigmaAdjustedVlMdfdRed), ctTimes, log10(DynamicRadiusVelocitySigmaAdjustedVlMdfdRed) );
% legend({'rsSTAT', 'rsStrs', 'rsStrsMod', 'rsVelMod', 'rsStrsRUNVel', 'rsStrsModRUNVel', 'rsVelModRUNVel'});
% legend('boxoff');
% title('LEFM dynamic process zone size expanded');
% xlabel('time');
% ylabel('rs');
% print('-dpdf', [subName, 'Expanded_dynamic_LEFM_processZoneSize.pdf']);
% close(300);
% 
% figure(300);
% plot(ctTimes, log10(StaticRadiusRedRelative), ...
%     ctTimes, log10(DynamicRadiusRedRelative), ctTimes, log10(DynamicRadiusSigmaAdjustedRedRelative), ctTimes, log10(DynamicRadiusVelocitySigmaAdjustedRedRelative), ...
%     ctTimes, log10(DynamicRadiusVlMdfdRedRelative), ctTimes, log10(DynamicRadiusSigmaAdjustedVlMdfdRedRelative), ctTimes, log10(DynamicRadiusVelocitySigmaAdjustedVlMdfdRedRelative) );
% legend({'rsSTAT', 'rsStrs', 'rsStrsMod', 'rsVelMod', 'rsStrsRUNVel', 'rsStrsModRUNVel', 'rsVelModRUNVel'});
% legend('boxoff');
% title('LEFM dynamic process zone size expanded');
% xlabel('time');
% ylabel('rs');
% print('-dpdf', [subName, 'Relative_Expanded_dynamic_LEFM_processZoneSize.pdf']);
% close(300);
% 
% 
% plotLEFMHistories(time, Load, SigmaForce, KIstatic, KIdynamic, ldotCrack, lCrack, StaticRadius, DynamicRadius, DynamicRadiusSigmaAdjusted , DynamicRadiusVelocitySigmaAdjusted, subName, flags);
