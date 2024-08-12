function [numSubConfig, maxPlotNoToPlot,  plotComponentSize, plotFileNumber, Size, xcol, ycol, curve, linespec, symbol, ...
    xaxis, yaxis, xmaxDist, ymaxDist, marker,  startingPts, colSize, maxCross, minV, minCoord, min_eID, ...
    min_id, maxV, maxCoord, max_eID, max_id, counter, average, sum, sDiviation, fieldName, directoryO, ...
    runnameO, middlenameO ,name, flagnum, serial, ext, minVT, minCoordT, maxVT, maxCoordT, averageT, outputFolderT] = ...
readConfig(outputFolderIn, regenerateDataFile, fid,  flagNoIn, readStat, readHistories, historyFileName, historyStatFileName, cracktipVSymbol, cracktipVIndex, ...
    processZoneSymbol, processZoneIndex, cohesiveZoneSizeFileName, modifierForHistoryFiles, plotBlack)
%figVec,
%global filenameRegLog;

global cnfg;
global doReg;
global fidQuasiSingular;

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

global IappendRunMidName2OutFldr;
%global IoutputFolder;


numSubConfig = fscanf(fid,'%d', 1);

[flagValueBase, flagDataBase] = readFlagValueData(fid, [], []);


for subCnf = 1:numSubConfig
    tmp = fscanf(fid, '%s', 1);
    runFolderPreName = fscanf(fid, '%s', 1);
    if (strcmp(runFolderPreName, 'NoRoot') == 1)
        runFolderPreName = '';
    end

    runFolderMidName = fscanf(fid, '%s', 1);
    
   runFolderPostName = ''; 
%     runFolderPostName = fscanf(fid, '%s', 1);
%     if (strcmp(runFolderPostName, 'NoRoot') == 1)
%         runFolderPostName = '';
%     end
     runName = fscanf(fid, '%s', 1);

% reading run parameters
    tmp = fscanf(fid, '%s', 1);
    paraFolder = fscanf(fid, '%s', 1);
    
    tmp = fscanf(fid, '%s', 1);
    paraPreName = fscanf(fid, '%s', 1);

%     if (strcmp(paraFolder, 'NONE') == 1)
%         runParaName = 'NONE';
%     else
%         if (strcmp(paraFolder, 'NoRoot') == 1)
%             paraFolder = '';
%         else
%             paraFolder = [paraFolder, '/'];
%         end
%         runParaName = [paraFolder, paraPreName, runFolderMidName, '.txt'];
%     end

    runDir{subCnf} = [runFolderPreName, runFolderMidName, runFolderPostName];
    if (strcmp(runDir{subCnf},'NoRoot') == 1)
        runDir{subCnf} = '';
    end

    runParaName = [runDir{subCnf}, runName, '.matlab'];
    runRunParaName{subCnf} = runParaName;
    
%    runParaName = [paraFolder, paraPreName, runFolderMidName, '.txt'];
%    runRunParaName{subCnf} = runParaName;

    
    
    tmp = fscanf(fid, '%s', 1);
    subCnfDir{subCnf} = fscanf(fid,'%s', 1);
    if (strcmp(subCnfDir{subCnf},'NoRoot') == 1)
        subCnfDir{subCnf} = '';
    end
    
    if (strcmp(subCnfDir{subCnf},'Same') == 1)
        subCnfDir{subCnf} = runDir{subCnf};
    end

    subCnfFileName{subCnf} = fscanf(fid,'%s', 1);
    
    subCnfSymbol{subCnf} = fscanf(fid,'%s', 1);
    subCnfSymbol{subCnf} = readStringWithoutSpace(subCnfSymbol{subCnf}, '*', ' ');
end

outputFolderTemp = outputFolderIn;
if ((numSubConfig == 1) && (cnfg{IappendRunMidName2OutFldr} == 1))
%   ln = length(cnfg{IoutputFolder});
%   if (cnfg{IoutputFolder}(ln) == '/')
%        cnfg{IoutputFolder} = cnfg{IoutputFolder}(1:ln - 1);
%   end
%    outputFolderTemp = cnfg{IoutputFolder};
    ln = length(outputFolderTemp);
    if (outputFolderTemp == '/')
        outputFolderTemp = outputFolderTemp(1:(ln - 1));
    end
    outputFolderTemp = [outputFolderTemp, runFolderMidName];
    if (strcmp(outputFolderTemp, '') ~= 1)
        b_dir = isdir(outputFolderTemp);
        if (b_dir == 1)
        %    rmdir(outputFolderTemp,'s');
        else
            mkdir(outputFolderTemp);
        end
        outputFolderTemp = [outputFolderTemp, '/'];
%        cnfg{IoutputFolder} = outputFolderTemp;
    end
end


outputFolderT = outputFolderTemp;%cnfg{IoutputFolder};
% if (strcmp(outputFolderT,'') ~= 1)
%     outputFolderT = [outputFolderT,'/'];
% end


if (doReg == 1)
    filenameRegLog = [outputFolderT, 'RegressionLog.txt'];
    fidQuasiSingular = fopen(filenameRegLog, 'w');
    fprintf(fidQuasiSingular, '%d\n\n', flagNoIn);
end


%reading number of plots To Plot:
tmp = fscanf(fid,'%s', 1);
maxPlotNoToPlot = fscanf(fid,'%d', 1);

%reading number of plots To Read:
%tmp = fscanf(fid,'%s', 1);
%numPlotsToRead = fscanf(fid,'%d', 1);

tmp = fscanf(fid,'%s', 1);
maxPlotNo = fscanf(fid,'%d', 1);
% clear figVec;
% for plotNo = 1:numPlotsToPlot
%     figVec(plotNo) = figure(plotNo);
% %    orient(figVec(plotNo),'landscape');
% %    set(figVec(plotNo),'PaperOrientation','landscape');
% end

clear plotComponentSize plotFileNumber Size xcol ycol curve linespec symbol xaxis yaxis xmaxDist ymaxDist marker startingPts colSize maxCross minV minCoord min_eID min_id maxV maxCoord max_eID max_id counter average sum sDiviation fieldName directoryO runnameO middlenameO name flagnum serial ext;



fileReadNoNew = 0;
curveEndNoNew = 0; 
% plotComponentSize = zeros(1,numPlotsToRead);
plotComponentSize = zeros(1,maxPlotNo);

for subCnf = 1:numSubConfig
    if (strcmp(subCnfDir{subCnf}, '') == 1)
        subCnfFullName{subCnf} = subCnfFileName{subCnf};
    else
        subCnfFullName{subCnf} = [subCnfDir{subCnf},'/',subCnfFileName{subCnf}];
    end
    fn = subCnfFullName{subCnf};
    fidSubConfig{subCnf} = fopen(subCnfFullName{subCnf}, 'r');
    if (fidSubConfig{subCnf} < 0)
       fprintf(1, 'unable to open %s\n', subCnfFullName{subCnf});
    end
%reading subconfig file    
    [plotComponentSizes, fileReadNoNewBK, plotFileNumbers, Sizes, xcols, ycols, curves, linespecs, symbols, xaxiss, yaxiss,  ...
        xmaxDists, ymaxDists, markers, startingPtss, colSizes, maxCrosss, minVs, minCoords, min_eIDs, ...
        min_ids, maxVs, maxCoords, max_eIDs, max_ids, counters, averages, sums, sDiviations, fieldNames, ...
        directoryOs, runnameOs, middlenameOs ,names, flagnums, serials, exts, curveEndNoNew, minVTs, ...
        minCoordTs, maxVTs, maxCoordTs, averageTs] = ...
        readsubConfigMultiProfileSingleFile(regenerateDataFile, fidSubConfig{subCnf}, ...
        runDir{subCnf}, runRunParaName{subCnf}, subCnf, fileReadNoNew,  flagNoIn, curveEndNoNew, readStat, ...
        maxPlotNo, readHistories, historyFileName, historyStatFileName, cracktipVSymbol, cracktipVIndex, ...
        processZoneSymbol, processZoneIndex, cohesiveZoneSizeFileName, modifierForHistoryFiles, subCnfSymbol{subCnf}, plotBlack);



%    for plotNo = 1:numPlotsToRead
    for plotNo = 1:maxPlotNo
        if (plotNo > length(plotFileNumbers))
            continue;
        end
        len = length(plotFileNumbers{plotNo});
        if (len == 0)
            continue;
            end
        for i = 1:len
            plotFileNumber{plotNo}{i + plotComponentSize(plotNo)} = plotFileNumbers{plotNo}{i};
            Size{plotNo}{i + plotComponentSize(plotNo)}           = Sizes{plotNo}{i};
            xcol{plotNo}{i + plotComponentSize(plotNo)}           = xcols{plotNo}{i};
            ycol{plotNo}{i + plotComponentSize(plotNo)}           = ycols{plotNo}{i};
            curve{plotNo}{i + plotComponentSize(plotNo)}          = curves{plotNo}{i};
            linespec{plotNo}{i + plotComponentSize(plotNo)}       = linespecs{plotNo}{i};
            symbol{plotNo}{i + plotComponentSize(plotNo)}         = symbols{plotNo}{i};
            xaxis{plotNo}{i + plotComponentSize(plotNo)}          = xaxiss{plotNo}{i};
            yaxis{plotNo}{i + plotComponentSize(plotNo)}          = yaxiss{plotNo}{i};
            xmaxDist{plotNo}{i + plotComponentSize(plotNo)}          = xmaxDists{plotNo}{i};
            ymaxDist{plotNo}{i + plotComponentSize(plotNo)}          = ymaxDists{plotNo}{i};
            marker{plotNo}{i + plotComponentSize(plotNo)}          = markers{plotNo}{i};
        end
    end
    lenN = length(plotComponentSize);
    lenAdded = length(plotComponentSizes);
    if (lenN < lenAdded)
        plotComponentSizeTemp = plotComponentSize;
        plotComponentSize = plotComponentSizes;
        plotComponentSize(1:lenN) =  plotComponentSize(1:lenN) + plotComponentSizeTemp;
    elseif (lenN == lenAdded)
        plotComponentSize = plotComponentSize + plotComponentSizes;
    else
        fprintf(1, 'wrong sizes lenN = %d   lenAdded = %d\n', lenN, lenAdded);
    end
    numFileRead = fileReadNoNewBK - fileReadNoNew;
    
    if (readStat == 1)
        for fFile = 1:numFileRead
            startingPts(fFile + fileReadNoNew) = startingPtss(fFile);
            colSize(fFile + fileReadNoNew)     = colSizes(fFile);
            maxCross(fFile + fileReadNoNew)    = maxCrosss(fFile);
            minV(fFile + fileReadNoNew)        = minVs(fFile);
            minCoord(fFile + fileReadNoNew)    = minCoords(fFile);
            min_eID(fFile + fileReadNoNew)     = min_eIDs(fFile);
            min_id(fFile + fileReadNoNew)      = min_ids(fFile);
            maxV(fFile + fileReadNoNew)        =  maxVs(fFile);
            maxCoord(fFile + fileReadNoNew)    =  maxCoords(fFile);
            max_eID(fFile + fileReadNoNew)     =  max_eIDs(fFile);
            max_id(fFile + fileReadNoNew)      =  max_ids(fFile);
            counter(fFile + fileReadNoNew)     =  counters(fFile);
            average(fFile + fileReadNoNew)     =  averages(fFile);
            sum(fFile + fileReadNoNew)         =  sums(fFile);
            sDiviation(fFile + fileReadNoNew)  =  sDiviations(fFile);
            fieldName(fFile + fileReadNoNew)   =  fieldNames(fFile);
            minVT(fFile + fileReadNoNew)       = minVTs(fFile);
            minCoordT(fFile + fileReadNoNew) = minCoordTs(fFile);
            maxVT(fFile + fileReadNoNew)     = maxVTs(fFile);
            maxCoordT(fFile + fileReadNoNew) = maxCoordTs(fFile);
            averageT(fFile + fileReadNoNew)  = averageTs(fFile);
        end
    end
    for fFile = 1:numFileRead
        directoryO(fFile + fileReadNoNew)  =  directoryOs(fFile);
        runnameO(fFile + fileReadNoNew)    =  runnameOs(fFile);
        middlenameO(fFile + fileReadNoNew) = middlenameOs(fFile);
        name(fFile + fileReadNoNew)        = names(fFile);
         flagnum(fFile + fileReadNoNew)     = flagnums(fFile);
        serial(fFile + fileReadNoNew)      = serials(fFile);
        ext(fFile + fileReadNoNew)         = exts(fFile);
    end

    fileReadNoNew = fileReadNoNewBK;
    fclose(fidSubConfig{subCnf});
end


