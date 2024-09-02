function [confGen, confData, conf2DPlot, dataCollected, fullFldData, ...
    fullFldSizes, ctTimeDatas, ctRelVels, xLMrkr, yLMrkr] = generateContourPlots(configFileName, stepNum)
tic
if nargin < 2
    % this is the level the function is called recurcively and should not
    % be used by the user, it helps to reduce the number of times loaded at
    % once
    stepNum = 0;
end

global confGen;
global conf2DPlot;

global s_maxNumRows2Read;
global s_maxNumRows2ReadBulk;
global s_maxNumRows2ReadBulkTotal;
global s_serialStartAbsolute;
global s_serialEndAbsolute;
global s_serialStart;
global s_serialStep;
global s_serialEnd;

global dataCollected;
global fullFldData;
global fullFldSizes;
global ctTimeDatas;
global ctRelVels;
global s_times;
global xLMrkr;
global yLMrkr;

global I_do2DColorPlot;
global I_plotTimeSlice;
global I_plotOnlyCrackPath;
global s_plot_contours;
% setGlobalValuesContour();

if nargin < 1
    configFileName = 'contourConfig';
end
pauseTime = 0.0;

confF = [configFileName, '.txt'];
fid = fopen(confF);

if fid < 0
    fprintf(1, 'contour config file does not exist\n %s', confF);
end

[confGen, confData, conf2DPlot, stepNumNew] = readContourPlotConfigFile(fid, stepNum);
fclose(fid);

maxNumRows2Read = confGen{s_maxNumRows2Read};
maxNumRows2ReadBulk = confGen{s_maxNumRows2ReadBulk};
maxNumRows2ReadBulkTotal = confGen{s_maxNumRows2ReadBulkTotal};

steps = confGen{s_serialStart}:confGen{s_serialStep}:confGen{s_serialEnd};
addMarkerData = 1;
b_plotMarkers4BulkContours = addMarkerData * confGen{s_plot_contours} * conf2DPlot{I_plotTimeSlice};

if (length(steps) == 1)
    serialNum = confGen{s_serialStart};
    aboluteSerialNumberAbs = (serialNum - confGen{s_serialStartAbsolute}) / confGen{s_serialStep} + 1;
    aboluteSerialNumberRel = (serialNum - confGen{s_serialStart}) / confGen{s_serialStep} + 1;
    num = (serialNum - confGen{s_serialStart}) / confGen{s_serialStep} + 1;
    if (confGen{s_plot_contours} == 1)
        plotSingleSerialContourDataMultipleSegments(confGen, confData, serialNum, aboluteSerialNumberRel, pauseTime, addMarkerData, maxNumRows2ReadBulk, maxNumRows2ReadBulkTotal);
    end
    
    if (conf2DPlot{I_plotTimeSlice} ~= 0)
        fidData = -1;
        noteof = 1;
        while (noteof ~= 0)
            dataCollected = cell(0);
            fullFldData = cell(0);
            fullFldSizes = cell(0);
            ctTimeDatas = cell(0);
            ctRelVels = cell(0);
            xLMrkr = cell(0);
            yLMrkr = cell(0);
            [dataCollected, fullFldData, fullFldSizes, ctTimeDatas, ctRelVels, xLMrkr, yLMrkr, noteof, fidData] = ...
                getMarkerDataContourPlot(fidData, maxNumRows2Read);

%            if (noteof == 1)
                if (conf2DPlot{I_plotOnlyCrackPath} == 1)
                    plotCrackPath2D(serialNum, aboluteSerialNumberRel, aboluteSerialNumberAbs, confGen{s_times}(num));
                end
                if (b_plotMarkers4BulkContours ~= 0)
                    plotMarkers4BulkContours(serialNumAbsolute);
                end
%            end
        end
    end
else
    if (conf2DPlot{I_plotTimeSlice} ~= 0)
        [dataCollected, fullFldData, fullFldSizes, ctTimeDatas, ctRelVels, xLMrkr, yLMrkr] = getMarkerDataContourPlot();
    end
    for serialNum = confGen{s_serialStart}:confGen{s_serialStep}:confGen{s_serialEnd}
        aboluteSerialNumberAbs = (serialNum - confGen{s_serialStartAbsolute}) / confGen{s_serialStep} + 1;
        aboluteSerialNumberRel = (serialNum - confGen{s_serialStart}) / confGen{s_serialStep} + 1;
        num = (serialNum - confGen{s_serialStart}) / confGen{s_serialStep} + 1;
        if (conf2DPlot{I_plotOnlyCrackPath} == 1)
            plotCrackPath2D(serialNum, aboluteSerialNumberRel, aboluteSerialNumberAbs, confGen{s_times}(num));
        end
       if (b_plotMarkers4BulkContours ~= 0)
            plotMarkers4BulkContours(serialNumAbsolute);
        end
        if (confGen{s_plot_contours} == 1)
            plotSingleSerialContourDataMultipleSegments(confGen, confData, serialNum, aboluteSerialNumberRel, ...
                pauseTime, addMarkerData, maxNumRows2ReadBulk, maxNumRows2ReadBulkTotal);
        end
    end
end



cls_
toc
if (stepNumNew > 0)
    generateContourPlots(configFileName, stepNumNew);
end