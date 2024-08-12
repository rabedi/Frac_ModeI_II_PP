function [plotNo, Size, xcol, ycol, curve, linespec, symbol, xaxis, yaxis,xmaxDist, ymaxDist, marker, NewcurveEndNo] = ...
    readSingleProfile(fid, startingPts, runNoIn, fileReadNo,  curveEndNo, flagNo,  subCnfSymbols, plotBlack, minV, maxV, average, minVTot, maxVTot, averageTot, minCoord, maxCoord, minCoordTot, maxCoordTot)

global doReg;
global RegPlotNo;
global Icoord2sIndex;
global indcmnf;
global indcmxf;
global indcmnb;
global indcmxb;

global fidQuasiSingular;


global cnfg;
global IdisableMarkers;
global IenableMarkerValues;
global IelementBndryMarkerSize;
global IdisableElementBndry;
global IdisableProcessZones;
global IdisableExtrmmValues;
global IdisableLocalExtrmmValues;
global IplotAroundProcessZoneFactor;
global IplotAroundProcessZoneMinValues;
global IplotAroundProcessZoneMaxValues;


global flagValueBase; 
global flagDataBase;
global flagValueFile; 
global flagDataFile;
global flagValueCurvex; 
global flagDataCurvex;
global flagValueCurvey; 
global flagDataCurvey;
global flagSimDataCurvex;
global flagSimDataCurvey;


global gColor;
global gColorname;
global gLineStyle;
global gLineStyleName;
global gMarkerStyle;
global gMarkerStyleName;
global gMarkerSize;

numStatTotal = length(minVTot);
[plotNo, noteof] = fscanf(fid,'%d',1);
if (noteof == 0)
    fprintf('nothing to read, problem in subConfig file\n');
    pause;
end

Size = fscanf(fid,'%d',1);
%  if (Size > 3)
%      fprintf(1, 'hello\n');
%  end
for i = 1:Size
%reading x part
    temp = fscanf(fid,'%s',1);
    temp = fscanf(fid,'%s',1);
    colSymX = fscanf(fid,'%s',1);
    numberX = fscanf(fid,'%d',1);
    xcol(i) = getColNumberFromSymbolNumber(colSymX, numberX, startingPts);
    temp = fscanf(fid,'%s',1);
    xaxis(i) = fscanf(fid,'%d',1);
% reading max xDistance
    temp = fscanf(fid,'%s',1);
    xmaxDist(i) = fscanf(fid,'%lg',1);
% reading y part    
    temp = fscanf(fid,'%s',1);
    temp = fscanf(fid,'%s',1);
    colSymY = fscanf(fid,'%s',1);
    numberY = fscanf(fid,'%d',1);
    ycol(i) = getColNumberFromSymbolNumber(colSymY, numberY, startingPts);
    temp = fscanf(fid,'%s',1);
    yaxis(i) = fscanf(fid,'%d',1);
% reading max yDistance
    temp = fscanf(fid,'%s',1);
    ymaxDist(i) = fscanf(fid,'%lg',1);

%curve
    curve(i) = i + curveEndNo;

%line spec   
    temp = fscanf(fid,'%s',1);  % temp must be linespec
% line style   
    temp = fscanf(fid,'%s',1);  % temp must be style
    temp = fscanf(fid,'%s',1);  % temp must be either abs or def
    if (strcmp(temp, 'abs') == 1)
        linespec{1}{i} = fscanf(fid, '%s', 1);
    elseif (strcmp(temp, 'def') == 1)
        num = fscanf(fid, '%d', 1);
        linespec{1}{i} = gLineStyle{num};
    end
%line color    
    temp = fscanf(fid,'%s',1);  % temp must be color
    temp = fscanf(fid,'%s',1);  % temp must be either abs or def
    numCol = 0;
    if (strcmp(temp, 'abs') == 1)
        linespec{2}{i} = fscanf(fid, '%s', 1);
        if (strcmp(linespec{2}{i}, 'runNo') == 1)
            linespec{2}{i} = gColor{runNoIn};
        end
    elseif (strcmp(temp, 'def') == 1)
        numCol = fscanf(fid, '%d', 1);
        linespec{2}{i} = gColor{numCol};
    end
%line marker    
    temp = fscanf(fid,'%s',1);  % temp must be marker
    temp = fscanf(fid,'%s',1);  % temp must be either abs or def
    if (strcmp(temp, 'abs') == 1)
        linespec{3}{i} = fscanf(fid, '%s', 1);
    elseif (strcmp(temp, 'def') == 1)
        num = fscanf(fid, '%d', 1);
        linespec{3}{i} = gMarkerStyle{num};
    end

%overriding line style, color, and marker for black and white prints       
    if (plotBlack == 1)
        if (numCol == 0)
            [linespec{1}{i}, linespec{2}{i}, linespec{3}{i}] = gLineStyleBlack(runNoIn);
        else
            [linespec{1}{i}, linespec{2}{i}, linespec{3}{i}] = gLineStyleBlack(numCol);
        end
    end
    

%symbol spec
    temp = fscanf(fid,'%s',1);
    tempN = fscanf(fid,'%d', 1);
    temp = fscanf(fid,'%s', 1);
    symbol{i} = readStringWithoutSpace(temp, '*', ' ');
    if (strcmp(symbol{i},'auto') == 1)
%        symbol{i} = sprintf('CRV%d_FN%d_FlN_%d_i%d_x%d_y%d', curve(i), fileReadNo, flagNo, i, xcol(i), ycol(i));
        symbol{i} = sprintf('%d', curve(i));
    end
    if ((tempN > 0) && (runNoIn ~= tempN))
        symbol{i} = 'none';
    end
    if (strcmp(symbol{i},'runSym') == 1)
         symbol{i} = subCnfSymbols;
    end
    
%number of markers    
    temp = fscanf(fid,'%s',1);  % temp must be markers
    numMarker = fscanf(fid, '%d',1);
%    if (numMarker == 0)
        for j = 1:5
            marker{j}{i} = cell(0);
        end
%    end

    
    
    
    
    mCntr = 1;
    for num = 1:numMarker
%value of marker
        temp = fscanf(fid,'%s',1);  % temp must be value
        markerFlag = fscanf(fid,'%d',1);
        store = 1;
        
        
        if (markerFlag == -12345678)
            if ((doReg ~= 0) && (plotNo <= RegPlotNo))
                store = 1;
            elseif (cnfg{IdisableElementBndry} ~= 0)
                store = 0;
            end
        end
        if ((cnfg{IdisableProcessZones} ~= 0) && (markerFlag <= -1) && (markerFlag >= -16))
            store = 0;
        end
        if ((cnfg{IdisableExtrmmValues} ~= 0) && (markerFlag <= -1000))
            store = 0;
        end
        if ((cnfg{IdisableLocalExtrmmValues} ~= 0) && (markerFlag <= -1000) && (markerFlag >= -3000))
            store = 0;
        end
        
        if ( (cnfg{IdisableMarkers} ~= 0) && (sum(cnfg{IenableMarkerValues} == markerFlag) == 0))
            store = 0;
        end
        if (store == 1)
            marker{1}{i}{mCntr} = markerFlag;
        end
        
% symbol used in legend
        temp = fscanf(fid,'%s',1);  % temp must be symbol
        tempN = fscanf(fid,'%d', 1);
        temp = fscanf(fid,'%s', 1);
        if (store == 1)
            marker{2}{i}{mCntr} = readStringWithoutSpace(temp, '*', ' ');
            if ((tempN > 0) && (runNoIn ~= tempN))
                marker{2}{i}{mCntr} = 'none';
            end
            if (strcmp(marker{2}{i}{mCntr},'runSym') == 1)
                 marker{2}{i}{mCntr} = subCnfSymbols;
            end
        end
%marker symbol
        temp = fscanf(fid,'%s',1);  % temp must be marker
        temp = fscanf(fid,'%s',1);  % this must be abs of def

        if (strcmp(temp, 'abs') == 1)
            m3 = fscanf(fid, '%s', 1);
        elseif (strcmp(temp, 'def') == 1)
            number = fscanf(fid, '%d', 1);
            m3 = gMarkerStyle{number};
        end
        if (store == 1)
            marker{3}{i}{mCntr} = m3;
        end
%marker color
        temp = fscanf(fid,'%s',1);  % temp must be color
        temp = fscanf(fid,'%s',1);  % this must be abs of def
        if (strcmp(temp, 'abs') == 1)
            m4 = fscanf(fid, '%s', 1);
        elseif (strcmp(temp, 'def') == 1)
            number = fscanf(fid, '%d', 1);
            m4 = gColor{number};
        end
        if (store == 1)
            marker{4}{i}{mCntr} = m4;
        end
%marker size        
        temp = fscanf(fid,'%s',1);  % temp must be size
        temp = fscanf(fid,'%s',1);  % this must be abs of def
        if (strcmp(temp, 'abs') == 1)
            m5 = fscanf(fid, '%d', 1);
        elseif (strcmp(temp, 'def') == 1)
            number = fscanf(fid, '%d', 1);
            m5 = gMarkerSize{number};
        end
        if (markerFlag == -12345678)
            number = cnfg{IelementBndryMarkerSize};
            m5 = gMarkerSize{number};
        end
        
        if (store == 1)
            marker{5}{i}{mCntr} = m5;
            mCntr = mCntr + 1;
        end
    end
    
%xFlagValue xFlagData
    temp = fscanf(fid,'%s',1);  % temp must be xflagdata
    
    colNoOut = getActualColNumFromColNumStat(xcol(i));
    [dim, fld] = getDimensionFieldOfPrimaryFldOutput(xcol(i), startingPts);
    if (numStatTotal >= colNoOut)
        minVTotV = minVTot(colNoOut);
        maxVTotV = maxVTot(colNoOut);
        minCoordTotV = minCoordTot(colNoOut, :);
        maxCoordTotV = maxCoordTot(colNoOut, :);
        averageTotV = averageTot(colNoOut);
    else
        minVTotV = minV(colNoOut);
        maxVTotV = maxV(colNoOut);
        minCoordTotV = minCoord(colNoOut, :);
        maxCoordTotV = maxCoord(colNoOut, :);
        averageTotV = average(colNoOut);
    end        
    
        
    [tempValue, tempData, tempFlagSimData] = readFlagValueData(fid, flagDataBase, flagDataFile{fileReadNo}, ...
        1, [], [], [], minV(colNoOut), maxV(colNoOut), average(colNoOut), minVTotV, maxVTotV, averageTotV, ...
        minCoord(colNoOut, :), maxCoord(colNoOut, :), minCoordTotV, maxCoordTotV, dim, fld, startingPts);
    % this is were I want to modify quasi-singular parameters 

    factor = 1.0;
    if (tempValue(3) == 1)
        factor = tempData(3);
    elseif (tempValue(3) == 2)
        factor = 1.0 / tempData(3);
    end
    
    colNoOutY = getActualColNumFromColNumStat(ycol(i));
    
    
    if ((doReg == 1) && (plotNo <= RegPlotNo))
        indSizes = [indcmnf indcmxf indcmnb indcmxb];

        % part A: sizes:
        if (plotNo > 1)
%            [xMinRegPZSpace xMaxRegPZSpace] = computeLimitsAroundProcessZone();
%            pzSize = abs(xMaxRegPZSpace - xMinRegPZSpace);
%             if ((pzSize == 0) || (isfinite(pzSize) == 0))
%                 pzSize = 1.0;
%             end
            logBase = tempData(4);
%            baseLogVal = log(pzSize) / log(logBase);
            baseLogVal = 11000;
            for m = 1:4
                if (tempData(indSizes(m)) > 10000)
                    tmp = tempData(indSizes(m)) - 11000;
                    newVal = baseLogVal + log(tmp) / log(logBase) - log(factor) / log(logBase);
                    tempData(indSizes(m)) = newVal;
                end
            end
        end
        fprintf(fidQuasiSingular, '\n');
        for m = 1:4

            if (tempData(indSizes(m)) > 10000)
                val = tempData(indSizes(m)) - 11000;
                fprintf(fidQuasiSingular, 'rel %d\t%g\t', indSizes(m), val);
            else                
                val = tempData(indSizes(m));
                fprintf(fidQuasiSingular, 'abs %d\t%g\t', indSizes(m), val);
            end
        end
        fprintf(fidQuasiSingular, '\n');

        % part B: location of singular core:
            coh_post_process_loc_Sin = 3;   % from CohesivePostP.h
            indexCoord2SpaceExtermums = cnfg{Icoord2sIndex};
            if (abs(minV(colNoOutY)) < abs(maxV(colNoOutY)))
                xv = maxCoord(colNoOutY, indexCoord2SpaceExtermums);
            else
                xv = minCoord(colNoOutY, indexCoord2SpaceExtermums);
            end

            colS = getColNumberFromSymbolNumber(colSymY, coh_post_process_loc_Sin, startingPts);
            colSOut = getActualColNumFromColNumStat(colS);
            
            xs = maxCoord(colSOut, indexCoord2SpaceExtermums);
            %x0: singular core location
            %xs: max stress
            %xv max velocity
        if (tempData(2) > 10000)
            r = tempData(2) - 11000;
            x0 = (1 - r) * xs + r * xv;
            tempData(2) = x0;
        else
            r = -1;
            x0 = tempData(2);
        end
        fprintf(fidQuasiSingular, 'xs\t%g\txv\t%g\tx0\t%g\tr\t%g\n', xs, xv, x0, r);
    end
    % end of quasi-singular parameters
    
    
    flagValueCurvex{curve(i)} = tempValue;
    flagDataCurvex{curve(i)} = tempData;
    flagSimDataCurvex{curve(i)} = tempFlagSimData;
    
%yFlagValue yFlagData
    temp = fscanf(fid,'%s',1);  % temp must be xflagdata
    [dim, fld] = getDimensionFieldOfPrimaryFldOutput(ycol(i), startingPts);
    if (numStatTotal >= colNoOutY)
        minVTotV = minVTot(colNoOutY);
        maxVTotV = maxVTot(colNoOutY);
        minCoordTotV = minCoordTot(colNoOutY, :);
        maxCoordTotV = maxCoordTot(colNoOutY, :);
        averageTotV = averageTot(colNoOutY);
    else
        minVTotV = minV(colNoOutY);
        maxVTotV = maxV(colNoOutY);
        minCoordTotV = minCoord(colNoOutY, :);
        maxCoordTotV = maxCoord(colNoOutY, :);
        averageTotV = average(colNoOutY);
    end        
    [tempValue, tempData, tempFlagSimData] = readFlagValueData(fid, flagDataBase, flagDataFile{fileReadNo}, 1, [], [], [], minV(colNoOutY), maxV(colNoOutY), average(colNoOutY), minVTotV, maxVTotV, averageTotV, minCoord(colNoOutY, :), maxCoord(colNoOutY, :), minCoordTotV, maxCoordTotV, dim, fld, startingPts);
    flagValueCurvey{curve(i)} = tempValue;
    flagDataCurvey{curve(i)} = tempData;
    flagSimDataCurvey{curve(i)} = tempFlagSimData;
end



NewcurveEndNo = curve( Size);