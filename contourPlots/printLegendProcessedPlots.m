function printLegendProcessedPlots()

global fnt_cnfgAddedFlds;
global pl_confAddedFlds;
global pf_plotsAddedFlds;
global figHandlesAddedFlds;

global crv_LineStyle;
global crv_LlineColor;
global crv_LlineWidth;
global crv_Lsymbol;
global crv_LmarkerStyle;
global crv_LmarkerSize;
global crv_LmarkerEdgeColor;
global crv_LmarkerFaceColor;

global Ipltfs;
global Isymfs;
global IxminT;   
global IyminT;

global crv_LineStyle;
global crv_LlineColor;
global crv_LlineWidth;
global crv_Lsymbol;
global crv_LmarkerStyle;
global crv_LmarkerSize;
global crv_LmarkerEdgeColor;
global crv_LmarkerFaceColor;

global pl_numPlots;
global plt_legendLocation;
global plt_Curves;
global plt_active;

global INumStates;

numStated = fnt_cnfgAddedFlds{INumStates};

pltfs = fnt_cnfgAddedFlds{Ipltfs};
symfs = fnt_cnfgAddedFlds{Isymfs};
xminT = fnt_cnfgAddedFlds{IxminT};   
yminT = fnt_cnfgAddedFlds{IyminT};

numPlots = pl_confAddedFlds{pl_numPlots};


baseFigureCntr = 30000;
incrementFigureCntr = 10000;

for pl = 1:numPlots
    if (pf_plotsAddedFlds{pl}{plt_active} == 0)
        continue;
    end
    for st = 1:numStated
        baseFigTemp = baseFigureCntr + incrementFigureCntr * st;
        figHandlesAddedFlds{st}{pl} = figure(baseFigTemp + pl);

        legL = pf_plotsAddedFlds{pl}{plt_legendLocation};
        Lnum = length(pf_plotsAddedFlds{pl}{plt_Curves}{crv_LineStyle});

        for crv = 1:Lnum
            LineStyle{crv} = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LineStyle}{crv}{st};
            LlineColor{crv} = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LlineColor}{crv}{st};
    %        pf_plotsAddedFlds{pl}{plt_Curves}{crv_LlineWidth}{st};
            Lsymbol{crv} = pf_plotsAddedFlds{pl}{plt_Curves}{crv_Lsymbol}{crv}{st};
            LmarkerStyle{crv} = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerStyle}{crv}{st};
            LmarkerSize{crv} = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerSize}{crv}{st};
            LmarkerEdgeColor{crv} = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerEdgeColor}{crv}{st}; 
            LmarkerFaceColor{crv} = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerFaceColor}{crv}{st}; 
        end
        [lineHandle, symbolOut, numOut, lineWidthOut] = prepareLineSymbolsForLegend(gcf, legL, 'boxoff', Lnum, Lsymbol, LlineColor, LineStyle,...
            LmarkerStyle, LmarkerSize, LmarkerEdgeColor, LmarkerFaceColor, pltfs, symfs, xminT, yminT);
    end
end