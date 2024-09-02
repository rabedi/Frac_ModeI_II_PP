function GENERAL_DATA_SET_PLOT(version, clr, isPSFrag, plotConfigFileName, axesForcedLims, forceDroppingDir, addFieldNameInsideLeg, print1CurveDat, root) %, inputIndices, specIndicesNames, inputValues, specValsNames, dataFull, namesTable, outputFolderName)

maxDataSize = 10000;
if (nargin < 1)
    version = 1;
end

if (nargin < 2)
    clr = 1;
end

if (clr == 0)
    maxDataSize = 500;
end

if (nargin < 3)
    isPSFrag = 0;
end

% no parameter plots the default deta set/config
% the development phases of this file are stored in script2
if (nargin < 4)
    plotConfigFileName = 'plotConfigExtended.txt';
end

%for certain run versions (9-15, 31-36) which include load rate, for plots
%that have normalization w.r.t. velocity damage rate model the run
%parameter is offset
changeOneCurveRunParameter = strncmp(plotConfigFileName, 'plotConfigExtended', 18);
% 9 and 31 are not in the list because the have the same scale for
% deltau_s, deltau_v]
offset = 0;
forceScaleOptVersion = -1;
if (((version >= 8) && (version <= 15)) || ((version >= 30) && (version <= 36)))
    forceScaleOptVersion = 2;
end

pltSets4Offset = [];
if (changeOneCurveRunParameter)
    offsetValue(9) = 0;
    offsetValue(10) = -1;
    offsetValue(32) = -1;
    offsetValue(11) = -2;
    offsetValue(33) = -2;
    offsetValue(12) = -3;
    offsetValue(34) = -3;
    offsetValue(13) = 1;
    offsetValue(35) = 1;
    offsetValue(14) = 2;
    offsetValue(36) = 2;
    offsetValue(15) = 3;
    offsetValue(31) = 0;
    [m, nOffset] = size(offsetValue);
    if ((version > nOffset) || (offsetValue(version) == 0))
        offset = 0;
    else
        offset = offsetValue(version);
    end
    pltSets4Offset = [24, 26, 28, 30, 32]; % energy, displacement, time, stress, D_s % normalized by vel ddot term
end

    % for fracture work the order will be maxTime, maxDelta,
% maxTimeScaling2Fracture, maxDeltaScaling2Fracture
if (nargin < 5)
    axesForcedLims = [2 2 2 2 2];
end

if (nargin < 6)
    forceDroppingDir = 1;
end

if (nargin < 7)
    addFieldNameInsideLeg = 0;
end

if (nargin < 8)
    print1CurveDat = 1;
end

if (nargin < 9)
%    root = '../../physics/';
     root = 'data/';
end

if (isPSFrag == 2)
    if (clr ~= 2)
        GENERAL_DATA_SET_PLOT(version, clr, 0, plotConfigFileName, axesForcedLims, forceDroppingDir, addFieldNameInsideLeg, print1CurveDat, root);
        GENERAL_DATA_SET_PLOT(version, clr, 1, plotConfigFileName, axesForcedLims, forceDroppingDir, addFieldNameInsideLeg, print1CurveDat, root);
    else
        GENERAL_DATA_SET_PLOT(version, 1, 0, plotConfigFileName, axesForcedLims, forceDroppingDir, addFieldNameInsideLeg, print1CurveDat, root);
        GENERAL_DATA_SET_PLOT(version, 1, 1, plotConfigFileName, axesForcedLims, forceDroppingDir, addFieldNameInsideLeg, print1CurveDat, root);
        GENERAL_DATA_SET_PLOT(version, 0, 0, plotConfigFileName, axesForcedLims, forceDroppingDir, addFieldNameInsideLeg, print1CurveDat, root);
        GENERAL_DATA_SET_PLOT(version, 0, 1, plotConfigFileName, axesForcedLims, forceDroppingDir, addFieldNameInsideLeg, print1CurveDat, root);
    end
else
    if (clr == 2)
        GENERAL_DATA_SET_PLOT(version, 0, isPSFrag, plotConfigFileName, axesForcedLims, forceDroppingDir, addFieldNameInsideLeg, print1CurveDat, root);
        GENERAL_DATA_SET_PLOT(version, 1, isPSFrag, plotConfigFileName, axesForcedLims, forceDroppingDir, addFieldNameInsideLeg, print1CurveDat, root);
    end
end

isLatex = ~isPSFrag;
latexHaveHeaderLine = (isLatex  && (addFieldNameInsideLeg == 0));
addOneLine2Leg = ((isPSFrag == 1) || latexHaveHeaderLine);


szAxL = length(axesForcedLims);

szFL = 10;
userConfigSpecifiedAxisLims = zeros(szFL, 1);
for i = 1:szFL
    userConfigSpecifiedAxisLims(i) = 1;
end

for i = 1:szAxL
    userConfigSpecifiedAxisLims(i) = axesForcedLims(i);
end

vn = num2str(version);
%if (isPSFrag == 0)
    if (clr == 1)
        figureFldrName = ['figures/version_', vn];
    else
        figureFldrName = ['figures/version_', vn, '/clr0'];
    end
%else
%     if (clr == 1)
%         figureFldrName = ['figures/version_', vn, '/psFrag'];
%     else
%         figureFldrName = ['figures/version_', vn, '/psFragClr0'];
%     end
% end

[status,message,messageid] = mkdir(figureFldrName);
oneCurvePlotDat = ['dataOneCurvePlot_clr', num2str(clr), '_ps_', num2str(isPSFrag)];
[status,message,messageid] = mkdir(oneCurvePlotDat);

ext = 'png';
prFlg = '-dpng';
if (isPSFrag == 1)
    ext = 'eps';
    prFlg = '-depsc';
end

plotPropTable = plt_plotDataPropTable;
szVec = 15;
getPropVector = plt_plotDataPropGenerateVector(clr, plotPropTable, szVec);

dt = dat_matrixFractureDats;
dt = dt.read(version, root, maxDataSize);
runsParameterName = dt.runsParameterName;

fid = fopen(plotConfigFileName, 'r');

buf = fscanf(fid, '%s', 1);
general_dataModifiers = aa_general_dataModifiers;
general_dataModifiers = general_dataModifiers.read(fid);

%[plotProperties, numPlotProperties] = plt_plot_plotProperties_Read(fid);


[plotConfigurations, plotConfigurationsNumber] = plt_plot_plotDataSet_read(fid);
%plotConfigurations = plt_plot_plotDataSet_setNumberOfAxisPlots(plotConfigurationsTemp, plotConfigurationsNumber, index_sets);

fclose(fid);


closeFigure = 1;
for pltSet = 1:plotConfigurationsNumber
    if (plotConfigurations{pltSet}.active == 0)
        continue;
    end
    pltSet
%    plotPropertyNumber = plotConfigurations{pltSet}.plotPropertyNumber;
    if (plotConfigurations{pltSet}.numberOfAxesDataSets ~= 1)
        fprintf('Number of data sets plotConfigurations{pltSet}.numberOfAxesDataSets NOT one %s\n',plotConfigurations{pltSet}.numberOfAxesDataSets);
        pause;
    end
    dataSetNumber{1} = plotConfigurations{pltSet}.axesDataSets{1}.xAxisData.dataSetNumber;
    dataSetNumber{2} = plotConfigurations{pltSet}.axesDataSets{1}.yAxisData.dataSetNumber;
    dModifierNumbers{1} = plotConfigurations{pltSet}.axesDataSets{1}.xAxisData.dataSetOrderModifiers;
    dModifierNumbers{2} = plotConfigurations{pltSet}.axesDataSets{1}.yAxisData.dataSetOrderModifiers;
    
    for ax = 1:2
        [axCurve{ax}, numAxCurve{ax}, multiRunCurve{ax}, legEntries{ax}, label{ax}, labelSimple{ax}]  = dt.getData(dataSetNumber{ax});
        if (length(dModifierNumbers{ax}) > 0)
            for gci = 1:numAxCurve{ax}
                axCurve{ax}{gci} = general_dataModifiers.operateSeries(axCurve{ax}{gci}, dModifierNumbers{ax});
            end
        end
    end
    hf = figure(pltSet);
    
    if (multiRunCurve{ax} == 1)
        if (addOneLine2Leg == 1)
            plot(nan, nan, 'lineStyle', 'none');
            hold on;
        end
    end
    
    forceScaleOpt = -1;
    ind = find(pltSets4Offset == pltSet);
    specialPlt = length(ind > 0);
    if ((forceScaleOptVersion >= 0) && (specialPlt))
        forceScaleOpt = forceScaleOptVersion;
    end
    for gci = 1:numAxCurve{ax}
        xDat = axCurve{1}{gci};
        if (offset ~= 0)
            if (specialPlt > 0)
                xDat = xDat + offset;
            end
        end
        plt_plotData_plotXYbasedOnDataSpec(getPropVector{gci}, xDat, axCurve{2}{gci});
        hold on;
    end
    if ((print1CurveDat) && (multiRunCurve{ax} == 0))
        fileNameOC = [oneCurvePlotDat, '/plt_', num2str(pltSet), '_v_', vn, '.txt'];
        fidoc = fopen(fileNameOC, 'wt');
        gci = 1;
        sz = length(xDat);
        fprintf(fidoc, 'data');
        fprintf(fidoc, '\n');
        fprintf(fidoc, 'size\t%d', sz);
        fprintf(fidoc, '\n');
        fprintf(fidoc, 'x');
        fprintf(fidoc, '\n');
        for i = 1:sz
            fprintf(fidoc, '%g\t', xDat(i));
        end
        fprintf(fidoc, '\n');
        fprintf(fidoc, 'y');
        fprintf(fidoc, '\n');
        for i = 1:sz
            fprintf(fidoc, '%g\t', axCurve{2}{gci}(i));
        end
        fprintf(fidoc, '\n');
    else
        fidoc = -1;
    end
    
    ax = 1;
    titl = '';
    xLabel = label{1};
    yLabel = label{2};
    if (multiRunCurve{ax} == 1)
        if (isPSFrag == 1)
            legendLabels{1} = 'header';
            for k = 1:length(legEntries{ax})
                legendLabels{1 + k} = legEntries{ax}{k};
            end
        else
            if (latexHaveHeaderLine == 0)
                legendLabels = legEntries{ax};
            else
                legendLabels{1} = runsParameterName;
                for k = 1:length(legEntries{ax})
                    legendLabels{1 + k} = legEntries{ax}{k};
                end
            end
        end
    else
        legendLabels = '';
    end
%    plotProperties{plotPropertyNumber}.setPlotLabelsAxis(gca, titl, legendLabels, xLabel, yLabel, isPSFrag);
    plotConfigurations{pltSet}.pltProp.setPlotLabelsAxis(gca, titl, legendLabels, xLabel, yLabel, isPSFrag, userConfigSpecifiedAxisLims, isLatex, addFieldNameInsideLeg, runsParameterName, forceDroppingDir, forceScaleOpt);
    ttlPrint = [figureFldrName, '/plotV', vn, '_plt_', num2str(pltSet), '_', labelSimple{1}, 'vs', labelSimple{2}, '.', ext];
    print(prFlg, ttlPrint);
    if (fidoc > 0)
%        xlbl = get(gca, 'xlabel');
%        ylbl = get(gca, 'ylabel');
        fprintf(fidoc, 'xLabel\t%s', xLabel);
        fprintf(fidoc, '\n');
        fprintf(fidoc, 'yLabel\t%s', yLabel);
        fprintf(fidoc, '\n');
        fclose(fidoc);
    end
    
end
fclose('all');
close('all');