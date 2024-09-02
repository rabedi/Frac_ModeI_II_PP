function labl = getContourMarkerLegend(lablIn, showLegend)

global confGen;
global conf2DPlot;

if nargin < 1
    lablIn = [];
end

if nargin < 2
    showLegend = 1;
end

labl = lablIn;

cntrStart = length(labl) + 1;



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


if (conf2DPlot{I_do2DColorPlot} ~= 0)
    for fld = 1:conf2DPlot{I_TS_numReqFlds};
        if (conf2DPlot{I_TS_ReqFlds}{fld}{ind_sl_MkrActive} == 0)
            continue;
        end
        hold on;
        plot(inf, inf, 'LineStyle', 'none', 'Marker', ...
            conf2DPlot{I_TS_ReqFlds}{fld}{ind_sl_MkrStyl}, ...
            'MarkerSize', conf2DPlot{I_TS_ReqFlds}{fld}{ind_sl_MkrSize}, ...
            'MarkerFaceColor', conf2DPlot{I_TS_ReqFlds}{fld}{ind_sl_MkrClr}, ...
            'MarkerEdgeColor', conf2DPlot{I_TS_ReqFlds}{fld}{ind_sl_MkrClr});
        labl{cntrStart} = conf2DPlot{I_TS_ReqFlds}{fld}{ind_sl_name};
        cntrStart = cntrStart + 1;
    end
end


 
if (conf2DPlot{I_CrackTipFldsMarkerActive} ~= 0)
    hold on;
    plot(inf, inf, 'LineStyle', 'none', 'Marker', ...
        conf2DPlot{I_CrackTipFldsMarkerStyle}, ...
        'MarkerSize', conf2DPlot{I_CrackTipFldsMarkerSize}, ...
        'MarkerFaceColor', conf2DPlot{I_CrackTipFldsMarkerColor}, ...
        'MarkerEdgeColor', conf2DPlot{I_CrackTipFldsMarkerColor});
    labl{cntrStart} = conf2DPlot{I_CrackTipFldsName};
    cntrStart = cntrStart + 1;
end

if (showLegend  == 1)
    h = legend(labl);
    set(h, 'box', 'off');
end