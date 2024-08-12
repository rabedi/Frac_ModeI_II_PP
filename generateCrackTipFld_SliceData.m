function [data, names] = generateCrackTipFld_SliceData(ctTimes, pts, vals, collectData, flagDataFileTemp, colNormalizer, directory, runname, middlename)


returnInfs = 1;

global startTimeIndex;
% global endTimeIndex;
global timeIncrementInex;



global cnfg;
global I_TS_addData;
global I_TS_StatName;
global I_TS_readOnlyStat;
global I_TS_SliceDataName;
global I_TS_sliceReadFlag;
global I_TS_derOptionForTimeDerivatives;
global I_TS_interpolantOptCZEndPoints;
global I_TS_maxPowerVelocitiesRoundOff;
global I_TS_numReqFlds;
global I_TS_ReqFldsSymbol;
global I_TS_ReqFldsIndex;
global I_TS_ReqFldsFinderType;
global I_TS_numCollectFlds;
global I_TS_CollectFldsSymbol;
global I_TS_CollectFldsIndex;
global I_TS_CollectFldsNormalizerType;
global I_TS_ReqFlds;
global I_TS_ReqFldsNormalizerType;
global I_TS_CollectFlds;
global Icoord2sIndex;

global IstartCohNormalizer;
global IincrmCohNormalizer;
global IstartLoadNormalizer;
global IincrmLoadNormalizer;

startTime = flagDataFileTemp(startTimeIndex);
timeStep = flagDataFileTemp(timeIncrementInex);

statBriefName = cnfg{I_TS_StatName};
sliceName = cnfg{I_TS_SliceDataName};
sliceReadFlag = cnfg{I_TS_sliceReadFlag};
matrixTypeOutput = 1;
computeDerivatives = 1;
derMethod = cnfg{I_TS_derOptionForTimeDerivatives};
maxPower = cnfg{I_TS_maxPowerVelocitiesRoundOff};
returnInfs = 1;
useOnlyStat = cnfg{I_TS_readOnlyStat};
indexCoord2SpaceExtermums = cnfg{Icoord2sIndex};

numReq = cnfg{I_TS_numReqFlds};
numCol = cnfg{I_TS_numCollectFlds};
numT = length(ctTimes);
offset = 3;
numReqExt = numReq + offset;

reqNormalizer = ones(1, numReq);
for i = 1:numReq
	normOption = cnfg{I_TS_ReqFldsNormalizerType}{i};
    dim = cnfg{I_TS_ReqFlds}{i}{5};
    fld = cnfg{I_TS_ReqFldsIndex}{i};

%     if (strcmp(normOption, 'none') == 1)
%         reqNormalizer(i) = 1.0;
    if (strcmp(normOption, 'relCoh') == 1)
        reqN = cnfg{IstartCohNormalizer} + cnfg{IincrmCohNormalizer} * dim + fld;
        reqNormalizer(i) = flagDataFileTemp(reqN);
    elseif (strcmp(normOption, 'relLoad') == 1)
        reqN = cnfg{IstartLoadNormalizer} + cnfg{IincrmLoadNormalizer} * dim + fld;
        reqNormalizer(i) = flagDataFileTemp(reqN);
    end
end    


[spaces, values, dataCollected, dSpaces, dValues, dDataCollected, fullFldSizes, fullFldData] = ...
getSelectedFldsSelectedPts(ctTimes , startTime, timeStep, ...
directory, runname, middlename, sliceName,sliceReadFlag, statBriefName, ...
cnfg{I_TS_ReqFlds}, cnfg{I_TS_CollectFlds}, matrixTypeOutput, computeDerivatives, derMethod, maxPower, ...
returnInfs, useOnlyStat, indexCoord2SpaceExtermums, colNormalizer, reqNormalizer);

dels = pts{3} - pts{1};

relS = zeros(numT, numReqExt);
% DrelS = zeros(numT, numReqExt);
S = zeros(numT, numReqExt);
DS = zeros(numT, numReqExt);
Vals = zeros(numT, numReqExt);
DVals = zeros(numT, numReqExt);
colD = cell(numReqExt);
DcolD = cell(numReqExt);
%relS(:, 1) = 0;
relS(:, 3) = 1;
relS(:, 2) = (pts{2} - pts{1}) ./ dels;






for j = 1:offset
    S(:, j) = pts{j};
    Vals(:, j) = vals{j};
    colD{j} = collectData{j};
    DcolD{j} = takeDerivative(ctTimes, colD{j}, derMethod, maxPower, returnInfs);
end
DS(:, 1:offset) = takeDerivative(ctTimes, S(:, 1:offset), derMethod, maxPower, returnInfs);
DVals(:, 1:offset) = takeDerivative(ctTimes, Vals(:, 1:offset), derMethod, maxPower, returnInfs);

for fld = 1:numReq
    relS(:, fld + offset) = (spaces{fld} - pts{1}) ./ dels;

    S(:, fld + offset) = spaces{fld};
    DS(:, fld + offset) = dSpaces{fld};
    Vals(:, fld + offset) = values{fld};
    DVals(:, fld + offset) = dValues{fld};
    
    
    if (cnfg{I_TS_readOnlyStat} == 1)
        colD{fld + offset} = zeros(numT, numCol);
        DcolD{fld + offset} = zeros(numT, numCol);
    else
        colD{fld + offset} = dataCollected{fld};
        DcolD{fld + offset} = dDataCollected{fld};
    end
end

DrelS = takeDerivative(ctTimes, relS, derMethod, maxPower, returnInfs);

numTotFlds = (6 + 2 * numCol) * numReqExt;
data = cell(1);
names = cell(1);
data{1} = zeros(numT, numTotFlds);

colCntr = 1;
for fld = 1:numReqExt
    data{1}(:, colCntr) = relS(:, fld);
    names{1}{colCntr} = ['relS_', num2str(fld)];
    colCntr = colCntr + 1;

    data{1}(:, colCntr) = DrelS(:, fld);
    names{1}{colCntr} = ['DrelS_', num2str(fld)];
    colCntr = colCntr + 1;
    
    data{1}(:, colCntr) = S(:, fld);
    names{1}{colCntr} = ['S_', num2str(fld)];
    colCntr = colCntr + 1;

    data{1}(:, colCntr) = DS(:, fld);
    names{1}{colCntr} = ['DS_', num2str(fld)];
    colCntr = colCntr + 1;

    data{1}(:, colCntr) = Vals(:, fld);
    names{1}{colCntr} = ['Vals_', num2str(fld)];
    colCntr = colCntr + 1;

    data{1}(:, colCntr) = DVals(:, fld);
    names{1}{colCntr} = ['DVals_', num2str(fld)];
    colCntr = colCntr + 1;
    
    for clfd = 1:numCol
       data{1}(:, colCntr) = colD{fld}(:, clfd);
       names{1}{colCntr} = ['Fld_',num2str(fld), '_ColData_', num2str(clfd)];
       colCntr = colCntr + 1;

       data{1}(:, colCntr) = DcolD{fld}(:, clfd);
       names{1}{colCntr} = ['Fld_',num2str(fld), '_DColData_', num2str(clfd)];
       colCntr = colCntr + 1;
    end
end
