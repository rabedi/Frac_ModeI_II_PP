function setAxisMinorTicksAndFontSize(pltfs, xminT, yminT, doPlotFontSize)

if nargin < 4
    doPlotFontSize = 1;
end

if (doPlotFontSize == 1)
    set(gca,'FontSize',pltfs);
end

if (xminT == 1)
    set(gca,'XMinorTick','on');
end
if (yminT == 1)
    set(gca,'YMinorTick','on');
end
