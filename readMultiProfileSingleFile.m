function [Size, xcol, ycol, curve, linespec, symbol, xaxis, yaxis, xmaxDist, ymaxDist, marker, startingPts, colSize, maxCross, minV, ...
    minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, counter, average, sum, sDiviation, fieldName,flagnum, name, serial, ext, ...
    newCurveEnd, minVTot, minCoordTot, maxVTot, maxCoordTot, averageTot] = ...
readMultiProfileSingleFile(fid, directory, runNoIn, runname, ...
    middlename, fileReadNo,  flagNoIn, curveEndNo, readStat, subCnfSymbols, plotBlack)



global cnfg;
global IStatFinalTimeName;
global IStatFinalTimeName;

global flagValueBase; 
global flagDataBase;
global flagValueFile; 
global flagDataFile;
global flagValueCurvex; 
global flagDataCurvex;
global flagValueCurvey; 
global flagDataCurvey;


global gColor;
global gColorname;
global gLineStyle;
global gLineStyleName;
global gMarkerStyle;
global gMarkerStyleName;
global gMarkerSize;

global IAddSerialNumber2ModifedFilesBasedOnRunOrder;

addRunSerialNum2FIleModifier = cnfg{IAddSerialNumber2ModifedFilesBasedOnRunOrder};
if (addRunSerialNum2FIleModifier == 1)
    sn_ = num2str(runNoIn);
else
    sn_ = '1';
end


name = fscanf(fid,'%s', 1);
if (strcmp(name,'TimeValModified') == 1)
    name = [name, sn_];
end
if (strcmp(name,'TimeValCohZone') == 1)
    name = [name, sn_];
end


temp = fscanf(fid,'%d', 1);
if (flagNoIn == -1)
    flagnum = temp;
else
    flagnum = flagNoIn;
end 

serial = fscanf(fid,'%d', 1);
ext = fscanf(fid,'%s', 1);

nameStat = fscanf(fid,'%s', 1);
tempStat = fscanf(fid,'%d', 1);
if (flagNoIn == -1)
    flagnumStat = tempStat;
else
    flagnumStat = flagNoIn;
end    
serialStat = fscanf(fid,'%d', 1);
extStat = fscanf(fid,'%s', 1);

%reading stat file    and stat members
if (readStat == 1)
    fileNameStat = getFileName(directory, runname, middlename, flagnumStat, nameStat, serialStat, extStat);
    fidStat = fopen(fileNameStat,'r');
    if (fidStat < 0)
        fprintf('stat file does not exist %s', fileNameStat);
        directory, runname, middlename, flagnumStat, nameStat, serialStat, extStat
    end
    [startingPts, sizeBreakPts] = readStartingPoints(fidStat);
    colSize = fscanf(fidStat,'%d', 1);
    maxCross = fscanf(fidStat,'%d', 1);
    [minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, counter, average, sum, sDiviation, fieldName] =  readBriefStat(fidStat, colSize);
    fclose(fidStat);

    if (cnfg{IStatFinalTimeName} > 0)
        fileNameStatT = getFileName(directory, runname, middlename, -1, cnfg{IStatFinalTimeName}, -1, 'txt');
        fidStatT = fopen(fileNameStatT,'r');
        if (fidStatT < 0)
            fprintf('stat file does not exist %s', fileNameStatT);
            minVT = minV;
            maxVT = maxV;
            averageT = average;
        else
            [startingPtsT, sizeBreakPtsT] = readStartingPoints(fidStatT);
            colSizeT = fscanf(fidStatT,'%d', 1);
            maxCrossT = fscanf(fidStatT,'%d', 1);
            pointNumStart = fscanf(fidStatT,'%d', 1);
            pointNumEnd = fscanf(fidStatT,'%d', 1);
            
            [minVTot, minCoordTot, min_eIDTot, min_idTot, maxVTot, maxCoordTot, max_eIDTot, max_idTot, counterTot, averageTot, sumTot, sDiviationTot, fieldNameTot] =  readBriefStat(fidStatT, colSizeT);
            fclose(fidStatT);
        end
    end
    
end


plotSize = fscanf(fid,'%d', 1);
newCurveEnd = curveEndNo;

for i = 1:plotSize
    [plotNo, sizes, xcols, ycols, curves, linespecs, symbols, xaxiss, yaxiss, xmaxDists, ymaxDists, markers, newCurveEnd] = readSingleProfile(fid, startingPts, runNoIn, fileReadNo,  newCurveEnd, flagnum, subCnfSymbols, plotBlack, minV, maxV, average, minVTot, maxVTot, averageTot, minCoord, maxCoord, minCoordTot, maxCoordTot);
    for j = 1 : length(xmaxDists)
        curve_ = curves(j);
        if (xmaxDists(j) < 0)
%            xcoln = xcols(j)
            colNoOut = getActualColNumFromColNumStat(xcols(j));
%             minV(colNoOut)
%             maxV(colNoOut)
%             minVTot(colNoOut)
%             maxVTot(colNoOut)
%             flagValueCurvex{curve_}
%             flagDataCurvex{curve_}
%             pause
            maxVT = operateOnValBasedOnFlagValueData(maxV(colNoOut), flagValueCurvex{curve_}, flagDataCurvex{curve_});
            minVT = operateOnValBasedOnFlagValueData(minV(colNoOut), flagValueCurvex{curve_}, flagDataCurvex{curve_});
            xmaxDists(j) = -xmaxDists(j) * abs(maxVT - minVT);
        end
    end

    for j = 1 : length(ymaxDists)
        curve_ = curves(j);
        if (ymaxDists(j) < 0)
            colNoOut = getActualColNumFromColNumStat(ycols(j));
            maxVT = operateOnValBasedOnFlagValueData(maxV(colNoOut), flagValueCurvey{curve_}, flagDataCurvey{curve_});
            minVT = operateOnValBasedOnFlagValueData(minV(colNoOut), flagValueCurvey{curve_}, flagDataCurvey{curve_});
            ymaxDists(j) = -ymaxDists(j) * abs(maxVT - minVT);
        end
    end
    
%     for j = 1:length(curves)
%         curveNo = curves(j);
%        % between 500 and 600 means to get x0 in x - x0 from statistics file given by field:  
%         if (flagValueCurvex{curveNo}(2) > 500)
% %            flagValueCurvex{curveNo}
% %           flagValueCurvex{curveNo}(2)
% 
%             if (flagValueCurvex{curveNo}(2) < 600)
%                 tempN = flagValueCurvex{curveNo}(2) - 500;
%                 flagValueCurvex{curveNo}(2) = 1;
%             elseif ((flagValueCurvex{curveNo}(2) > 600) && (flagValueCurvex{curveNo}(2) < 700))
%                 tempN = flagValueCurvex{curveNo}(2) - 600;
%                 flagValueCurvex{curveNo}(2) = 2;
%             end
% 
%             colNoIni = getColNumberFromSymbolNumber('fld', tempN, startingPts);
%             colNoOut = getActualColNumFromColNum(colNoIni);
%             flagDataCurvex{curveNo}(2) = maxCoord(colNoOut, 1) - flagDataCurvex{curveNo}(2);
%         end
%     end
    

    Size{plotNo} = sizes;
    xcol{plotNo} = xcols;
    ycol{plotNo} = ycols;
    curve{plotNo} = curves;
    linespec{plotNo} = linespecs;
    symbol{plotNo} = symbols;
    xaxis{plotNo} = xaxiss;
    yaxis{plotNo} = yaxiss;
    xmaxDist{plotNo} = xmaxDists;
    ymaxDist{plotNo} = ymaxDists;
    marker{plotNo} = markers;
    clear sizes xcols ycols linespecs symbols xaxiss yaxiss;
end



