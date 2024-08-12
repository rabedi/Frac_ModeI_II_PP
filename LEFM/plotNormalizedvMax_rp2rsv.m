function [x, y] = plotNormalizedvMax_rp2rsv(doPlot, lineStyle, lineColor, lineWidth, markerStyle, ...
            xlimMinChosen,  xlimMaxChosen, rpFactorIn, FValuePZSizeIn, xlogOption, ylogOption)

factor = rpFactorIn * FValuePZSizeIn;
        
xlimMinLog = xlimMinChosen;
xlimMaxLog = xlimMaxChosen;

logFactor = 1.0;

if (xlogOption > 0)
    logFactor = 1 / log(xlogOption);
    xlimMinLog = xlimMinLog / logFactor;
    xlimMaxLog = xlimMaxLog / logFactor;
else
    xlimMinLog = log(xlimMinLog);
    xlimMaxLog = log(xlimMaxLog);
end

num = 300;
delxLog = (xlimMaxLog - xlimMinLog) / num;
xlog = xlimMinLog:delxLog:xlimMaxLog;
xReal = exp(xlog);
%yReal = 1 + power(xReal, -0.5) ./ sqrt(rpFactorIn);
yReal = power(xReal, -0.5) ./ sqrt(factor);

if (xlogOption > 0)
    x = xlog * logFactor;
else
    x = xReal;
end

if (ylogOption > 0)
    logFactorY = 1 / log(ylogOption);
    y = log(yReal) * logFactorY;
else
    y = yReal;
end

if doPlot
    plot(x, y, 'LineStyle', lineStyle, 'Color', lineColor, 'LineWidth', lineWidth, 'Marker', markerStyle);
end