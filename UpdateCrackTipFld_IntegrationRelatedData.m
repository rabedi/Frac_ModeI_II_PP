function [startingPtsOut, sizeBreakPtsOut, colSizeOut, maxCrossOut, minVOut, minCoordOut, min_eIDOut, ...
    min_idOut, maxVOut, maxCoordOut, max_eIDOut, max_idOut, counterOut, averageOut, sumOut,...
    sDiviationOut, fieldNameOut, dataOut, energyReleaseRate] = ...
    UpdateCrackTipFld_IntegrationRelatedData(dataTimeVcR, ctVelFD, directory, runname, middlename, flagDataFileTemp, ...
    startingPtsIn, sizeBreakPtsIn, colSizeIn, maxCrossIn, minVIn, minCoordIn, min_eIDIn, min_idIn, ...
    maxVIn, maxCoordIn, max_eIDIn, max_idIn, counterIn, averageIn, sumIn, sDiviationIn, fieldNameIn, dataIn)

separateFldPerDataBlock = 0;
dateNamesIn = cell(1, 2);
newDataIn = [];


global nrmlzrRun;
global nrmlzrSptl;
global nrmlzrPW;
nrmlzrRun = 1;
nrmlzrSptl = 2;
nrmlzrPW = 3;


global cnfg;
global IcohesiveZoneSizeConfigFileName;
global IaddIntegrateData
global IitegateDataFileName
global IderDataFileName
global IitegrationNormalizationOption

ctTimes = dataTimeVcR(:,1);
%ctVel = dataTimeVcR(:,2);
% finite difference crack velocity is less noisy and gives better results
% for energy release rate
ctVel = ctVelFD;


newDataAdded = cnfg{IaddIntegrateData};
zeroDataSize = ~newDataAdded;
fldMult = -1;
typeMult = -1;
dimMult = -1;

global timeIncrementInex;
global startTimeIndex;

timeStart = flagDataFileTemp(startTimeIndex);
timeStep = flagDataFileTemp(timeIncrementInex);


if (newDataAdded ~= 0)
    filename = getFileName(directory, runname, middlename, -1, cnfg{IderDataFileName}, -1, 'txt');
    fidSpt = fopen(filename, 'r');
    if (fidSpt < 0)
        fprintf(1, 'cannot open %s\n',  filename);
        pause;
    end

    filename = getFileName(directory, runname, middlename, -1, cnfg{IitegateDataFileName}, -1, 'txt');
    fidInt = fopen(filename, 'r');
    if (fidSpt < 0)
        fprintf(1, 'cannot open %s\n',  filename);
        pause;
    end
    normalizerOption = cnfg{IitegrationNormalizationOption};

    numDflds = 3;

    [newDataIn, dateNamesIn, numBaseFlds, fldMult, typeMult, dimMult, energyReleaseRate] = generateIntegrationRelatedCrackData(fidInt, fidSpt, timeStart, timeStep, ctTimes, ctVel, normalizerOption, numDflds);
end

[startingPtsOut, sizeBreakPtsOut, colSizeOut, maxCrossOut, minVOut, minCoordOut, min_eIDOut, min_idOut, maxVOut, ...
    maxCoordOut, max_eIDOut, max_idOut, counterOut, averageOut, sumOut, sDiviationOut, fieldNameOut, dataOut]  = ...
    UpdateDataStat(ctTimes, startingPtsIn, sizeBreakPtsIn, colSizeIn, maxCrossIn, minVIn, minCoordIn, min_eIDIn, ...
    min_idIn, maxVIn, maxCoordIn, max_eIDIn, max_idIn, counterIn, averageIn, sumIn, sDiviationIn, fieldNameIn, ...
    dataIn, newDataIn, dateNamesIn, separateFldPerDataBlock, zeroDataSize, fldMult, typeMult, dimMult);
