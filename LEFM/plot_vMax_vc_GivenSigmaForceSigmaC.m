function [x, y] = plot_vMax_vc_GivenSigmaForceSigmaC(E, nu, rho, sigmaForce, sigmaC, doPlot, lineStyle, lineColor, lineWidth, markerStyle, ...
            xlimMinChosen,  xlimMaxChosen, FValuePZSizeIn, pz_rpFactor, xlogOption, ylogOption, maxVValue, vresolution)

if (xlogOption > 0)
    fprintf(1, '(xlogOption > 0) in function plotrp_rsv_GivenSigmaForceSigmaC\n');
    pause;
end
  
% xlimMinLog = xlimMinChosen;
% xlimMaxLog = xlimMaxChosen;
%  
% logFactor = 1.0;
% logFactorY = 1.0;
% if (ylogOption > 0)
%     logFactorY = 1 / log(ylogOption);
% end
%  
% if (xlogOption > 0)
%     logFactor = 1 / log(xlogOption);
%     xlimMinLog = xlimMinLog / logFactor;
%     xlimMaxLog = xlimMaxLog / logFactor;
% else
%     xlimMinLog = log(xlimMinLog);
%     xlimMaxLog = log(xlimMaxLog);
% end
%  
% num = 300;
% delxLog = (xlimMaxLog - xlimMinLog) / num;
% xlog = xlimMinLog:delxLog:xlimMaxLog;
% xReal = exp(xlog);

if (xlogOption < 0)
    amin = xlimMaxChosen;
    amax = xlimMinChosen;
    baseLog = -xlogOption;
    xlimMinChosen = 1.0 - power(baseLog, amin);
    xlimMaxChosen = 1.0 - power(baseLog, amax);
end

 
[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);
 
 
if nargin < 17
    maxVValue = 1;
end

minVValue = 1 - maxVValue;

if nargin < 18
    vresolution = 0.02;
end

minVValue = 0;

vMin = max(xlimMinChosen, minVValue);
vMax = min(xlimMaxChosen, maxVValue);

if (vMax <= 0.9)
    v = vMin:vresolution:vMax;
    numv = length(v);
    if (v(numv) ~= vMax)
        v(numv + 1) = vMax;
        numv = numv + 1;
    end
else
    v1 = vMin:vresolution:0.9;
    diff = 1.0 - vMax;
    if (diff <= 0)
        diff = 1e-15;
    end
    a = floor(log10(diff));
    ind = -2:-0.25:a;
    for i = 1:length(ind)
        pt = 1.0 - power(10, ind(i));
        v2(i) = pt;
    end
    v = [v1 v2];
end

 
factor = (1 - nu) / pi / sqrt(FValuePZSizeIn) / sqrt(pz_rpFactor) * cd / cs^2 * cr;

scaledv = 1;

numv = length(v);


for nv = 1:numv
    vsld = v(nv);
    AI = comptuteAI(vsld, nu, cd, cs, cr, scaledv);
%    vMax_vc(nv) = sigmaForce / sigmaC + factor * (AI * vsld);
    vMax_vc(nv) = factor * (AI * vsld);
end


if (ylogOption > 0)
    y = log(vMax_vc) / log(ylogOption);
else
    y = vMax_vc;
end

x = v;

if (xlogOption < 0)
    x = log(1.0 - x) / log(-xlogOption);
end

if doPlot
    plot(x, y, 'LineStyle', lineStyle, 'Color', lineColor, 'LineWidth', lineWidth, 'Marker', markerStyle);
end