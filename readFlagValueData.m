function [flagValue, flagData, flagSimData] = readFlagValueData(fid, flagDataBase, flagDataRun, Doresize, flagValueIn, ...
    flagDataIn, flagSimDataIn, minV, maxV, average, minVTot, maxVTot, averageTot, minCoord, maxCoord, ...
    minCoordTot, maxCoordTot, dim, fld, startingPts)

tol = 1e-60;

if nargin > 7
    if (abs(minV) < tol)
        minV = 1.0;
    end
    if (abs(maxV) < tol)
        maxV = 1.0;
    end


    if (abs(minVTot) < tol)
        minVTot = 1.0;
    end
    if (abs(maxVTot) < tol)
        maxVTot = 1.0;
    end
end

global cnfg;
global IstartCohNormalizer;
global IincrmCohNormalizer;
global IstartLoadNormalizer;
global IincrmLoadNormalizer;

if nargin < 4
    Doresize = 1;
    changeStaticProcessZoneSize = 0;
end


if (Doresize == 0)
    flagValue = flagValueIn;
    flagData = flagDataIn;
    flagSimData = flagSimDataIn; 
end



size = fscanf(fid, '%d',1);
number = fscanf(fid, '%d',1);

if (Doresize == 1)
    flagValue = zeros(1, size);
    flagData = zeros(1, size);
    flagSimData = -1 * ones(1, size);
else
    if size > length(flagData)
        flagData(size) = 0;
    end
    if size > length(flagValue)
        flagValue(size) = 0;
    end
    if size > length(flagSimData)
        flagSimData(size) = -1;
    end
end

for i = 1:number
    flagnumber = fscanf(fid, '%d',1);
    flagValue(flagnumber) = fscanf(fid, '%d',1);
    flagSimData(flagnumber) = -1;
   
    temp = fscanf(fid,'%s',1);

% reading simulation data flag    
    if (strncmp(temp, 'rSD', 3) == 1)
        temp = temp(4:length(temp));
        symbol = fscanf(fid, '%s', 1);
        index  = fscanf(fid, '%d', 1);
        colNo = getColNumberFromSymbolNumber(symbol, index, startingPts);
        flagSimData(flagnumber) = colNo;
    end

    if (strcmp(temp, 'abs') == 1)
        flagData(flagnumber) = fscanf(fid, '%lg',1);
    elseif (strcmp(temp, 'relB') == 1)
        tempF = fscanf(fid, '%d',1);
        factor = fscanf(fid, '%lg',1);
        flagData(flagnumber) = flagDataBase(tempF) * factor;
    elseif (strcmp(temp, 'relF') == 1)
        tempF = fscanf(fid, '%d',1);
        factor = fscanf(fid, '%lg',1);
        flagData(flagnumber) = flagDataRun(tempF) * factor;
    elseif (strcmp(temp, 'relCoh') == 1)
        factor = fscanf(fid, '%lg',1);
        colN = cnfg{IstartCohNormalizer} + cnfg{IincrmCohNormalizer} * dim + fld;
        flagData(flagnumber) = flagDataRun(colN) * factor;
    elseif (strcmp(temp, 'relLoad') == 1)
        factor = fscanf(fid, '%lg',1);
        colN = cnfg{IstartLoadNormalizer} + cnfg{IincrmLoadNormalizer} * dim + fld;
        flagData(flagnumber) = flagDataRun(colN) * factor;
    elseif (strcmp(temp, 'relMax') == 1)
        factor = fscanf(fid, '%lg',1);
        flagData(flagnumber) = maxV * factor;
    elseif (strcmp(temp, 'absMax') == 1)
        factor = fscanf(fid, '%lg',1);
        flagData(flagnumber) = maxVTot * factor;
    elseif (strcmp(temp, 'relMin') == 1)
        factor = fscanf(fid, '%lg',1);
        flagData(flagnumber) = minV * factor;
    elseif (strcmp(temp, 'absMin') == 1)
        factor = fscanf(fid, '%lg',1);
        flagData(flagnumber) = minVTot * factor;
    elseif (strcmp(temp, 'relExt') == 1)
        factor = fscanf(fid, '%lg',1);
        flagData(flagnumber) = max(abs(maxV), abs(minV)) * factor;
    elseif (strcmp(temp, 'absExt') == 1)
        factor = fscanf(fid, '%lg',1);
        flagData(flagnumber) = max(abs(maxVTot), abs(minVTot)) * factor;
    elseif (strcmp(temp, 'relMaxCrd') == 1)
        factor = fscanf(fid, '%d',1);
        flagData(flagnumber) = maxCoord(factor);
    elseif (strcmp(temp, 'absMaxCrd') == 1)
        factor = fscanf(fid, '%d',1);
        flagData(flagnumber) = maxCoordTot(factor);
    elseif (strcmp(temp, 'relMinCrd') == 1)
        factor = fscanf(fid, '%d',1);
        flagData(flagnumber) = minCoord(factor);
    elseif (strcmp(temp, 'absMinCrd') == 1)
        factor = fscanf(fid, '%d',1);
        flagData(flagnumber) = minCoordTot(factor);
    elseif (strcmp(temp, 'relAve') == 1)
        factor = fscanf(fid, '%lg',1);
        flagData(flagnumber) = average * factor;
    elseif (strcmp(temp, 'absAve') == 1)
        factor = fscanf(fid, '%lg',1);
        flagData(flagnumber) = averageTot * factor;
    elseif (strcmp(temp, 'pzloc') == 1)
        temp = fscanf(fid, '%s',1);
        if (strcmp(temp, 'relF') == 1)
            tempF = fscanf(fid, '%d',1);
            factor = fscanf(fid, '%lg',1);
            r = flagDataRun(tempF) * factor;
        elseif (strcmp(temp, 'abs') == 1)
            r = fscanf(fid, '%lg',1);
        end
         flagData(flagnumber) = 11000 + r;
    elseif (strcmp(temp, 'pzsize') == 1)
        temp = fscanf(fid, '%s',1);
        if (strcmp(temp, 'relF') == 1)
            tempF = fscanf(fid, '%d',1);
            factor = fscanf(fid, '%lg',1);
            r = flagDataRun(tempF) * factor;
        elseif (strcmp(temp, 'abs') == 1)
            r = fscanf(fid, '%lg',1);
        end
        flagData(flagnumber) = 11000 + r;
    else
        temp
        fprintf(1,'wrong value option function readFlagValueData \n');
   end
end

