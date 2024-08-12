function [xAddCRVS, yAddCRVS] = plotAddCRVSData(doPlot, plotAddModifiedOptNumber, lineStyle, lineColor, lineWidth, markerStyle, ...
                                    flagsAddCRVS, xlimMinChosen,  xlimMaxChosen, xlogOption, ylogOption)



global sigmaNcohIndex;
global deltaNcohIndex;
global sigmaTcohIndex;
global deltaTcohIndex;
global EIndex;
global rhoIndex;
global nuIndex;
%global plainStrainIndex;
global CdIndex;
global CsIndex;
global CrIndex;
global v0Index;
global sigma0Index;
global rampTimeIndex;
global plateWidthIndex;
global loadTypeIndex;
global loadIncrementFactorInex;
global loadFinalTimeIndex;
global plateTimeScale;
global AddCRVSopt_rprss_velocityUnbounded;
global AddCRVSopt_rprss_velocityBounded;
global rampTimeIndex;
global fracEneryIndex

sigmaCN = flagsAddCRVS(sigmaNcohIndex);
% sigmaCT = flagsAddCRVS(sigmaTcohIndex);
% deltaCN = flagsAddCRVS(deltaNcohIndex);
% deltaCT = flagsAddCRVS(deltaTcohIndex);
E = flagsAddCRVS(EIndex);
rho = flagsAddCRVS(rhoIndex);
nu = flagsAddCRVS(nuIndex);
sigmaForce = 2.0 * flagsAddCRVS(sigma0Index);
rampTime = flagsAddCRVS(rampTimeIndex);
FractureEnergy = flagsAddCRVS(fracEneryIndex);

% cd = flagsAddCRVS(CdIndex);
% cr = flagsAddCRVS(CrIndex);
% cs = flagsAddCRVS(CsIndex);

% all quantities are normalized
%PZ process zone size
% v velocity
% t time
% a crack length (increment)
% vMax is maximum material velocity normal to crack surface (for mode I)
% vc: is cohesive time scale

global AddCRVSopt_a_t;
global AddCRVSopt_v_t;
global AddCRVSopt_PZ_v;
global AddCRVSopt_00_11Unbounded;
global AddCRVSopt_00_11Bounded;
global AddCRVSopt_1_Unbounded;
global AddCRVSopt_1Bounded;
global AddCRVSopt_vMax_rp2rsv;
global AddCRVSopt_rp_rsv_GivenSigmaForceSigmaC;
global AddCRVSopt_vMax_vc;
global AddCRVSopt_rprss_sigmaForceSigmaCUnbounded;
global AddCRVSopt_rprss_sigmaForceSigmaCBounded;

global pz_rpFactor;
global FValuePZSize;

cohModelTSL = 1;
cohModelDamage = 2;


cohModelType = floor(plotAddModifiedOptNumber/ 100) + 1;
dataPlotType = mod(plotAddModifiedOptNumber, 100);

if (dataPlotType == AddCRVSopt_a_t)
%    if (cohModelType == cohModelTSL)
        [xAddCRVS, yAddCRVS] = plotNormalizedCrackGrowth4ContactLoadLEFM...
            (doPlot, lineStyle, lineColor, lineWidth, markerStyle, xlimMinChosen,  xlimMaxChosen, ...
            E, rho, nu, sigmaForce, rampTime, FractureEnergy); 
%    end
    return;
end

if (dataPlotType == AddCRVSopt_v_t)
%    if (cohModelType == cohModelTSL)
        [xAddCRVS, yAddCRVS] = plotNormalizedVelocity4ContactLoadLEFM...
            (doPlot, lineStyle, lineColor, lineWidth, markerStyle, xlimMinChosen,  xlimMaxChosen, ...
            E, rho, nu, sigmaForce, rampTime, FractureEnergy); 
%    end
    return;
end

if (dataPlotType == AddCRVSopt_PZ_v)
    if (cohModelType == cohModelTSL)
        [xAddCRVS, yAddCRVS] = plotYuSuoNormalizedPZSize_Velocity(nu, doPlot, lineStyle, lineColor, lineWidth, markerStyle); 
    end
    return;
end


if (dataPlotType == AddCRVSopt_vMax_rp2rsv)
%    if (cohModelType == cohModelTSL)
        [xAddCRVS, yAddCRVS] = plotNormalizedvMax_rp2rsv(doPlot, lineStyle, lineColor, lineWidth, markerStyle, ...
            xlimMinChosen,  xlimMaxChosen, pz_rpFactor, FValuePZSize, xlogOption, ylogOption); 
%    end
    return;
end

if (dataPlotType == AddCRVSopt_rp_rsv_GivenSigmaForceSigmaC)
%    if (cohModelType == cohModelTSL)
        [xAddCRVS, yAddCRVS] = plotrp_rsv_GivenSigmaForceSigmaC(E, nu, rho, sigmaForce, sigmaCN, doPlot, lineStyle, lineColor, lineWidth, markerStyle, ...
            xlimMinChosen,  xlimMaxChosen, FValuePZSize, xlogOption, ylogOption);
%    end
    return;
end

if (dataPlotType == AddCRVSopt_vMax_vc)
%    if (cohModelType == cohModelTSL)
        [xAddCRVS, yAddCRVS] = plot_vMax_vc_GivenSigmaForceSigmaC(E, nu, rho, sigmaForce, sigmaCN, doPlot, lineStyle, lineColor, lineWidth, markerStyle, ...
            xlimMinChosen,  xlimMaxChosen, FValuePZSize, pz_rpFactor, xlogOption, ylogOption);
%    end
    return;
end





%


doPlotGivenCase = doPlot;
% if (cohModelType ~= cohModelTSL)
%     doPlotGivenCase = 0;
% end


if (dataPlotType == AddCRVSopt_00_11Unbounded)
    xAddCRVS = [xlimMinChosen xlimMaxChosen];
    yAddCRVS = [xlimMinChosen xlimMaxChosen];
elseif (dataPlotType == AddCRVSopt_00_11Bounded)
    xAddCRVS = [0 1];
    yAddCRVS = [0 1];
elseif (dataPlotType == AddCRVSopt_1_Unbounded)
    xAddCRVS = [xlimMinChosen xlimMaxChosen];
    yAddCRVS = [1 1];
elseif (dataPlotType == AddCRVSopt_1Bounded)
    xAddCRVS = [0 1];
    yAddCRVS = [1 1];
elseif (dataPlotType == AddCRVSopt_rprss_sigmaForceSigmaCUnbounded)
    xAddCRVS = 0:0.05:1;
    yAddCRVS = FValuePZSize * pi^2 * power(xAddCRVS, 2);
elseif (dataPlotType == AddCRVSopt_rprss_sigmaForceSigmaCBounded)
    xAddCRVS = [xlimMinChosen xlimMaxChosen];
    yAddCRVS = FValuePZSize * pi^2 * power(xAddCRVS, 2);
elseif (dataPlotType == AddCRVSopt_rprss_velocityUnbounded)
    xAddCRVS = [0 1];
    yAddCRVSTemp = FValuePZSize * (pi * sigmaForce / sigmaCN)^2;
    yAddCRVS = [yAddCRVSTemp yAddCRVSTemp];
elseif (dataPlotType == AddCRVSopt_rprss_velocityBounded)
    xAddCRVS = [xlimMinChosen xlimMaxChosen];
    yAddCRVSTemp = FValuePZSize * (pi * sigmaForce / sigmaCN)^2;
    yAddCRVS = [yAddCRVSTemp yAddCRVSTemp];
end


sigmaCN = flagsAddCRVS(sigmaNcohIndex);
% sigmaCT = flagsAddCRVS(sigmaTcohIndex);
% deltaCN = flagsAddCRVS(deltaNcohIndex);
% deltaCT = flagsAddCRVS(deltaTcohIndex);
E = flagsAddCRVS(EIndex);
rho = flagsAddCRVS(rhoIndex);
nu = flagsAddCRVS(nuIndex);
sigmaForce = flagsAddCRVS(sigma0Index);

if doPlotGivenCase
    plot(xAddCRVS, yAddCRVS, 'LineStyle', lineStyle, 'Color', lineColor, 'LineWidth', lineWidth, 'Marker', markerStyle);
end



