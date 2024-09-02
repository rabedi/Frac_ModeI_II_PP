function [dataCollected, fullFldData, fullFldSizes, ctTimeDatas, ctRelVels, xLMrkr, yLMrkr, noteof, fidDataOut] = ...
    getMarkerDataContourPlot(fidData, maxNumRows2Read)


if nargin < 1
    fidData = -2;
end

if nargin < 2
    maxNumRows2Read = inf;
end    



global confGen;
global conf2DPlot;

% spacesCT = []; valuesCT = []; dataCollectedCT = []; dSpacesCT = []; dValuesCT = []; dDataCollectedCT = []; fullFldSizesCT = []; fullFldDataCT = []; 
% ctTimeDatas = cell(0);
% ctRelVels = cell(0);
% ctPzSizes = cell(0);

dataCollected = cell(0);
fullFldData = cell(0);
fullFldSizes = cell(0);
ctTimeDatas = cell(0);
ctRelVels = cell(0);

global IplotAroundProcessZoneFactorX;
global IplotAroundProcessZoneFactorY;
global I_CrackTipFldsMarkerActive;


global s_x0_factor;
global s_x1_factor;
global s_serialStartAbsolute;
global s_serialEndAbsolute;
global s_serialStart;   
global s_serialStep;
global s_serialEnd;





u0Factor = confGen{s_x0_factor};
u1Factor = confGen{s_x1_factor};


global I_do2DColorPlot;
global I_plotTimeSlice;
global s_times;
global s_startTimes;
global s_timeStep;
global s_dir;
global s_runName;
global s_middlename;
global s_coord2sIndex;

global s_startCohNormalizer;
global s_incrmCohNormalizer;
global s_startLoadNormalizer;
global s_incrmLoadNormalizer;
global s_runData;

global I_TS_SliceDataName;
global I_TS_sliceReadFlag;
global I_TS_StatName;
global I_TS_ReqFlds;
global I_TS_numReqFlds;
global I_TS_CollectFlds;
global I_TS_numCollectFlds;
global I_TS_derOptionForTimeDerivatives;
global I_TS_maxPowerVelocitiesRoundOff;
global I_TS_readOnlyStat;
global I_fullFldSymbols;
global I_fullFldIndices;
global I_TS_numCollectOffset;
global CrIndex;

global I_CrackTipDataName;
global I_CrackTipReadFlag;
global I_CrackTipFldsName;
global I_CrackTipFldsMarkerStyle;
global I_CrackTipFldsMarkerColor;
global I_CrackTipFldsMarkerSize;
global I_CrackTipFldsMarkerActive;
global I_CrackTipStatName;
global I_CrackTipFullFldSymbols;
global I_CrackTipFullFldIndices;
global I_CrackTipFlagNum;

global ind_sl_nrmlzrT;
global ind_sl_dim;
global ind_sl_index;

if (length(confGen{s_times}) > 1)
    fidData = -2;
    maxNumRows2Read = inf;
end


reqNormalizer = ones(1, conf2DPlot{I_TS_numReqFlds});
for i = 1:conf2DPlot{I_TS_numReqFlds}
	normOption = conf2DPlot{I_TS_ReqFlds}{i}{ind_sl_nrmlzrT};
	dim = conf2DPlot{I_TS_ReqFlds}{i}{ind_sl_dim};
	fld = conf2DPlot{I_TS_ReqFlds}{i}{ind_sl_index};

    if (strcmp(normOption, 'relCoh') == 1)
        reqN = confGen{s_startCohNormalizer} + confGen{s_incrmCohNormalizer} * dim + fld;
        reqNormalizer(i) = confGen{s_runData}(reqN);
    elseif (strcmp(normOption, 'relLoad') == 1)
        reqN = confGen{s_startLoadNormalizer} + confGen{s_incrmLoadNormalizer} * dim + fld;
        reqNormalizer(i) = confGen{s_runData}(reqN);
    end
end    

colNormalizer = ones(1, conf2DPlot{I_TS_numCollectFlds});
for i = 1:conf2DPlot{I_TS_numCollectFlds}
	normOption = conf2DPlot{I_TS_CollectFlds}{i}{ind_sl_nrmlzrT};
	dim = conf2DPlot{I_TS_CollectFlds}{i}{ind_sl_dim};
	fld = conf2DPlot{I_TS_CollectFlds}{i}{ind_sl_index};

    if (strcmp(normOption, 'relCoh') == 1)
        colN = confGen{s_startCohNormalizer} + confGen{s_incrmCohNormalizer} * dim + fld;
        colNormalizer(i) = confGen{s_runData}(colN);
    elseif (strcmp(normOption, 'relLoad') == 1)
        colN = confGen{s_startLoadNormalizer} + confGen{s_incrmLoadNormalizer} * dim + fld;
        colNormalizer(i) = confGen{s_runData}(colN);
    end
end    




matrixTypeOutput = 0;
computeDerivatives = 0;
returnInfs = 1;
offset = conf2DPlot{I_TS_numCollectOffset};
flagNum = -1;


if (conf2DPlot{I_plotTimeSlice} == 0)
    spaces = []; values = []; dataCollected = []; dSpaces = []; dValues = []; dDataCollected = []; fullFldSizes = []; fullFldData = []; 
    startPX = cell(0);
    endPX = cell(0);
    startPY = cell(0);
    endPY = cell(0);
else
    [spaces, values, dataCollected, dSpaces, dValues, dDataCollected, fullFldSizes, fullFldData, noteof, fidDataOut] =...
    getSelectedFldsSelectedPts(confGen{s_times}, confGen{s_startTimes}, confGen{s_timeStep}, confGen{s_dir}, confGen{s_runName}, ...
	confGen{s_middlename}, conf2DPlot{I_TS_SliceDataName},conf2DPlot{I_TS_sliceReadFlag}, conf2DPlot{I_TS_StatName},...
	conf2DPlot{I_TS_ReqFlds}, conf2DPlot{I_TS_CollectFlds}, matrixTypeOutput, computeDerivatives, conf2DPlot{I_TS_derOptionForTimeDerivatives}, ...
	conf2DPlot{I_TS_maxPowerVelocitiesRoundOff}, returnInfs, conf2DPlot{I_TS_readOnlyStat}, confGen{s_coord2sIndex}, ...
	colNormalizer, reqNormalizer, conf2DPlot{I_fullFldSymbols}, conf2DPlot{I_fullFldIndices}, flagNum, fidData, maxNumRows2Read);

    for fld = 1:conf2DPlot{I_TS_numReqFlds}
        for ind = 1:length(dataCollected{fld})
            if (length(dataCollected{fld}{ind}) > 0)
                dataCollected{fld}{ind}(:, 1) = dataCollected{fld}{ind}(:, 1) + u0Factor * dataCollected{fld}{ind}(:, 3);
                dataCollected{fld}{ind}(:, 2) = dataCollected{fld}{ind}(:, 2) + u1Factor * dataCollected{fld}{ind}(:, 4);
            end
        end
    end

    offsetPZpts = 1;
    for pz = 1:4
        fld = offsetPZpts + pz;
        for ind = 1:length(dataCollected{fld})
        pzX{ind}(pz) = -inf;
        pzY{ind}(pz) = -inf;
            if (length(dataCollected{fld}{ind}) > 0)
                [ro, co] = size(dataCollected{fld}{ind});
                for r = 1:ro
                    pzX{ind}(pz) = max(pzX{ind}(pz), dataCollected{fld}{ind}(r, 1));
                    pzY{ind}(pz) = max(pzY{ind}(pz), dataCollected{fld}{ind}(r, 2));
                end
            end
        end
    end
    
    
    for ind = 1:length(fullFldData)
        if (length(fullFldData{ind}) > 0)
            fullFldData{ind}(:, 1) = fullFldData{ind}(:, 1) + u0Factor * fullFldData{ind}(:, 3);
            fullFldData{ind}(:, 2) = fullFldData{ind}(:, 2) + u1Factor * fullFldData{ind}(:, 4);
        end
    end
    for pt = 1:length(pzX)
        [startPX{pt}, endPX{pt}, startPY{pt}, endPY{pt}] = computeLimitsAroundProcessZoneContourPlots(pzX{pt}, pzY{pt});
    end
end



    

% global flagValueFile; 
% global flagDataFile;
% global CZstartIndex;
% global CZendIndex; 
% global CTindex;
% global startCohFaceIndex;
% global CZstaticSizeIndex;
% 
% global s_runData;
% confGen{s_runData}

if (conf2DPlot{I_CrackTipFldsMarkerActive} == 0)
    ctTimeDatas = cell(0);
    ctRelVels = cell(0); 
    xLMrkr = cell(0);
    yLMrkr = cell(0);
    return;
end

fidTemp = -2;
maxNumRows2ReadTemp = inf;



[spacesCT, valuesCT, dataCollectedCT, dSpacesCT, dValuesCT, dDataCollectedCT, fullFldSizesCT, fullFldDataCT, noteofTemp, fidOutTemp] =...
getSelectedFldsSelectedPts(0, 0, 1, confGen{s_dir}, confGen{s_runName}, ...
confGen{s_middlename}, conf2DPlot{I_CrackTipDataName}, conf2DPlot{I_CrackTipReadFlag}, conf2DPlot{I_CrackTipStatName},...
[], [], matrixTypeOutput, computeDerivatives, conf2DPlot{I_TS_derOptionForTimeDerivatives}, ...
conf2DPlot{I_TS_maxPowerVelocitiesRoundOff}, returnInfs, 0, confGen{s_coord2sIndex}, ...
colNormalizer, reqNormalizer, conf2DPlot{I_CrackTipFullFldSymbols}, ...
conf2DPlot{I_CrackTipFullFldIndices}, conf2DPlot{I_CrackTipFlagNum}, flagNum, fidTemp, maxNumRows2ReadTemp);

fullFldDataCT = fullFldDataCT{1};
cR = confGen{s_runData}(CrIndex);
if (length(fullFldDataCT) > 0)
    fullFldDataCT(:, offset + 2) = fullFldDataCT(:, offset + 2) / cR;
    fullFldDataCT(:, 1) = fullFldDataCT(:, 1) + u0Factor * fullFldDataCT(:, 3);
    fullFldDataCT(:, 2) = fullFldDataCT(:, 2) + u1Factor * fullFldDataCT(:, 4);
end

for serialNum = confGen{s_serialStart}:confGen{s_serialStep}:confGen{s_serialEnd}
    time = (serialNum - 1) * confGen{s_timeStep} + confGen{s_startTimes}; 
    absoluteSerial = (serialNum - confGen{s_serialStartAbsolute}) / confGen{s_serialStep} + 1;
    ind = find(DoublesAreEqual(time, fullFldDataCT(:, offset + 1), 1e-6));
    if (length(ind) > 0)
        ctTimeData = fullFldDataCT(ind, :);
        ctTimeData = sortrows(ctTimeData, [offset + 4]);
        ctRelVel = ctTimeData(:, offset + 2);
        ctPzSize = ctTimeData(:, offset + 3);
    else
        ctTimeData = [];
        ctRelVel = [];
        ctPzSize = [];
    end
    if (length(ind) > 0)
        ctTimeDatas{absoluteSerial} = ctTimeData;
        ctRelVels{absoluteSerial} = ctRelVel;
        ctPzSizes{absoluteSerial} = ctPzSize;
        [ctVel, ctInd] = max(ctRelVel);
    end
%         ctX = ctTimeData(ctInd, 1);
%         ctY = ctTimeData(ctInd, 2);
%    else
%         if (strcmp(confGen{s_runName}, 'XuN') == 1)
%             ctX = 4.25;
%             ctY = 0.0;
%         elseif (strcmp(confGen{s_runName}, 'shf') == 1)
%             ctX = 2.0;
%             ctY = 0.0;
%         end
%     end
%     delX = conf2DPlot{I_CrackTipXSpanPlots};
%     delY = conf2DPlot{I_CrackTipYSpanPlots};
%     xLMrkr{absoluteSerial} = [(ctX - delX) (ctX + delX)];
%     yLMrkr{absoluteSerial} = [(ctY - delY) (ctY + delY)];
    
    xLMrkr{absoluteSerial} = [startPX{absoluteSerial} endPX{absoluteSerial}];
    yLMrkr{absoluteSerial} = [startPY{absoluteSerial} endPY{absoluteSerial}];
end