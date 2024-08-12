function  [pzStaticFactor, FValuePZSz, singularDistFctrs] = ...
    computeStaticProcessZoneSizeFactor(tslModel, kappaOpt, kappaMyEstOpt, crpv_rps, crelDist)
%function  [pzStaticFactor, FValuePZSz] = computeStaticProcessZoneSizeFactor(potential_Rice, rpFactor, tslModel)



%tslModel 0 for XuN,
%         1     Ortiz
%         2     Dugdale
%         others not implemented

FValuePZSzPotential = 9.0 / 16.0;
if (kappaOpt == 0)
    pzStaticFactor = 1;
    if (kappaMyEstOpt ~= 0)
        singularDistFctrs = 1;
    else
        singularDistFctrs = crpv_rps * crelDist;
    end        
    FValuePZSz = FValuePZSzPotential;
    return;
elseif (kappaOpt == 1)
    if (kappaMyEstOpt ~= 0)
        singularDistFctrs = 1;
    else
        singularDistFctrs = crpv_rps * crelDist;
    end        
    FValuePZSz = 1/4.0;
    pzStaticFactor = FValuePZSz / FValuePZSzPotential;
    return;
end

if (kappaOpt ~= 2)
    printf(1, 'invalid %d\n', kappaOpt);
    pause;
end


if (kappaMyEstOpt == 1)
    crelDist = 0.5;
    pzStaticFactor = 1;
    FValuePZSz = FValuePZSzPotential;
    if (tslModel == 0) % XuN
        crpv_rps = 0.776305;
    elseif (tslModel == 1) % Ortiz
        crpv_rps = 1.134644341;
    end
    singularDistFctrs = crpv_rps * crelDist;
%    return;
elseif (kappaMyEstOpt == 2)
    crelDist = 1.0;
    pzStaticFactor = 1;
    FValuePZSz = FValuePZSzPotential;
    if (tslModel == 0) % XuN
        crpv_rps = 0.466328;
    elseif (tslModel == 1) % Ortiz
        crpv_rps = 0.617790448;
    end
    singularDistFctrs = crpv_rps * crelDist;
%    return;
end

beta = crpv_rps;
gamma = crelDist;
singularDistFctrs = beta * gamma;

%deltaEnd and Start are end and start points on TSL curve corresponding to
%complete separation and start of stress decline on the curve (normalized
%by deltaC)
% alpha = FractureEnergyTSL/deltaC/sigmaC
if (tslModel == 0) % XuN
    deltaEnd = 7.6383520679940; % sigma = 0.01 sigmaC
    deltaStart = 1.0;
    alpha = exp(1.0);
elseif (tslModel == 1) % Ortiz
    deltaEnd = 1.0;
    deltaStart = 0.0;
    alpha = 0.5;
elseif (tslModel == 2) % Dugdale
    deltaEnd = 1.0;
    deltaStart = 0.0;
    alpha = 1.0;
end    

deltaES = deltaEnd - deltaStart;


%FValuePZSz = 1.0 / 4.0 * (deltaES / alpha)^2 * rpFactor;

factor = beta * (beta + 2.0 * sqrt(beta) * (1 - sqrt(beta)))^2;
FValuePZSz = 1.0 / 4.0 * (deltaES / alpha)^2 * gamma * factor;


pzStaticFactor = FValuePZSz / FValuePZSzPotential;