forceDroppingDir = 1;
addFieldNameInsideLeg = 0;
configName = 'plotConfigExtended.txt';
forceDroppingDir = 1;
clr = 1;
clrOneCurve = 2;
if (addFieldNameInsideLeg == 0)
    usePrime4normalized = 0;
    forceScaleOptTmp = 0;
	header = getLatexName('k', usePrime4normalized, forceDroppingDir, forceScaleOptTmp);
    header = ['$$\log($$', header, '$$)$$']; 
else
    header = '';
end

isPSFrag = 0;
plot21_25kLoadVal = 1;
plot30_36kRate = 1;
plot8_15kRate = 1;
MAIN_plotDamagePaperPlots(configName, clr, isPSFrag, forceDroppingDir, addFieldNameInsideLeg, plot21_25kLoadVal, plot30_36kRate, plot8_15kRate);

GENERAL_DATA_SET_PLOT_ONE_CURVE('_x_loadRate_curve_k', 'plotConfigExtended.txt', clrOneCurve, isPSFrag, forceDroppingDir, header);
GENERAL_DATA_SET_PLOT_ONE_CURVE('_x_loadRate_curve_k_inf', 'plotConfigExtended.txt', clrOneCurve, isPSFrag, forceDroppingDir, header);

if 1
    GENERAL_DATA_SET_PLOT_ONE_CURVE('_x_loadRate_curve_sNormalized6', 'plotConfigExtended_Normalized6.txt', clrOneCurve, isPSFrag, forceDroppingDir, header);
    GENERAL_DATA_SET_PLOT_ONE_CURVE('_x_loadRate_curve_sNormalized5', 'plotConfigExtended_Normalized5.txt', clrOneCurve, isPSFrag, forceDroppingDir, header);

    GENERAL_DATA_SET_PLOT_ONE_CURVE('_x_loadRate_curve_vNormalized6', 'plotConfigExtended_Normalized6.txt', clrOneCurve, isPSFrag, forceDroppingDir, header);
    GENERAL_DATA_SET_PLOT_ONE_CURVE('_x_loadRate_curve_vNormalized5', 'plotConfigExtended_Normalized5.txt', clrOneCurve, isPSFrag, forceDroppingDir, header);
end

if 1
    GENERAL_DATA_SET_PLOT_ONE_CURVE('_x_loadRate_curve_sNormalized6_inf', 'plotConfigExtended_Normalized6.txt', clrOneCurve, isPSFrag, forceDroppingDir, header);
    GENERAL_DATA_SET_PLOT_ONE_CURVE('_x_loadRate_curve_sNormalized5_inf', 'plotConfigExtended_Normalized5.txt', clrOneCurve, isPSFrag, forceDroppingDir, header);

    GENERAL_DATA_SET_PLOT_ONE_CURVE('_x_loadRate_curve_vNormalized6_inf', 'plotConfigExtended_Normalized6.txt', clrOneCurve, isPSFrag, forceDroppingDir, header);
    GENERAL_DATA_SET_PLOT_ONE_CURVE('_x_loadRate_curve_vNormalized5_inf', 'plotConfigExtended_Normalized5.txt', clrOneCurve, isPSFrag, forceDroppingDir, header);
end

xMode = 1; % 1 deltau s / 2 delta u v is the x axis
MAIN_plot_Dsu_Dvs_AllVersions(xMode, forceDroppingDir);