function [startingPtsOut, sizeBreakPtsOut, colSizeOut, maxCrossOut, minVOut, minCoordOut, min_eIDOut, min_idOut, maxVOut, ...
    maxCoordOut, max_eIDOut, max_idOut, counterOut, averageOut, sumOut, sDiviationOut, fieldNameOut, dataOut] = ...
    UpdateCrackTipFld_LEFM_solution(velFD, dataTimeVcR, directory, runname, middlename, flagDataFileTemp, startingPtsIn, ...
    sizeBreakPtsIn, colSizeIn, maxCrossIn, minVIn, minCoordIn, min_eIDIn, min_idIn, maxVIn, maxCoordIn, max_eIDIn, ...
    max_idIn, counterIn, averageIn, sumIn, sDiviationIn, fieldNameIn, dataIn, normalizedEnergyReleasesRate)

fldMult = -1;
typeMult = -1;
dimMult = -1;

separateFldPerDataBlock = 1;
dateNamesIn = cell(1, 3);
newDataIn = [];


global cnfg;
global Iadd_LEFM_Data;






newDataAdded = cnfg{Iadd_LEFM_Data};
zeroDataSize = ~newDataAdded;


if (newDataAdded ~= 0)
    [newDataIn, dateNamesIn] = generateLEFMRelatedCrackData(dataTimeVcR, velFD, flagDataFileTemp, normalizedEnergyReleasesRate);
end
ctTimes = dataTimeVcR(:, 1);

[startingPtsOut, sizeBreakPtsOut, colSizeOut, maxCrossOut, minVOut, minCoordOut, min_eIDOut, min_idOut, maxVOut, ...
    maxCoordOut, max_eIDOut, max_idOut, counterOut, averageOut, sumOut, sDiviationOut, fieldNameOut, dataOut]  = ...
    UpdateDataStat(ctTimes, startingPtsIn, sizeBreakPtsIn, colSizeIn, maxCrossIn, minVIn, minCoordIn, min_eIDIn, ...
    min_idIn, maxVIn, maxCoordIn, max_eIDIn, max_idIn, counterIn, averageIn, sumIn, sDiviationIn, fieldNameIn, ...
    dataIn, newDataIn, dateNamesIn, separateFldPerDataBlock, zeroDataSize, fldMult, typeMult, dimMult);

