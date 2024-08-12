function [staticRadius, dynamicRadius, dynamicRadiusSigmaAdjusted, dynamicRadiusVelocitySigmaAdjusted, ...
    cohProcessZoneSize, t_rprss, t_rprsv, t_rsvrss, t_rstat_rss, ...
    vMax2sigFrce2Crho, vMax2cD, klDotComp, vMax2sigFrce2Crho_nG, vMax2cD_nG] = ...
    getAllFractureProcessRadii(lDot, cd, cs, cr, E, nu, rho, resolution, drSigAdjMethod, drVelAdjMethod, drVelAdjDir,... 
    FractureEnergy, sigmaForce, scaledv, sigmaC, glDot, AIlDot, klDot, fvalPZ, nGs)

if ((nargout < 14) || (nargin < 20))
% do not do nG modified computation
    do_nG = 0;
else
    do_nG = 1;
end

global FValuePZSize;
global pz_rpFactor;


if nargin < 16
    glDot = -1;
end

if nargin < 17
    AIlDot = -1;
end

if nargin < 18
    klDot = -1;
end

if nargin < 19
    fvalPZ = FValuePZSize;
end

if (glDot < 0)
    gv = comptuteGv(lDot, cr, scaledv);
end

if (AIlDot < 0)
    AIlDot = comptuteAI(lDot, nu, cd, cs, cr, scaledv);
end

if (klDot < 0)
    klDot = comptuteKv(lDot, nu, cd, cs, cr, scaledv);
end
klDotComp = klDot;

mu = E / (1 + nu) / 2.0;
if (scaledv == 0)
    v2cr = lDot/cr;
    vAbs = lDot;
else
    v2cr = lDot;
    vAbs = lDot * cr;
end

% r_stat = staticRadius
% r_ss = dynamicRadius
% r_sv  = dynamicRadiusVelocitySigmaAdjusted
% r_p = cohProcessZoneSize
% t stands for theoretical

radiusFactor = 1 / pi / (1 - nu) * mu * FractureEnergy / sigmaForce^2;
radiusFactorVel = 1 / pi * (1 - nu) * mu * FractureEnergy / sigmaForce^2 * (cd / cs)^2;
staticRadius = radiusFactor / glDot;
dynamicRadius = radiusFactor / AIlDot;
dynamicVelRadius = radiusFactorVel * (vAbs / cs)^2 * AIlDot;
cohProcessZoneSize = pi * fvalPZ / (1 - nu) * mu * FractureEnergy / sigmaC^2 / AIlDot;

t_rprss = pi^2 * fvalPZ * (sigmaForce / sigmaC)^2;
vcsAI = (vAbs / cs * AIlDot);
t_rprsv = pi^2 * fvalPZ / (1 - nu)^2 * (cs / cd)^2 * (sigmaForce / sigmaC)^2 / vcsAI^2;
t_rsvrss = (vcsAI * cd * (1 - nu) / cs)^2;
t_rstat_rss = 1.0 / klDot^2;



dynamicRadiusSigmaAdjusted = dynamicRadius;
dynamicRadiusVelocitySigmaAdjusted = dynamicVelRadius;


facrpRelated = 1 / sqrt(pz_rpFactor);
%vMax2sigFrce2Crho = vmax / (sigmaForce / (cd * rho))
vMax2sigFrce2Crho = 1 + (1 - nu) / pi / sqrt(fvalPZ) / sqrt(pz_rpFactor) * (cd / cs) * (sigmaC / sigmaForce) * vcsAI;% * facrpRelated;
vMax2cD = (1 + nu) * (1 - 2.0 * nu) * (sigmaForce / E / (1 - nu) + 1 / pi / sqrt(fvalPZ) / sqrt(pz_rpFactor) * (cd / cs) * (sigmaC / E) ...
    * vcsAI * facrpRelated); 




if (do_nG == 1)
    vMax2sigFrce2Crho_nG = 1 + nGs * (1 - nu) / pi / sqrt(fvalPZ) / sqrt(pz_rpFactor) * (cd / cs) * (sigmaC / sigmaForce) * vcsAI;% * facrpRelated;
    vMax2cD_nG = (1 + nu) * (1 - 2.0 * nu) * (sigmaForce / E / (1 - nu) + nGs / pi / sqrt(fvalPZ) / sqrt(pz_rpFactor) * (cd / cs) * (sigmaC / E) ...
        * vcsAI * facrpRelated); 
end

if ((drSigAdjMethod == 0) && (drVelAdjMethod == 0))
    return;
end

[S11_, Smax_, TauMax_, Steta_, TauTeta_, V1_, V2_, Vs_] = getKScalingValues(v2cr, E, nu, rho, resolution);
    
if (drSigAdjMethod > 0)
    dynamicRadiusSigmaAdjusted = S11_(drSigAdjMethod) * dynamicRadius;
end

if (drVelAdjMethod == 0)
    return;
end


if (drVelAdjDir == 0)
    dynamicRadiusVelocitySigmaAdjusted = dynamicRadius * V1_(drVelAdjMethod)^2 * power(cd/cs, 4);
elseif (drVelAdjDir == 1)
    dynamicRadiusVelocitySigmaAdjusted = dynamicRadius * V2_(drVelAdjMethod)^2 * power(cd/cs, 4);
else
    dynamicRadiusVelocitySigmaAdjusted = dynamicRadius * Vs_(drVelAdjMethod)^2 * power(cd/cs, 4);
end
