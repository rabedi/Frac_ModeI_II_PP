function [startingPtsOut, sizeBreakPtsOut, colSizeOut, maxCrossOut, minVOut, minCoordOut, min_eIDOut, min_idOut, maxVOut, maxCoordOut, max_eIDOut, max_idOut, counterOut, averageOut, sumOut, sDiviationOut, fieldNameOut, dataOut]  = UpdateDataStat(ctTimes, startingPtsIn, sizeBreakPtsIn, colSizeIn, maxCrossIn, minVIn, minCoordIn, min_eIDIn, min_idIn, maxVIn, maxCoordIn, max_eIDIn, max_idIn, counterIn, averageIn, sumIn, sDiviationIn, fieldNameIn, dataIn, newDataIn, dateNamesIn, separateFldPerDataBlock, zeroDataSize, fldMult, typeMult, dimMult)
numBaseFlds = length(dateNamesIn);

startingPtsTmp = getNonZeroPartOfBreakingPoints(startingPtsIn);
startIndAd = length(startingPtsTmp);


numFlds(1) = length(dateNamesIn{1});
startFlds(1) = startingPtsIn(startIndAd) + numFlds(1);

for base = 2:numBaseFlds
    numFlds(base) = length(dateNamesIn{base});
    startFlds(base) = startFlds(base - 1) + numFlds(base);
end

if (separateFldPerDataBlock == 1)
    startsNew = startFlds;
else
    startsNew = startFlds(numBaseFlds);
end

numAddedStartPts = length(startsNew);


startingPtsOut = startingPtsIn;
for i = 1:numAddedStartPts
    startingPtsOut(startIndAd + i) = startsNew(i);
end
colSizeOut = startingPtsOut(startIndAd + numAddedStartPts);
sizeBreakPtsOut = sizeBreakPtsIn + numAddedStartPts;
maxCrossOut = maxCrossIn;


minVOut = minVIn;
minCoordOut = minCoordIn;
min_eIDOut = min_eIDIn;
min_idOut = min_idIn;
maxVOut = maxVIn;
maxCoordOut = maxCoordIn;
max_eIDOut = max_eIDIn;
max_idOut = max_idIn;
counterOut = counterIn;
averageOut = averageIn;
sumOut = sumIn;
sDiviationOut = sDiviationIn;
fieldNameOut = fieldNameIn;
dataOut = dataIn;

if (zeroDataSize == 1)
    return;
end



dataBlockNew = [];
for base = 1:numBaseFlds
    [iminV{base}, iminCoord{base}, imin_eID{base}, imin_id{base}, imaxV{base}, imaxCoord{base}, ...
        imax_eID{base}, imax_id{base}, icounter{base}, iaverage{base}, ...
        isums{base}, isDiviation{base}] = getStatisticForData(ctTimes, newDataIn{base});
    dataBlockNew = [dataBlockNew newDataIn{base}];
end

dataOut = [dataOut dataBlockNew];


cntr = length(fieldNameOut) + 1;
for base = 1:numBaseFlds
    minVOut = [minVOut iminV{base}];
    minCoordOut = [minCoordOut; iminCoord{base}];
    min_eIDOut = [min_eIDOut imin_eID{base}];
    min_idOut = [min_idOut imin_id{base}];
    maxVOut = [maxVOut imaxV{base}];
    maxCoordOut = [maxCoordOut; imaxCoord{base}];
    max_eIDOut = [max_eIDOut imax_eID{base}];
    max_idOut = [max_idOut imax_id{base}];
    counterOut = [counterOut icounter{base}];
    averageOut = [averageOut iaverage{base}];
    sumOut = [sumOut isums{base}];
    sDiviationOut = [sDiviationOut isDiviation{base}];

    for j = 1:length(dateNamesIn{base})
        fieldNameOut{cntr} = dateNamesIn{base}{j};
        cntr = cntr + 1;
    end
end


if (fldMult > 0)
    startingPtsOut(33) = fldMult;
    startingPtsOut(34) = typeMult;
    startingPtsOut(35) =  dimMult;
end