function [arrestTime, nucleationTime, time, Load, SigmaForce, KIstatic, KIdynamic, ldotCrack, lCrack, ...
    StaticRadius, DynamicRadius, DynamicRadiusSigmaAdjusted, DynamicRadiusVelocitySigmaAdjusted, flags, T] = ...
    getLEFMCrackTipFieldsForSemiInfiniteDomain(rampTime, p0, alpha, finalLoadFactor, plateWidth, E, rho, nu, loadType, loadScaled, ...
    FractureEnergy, finalTime, numPtPerT, numPtPerRamp, normalizelDot2cR, drSigAdjMethod, drVelAdjMethod, drVelAdjDir, ShiftTime, ...
    inputTimes, sigmaC, fvalPZ)



flags = [];

eps = 1e-8;
% rampTime, the time it takes for the load to ramp from zero to p0
% p0 constant load level after ramp time
% alpha is time derivative of applied load after reaching p0
% finalLoadFactor is absolute time value that load goes to zero for
% infinite domain and is relative to T' for other load types (stress,
% velocity)
% loadType, 0 velocity, 1 stress, and 2 infinite plate width
% loadScaled (whether load value is scaled to stress, only applies to
% velocity load type in which the load can be either given as velocity or
% have already been scaled to stress
% fracture energy: edynamic fracture energy

[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);
mu = E / 2.0 / (1.0 + nu);

CI = sqrt(2.0 * (1 - 2 * nu)) / pi / (1 - nu);
KIstaticFactor = CI * sqrt(2.0 * pi * cd);

lfactor = 1.0;
if ((loadType == 0) && (loadScaled == 0))
    lfactor = 1.0 * cd * rho;
end

% tau1 = FractureEnergy * E / (1 - nu * nu) / CI^2 / p0^2 / (2 * pi) / cd
% tau2 = pi / 4 * FractureEnergy * rho * cd / p0^2



T = plateWidth / cd;
Tp = 2 * T;

if (loadType == 2)
    cntrlTp = 0;
    stopTime = finalLoadFactor;
    base = 0;
else
    cntrlTp = 1;
    
    if (finalLoadFactor  < 0)
        stopTime = -finalLoadFactor * Tp; 
    else
        stopTime = finalLoadFactor;
    end
    
    if (loadType == 0)
        base = 1;
    else
        base = -1;
    end
end

if (ShiftTime == 1)
    inputTimes = inputTimes - T;
end
indInpTimes = 1;
szInpTimes = length(inputTimes);


delT = T / numPtPerT;
if (isfinite(T) == 0)
    tau = pi / 8 / (1 + nu) * E / (cs * 2 * p0)^2 * cd * FractureEnergy;
    delT = tau / numPtPerT;
end

if (rampTime > 0)
    delTrmp = rampTime / numPtPerRamp;
    if (delTrmp > delT)
        delTrmp = delT;
        numPtPerRamp = ceil(rampTime / delTrmp);
        delTrmp = rampTime / numPtPerRamp;
    end
else
   delTrmp = delT;
end

lp = 0;
cntr = 1;
t = 0;
dt = delTrmp;

nucleationTime = [];
arrestTime = [];
scaledv = 0;
resolution = 200;


if ((szInpTimes > 1) && (inputTimes(1) == 0))
    flags(indInpTimes) = 1;
    indInpTimes = indInpTimes + 1;
end


while (t <= finalTime)
    load = getLoadvalue(t, rampTime, p0, alpha, stopTime) * lfactor;
    sigmaForce = load;
    if ((loadType == 0) || (loadType == 1))
        numPreSteps = floor(t / Tp + eps);
        tFirstInterval = t - numPreSteps * Tp;
        for J = 1:numPreSteps
            lt = getLoadvalue(t - J * Tp, rampTime, p0, alpha, stopTime) * lfactor;
            sigmaForce = sigmaForce + base^J * lt;
        end
    else
       tFirstInterval = t;
    end
    sigmaForce = 2.0 * sigmaForce;
%
    Load(cntr) = load;
    SigmaForce(cntr) = sigmaForce;
    time(cntr) = t;

    s = time(1);
    delQ = SigmaForce(1);       % stress wave impinging on crack boundary
    delQsqrtTminusSIntegral = delQ * sqrt(t - s);
    
    for n = 2:(cntr - 1)
        delQ = SigmaForce(n) - SigmaForce(n - 1);
        s = time(n);
        delQsqrtTminusSIntegrand = delQ * sqrt(t - s);
        delQsqrtTminusSIntegral = delQsqrtTminusSIntegral + delQsqrtTminusSIntegrand;
    end
    kIstat = delQsqrtTminusSIntegral * KIstaticFactor;
    
    KIstatic(cntr) = kIstat;
    staticDrivingForce = (1 - nu * nu) / E * kIstat * kIstat;
    

    nucSize = length(nucleationTime);
    arrestSize = length(arrestTime);
    if (staticDrivingForce <= FractureEnergy)
        glDot = 1.0;
        lDot = 0.0;
        if (arrestSize < nucSize)
            arrestTime(arrestSize + 1) = t;
            arrestSize = arrestSize + 1;
            if (arrestSize ~= nucSize)
                fprintf(1, 'error in calculating nucleation and arrests - 1 \n');
            end
        end
    else
        if (arrestSize == nucSize)
            nucleationTime(nucSize + 1) = t;
%             if (arrestSize ~= nucSize)
%                 fprintf(1, 'error in calculating nucleation and arrests - 2 \n');
%             end
            nucSize = nucSize + 1;
        end
        glDot = FractureEnergy / staticDrivingForce;
        if ((glDot < 0) || (glDot > 1))
            fprintf(1, 'error %g\n', glDot);
            pause
        end
        lDot = comptuteGvInverse(glDot, cr, scaledv);
        if (lDot > cr)
            fprintf(1, 'error lDot %g\nglDot %g\ncr %g\n', lDot, glDot, cr);
            pause
        end
    end

        
    if (cntr == 1)
        ldotCrack(cntr) = 0;
        lCrack(cntr) = 0;
        lDotAve = 0.0;
    else
        ldotCrack(cntr) = lDot;
        lDotAve = 0.5 * (ldotCrack(cntr - 1) + lDot);
        lCrack(cntr) = lCrack(cntr - 1) + lDotAve * dt;
    end
    
    klDot = comptuteKv(lDot, nu, cd, cs, cr, scaledv);
    AIlDot = comptuteAI(lDot, nu, cd, cs, cr, scaledv);
    
    kIdynamic = kIstat * klDot;
    KIdynamic(cntr) = kIdynamic;
    
    
    % finding static radius of influence
    denom = max(sigmaForce, 2 * p0);
   
    [staticRadius, dynamicRadius, dynamicRadiusSigmaAdjusted, dynamicRadiusVelocitySigmaAdjusted, ...
        cohProcessZoneSize, t_rprss, t_rprsv, t_rsvrss, t_rstat_rss, vMax2sigFrce2Crho, vMax2cD, klDotComp] = ...
        getAllFractureProcessRadii(lDot, cd, cs, cr, E, nu, rho, resolution, drSigAdjMethod, drVelAdjMethod, drVelAdjDir,... 
        FractureEnergy, sigmaForce, scaledv, sigmaC, glDot, AIlDot, klDot, fvalPZ);

    StaticRadius(cntr) = staticRadius;
    DynamicRadius(cntr) = dynamicRadius;
    DynamicRadiusSigmaAdjusted(cntr) = dynamicRadiusSigmaAdjusted;
    DynamicRadiusVelocitySigmaAdjusted(cntr) = dynamicRadiusVelocitySigmaAdjusted;
    
    
    
%     if (scaledv == 0)
%         v2cr = lDot/cr;
%     else
%         v2cr = lDot;
%     end
%     
%     %Here is the part that I use exact formula to compute given radii:
%     radiusFactor = 1 / pi / (1 - nu) * mu * FractureEnergy / sigmaForce^2;
%     radiusFactorVel = 1 / pi * (1 - nu) * mu * FractureEnergy / sigmaForce^2 * (cd / cs)^2;
%     staticRadius = radiusFactor / glDot;
%     dynamicRadius = radiusFactor / AIlDot;
%     dynamicVelRadius = radiusFactorVel * (v2cr * cr / cs)^2 * AIlDot;
%     
%     staticRadius2 = 0.5 / pi * (kIstat / denom)^2;
%     dynamicRadius2 = staticRadius * klDot * klDot;
%     
%     
%     StaticRadius(cntr) = staticRadius;
%     DynamicRadius(cntr) = dynamicRadius;
%     
%     [S11_, Smax_, TauMax_, Steta_, TauTeta_, V1_, V2_, Vs_] = getKScalingValues(lDot/cr , E, nu, rho, resolution);
%     
% %     if (lDot > 0.22 * cr)
% %          vsl = lDot/cr
% %          Vs_
% %         staticRadius
% %         staticRadius2
% %         dynamicRadius
% %         dynamicRadius2
% %         dynamicVelRadius
% %          pause
% %      end
%             
%     DynamicRadiusSigmaAdjusted(cntr) = dynamicRadius;
%     if (drSigAdjMethod > 0)
%         DynamicRadiusSigmaAdjusted(cntr) = S11_(drSigAdjMethod) * dynamicRadius;
%     end
%     if (drVelAdjMethod == 0)
%         DynamicRadiusVelocitySigmaAdjusted(cntr) = dynamicVelRadius;
% %       DynamicRadiusVelocitySigmaAdjusted(cntr) = dynamicRadius * power(cd/cs, 4);
%     elseif (drVelAdjDir == 0)
%         DynamicRadiusVelocitySigmaAdjusted(cntr) = dynamicRadius * V1_(drVelAdjMethod)^2 * power(cd/cs, 4);
%     elseif (drVelAdjDir == 1)
%         DynamicRadiusVelocitySigmaAdjusted(cntr) = dynamicRadius * V2_(drVelAdjMethod)^2 * power(cd/cs, 4);
%     else
%         DynamicRadiusVelocitySigmaAdjusted(cntr) = dynamicRadius * Vs_(drVelAdjMethod)^2 * power(cd/cs, 4);
%     end
    
 %  computing next time (step)
    
    if (tFirstInterval < rampTime)
        dt = delTrmp;
        dtemp = rampTime - tFirstInterval;
        if ((dtemp < delTrmp) && (dtemp > 0.01 * delTrmp))
            dt = dtemp;
        end
    else
        dt = ceil(t / delT) * delT - t;
        if (dt < 0.00001 * delT)
        dt = delT;
        end
     end
    delfTt = finalTime - t;
    if ((delfTt < dt) & (delfTt > 0.00001 * delT))
        dt = delfTt - 0.00000001 * delT;
    end
    
    if (indInpTimes <= szInpTimes)
        deltInputTimes = inputTimes(indInpTimes) - t;
        if (deltInputTimes < 0)
            fprintf(1, 'error start with smaller time step for LEFM integration\n');
            pause;
        end
        if (deltInputTimes < dt)
            dt = deltInputTimes;
            flags(indInpTimes) = cntr + 1;
            indInpTimes = indInpTimes + 1;
        end
    end
            
    t = t + dt;
    cntr = cntr + 1;
end
 
if (normalizelDot2cR == 1)
    ldotCrack = ldotCrack / cr;
end