function [kIdynamic, dynamicRadius, dynamicRadiusSigmaAdjusted, dynamicRadiusVelocitySigmaAdjusted] = getVelocityAdjustedProcessZoneSizes(kIstat, staticRadius, lDot, cd, cs, cr, E, nu, rho, resolution, drSigAdjMethod, drVelAdjMethod, drVelAdjDir)

klDot = comptuteKv(lDot, nu, cd, cs, cr, 0);
kIdynamic = kIstat * klDot;

% finding static radius of influence
dynamicRadius = staticRadius * klDot * klDot;

[S11_, Smax_, TauMax_, Steta_, TauTeta_, V1_, V2_, Vs_] = getKScalingValues(lDot/cr , E, nu, rho, resolution);
    
dynamicRadiusSigmaAdjusted = dynamicRadius;
if (drSigAdjMethod > 0)
    dynamicRadiusSigmaAdjusted = S11_(drSigAdjMethod) * dynamicRadius;
end


if (drVelAdjMethod == 0)
    dynamicRadiusVelocitySigmaAdjusted = dynamicRadius * power(cd/cs, 4);
elseif (drVelAdjDir == 0)
    dynamicRadiusVelocitySigmaAdjusted = dynamicRadius * V1_(drVelAdjMethod)^2 * power(cd/cs, 4);
elseif (drVelAdjDir == 1)
    dynamicRadiusVelocitySigmaAdjusted = dynamicRadius * V2_(drVelAdjMethod)^2 * power(cd/cs, 4);
else
    dynamicRadiusVelocitySigmaAdjusted = dynamicRadius * Vs_(drVelAdjMethod)^2 * power(cd/cs, 4);
end
