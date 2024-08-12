function [startP endP] = computeLimitsAroundProcessZone()

global cnfg;
global IplotAroundProcessZoneFactor;
global IplotAroundProcessZoneMinValues;
global IplotAroundProcessZoneMaxValues;
global IplotAroundProcessZoneSize;

global flagValueFile; 
global flagDataFile;
global CZstartIndex;
global CZendIndex; 
global CTindex;
global startCohFaceIndex;
global CZstaticSizeIndex;


startInd = flagDataFile{1}(CZstartIndex);
endInd = flagDataFile{1}(CZendIndex);

startP = cnfg{IplotAroundProcessZoneMaxValues}(startInd);
endP = cnfg{IplotAroundProcessZoneMaxValues}(endInd);
if ((startP > -inf) && (endP > -inf))
    delta = endP - startP;
    factor = (cnfg{IplotAroundProcessZoneFactor} - 1) / 2.0;
    endP = endP + factor * delta;
    startP = startP - factor * delta;
    
    if (startP > endP)
        tmp = startP;
        startP = endP;
        endP = tmp;
    end
else
    ctInd = flagDataFile{1}(CTindex);
    basePtCT = cnfg{IplotAroundProcessZoneMaxValues}(ctInd);
    basePt0 = flagDataFile{1}(startCohFaceIndex);
    if (basePtCT == -inf)
        basePt = basePt0;
    else
        basePt = basePtCT;
    end
    staticProcessZoneSize = -inf;
    numFiles = length(flagDataFile);
    for file = 1:numFiles
        staticProcessZoneSize = max(staticProcessZoneSize, flagDataFile{file}(CZstaticSizeIndex));
    end
    factor = cnfg{IplotAroundProcessZoneFactor};
    startP = max(basePt0, basePt - factor * staticProcessZoneSize);
    endP = basePt + factor * staticProcessZoneSize;
end

cnfg{IplotAroundProcessZoneSize} = abs(endP - startP);
