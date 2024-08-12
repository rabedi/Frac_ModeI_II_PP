function [startingPtsOut, sizeBreakPtsOut, colSizeOut, maxCrossOut, minVOut,...
    minCoordOut, min_eIDOut, min_idOut, maxVOut, maxCoordOut, max_eIDOut, max_idOut, ...
    counterOut, averageOut, sumOut, sDiviationOut, fieldNameOut, dataOut] =  ...
    UpdateCrackTipFld_SliceData(dataTimeVcR, pts, vals, collectData, colNormalizer, ...
    directory, runname, middlename, flagDataFileTemp, startingPtsIn, sizeBreakPtsIn, ...
    colSizeIn, maxCrossIn, minVIn, minCoordIn, min_eIDIn, min_idIn, maxVIn, maxCoordIn, ...
    max_eIDIn, max_idIn, counterIn, averageIn, sumIn, sDiviationIn, fieldNameIn, dataIn)

fldMult = -1;
typeMult = -1;
dimMult = -1;

separateFldPerDataBlock = 0;
dateNamesIn = cell(1, 1);
newDataIn = [];


global cnfg;
global I_TS_addData;






newDataAdded = cnfg{I_TS_addData};
zeroDataSize = ~newDataAdded;

ctTimes = dataTimeVcR(:, 1);

if (newDataAdded ~= 0)
    [newDataIn, dateNamesIn] = generateCrackTipFld_SliceData(ctTimes, pts, vals, collectData, flagDataFileTemp, colNormalizer, directory, runname, middlename);
end

[startingPtsOut, sizeBreakPtsOut, colSizeOut, maxCrossOut, minVOut, minCoordOut, min_eIDOut, min_idOut, maxVOut, ...
    maxCoordOut, max_eIDOut, max_idOut, counterOut, averageOut, sumOut, sDiviationOut, fieldNameOut, dataOut]  = ...
    UpdateDataStat(ctTimes, startingPtsIn, sizeBreakPtsIn, colSizeIn, maxCrossIn, minVIn, minCoordIn, min_eIDIn, ...
    min_idIn, maxVIn, maxCoordIn, max_eIDIn, max_idIn, counterIn, averageIn, sumIn, sDiviationIn, fieldNameIn, ...
    dataIn, newDataIn, dateNamesIn, separateFldPerDataBlock, zeroDataSize, fldMult, typeMult, dimMult);

