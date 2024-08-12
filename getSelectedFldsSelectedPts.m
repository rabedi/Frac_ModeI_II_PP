function [spaces, values, dataCollected, dSpaces, dValues, dDataCollected, fullFldSizes, fullFldData, noteof, fidOut] = ...
    getSelectedFldsSelectedPts(ctTimes , startTime, timeStep, directory, runname, middlename, ...
    sliceName,sliceReadFlag, statBriefName, fldRequested, fldCollected, matrixTypeOutput, ...
    computeDerivatives, derMethod, maxPower, returnInfs, useOnlyStat, indexCoord2SpaceExtermums, ...
    colNormalizer, reqNormalizer, fullFldSymbols, fullFldIndices, flagNum, fid, maxNumRows2Read)




if nargin < 19
    colNormalizer = ones(length(fldCollected));
end

if nargin < 20
    reqNormalizer = ones(length(fldRequested));
end

if nargin < 21
 fullFldSymbols = cell(0);
end

if nargin < 22
   fullFldIndices = [];
end

if nargin < 23
    flagNum = -1;
end

if nargin < 24
    fid = -2;
end

if nargin < 25
    maxNumRows2Read = inf;
end


numTimes = length(ctTimes);

if (numTimes > 1)
    fid = -2;
    maxNumRows2Read = inf;
end


fullFldSizes = cell(0);
fullFldData = cell(0);



% indexCoord2SpaceExtermums
% is the index that changes coordinate to space
if (computeDerivatives == 1)
    matrixTypeOutput = 1;
end

if ((computeDerivatives == 1) || (useOnlyStat == 0))
    matrixFormData = 1;
end

tol = 1e-6;

spaces = cell(0);
values = cell(0);
dataCollected = cell(0);
dSpaces = cell(0);
dValues = cell(0);
dDataCollected = cell(0);

matrixFormData = 1;

numReq = length(fldRequested);




maxNumRows2ReadTemp = 10;
fidTemp = -1;
serialNum = round((ctTimes(1) - startTime) / timeStep) + 1;
[dataUnitSizeTemp, dataTemp, startingPts, sizeBreakPts, col, colSize, minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, ...
    max_id, Counter, average, sum, sDiviation, fieldName, noteofTemp, fidOutTemp] = ...
    readSliceFile(directory, runname, middlename, statBriefName, sliceName, sliceReadFlag, flagNum, serialNum, 1, 1, fidTemp, maxNumRows2ReadTemp);

reqFldNum = cell(0);
reqFldSearchType = cell(0);
reqFldSearchVal = cell(0);
spaceIndex = getColNumberFromSymbolNumber('space', 0, startingPts);
timeIndex = getColNumberFromSymbolNumber('time', 0, startingPts);
for fld = 1:numReq
    reqFldNum{fld} = getColNumberFromSymbolNumber(fldRequested{fld}{1}, fldRequested{fld}{2}, startingPts);
    reqFldSearchVal{fld} = inf;
    reqFldSearchType{fld} = fldRequested{fld}{3};
    numTemp = str2num(reqFldSearchType{fld});
    if (length(numTemp) > 0)
        reqFldSearchVal{fld} = numTemp;
    end
end


sizeFullFld = length(fullFldSymbols);
fullDataColNo = zeros(1, sizeFullFld);
for i = 1:sizeFullFld
    fullDataColNo(i) = getColNumberFromSymbolNumber(fullFldSymbols{i}, fullFldIndices(i), startingPts);
end



numCol = length(fldCollected);
colFldNum = [];
for fldc = 1:numCol
    colFldNum(fldc) = getColNumberFromSymbolNumber(fldCollected{fldc}{1}, fldCollected{fldc}{2}, startingPts);
end



for tind = 1:numTimes
    
    serialNum = round((ctTimes(tind) - startTime) / timeStep) + 1;
    [dataUnitSizeTemp, dataTemp, startingPts, sizeBreakPts, col, colSize, minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, ...
        max_id, Counter, average, sum, sDiviation, fieldName, noteof, fidOut] = ...
        readSliceFile(directory, runname, middlename, statBriefName, sliceName, sliceReadFlag, flagNum, serialNum,1 , useOnlyStat, fid, maxNumRows2Read);
    
    if ((sizeFullFld > 0) && (useOnlyStat == 0))
        fullFldSizes{tind} = dataUnitSizeTemp;
        fullFldData{tind} = dataTemp(:, fullDataColNo);
        [m, n] = size(fullFldData{tind});
        for i = 1:m
            x = fullFldData{tind}(i, 1);
            y = fullFldData{tind}(i, 2);
            n1 = fullFldData{tind}(i, 8);
            n2 = fullFldData{tind}(i, 9);
            ns = sqrt(n1 * n1 + n2 * n2);
            if ((ns > 1.01) || (ns < 0.9))
                n1
                n2
%                pause;
                fprintf(1, 'error in file getSelectedFldsSelectedPts\n');
                n1 = NaN;
                n2 = NaN;
            else
                n1 = n1 / ns;
                n2 = n2 / ns;
            end
            n1 = n1 / ns;
            n2 = n2 / ns;
            delun = fullFldData{tind}(i, 6);
            delut = fullFldData{tind}(i, 7);
            delu1 = delun * n1 - delut * n2;
            delu2 = delun * n2 + delut * n1;
            fullFldData{tind}(i, 6) = delu1;
            fullFldData{tind}(i, 7) = delu2;
        end
    end
    
     if ((DoublesAreEqual(ctTimes(tind) , minV(timeIndex), tol) == 0) && (flagNum < 0))
         ctTimes_tind = ctTimes(tind)
         minV_timeIndex = minV(timeIndex)
         fprintf(1, 'wrong slab file loaded\n');
         pause
     end
    
    if (useOnlyStat == 1)
        for fld = 1:numReq
            spaces{fld}{tind} = inf;
            values{fld}{tind} = inf;
        end
        
        for fld = 1:numReq
            if (strcmp(reqFldSearchType{fld}, 'min') == 1)
                spaces{fld}{tind} = minCoord(reqFldNum{fld}, indexCoord2SpaceExtermums);
                values{fld}{tind} = minV(reqFldNum{fld}) / reqNormalizer(fld);
            elseif (strcmp(reqFldSearchType{fld}, 'max') == 1)
                spaces{fld}{tind} = maxCoord(reqFldNum{fld}, indexCoord2SpaceExtermums);
                values{fld}{tind} = maxV(reqFldNum{fld}) / reqNormalizer(fld);
            elseif (strcmp(reqFldSearchType{fld}, 'maxAbs') == 1)
                maxS_ = maxCoord(reqFldNum{fld}, indexCoord2SpaceExtermums);
                maxV_ = maxV(reqFldNum{fld});
                minS_ = minCoord(reqFldNum{fld}, indexCoord2SpaceExtermums);
                minV_ = minV(reqFldNum{fld});
                
                if (abs(maxV_) >= abs(minV_))
                    spaces{fld}{tind} = maxS_;
                    values{fld}{tind} = abs(maxV_) / reqNormalizer(fld);
                else
                    spaces{fld}{tind} = minS_;
                    values{fld}{tind} = abs(minV_) / reqNormalizer(fld);
                end
            end
        end
        continue;
    end
    for fld = 1:numReq
        if (strcmp(reqFldSearchType{fld}, 'min') == 1)
            [val, ind] = min(dataTemp(:, reqFldNum{fld}));
            spaces{fld}{tind} = dataTemp(ind, spaceIndex);
            values{fld}{tind} = val / reqNormalizer(fld);
            dataCollected{fld}{tind} = dataTemp(ind, colFldNum)  ./ colNormalizer;
        elseif (strcmp(reqFldSearchType{fld}, 'max') == 1)
            [val, ind] = max(dataTemp(:, reqFldNum{fld}));
            spaces{fld}{tind} = dataTemp(ind, spaceIndex);
            values{fld}{tind} = val / reqNormalizer(fld);
            dataCollected{fld}{tind} = dataTemp(ind, colFldNum) ./ colNormalizer;
        elseif (strcmp(reqFldSearchType{fld}, 'maxAbs') == 1)
            [val, ind] = max(abs(dataTemp(:, reqFldNum{fld})));
            spaces{fld}{tind} = dataTemp(ind, spaceIndex);
            values{fld}{tind} = val / reqNormalizer(fld);
            dataCollected{fld}{tind} = dataTemp(ind, colFldNum)  ./ colNormalizer;
        else
            [ind1, ind2] = find(DoublesAreEqual(dataTemp(:, reqFldNum{fld}) , reqFldSearchVal{fld}, tol));
            lenind1 = length(ind1);
            if (lenind1 > 0)
                spaces{fld}{tind} = dataTemp(ind1, spaceIndex);
                values{fld}{tind} = dataTemp(ind1, reqFldNum{fld}) / reqNormalizer(fld);
                dataCollected{fld}{tind} = dataTemp(ind1, colFldNum);
                for row = 1:lenind1
                    dataCollected{fld}{tind}(row, :) = dataCollected{fld}{tind}(row, :)  ./ colNormalizer;                
                end
            else
                spaces{fld}{tind} = inf;
                values{fld}{tind} = inf;
                dataCollected{fld}{tind} = inf * ones(1, numCol);
            end
        end
    end
end
if (matrixTypeOutput == 1)
    spacesTemp = spaces;
    valuesTemp = values;
    clear spaces;
    clear values;
    spaces = cell(numReq, 1);
    values = cell(numReq, 1);
    for fld = 1:numReq
        spaces{fld} = zeros(numTimes, 1);
        values{fld} = zeros(numTimes, 1);
        for tind = 1:numTimes
            spaces{fld}(tind) = spacesTemp{fld}{tind}(1);
            values{fld}(tind) = valuesTemp{fld}{tind}(1);
        end
    end
    if (computeDerivatives == 1)
        for fld = 1:numReq
            dSpaces{fld} = takeDerivative(ctTimes, spaces{fld}, derMethod, maxPower, returnInfs);
            dValues{fld} = takeDerivative(ctTimes, values{fld}, derMethod, maxPower, returnInfs);
        end
    end
    if (useOnlyStat == 0)
        dataCollectedTemp = dataCollected;
        clear dataCollected;   
        dataCollected = cell(numReq, 1);
        for fld = 1:numReq
            dataCollected{fld} = zeros(numTimes, numCol);
            for tind = 1:numTimes
                dataCollected{fld}(tind, :) = dataCollectedTemp{fld}{tind}(1, :);
            end
        end
        
        if (computeDerivatives == 1)
            for fld = 1:numReq
                dDataCollected{fld} = takeDerivative(ctTimes, dataCollected{fld}, derMethod, maxPower, returnInfs);
            end
        end
    end
end
