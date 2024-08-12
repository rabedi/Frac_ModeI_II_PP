function [x, y] = plotrp_rsv_GivenSigmaForceSigmaC(E, nu, rho, sigmaForce, sigmaC, doPlot, lineStyle, lineColor, lineWidth, markerStyle, ...
            xlimMinChosen,  xlimMaxChosen, FValuePZSizeIn, xlogOption, ylogOption, maxVValue, vresolution)

% if (xlogOption > 0)
%     fprintf(1, '(xlogOption > 0) in function plotrp_rsv_GivenSigmaForceSigmaC\n');
%     pause;
% end
  
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
 
 
if nargin < 16
    maxVValue = 1;
end


if nargin < 17
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


factor = FValuePZSizeIn * (pi / (1 - nu) * cs^2 / cd / cr * sigmaForce / sigmaC)^2;

scaledv = 1;

numv = length(v);

for nv = 1:numv
    vsld = v(nv);
    AI = comptuteAI(vsld, nu, cd, cs, cr, scaledv);
    rp2rsv(nv) = factor / (AI * vsld)^2;
end


if (ylogOption > 0)
    y = log(rp2rsv) / log(ylogOption);
else
    y = rp2rsv;
end

x = v;

if (xlogOption < 0)
    x = log(1.0 - x) / log(-xlogOption);
end

if doPlot
    plot(x, y, 'LineStyle', lineStyle, 'Color', lineColor, 'LineWidth', lineWidth, 'Marker', markerStyle);
end

