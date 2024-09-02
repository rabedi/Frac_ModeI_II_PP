function PlotContourMarkers(ind)


global dataCollected;
global fullFldData;
global fullFldSizes;
global ctTimeDatas;
global ctRelVels;



global confGen;
global conf2DPlot;
global gColormapInput;


global I_do2DColorPlot;
global I_plotTimeSlice;
global I_TS_ReqFlds;
global I_TS_numReqFlds;

global I_CrackTipFldsMarkerActive;
global I_CrackTipFldsMarkerStyle;
global I_CrackTipFldsMarkerSize;
global I_CrackTipFldsMarkerColor;
global I_CrackTipFldsName;

global ind_sl_sym;
global ind_sl_index;
global ind_sl_finderT;
global ind_sl_nrmlzrT;
global ind_sl_dim;
global ind_sl_name;
global ind_sl_MkrStyl;
global ind_sl_MkrClr;
global ind_sl_MkrSize;
global ind_sl_MkrActive;

global I_plotDistinctDamageLevels;


if (conf2DPlot{I_do2DColorPlot} ~= 0)
    for fld = 1:conf2DPlot{I_TS_numReqFlds};
        if (conf2DPlot{I_TS_ReqFlds}{fld}{ind_sl_MkrActive} == 0)
            continue;
        end
        hold on;
        plot(dataCollected{fld}{ind}(:, 1), dataCollected{fld}{ind}(:, 2), 'LineStyle', 'none', 'Marker', ...
            conf2DPlot{I_TS_ReqFlds}{fld}{ind_sl_MkrStyl}, ...
            'MarkerSize', conf2DPlot{I_TS_ReqFlds}{fld}{ind_sl_MkrSize}, ...
            'MarkerFaceColor', conf2DPlot{I_TS_ReqFlds}{fld}{ind_sl_MkrClr}, ...
            'MarkerEdgeColor', conf2DPlot{I_TS_ReqFlds}{fld}{ind_sl_MkrClr});
    end
end


 
if (conf2DPlot{I_CrackTipFldsMarkerActive} ~= 0)
    if (length(ctTimeDatas) > 0) 
        if (length(ctTimeDatas{ind}) > 0)
        hold on;
        plot(ctTimeDatas{ind}(:, 1), ctTimeDatas{ind}(:, 2), 'LineStyle', 'none', 'Marker', ...
            conf2DPlot{I_CrackTipFldsMarkerStyle}, ...
            'MarkerSize', conf2DPlot{I_CrackTipFldsMarkerSize}, ...
            'MarkerFaceColor', conf2DPlot{I_CrackTipFldsMarkerColor}, ...
            'MarkerEdgeColor', conf2DPlot{I_CrackTipFldsMarkerColor});
        end
    end
end



flagDamage = 5;
flagDelu0 = 6;
flagDelu1 = 7;

lim = [-inf inf];
colormapInput = confGen{gColormapInput};
hold on;
if (conf2DPlot{I_plotTimeSlice} ~= 0)
    if (conf2DPlot{I_plotDistinctDamageLevels} == 1)
        plot2DSegments(fullFldData{ind}, fullFldSizes{ind}, flagDamage , lim, flagDelu0, flagDelu1);
    else
        plotColor2DSegments(fullFldData{ind}, fullFldSizes{ind}, flagDamage , lim, colormapInput);
    end
end