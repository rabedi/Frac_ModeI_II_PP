function GENERAL_DATA_SET_PLOT_ONE_CURVE(configOneCurveNameAfterplotConfigSingleWOExt, config4PlotProperties, clr, isPSFrag, forceDroppingDir, header, maxPlotNumber)

pltSets4Offset = [];
pltSets4Offset = [24, 26, 28, 30, 32]; % energy, displacement, time, stress, D_s % normalized by vel ddot term
vs = [8:15,30:36];

%addFieldNameInsideLeg = 0;
runsParameterName = 'none';

if (nargin < 1)
    configOneCurveNameAfterplotConfigSingleWOExt = '_x_loadRate_curve_k';
end

if (nargin < 2)
    config4PlotProperties = 'plotConfigExtended.txt';
end

if (nargin < 3)
    clr = 1;
end

if (nargin < 4)
    isPSFrag = 0;
end

if (nargin < 5)
    forceDroppingDir = 0;
end

if (nargin < 6)
    header = '';
end

if (nargin < 7)
    maxPlotNumber = 50;
end


if (isPSFrag == 2)
    if (clr ~= 2)
        GENERAL_DATA_SET_PLOT_ONE_CURVE(configOneCurveNameAfterplotConfigSingleWOExt, config4PlotProperties, clr, 0, forceDroppingDir, header, maxPlotNumber);        
        GENERAL_DATA_SET_PLOT_ONE_CURVE(configOneCurveNameAfterplotConfigSingleWOExt, config4PlotProperties, clr, 1, forceDroppingDir, header, maxPlotNumber);        
        return;
    else
        clr = 1;
        GENERAL_DATA_SET_PLOT_ONE_CURVE(configOneCurveNameAfterplotConfigSingleWOExt, config4PlotProperties, clr, 0, forceDroppingDir, header, maxPlotNumber);        
        GENERAL_DATA_SET_PLOT_ONE_CURVE(configOneCurveNameAfterplotConfigSingleWOExt, config4PlotProperties, clr, 1, forceDroppingDir, header, maxPlotNumber);        
        clr = 0;
        GENERAL_DATA_SET_PLOT_ONE_CURVE(configOneCurveNameAfterplotConfigSingleWOExt, config4PlotProperties, clr, 0, forceDroppingDir, header, maxPlotNumber);        
        GENERAL_DATA_SET_PLOT_ONE_CURVE(configOneCurveNameAfterplotConfigSingleWOExt, config4PlotProperties, clr, 1, forceDroppingDir, header, maxPlotNumber);        
        return;
    end
else
    if (clr == 2)
        GENERAL_DATA_SET_PLOT_ONE_CURVE(configOneCurveNameAfterplotConfigSingleWOExt, config4PlotProperties, 0, isPSFrag, forceDroppingDir, header, maxPlotNumber);        
        GENERAL_DATA_SET_PLOT_ONE_CURVE(configOneCurveNameAfterplotConfigSingleWOExt, config4PlotProperties, 1, isPSFrag, forceDroppingDir, header, maxPlotNumber);        
        return;
    end
end

isLatex = 1 - isPSFrag;

addFieldNameInsideLeg = (length(header) == 0);

configOneCurveName = ['plotConfigSingleCurve', configOneCurveNameAfterplotConfigSingleWOExt, '.txt'];
runName = configOneCurveNameAfterplotConfigSingleWOExt;
figFld = 'figures/_oneCurve';
folderName = [figFld, '/', configOneCurveNameAfterplotConfigSingleWOExt];
clrName = 'c';
if (clr == 0)
    clrName = 'b';
end

folderName = [folderName, '/', clrName];

[status,message,messageid] = mkdir(folderName);

figNameBase = [folderName, '/', runName];


plotPropTable = plt_plotDataPropTable;
szVec = 10;
addMarker = 1;  % so markers are added
getPropVector = plt_plotDataPropGenerateVector(clr, plotPropTable, szVec, addMarker);
userConfigSpecifiedAxisLims = [];

%oneCurvePlotDat = ['dataOneCurvePlot_clr', num2str(clr), '_ps_', num2str(isPSFrag)];
oneCurvePlotDat = ['dataOneCurvePlot_clr', num2str(1), '_ps_', num2str(0)];

ext = 'png';
prFlg = '-dpng';
if (isPSFrag == 1)
    ext = 'eps';
    prFlg = '-depsc';
end


% default plot property
pppProp = plt_plot_plotProperties;

% plot property from original runs
fidcc = fopen(config4PlotProperties, 'r');
if (fidcc > 0)
    buf = fscanf(fidcc, '%s', 1);
    general_dataModifiers = aa_general_dataModifiers;
    general_dataModifiers = general_dataModifiers.read(fidcc);
    %[plotProperties, numPlotProperties] = plt_plot_plotProperties_Read(fid);
    [plotConfigurations, plotConfigurationsNumber] = plt_plot_plotDataSet_read(fidcc);
    %plotConfigurations = plt_plot_plotDataSet_setNumberOfAxisPlots(plotConfigurationsTemp, plotConfigurationsNumber, index_sets);
    fclose(fidcc);
    fidcc = 1;
else
    fidcc = 0;
end




fidc = fopen(configOneCurveName, 'r');
if (fidc < 0)
    fprintf(1, 'Cannot open %s', configOneCurveName);
    pause;
end
buf = fscanf(fidc, '%s', 1);
numberRuns = fscanf(fidc, '%d', 1);
buf = fscanf(fidc, '%s', 1);

addHeaderLine = ((addFieldNameInsideLeg == 0) || (isPSFrag));
if (isPSFrag)
    header = 'header';
end
    
if (addHeaderLine == 1)
    offset = 1;
    leg{1} = header;
else
    offset = 0;
end

for i = 1:numberRuns
    versions(i) = fscanf(fidc, '%d', 1);
    leg{i + offset} = fscanf(fidc, '%s', 1);
    if (isLatex)
        leg{i + offset} = ['OC', leg{i + offset}];
    end
end

if (isPSFrag == 1)
    for i = 1:numberRuns
        leg{i + offset} = ['leg', num2str(i)];
    end
end


for pltSet = 1:maxPlotNumber
    successful = 1;
    forceScaleOpt = -1;
    indp = find(pltSets4Offset == pltSet);
    if (size(indp) > 0)
        forceScaleOpt = 2;
    else
        indp = find(pltSets4Offset == (pltSet - 1));
        if (size(indp) > 0)
            forceScaleOpt = 1;
        end
    end
    for i = 1:numberRuns
        vn = num2str(versions(i));
        if (forceScaleOpt >= 0)
            indv = find(vs == versions(i));
            if (size(indv) == 0)
                forceScaleOpt = -1;
            end
        end
        fileNameOC = [oneCurvePlotDat, '/plt_', num2str(pltSet), '_v_', vn, '.txt'];
        fid = fopen(fileNameOC, 'r');
        if (fid < 0)
            successful = 0;
            break;
        end
        buf = fscanf(fid, '%s', 2);
        sz = fscanf(fid, '%d', 1);
        buf = fscanf(fid, '%s', 1);
        for j = 1:sz
            x{i}(j) = fscanf(fid, '%g', 1);
        end
        buf = fscanf(fid, '%s', 1);
        for j = 1:sz
            y{i}(j) = fscanf(fid, '%g', 1);
        end
        buf = fscanf(fid, '%s', 1);
        xlbl = fscanf(fid, '%s', 1);
        buf = fscanf(fid, '%s', 1);
        ylbl = fscanf(fid, '%s', 1);
    end
    if (successful == 1)
        figure(pltSet);
        if (addHeaderLine == 1)
            plot(nan, nan, 'lineStyle', 'none');
            hold on;
        end
        for i = 1:numberRuns
            plt_plotData_plotXYbasedOnDataSpec(getPropVector{i}, x{i}, y{i});
            hold on;
        end
        titl = '';
        if (fidcc == 0)
            pppProp.setPlotLabelsAxis(gca, titl, leg, xlbl, ylbl, isPSFrag, userConfigSpecifiedAxisLims, isLatex, addFieldNameInsideLeg, runsParameterName, forceDroppingDir, forceScaleOpt);
        else
            plotConfigurations{pltSet}.pltProp.setPlotLabelsAxis(gca, titl, leg, xlbl, ylbl, isPSFrag, userConfigSpecifiedAxisLims, isLatex, addFieldNameInsideLeg, runsParameterName, forceDroppingDir, forceScaleOpt);
        end
        ttlPrint = [figNameBase, '_plt_', num2str(pltSet), '.', ext];
        print(prFlg, ttlPrint);
        ttlFig = [figNameBase, '_plt_', num2str(pltSet), '.', 'fig'];
        savefig(ttlFig);
    end
end

fclose('all');
close('all');