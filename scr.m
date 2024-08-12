global nrmlzrRun;
global nrmlzrSptl;
global nrmlzrPW;

nrmlzrRun = 1;
nrmlzrSptl = 2;
nrmlzrPW = 3;

dat = load('../tVcR.txt');
ctTimes = dat(:,1);
ctVel = dat(:,2);
fidSpt = fopen('../trunk_working/physics/outputPP/XuNSLderFlds.txt', 'r');
fidInt = fopen('../trunk_working/physics/outputPP/XuNSLIntFlds.txt', 'r');
timeStep = 0.04;
normalizerOption = -1;
%[times, values, normalizers, numBaseFld] = readIntegratedRelatedFile(fid, timeStep, normalizerOption)

%[minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, counter, average, sums, sDiviation] = getStatisticForData(times, values{1})

numDflds = 3;
[dataPoints, names, numBaseFlds] = generateIntegrationRelatedCrackData(fidInt, fidSpt, timeStep, ctTimes, ctVel, normalizerOption, numDflds);
numBaseFlds = length(dataPoints);
for base = 1:numBaseFlds
    [iminV{base}, iminCoord{base}, imin_eID{base}, imin_id{base}, imaxV{base}, imaxCoord{base}, imax_eID{base}, imax_id{base}, icounter{base}, iaverage{base}, ...
        isums{base}, isDiviation{base}] = getStatisticForData(ctTimes, dataPoints{1});
end
% base = 1;
% iminV{base}, iminCoord{base}, imin_eID{base}, imin_id{base}, imaxV{base}, imaxCoord{base}, imax_eID{base}, imax_id{base}, icounter{base}, iaverage{base}, ...
%         isums{base}


fidStatR = fopen('../trunk_working/physics/outputPP/XuNSLTimeValStat00002.txt', 'r');
[startingPts, sizeBreakPts] = readStartingPoints(fidStatR);
colSize = fscanf(fidStatR,'%d', 1);
maxCross = fscanf(fidStatR,'%d', 1);
[minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, counter, average, sum, sDiviation, fieldName] =  readBriefStat(fidStatR, colSize);
fclose(fidStatR);

fidStatW = fopen('../STAT.txt', 'w');
writeStartingPoints(fidStatW, startingPts);
fprintf(fidStatW,'%d\t', colSize);
fprintf(fidStatW,'%d\n', maxCross);
writeBriefStat(fidStatW, minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, counter, average, sum, sDiviation, fieldName);
fclose(fidStatW);

startingPtsTmp = getNonZeroPartOfBreakingPoints(startingPts);
startIndAd = length(startingPtsTmp) + 1;

numAddFlds = 0;
for base = 1:numBaseFlds
    numAddFlds = numAddFlds + length(names{base});
end

startingPtsM = startingPts;
startingPtsM(startIndAd) = startingPtsM(startIndAd - 1) + numAddFlds;
colSizeM = startingPtsM(startIndAd);
maxCrossM = length(ctTimes);
minVM = minV;
minCoordM = minCoord;
min_eIDM = min_eID;
min_idM = min_id;
maxVM = maxV;
maxCoordM = maxCoord;
max_eIDM = max_eID;
max_idM = max_id;
counterM = counter;
averageM = average;
sumM = sum;
sDiviationM = sDiviation;
fieldNameM = fieldName;

cntr = length(fieldNameM) + 1;
for base = 1:numBaseFlds
    minVM = [minVM iminV{base}];
    minCoordM = [minCoordM; iminCoord{base}];
    min_eIDM = [min_eIDM imin_eID{base}];
    min_idM = [min_idM imin_id{base}];
    maxVM = [maxVM imaxV{base}];
    maxCoordM = [maxCoordM; imaxCoord{base}];
    max_eIDM = [max_eIDM imax_eID{base}];
    max_idM = [max_idM imax_id{base}];
    counterM = [counterM icounter{base}];
    averageM = [averageM iaverage{base}];
    sumM = [sumM isums{base}];
    sDiviationM = [sDiviationM isDiviation{base}];
    for j = 1:length(names{base})
        fieldNameM{cntr} = names{base}{j};
        cntr = cntr + 1;
    end
end

fidStatWM = fopen('../STATM.txt', 'w');
writeStartingPoints(fidStatWM, startingPtsM);
fprintf(fidStatWM,'%d\t', colSizeM);
fprintf(fidStatWM,'%d\n', maxCrossM);
writeBriefStat(fidStatWM, minVM, minCoordM, min_eIDM, min_idM, maxVM, maxCoordM, max_eIDM, max_idM, counterM, averageM, sumM, sDiviationM, fieldNameM);
fclose(fidStatWM);


fidStatRM = fopen('../STATM.txt', 'r');
[startingPtsRM, sizeBreakPtsRM] = readStartingPoints(fidStatRM);
colSizeRM = fscanf(fidStatRM,'%d', 1)
maxCrossRM = fscanf(fidStatRM,'%d', 1)
[minVRM, minCoordRM, min_eIDRM, min_idRM, maxVRM, maxCoordRM, max_eIDRM, max_idRM, counterRM, averageRM, sumRM, sDiviationRM, fieldNameRM] =  readBriefStat(fidStatRM, colSizeRM);
fclose(fidStatRM);

minVRM