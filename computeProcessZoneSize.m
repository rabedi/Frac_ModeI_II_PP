function [cohZoneReduction, dataTimeSortedSpaceClusterReduction, cohZoneReductionDerivative, dataTimeSortedSpaceClusteredReducedDerivative]...
    = computeProcessZoneSize(directory, runname, middlename, flagnum, name, serial, ext, nameStat, serialStat, extStat, flagNoInStart, ...
    flagNoInEnd, flagNoCT, startTime, endTime, incrementTime, maxSpaceDistanceInCluster, ClusterReductionMethod, startCohZoneReductionMethod, ...
    endCohZoneReductionMethod, cracktipVSymbol, cracktipVIndex, processZoneSizeSymbol, processZoneSizeIndex, derMethod, maxPIndexDiff, ...
    cohZoneFileName, modifierForHistoryFiles, flagDataFileTemp, startSpace, endSpace, cR)



global allowBinary;
if (allowBinary == 0) 
    ext = 'txt';
end

global fracEneryIndex;

global cnfg;
global IcohesiveZoneSizeConfigFileName;
%global I_TS_addData;
global I_TS_interpolantOptCZEndPoints;

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
global I_TS_CollectFlds;
global I_TS_CollectFldsNormalizerType;
global I_TS_processZoneValSymbol;
global I_TS_processZoneValIndex;
global I_TS_processZoneNormalizerRunFlagData;

global IstartCohNormalizer;
global IincrmCohNormalizer;
global IstartLoadNormalizer;
global IincrmLoadNormalizer;

global ImaxRelativeSpacePoint2PlotHistories;
global ImaxSpaceDotInClusterReductionRel2cR;


global IprocessZoneRelativeCrackOpeningSymbol;
global IprocessZoneRelativeCrackOpeningIndex;
global IprocessZoneCrackOpeningSymbol;
global IprocessZoneCrackOpeningIndex;
global ICrackOpeningSymbol;
global ICrackOpeningIndex;
%copd = crack opening
copdRelSym = cnfg{IprocessZoneRelativeCrackOpeningSymbol};
copdRelInd = cnfg{IprocessZoneRelativeCrackOpeningIndex};
copdAbsSym = cnfg{IprocessZoneCrackOpeningSymbol};
copdAbsInd = cnfg{IprocessZoneCrackOpeningIndex};
copdSym = cnfg{ICrackOpeningSymbol};
copdInd = cnfg{ICrackOpeningIndex};


% maxSpaceDistanceInCluster is at a time spatial distance of two points is
% less than this value they're clustered together in not they're in
% separate clusters
% ClusterReductionMethod:
% 1 means average    average of cluster values is considered correct value
% 2 means minSpatial data of min spatial value is representative of the
% cluster
% 3 means maxSpatial data of max spatial value is representative of the
% cluster
dimension = 2;


%check if the files exist no compute Again
 nameN = [name,modifierForHistoryFiles];
 doContinue = 0;

 for index = 1:  length(flagnum)
     flag = flagnum(index);
    filenameMod{flag} = getFileName(directory, runname, middlename, flag, nameN, serial, ext);
    fid = fopen(filenameMod{flag},'r');
    if (fid < 0)
        doContinue = 1;
    else
        fclose(fid);
    end
 end

 filenameCZ = getFileName(directory, runname, middlename, -1, cohZoneFileName, serial, ext);
 fid = fopen(filenameCZ,'r');
 if (fid < 0)
    doContinue = 1;
 else
    fclose(fid);
 end

% temporarily commented to replace bad existing files 
%
%  if (doContinue == 0)
%      return;
%  end
 


AsciiFormat = strcmp(ext, 'txt');

    
nonexistent = zeros(0,1);
 for index = 1:  length(flagnum)
     flag = flagnum(index);

   serialT = serial;
   if (serialT < 0)
       serialT = -2;
   end     
   filename = getFileName(directory, runname, middlename, flag, name, serialT, ext);
   fid = fopen(filename, 'r');

%reading stats for start and end of process zone    
   nam = getFileName(directory, runname, middlename, flag, nameStat, serialStat, extStat);
   fileNameStat{flag} = nam; 
   fidStat = fopen(fileNameStat{flag},'r');
    if (fidStat== -1)
        fprintf('unable to open %s', fileNameStat{flag});
        nonexistent(length(nonexistent) + 1) = flag;
        continue;
    end
    
    [startingPts{flag}, sizeBreakPts{flag}] = readStartingPoints(fidStat);
    col = startingPts{flag}(sizeBreakPts{flag});
    colSize = fscanf(fidStat,'%d', 1);
    maxCross = fscanf(fidStat,'%d', 1);
    
    [minVs, minCoords, min_eIDs, min_ids, maxVs, maxCoords, max_eIDs, max_ids, Counters, averages, sums, sDiviations, fieldNames] =  readBriefStat(fidStat, colSize);
    fclose(fidStat);
    minV{flag} = minVs;
    minCoord{flag} = minCoords;
    min_eID{flag} = min_eIDs;
    min_id{flag} = min_ids;
    maxV{flag} = min_ids;
    maxCoord{flag} = maxCoords;
    max_eID{flag} = max_eIDs;
    max_id{flag} = max_ids;
    Counter{flag} = Counters;
    average{flag} = averages;
    sum{flag} = sums;
    sDiviation{flag} = sDiviations;
    fieldName{flag} = fieldNames;
    
     
%reading each flag's data     
    counter = 1;
    while ((fid ~= -1) && (serialT ~= -1))
        [noteof, numpts, tmp] = readBlock(fid, col,AsciiFormat,  startingPts{flag});
        if (noteof ~= 0)
            data{flag}{counter} = tmp;
        end
        while (noteof ~= 0) 
            counter = counter + 1;
            [noteof, numpts, tmp] = readBlock(fid, col,AsciiFormat,  startingPts{flag});
            if (noteof ~= 0)
                data{flag}{counter} = tmp;
            end
        end
        serialT = serialT + 1;
        filename = getFileName(directory, runname, middlename, flag, name, serialT, ext);
        fclose(fid);
        if (serialT ~= -1)
            fid = fopen(filename);
        end
    end
%     for j = 1:length(data{flag})
%         data{flag}{j}
%     end
 end

 frac = cnfg{ImaxRelativeSpacePoint2PlotHistories};
 maxAllowableSpaceCoordinate = (1.0 - frac) * startSpace + frac * endSpace;
 spaceDotTol = cnfg{ImaxSpaceDotInClusterReductionRel2cR} * cR;

copdRelIndex  = getColNumberFromSymbolNumber(copdRelSym, copdRelInd, startingPts{flagNoCT});
copdAbsIndex  = getColNumberFromSymbolNumber(copdAbsSym, copdAbsInd, startingPts{flagNoCT});
copdIndex  = getColNumberFromSymbolNumber(copdSym, copdInd, startingPts{flagNoCT});

 
 for index = 1:  length(flagnum)
     flag = flagnum(index);
     if (length(find(nonexistent == flag)) > 0)
         continue;
     end
    timeIndex =  getColNumberFromSymbolNumber('time', 0, startingPts{flag});
    spaceIndex =  getColNumberFromSymbolNumber('space', 0, startingPts{flag});
    if (flag == flagNoCT)
        len = length(data{flag});
        for i = 1:len
            data{flag}{i}(copdRelIndex) = inf;
            data{flag}{i}(copdAbsIndex) = inf;
        end
    end
    dataTimeSortedSpaceClustered{flag} = indexOnPrimaryCellSortOnSecondaryColInClustersOfMaxDistance(data{flag}, timeIndex, startTime, endTime, incrementTime, spaceIndex, maxSpaceDistanceInCluster, spaceIndex, maxAllowableSpaceCoordinate);
    dataTimeSortedSpaceClusterReduction{flag} = clusterDataReduction(dataTimeSortedSpaceClustered{flag}, ClusterReductionMethod, spaceIndex, timeIndex, maxAllowableSpaceCoordinate);
 end
 timeIndex =  getColNumberFromSymbolNumber('time', 0, startingPts{1});
 spaceIndex =  getColNumberFromSymbolNumber('space', 0, startingPts{1});
 startCohZoneReduction = clusterDataReduction(dataTimeSortedSpaceClustered{flagNoInStart}, startCohZoneReductionMethod, spaceIndex, timeIndex, maxAllowableSpaceCoordinate);
 endCohZoneReduction = clusterDataReduction(dataTimeSortedSpaceClustered{flagNoInEnd}, endCohZoneReductionMethod, spaceIndex, timeIndex, maxAllowableSpaceCoordinate);

 
spaceIndexStart = getColNumberFromSymbolNumber('space', 0, startingPts{flagNoInStart});
spaceIndexEnd = getColNumberFromSymbolNumber('space', 0, startingPts{flagNoInEnd});



 
 InterestValIndexStart = getColNumberFromSymbolNumber(cnfg{I_TS_processZoneValSymbol}, cnfg{I_TS_processZoneValIndex}, startingPts{flagNoInStart});
 InterestValIndexEnd = getColNumberFromSymbolNumber(cnfg{I_TS_processZoneValSymbol}, cnfg{I_TS_processZoneValIndex}, startingPts{flagNoInEnd});


 
numCollectFlds = cnfg{I_TS_numCollectFlds}; 
for i = 1:numCollectFlds
    collectIndexStart(i) = getColNumberFromSymbolNumber(cnfg{I_TS_CollectFldsSymbol}{i}, cnfg{I_TS_CollectFldsIndex}{i}, startingPts{flagNoInStart});
    collectIndexEnd(i) = getColNumberFromSymbolNumber(cnfg{I_TS_CollectFldsSymbol}{i}, cnfg{I_TS_CollectFldsIndex}{i}, startingPts{flagNoInEnd});
    collectIndexCT(i)  = getColNumberFromSymbolNumber(cnfg{I_TS_CollectFldsSymbol}{i}, cnfg{I_TS_CollectFldsIndex}{i}, startingPts{flagNoCT});
end

 cohZoneReduction = dataTimeSortedSpaceClusterReduction{flagNoCT};
 pzIndex =  getColNumberFromSymbolNumber(processZoneSizeSymbol, processZoneSizeIndex, startingPts{flagNoCT});
 timeCTIndex =  getColNumberFromSymbolNumber('time', 0, startingPts{flagNoCT});

 
 offValuel = inf;
 sizeOneSolDerivativeVal = offValuel;
 numPts = length(cohZoneReduction);
 startPTemp = ones(numPts, 1)  * inf;
 endPTemp = ones(numPts, 1)  * inf;
 startValTemp = ones(numPts, 1)  * inf;
 endValTemp = ones(numPts, 1)  * inf;
 timesTemp = ones(numPts, 1) * inf;
 startCollectTemp = ones(numPts, numCollectFlds) * inf;
 endCollectTemp = ones(numPts, numCollectFlds) * inf;
 for i = 1: length(cohZoneReduction)
     for j = 1:length(cohZoneReduction{i})
         cohZoneReduction{i}{j}(pzIndex) = offValuel;
     end
 end 
 
% pzMax = -inf;
 cntR = 1;
 for i = 1: length(cohZoneReduction)
     lengthCluster = length(cohZoneReduction{i});
     if (lengthCluster == 0) 
         continue;
     end

     if ((length(startCohZoneReduction) < i) || (length(endCohZoneReduction) < i))
         continue;
     end
%      lensi = length(startCohZoneReduction{i}) 
%      lenei = length(endCohZoneReduction{i}) 
     if ((length(startCohZoneReduction{i}) ~= lengthCluster) || (length(endCohZoneReduction{i}) ~= lengthCluster))
        continue;
     end
     for j = 1:lengthCluster
%          if ((length(startCohZoneReduction{i}{j}) == 0) || (length(endCohZoneReduction{i}{j}) == 0))
%              continue;
%          end
%           i
%           j
%           spaceIndexEnd
%           spaceIndexStart
%          en = endCohZoneReduction{i}{j}(spaceIndexEnd)
%          st = startCohZoneReduction{i}{j}(spaceIndexStart)
%          pzIndex
         pzs = abs(startCohZoneReduction{i}{j}(spaceIndexStart) - endCohZoneReduction{i}{j}(spaceIndexEnd));
 %        pzMax = max(pzMax, pzs);
         cohZoneReduction{i}{j}(pzIndex) = pzs;
         cohZoneReduction{i}{j}(copdRelIndex) = endCohZoneReduction{i}{j}(copdIndex) - cohZoneReduction{i}{j}(copdIndex);
         cohZoneReduction{i}{j}(copdAbsIndex) = endCohZoneReduction{i}{j}(copdIndex);
         pzR(cntR) = cohZoneReduction{i}{j}(pzIndex);
         cntR = cntR + 1;
     end
     startPTemp(i) = startCohZoneReduction{i}{lengthCluster}(spaceIndexStart);
     endPTemp(i)   = endCohZoneReduction{i}{lengthCluster}(spaceIndexEnd);
     startValTemp(i) = startCohZoneReduction{i}{lengthCluster}(InterestValIndexStart);
     endValTemp(i)   = endCohZoneReduction{i}{lengthCluster}(InterestValIndexEnd);
     timesTemp(i) =  cohZoneReduction{i}{lengthCluster}(timeCTIndex);
     startCollectTemp(i, :) = startCohZoneReduction{i}{lengthCluster}(collectIndexStart);
     endCollectTemp(i, :) = endCohZoneReduction{i}{lengthCluster}(collectIndexEnd);
     
%     pzSR(cntR) = startCohZoneReduction{i}{j}(spaceIndexStart);
%     pzER(cntR) = endCohZoneReduction{i}{j}(spaceIndexEnd);
     
 end

 MAXRATIO = 12;
 returnInfs = 1;
 len = cntR - 1;
 cntR = 1;
 badInds = [];
 badIndInd = 1;
 for cr = 2:len - 1
     av = 0.5 * (pzR(cr - 1) + pzR(cr + 1));
     if (isfinite(computeRatioTwoSided(pzR(cr), av, MAXRATIO, returnInfs)) == 0)
         badInds(badIndInd) = cr;
         badIndInd = badIndInd + 1;
     end
 end
 if (badIndInd > 1)
     cntR = 1;
     for i = 1: length(cohZoneReduction)
         lengthCluster = length(cohZoneReduction{i});
         if (lengthCluster == 0) 
             continue;
         end
         if ((length(startCohZoneReduction) < i) || (length(endCohZoneReduction) < i))
             continue;
         end
         if ((length(startCohZoneReduction{i}) ~= lengthCluster) || (length(endCohZoneReduction{i}) ~= lengthCluster))
            continue;
         end
         gd = 1;
         for j = 1:lengthCluster
             if (length(find(badInds == cntR)) > 0)
                 gd = 0;
             end
             if (gd == 0)
                 cohZoneReduction{i}{j}(pzIndex) = NaN;
                 cohZoneReduction{i}{j}(copdRelIndex) = NaN;
                 cohZoneReduction{i}{j}(copdAbsIndex) = NaN;
             end
             cntR = cntR + 1;
         end
         if (gd == 0)
             startPTemp(i) = NaN;
             endPTemp(i)   = NaN;
             startValTemp(i) = NaN;
             endValTemp(i)   = NaN;
             timesTemp(i) =  NaN;
             startCollectTemp(i, :) = NaN;
             endCollectTemp(i, :) = NaN;
         end
    end
end
     
% timesTemp
% startPTemp
% endPTemp
[indTimesRed, tmp] = find(isfinite(timesTemp));
timesRed = timesTemp(indTimesRed);
startPRed = startPTemp(indTimesRed);
endPRed = endPTemp(indTimesRed);
startValRed = startValTemp(indTimesRed);
endValRed = endValTemp(indTimesRed);
startCollectRed = startCollectTemp(indTimesRed, :);
endCollectRed = endCollectTemp(indTimesRed, :);


 for index = 1:  length(flagnum)
     flag = flagnum(index);
     if (length(find(nonexistent == flag)) > 0)
         continue;
     end     
     [xValueIndex, yValueIndex, SolValueIndex] = getTimeDerivativeIndices(startingPts{flag}, dimension);
    dataTimeSortedSpaceClusteredReducedDerivative{flag} = takeDerivativeOfBlockData(dataTimeSortedSpaceClusterReduction{flag}, maxPIndexDiff, ...
        derMethod, xValueIndex, yValueIndex, SolValueIndex, sizeOneSolDerivativeVal, spaceIndex, timeIndex, spaceDotTol);
%    filename = getFileName(directory, runname, middlename, flag, nameN, serial, ext);
    fid = fopen(filenameMod{flag},'w');
    colNprintInt(1) = getColNumberFromSymbolNumber('eID', 0, startingPts{flag});
    colNprintInt(2) = getColNumberFromSymbolNumber('id', 0, startingPts{flag});
    printReducedClusterData(fid, dataTimeSortedSpaceClusteredReducedDerivative{flag}, colNprintInt);
    fclose(fid);
 end

 [xValueIndex, yValueIndex, SolValueIndex] = getTimeDerivativeIndices(startingPts{flagNoCT}, dimension);
 cohZoneReductionDerivative = takeDerivativeOfBlockData(cohZoneReduction, maxPIndexDiff, derMethod, xValueIndex, yValueIndex, ...
     SolValueIndex, sizeOneSolDerivativeVal, spaceIndex, timeIndex, spaceDotTol);

 
askedColumns(1) = getColNumberFromSymbolNumber('time', 0, startingPts{flagNoCT});
askedColumns(2) = getColNumberFromSymbolNumber(cracktipVSymbol, cracktipVIndex, startingPts{flagNoCT});
askedColumns(3) = getColNumberFromSymbolNumber(processZoneSizeSymbol, processZoneSizeIndex, startingPts{flagNoCT});
askedColumns(4) = getColNumberFromSymbolNumber('DspaceDT', 0, startingPts{flagNoCT});



spaceIndCT = getColNumberFromSymbolNumber('space', 0, startingPts{flagNoCT});
InterestValIndexCT = getColNumberFromSymbolNumber(cnfg{I_TS_processZoneValSymbol}, cnfg{I_TS_processZoneValIndex}, startingPts{flagNoInEnd});

  


dataTimeVcR = InquireReducedClusterDataSpecificValues(cohZoneReductionDerivative, colNprintInt, askedColumns);
CTPts = InquireReducedClusterDataSpecificValues(cohZoneReductionDerivative, colNprintInt, spaceIndCT);
CTVals = dataTimeVcR(:, 2);
CTCollect = InquireReducedClusterDataSpecificValues(cohZoneReductionDerivative, colNprintInt, collectIndexCT);
CTValsFD = dataTimeVcR(:, 4);



ctTimes = dataTimeVcR(:, 1);

%askedColumns
startPts = interp1(timesRed,startPRed, ctTimes , cnfg{I_TS_interpolantOptCZEndPoints});
endPts = interp1(timesRed,endPRed, ctTimes , cnfg{I_TS_interpolantOptCZEndPoints});
startVals = interp1(timesRed,startValRed, ctTimes , cnfg{I_TS_interpolantOptCZEndPoints});
endVals = interp1(timesRed,endValRed, ctTimes , cnfg{I_TS_interpolantOptCZEndPoints});
startCollect = interp1(timesRed, startCollectRed, ctTimes , cnfg{I_TS_interpolantOptCZEndPoints});
endCollect = interp1(timesRed, endCollectRed, ctTimes , cnfg{I_TS_interpolantOptCZEndPoints});


colNormalizer = ones(1, numCollectFlds);
for i = 1:numCollectFlds
	normOption = cnfg{I_TS_CollectFldsNormalizerType}{i};
    dim = cnfg{I_TS_CollectFlds}{i}{5};
    fld = cnfg{I_TS_CollectFldsIndex}{i};

%     if (strcmp(normOption, 'none') == 1)
%         colNormalizer(i) = 1.0;
    if (strcmp(normOption, 'relCoh') == 1)
        colN = cnfg{IstartCohNormalizer} + cnfg{IincrmCohNormalizer} * dim + fld;
        colNormalizer(i) = flagDataFileTemp(colN);
    elseif (strcmp(normOption, 'relLoad') == 1)
        colN = cnfg{IstartLoadNormalizer} + cnfg{IincrmLoadNormalizer} * dim + fld;
        colNormalizer(i) = flagDataFileTemp(colN);
    end
    startCollect(:, i) = startCollect(:, i) ./ colNormalizer(i);
    CTCollect(:, i)    = CTCollect(:, i) ./ colNormalizer(i);
    endCollect(:, i)   = endCollect(:, i) ./ colNormalizer(i);
end    

for i = 1:numCollectFlds
    if (strcmp(cnfg{I_TS_CollectFldsSymbol}{i}, 'flds') == 1)
        [ind, tmp] = find(startCollect(:, i) < 0);
        startCollect(ind, i) = inf;
        [ind, tmp] = find(endCollect(:, i) < 0);
        endCollect(ind, i) = inf;
    end
end

if (cnfg{I_TS_processZoneNormalizerRunFlagData} > 0)
    valNormalizer = flagDataFileTemp(cnfg{I_TS_processZoneNormalizerRunFlagData});
else
    valNormalizer = 1.0;
end
    

pts{1} = startPts;
pts{2} = CTPts;
pts{3} = endPts;
% pts{4} = CTPts;

vals{1} = startVals ./ valNormalizer;
vals{2} = CTVals ./ valNormalizer;
vals{3} = endVals ./ valNormalizer;
%vals{4} = CTValsFD ./ valNormalizer;
%velFD = CTValsFD ./ valNormalizer;
velFD = CTValsFD;

collectData{1} = startCollect;
collectData{2} = CTCollect;
collectData{3} = endCollect;
%collectData{4} = CTCollect;

% pts, vals, collectData

[startingPtsExp, sizeBreakPtsExp, colSizeExp, maxCrossExp, minVExp, minCoordExp, min_eIDExp, min_idExp, maxVExp, maxCoordExp, max_eIDExp, max_idExp, ...
    counterExp, averageExp, sumExp, sDiviationExp, fieldNameExp] = readCompleteStatBrief(fileNameStat{flagNoCT});

data = [];
[startingPtsExp, sizeBreakPtsExp, colSizeExp, maxCrossExp, minVExp, minCoordExp, min_eIDExp, min_idExp, maxVExp, maxCoordExp, max_eIDExp, ...
    max_idExp, counterExp, averageExp, sumExp, sDiviationExp, fieldNameExp, data, energtReleaseRate] = UpdateCrackTipFld_IntegrationRelatedData(...
    dataTimeVcR, velFD, directory, runname, middlename, flagDataFileTemp, startingPtsExp, sizeBreakPtsExp, colSizeExp, maxCrossExp, minVExp, minCoordExp, ...
    min_eIDExp, min_idExp, maxVExp, maxCoordExp, max_eIDExp, max_idExp, counterExp, averageExp, sumExp, sDiviationExp, fieldNameExp, data);

%workOfSeparation = flagDataFileTemp(fracEneryIndex)

[m,n] = size(energtReleaseRate);
coh_post_process_loc_Diss = 16;
for dim = 1:n
    colN = cnfg{IstartCohNormalizer} + cnfg{IincrmCohNormalizer} * (dim - 1) + coh_post_process_loc_Diss;
    workOfSeparation(dim) = flagDataFileTemp(colN);
end

for i = 1:m
    normalizedEnergyReleasesRate(i, :) = energtReleaseRate(i, :) ./ workOfSeparation;
end

%workOfSeparation


[startingPtsExp, sizeBreakPtsExp, colSizeExp, maxCrossExp, minVExp, minCoordExp, min_eIDExp, min_idExp, maxVExp, maxCoordExp, max_eIDExp, ...
    max_idExp, counterExp, averageExp, sumExp, sDiviationExp, fieldNameExp, data] = UpdateCrackTipFld_LEFM_solution(velFD, ...
    dataTimeVcR, directory, runname, middlename, flagDataFileTemp, startingPtsExp, sizeBreakPtsExp, colSizeExp, maxCrossExp, minVExp, minCoordExp, ...
    min_eIDExp, min_idExp, maxVExp, maxCoordExp, max_eIDExp, max_idExp, counterExp, averageExp, sumExp, sDiviationExp, fieldNameExp, data, normalizedEnergyReleasesRate);

[startingPtsExp, sizeBreakPtsExp, colSizeExp, maxCrossExp, minVExp, minCoordExp, min_eIDExp, min_idExp, maxVExp, maxCoordExp, max_eIDExp, ...
    max_idExp, counterExp, averageExp, sumExp, sDiviationExp, fieldNameExp, data] = UpdateCrackTipFld_SliceData(...
    dataTimeVcR, pts, vals, collectData, colNormalizer, directory, runname, middlename, flagDataFileTemp, startingPtsExp, sizeBreakPtsExp, colSizeExp, maxCrossExp, minVExp, minCoordExp, ...
    min_eIDExp, min_idExp, maxVExp, maxCoordExp, max_eIDExp, max_idExp, counterExp, averageExp, sumExp, sDiviationExp, fieldNameExp, data);

fileNameStatNew = getFileName(directory, runname, middlename, flagNoCT, cnfg{IcohesiveZoneSizeConfigFileName}, serialStat, 'txt');
writeCompleteStatBrief(fileNameStatNew, startingPtsExp, colSizeExp, maxCrossExp, minVExp, minCoordExp, min_eIDExp, min_idExp, maxVExp, ...
    maxCoordExp, max_eIDExp, max_idExp, counterExp, averageExp, sumExp, sDiviationExp, fieldNameExp);


fid = fopen(filenameCZ,'w');
colNprintInt(1) = getColNumberFromSymbolNumber('eID', 0, startingPts{flagNoCT});
colNprintInt(2) = getColNumberFromSymbolNumber('id', 0, startingPts{flagNoCT});
printReducedClusterData(fid, cohZoneReductionDerivative, colNprintInt, data);
fclose(fid);