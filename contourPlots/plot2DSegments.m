function plot2DSegments(fldData, fldSizes, zCol, lim, delu0Col, delu1Col)

global conf2DPlot;
global I_plotTwoSidedCrack;
global I_TwoSidedCrackDelu0Factor;
global I_TwoSidedCrackDelu1Factor;
global I_TwoSidedCrackDelu0FactorSideIn;
global I_TwoSidedCrackDelu0FactorSideOut;
global I_TwoSidedCrackDelu1FactorSideIn;
global I_TwoSidedCrackDelu1FactorSideOut;
global I_delu0C2D;
global I_delu1C2D;
global I_numberDistDPts;
global I_DistDPts;
 
global idam_level;
global id_clr;
global id_lstyle;
global id_lwdth;

plotTwoSide = conf2DPlot{I_plotTwoSidedCrack};


if nargin < 4
    lim = [-inf inf];
end


z = fldData(:, zCol);
x = fldData(:, 1);
y = fldData(:, 2);
z = fldData(:, zCol);

if (plotTwoSide == 1)
    delu0 = conf2DPlot{I_TwoSidedCrackDelu0Factor} * fldData(:, delu0Col);
    delu1 = conf2DPlot{I_TwoSidedCrackDelu1Factor} * fldData(:, delu1Col);
    delu0FactorSideIn = conf2DPlot{I_TwoSidedCrackDelu0FactorSideIn};
    delu0FactorSideOut = conf2DPlot{I_TwoSidedCrackDelu0FactorSideOut};
    delu1FactorSideIn = conf2DPlot{I_TwoSidedCrackDelu1FactorSideIn};
    delu1FactorSideOut = conf2DPlot{I_TwoSidedCrackDelu1FactorSideOut};
    xo = x + delu0FactorSideOut * delu0;
    yo = y + delu1FactorSideOut * delu1;
    x  = x + delu0FactorSideIn * delu0;
    y  = y + delu1FactorSideIn * delu1;
end



zmin = min(z);
zmax = max(z);

cmin = max(zmin, lim(1));
cmax = min(zmax, lim(2));

num = length(x);


cntr = 1;
numSegments = length(fldSizes);
for s =1:numSegments
    segSz = fldSizes(s);
    hold on;
    zsub = z(cntr:cntr + segSz - 1);
    dAve = average(zsub);
    [d1, d2] = find(conf2DPlot{I_DistDPts}{idam_level} <= dAve);
    if (length(d2) == 0)
        continue;
    end
    ind = d2(1);
    %Razaldo
    bDomainBoundary = isDomainBoundary(x(cntr:cntr + segSz - 1), y(cntr:cntr + segSz - 1));
    if (bDomainBoundary == 0)
        plot(x(cntr:cntr + segSz - 1), y(cntr:cntr + segSz - 1), 'Color', conf2DPlot{I_DistDPts}{id_clr}{ind}, ...
            'LineStyle', conf2DPlot{I_DistDPts}{id_lstyle}{ind}, 'LineWidth', conf2DPlot{I_DistDPts}{id_lwdth}(ind));

        if (plotTwoSide == 1)
            hold on;
            plot(xo(cntr:cntr + segSz - 1), yo(cntr:cntr + segSz - 1), 'Color', conf2DPlot{I_DistDPts}{id_clr}{ind}, ...
                'LineStyle', conf2DPlot{I_DistDPts}{id_lstyle}{ind}, 'LineWidth', conf2DPlot{I_DistDPts}{id_lwdth}(ind));
        end
    end
    cntr = cntr + segSz;
end