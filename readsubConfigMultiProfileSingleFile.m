function [plotComponentSize, fileReadNoInNew, plotFileNumber, Size, xcol, ycol, curve, linespec, symbol, ...
    xaxis, yaxis, xmaxDist, ymaxDist, marker,  startingPts, colSize, maxCross, minV, minCoord, min_eID, min_id, ...
    maxV, maxCoord, max_eID, max_id, counter, average, sum, sDiviation, fieldName, directoryO, runnameO, middlenameO, ...
    name, flagnum, serial, ext, newCurveEnd, minVT, minCoordT, maxVT, maxCoordT, averageT] = ...
    readsubConfigMultiProfileSingleFile(regenerateDataFile, fid, directory, runRunParaName, runNoIn, fileReadNoIn,  flagNoIn, curveEndNo, ...
    readStat, numPlots, readHistories, historyFileName, historyStatFileName, cracktipVSymbol, cracktipVIndex, ...
    processZoneSymbol, processZoneIndex, cohesiveZoneSizeFileName, modifierForHistoryFiles, subCnfSymbols, plotBlack,  finalConfigName)

global cnfg;
global fem_pzStaticFactor; % for modifying static process zone size


global IconfigDirectory;
global IconfigName;
global IflagNoIn;
global IprintOption;
global IplotXuNData;
global IplotAddCRVS;
%global IplotAddCRVSLabel;
%global IplotAddCRVSlColor;
global IplotAddCRVSlStyle;
global IplotAddCRVSlWidth;
global IplotBlack;
global IplotEPS;
global IblankRowNInLegend;
global IblankTextInLegend;
global IdisableMarkers;
global IenableMarkerValues;


global IprintDltTtlLabel;
global IdrawLineSegmentes;
global IonlyDrawSize2SolUnit;


global IoutputFolder;
global IreadStat;
global IreadStatFinalTime;
global IStatFinalTimeName;
global IreadHistories;
global IgenerateHistoryFiles;
global IgenerateHistoryFiles;
global ImaxPower_historyDerInfow;
global IhistoryFileName;
global IhistoryStatFileName;
global IcracktipVSymbol;
global IcracktipVIndex;
global IprocessZoneSymbol;
global IprocessZoneIndex;
global IprocessZoneRelativeCrackOpeningSymbol;
global IprocessZoneRelativeCrackOpeningIndex;
global IprocessZoneCrackOpeningSymbol;
global IprocessZoneCrackOpeningIndex;
global ICrackOpeningSymbol;
global ICrackOpeningIndex;
global IcohesiveZoneSizeFileName;
global IcohesiveZoneSizeConfigFileName;
global ImodifierForHistoryFiles;
global IAddSerialNumber2ModifedFilesBasedOnRunOrder;
global ImaxRelativeSpacePoint2PlotHistories;
global ImaxSpaceDotInClusterReductionRel2cR;
global IallowOverwriteOfRunParameters;


global IaddIntegrateData;
global IitegateDataFileName;
global IderDataFileName;
global IitegrationNormalizationOption;

addRunSerialNum2FIleModifier = cnfg{IAddSerialNumber2ModifedFilesBasedOnRunOrder};
if (addRunSerialNum2FIleModifier == 1)
    sn_ = num2str(runNoIn);
else
    sn_ = '1';
end
    
%modifierForHistoryFilesLoc = modifierForHistoryFiles;
%cohesiveZoneSizeFileNameLoc = cohesiveZoneSizeFileName;
modifierForHistoryFilesLoc = [modifierForHistoryFiles, sn_];
cohesiveZoneSizeFileNameLoc = [cohesiveZoneSizeFileName, sn_];

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




global startTimeIndex;
global endTimeIndex;
global timeIncrementInex;
global sigmaNcohIndex;
global deltaNcohIndex;
global sigmaTcohIndex;
global deltaTcohIndex;
global EIndex;
global rhoIndex;
global nuIndex;
global plainStrainIndex;
global CdIndex;
global CsIndex;
global CrIndex;
global v0Index;
global sigma0Index;
global rampTimeIndex;
global fracEneryIndex;
global tauLEFMIndex;	
global lengthLEFMIndex;

global CZstartIndex; % start of process zone which is going to be the tip of proces zone 
global CZendIndex; % end of process zone when there is almost complete separation
global CTindex;
% reduction methods available if a cluster of points exist either min max
    % or average value of coordinate is used for single data extraction
    %1 average values is considered
    %2 min value is considered
    %3 max value is considered
global CZstartReductionIndex; % min suggested? used (gives smaller process zone size)
global CZendReductionIndex;   % max suggested? used (gives smaller process zone size) 
global allFlagsReductionIndex;% average is used in general Xu Needleman use max value for computing crack-tip position 
global maxDistInClusterIndex; % span in coordinate that defines a cluster

global derMethodIndex;   
% if there is a jump in the data (e.g.) crack tip we don't consider those
global maxPIndexDerDiffIndex; 
global flagStartIndex;
global flagEndIndex;
global serialStartIndex;
global serialEndIndex;
global CZstaticSizeIndex;

global startCohFaceIndex;
global endCohFaceIndex;
global plateWidthIndex;
global plateTimeScale;


global stressFraction;    % if effective stress is smaller than this value there is no damage force (look at flag 84)
global dam_tau_C;	
global dam_a;	
global limitFy;  % if y > 1.0 f(y) is limited by 1 if this value is larger than 0.0 otherwise it takes larger values
global allowMinusDu;  % if true for negative unbounded damage values even if f(y) == 0 we allow f(y) - du = -du > 0.0 to cause damage rate


%rundependent
flagDataFileTemp = zeros(0,0);

% flagDataFileTemp(startTimeIndex) = 0;
% flagDataFileTemp(endTimeIndex) = 40;
% flagDataFileTemp(timeIncrementInex) = 0.04;
% flagDataFileTemp(sigmaNcohIndex) = 0.0324;
% flagDataFileTemp(deltaNcohIndex) = 4e-4;
% flagDataFileTemp(sigmaTcohIndex) = 0;
% flagDataFileTemp(deltaTcohIndex ) = 0;
% flagDataFileTemp(EIndex) = 3.24;
% flagDataFileTemp(rhoIndex) = 1.19;
% flagDataFileTemp(nuIndex) = 0.35;
% flagDataFileTemp(plainStrainIndex) = 1;
% flagDataFileTemp(CrIndex) = 0.938;
% flagDataFileTemp(v0Index) = 0.0015;

generateHistories = regenerateDataFile; %cnfg{IgenerateHistoryFiles};

% plotComponentSize = zeros(1,numPlots);
plotComponentSize = [];
fileReadNoInNew = fileReadNoIn;
newCurveEnd = curveEndNo;


numFilesT = fscanf(fid,'%d', 1);
runnameT = fscanf(fid,'%s', 1);
middlenameT = fscanf(fid,'%s', 1);
flagValueFileTempT = zeros(0,0);
flagDataFileTempT = zeros(0,0);
flagSimDataTempT = zeros(0, 0);

[flagValueFileTempT, flagDataFileTempT, flagSimDataTempT]  = readFlagValueData(fid, flagDataBase, [], 0, flagValueFileTempT, flagDataFileTempT, flagSimDataTempT);
flagDataFileTempT(CZstaticSizeIndex) = flagDataFileTempT(CZstaticSizeIndex) * fem_pzStaticFactor;


if (strcmp(runRunParaName, 'NONE') == 0)
    fidRunPara = fopen(runRunParaName, 'r');
    if (fidRunPara < 0)
        fprintf(1, 'unable to open %s\n', runRunParaName);
    end
    numFiles = fscanf(fidRunPara,'%d', 1);
    runname = fscanf(fidRunPara,'%s', 1);
    middlename = fscanf(fidRunPara,'%s', 1);
    flagValueFileTemp = zeros(0,0);
    flagSimDataTempT = zeros(0, 0);
    [flagValueFileTemp, flagDataFileTemp, flagSimDataTempT] = readFlagValueData(fidRunPara, flagDataBase, [], 0, flagValueFileTemp, flagDataFileTemp, flagSimDataTempT);
    
    flagDataFileTemp(CZstaticSizeIndex) = flagDataFileTemp(CZstaticSizeIndex) * fem_pzStaticFactor;
    
    if (cnfg{IallowOverwriteOfRunParameters} == 1)
        sizeSubConfigPara = length(flagValueFileTempT);
        for i = 1:sizeSubConfigPara 
            if ((flagValueFileTempT(i) > 0) && (flagValueFileTempT(i) < 10))
                flagValueFileTemp(i) = flagValueFileTempT(i);
                flagDataFileTemp(i) = flagDataFileTempT(i);
            end
        end
    end
else
%    numFiles = numFilesT;
    runname = runnameT;
    middlename = middlenameT;
    flagValueFileTemp = flagValueFileTempT;
    flagDataFileTemp = flagDataFileTempT;
end

% flagValueFileTemp
% flagDataFileTemp
% pause
numFiles = numFilesT;


E_ = flagDataFileTemp(EIndex);
nu_ = flagDataFileTemp(nuIndex);
rho = flagDataFileTemp(rhoIndex);
mu = E_/2.0/(1+nu_);
lambda = E_*nu_/(1.+nu_)/(1-2*nu_);
if (abs(flagDataFileTemp(CdIndex)) < 1e-7) 
    if ((flagDataFileTemp(plainStrainIndex) == 0) || (flagDataFileTemp(plainStrainIndex) == -2))
        flagDataFileTemp(CdIndex) = sqrt(E_/(1 - nu_ * nu_)/rho);
    elseif ((flagDataFileTemp(plainStrainIndex) == 1) || (flagDataFileTemp(plainStrainIndex) == -3))
        flagDataFileTemp(CdIndex) = sqrt((lambda+2*mu)/rho);
    end
end
if (abs(flagDataFileTemp(CsIndex)) < 1e-7) 
    flagDataFileTemp(CsIndex) = sqrt(mu/rho);
end

[cd, cs, cr]  = computeCrackVelocities(E_, nu_, rho);


%CHANGE
flagDataFileTemp(CrIndex) = cr;
flagDataFileTemp(CdIndex) = cd;
flagDataFileTemp(CsIndex) = cs;

% cr = flagDataFileTemp(CrIndex);
% cd = flagDataFileTemp(CdIndex);


G0 = flagDataFileTemp(fracEneryIndex);
lmax = flagDataFileTemp(sigma0Index);
rampTime = flagDataFileTemp(rampTimeIndex);

if (flagDataFileTemp(v0Index) == 0)
    flagDataFileTemp(v0Index) = flagDataFileTemp(sigma0Index) /  flagDataFileTemp(CdIndex) / flagDataFileTemp(rhoIndex);
elseif (flagDataFileTemp(sigma0Index) == 0)
    flagDataFileTemp(sigma0Index) = flagDataFileTemp(v0Index) *  flagDataFileTemp(CdIndex) * flagDataFileTemp(rhoIndex);
end


if (flagDataFileTemp(tauLEFMIndex) < 1e-26)
    crackSLoad = 2 * lmax;
    if (rampTime > 0)
        tauLEFM = pi / 4.0 * G0 * cd * rho / crackSLoad^2;
    else
        tauLEFM = power(9.0 * pi / 16.0 * G0 * cd * rho / crackSLoad^2, 1.0 / 3.0);
    end
    flagDataFileTemp(tauLEFMIndex) = tauLEFM;
end
if (flagDataFileTemp(lengthLEFMIndex) < 1e-26)
    flagDataFileTemp(lengthLEFMIndex) = flagDataFileTemp(tauLEFMIndex) * cr;
end

flagDataFileTemp(plateTimeScale) = flagDataFileTemp(plateWidthIndex) / cd;



if (readHistories == 1)

%    This is for dugdale (1960) rectilinear law (from paper
%    C:\project\research_paper\Cohesive\FractureLiterature\AddCRVSCTspeedVsZoneSize2000.pdf   
%    flagDataFileTemp() = pi * mu * flagDataFileTemp(deltaNcohIndex)/ 4.0 / (1 - nu_) / flagDataFileTemp(sigmaNcohIndex);

%    for cohesive traction laws that there is a dispalcement potential (T =
%    Dphi/DDelta) static process zone size is given by
%   9pi/32 * E/(1 - nu^2) * Phi_0/T_max^2 (Phi_0 is total energy under
%   traction separation law and T_max is max cohesive stress) for Xu
%   Needleman model Phi_0 = sigmaCoc * deltaCoh * e so
%   refefence:
%   C:\project\research_paper\Cohesive\FractureLiterature\InterestingCZSize_BoundsOnCohesiveElementSize.pdf
%   (1 - nu_2) may be removed for plain stress model
    fac = (1 - nu_^2);
    if ((flagDataFileTemp(plainStrainIndex) == 0) || (flagDataFileTemp(plainStrainIndex) == -2))
        fac = 1.0;
    end
    if (abs(flagDataFileTemp(CZstaticSizeIndex)) < 1e-12)
        flagDataFileTemp(CZstaticSizeIndex) = pi * exp(1.0) * 9.0 / 32.0 * flagDataFileTemp(EIndex)/ fac * flagDataFileTemp(deltaNcohIndex) / flagDataFileTemp(sigmaNcohIndex);
    end
    
    
    serialStat = -1;
    generateHistoriesT1 = generateHistories;
    if (generateHistories == 0)
        fileNameStatN = getFileName(directory, runname, middlename, flagDataFileTemp(CTindex), ...
        cnfg{IcohesiveZoneSizeConfigFileName}, serialStat, 'txt');
        fidStatN = fopen(fileNameStatN,'r');
        if (fidStatN < 0)
            generateHistoriesT1 = 1;
        else
            fclose(fidStatN);
        end
    end
        
        %rundependent
    flagnumCoh = flagDataFileTemp(flagStartIndex):flagDataFileTemp(flagEndIndex);

    for serialCoh = flagDataFileTemp(serialStartIndex):flagDataFileTemp(serialEndIndex)
        generateHistoriesTemp = generateHistoriesT1;
        if (generateHistoriesTemp == 0)
            filenameCZN = getFileName(directory, runname, middlename, -1, cohesiveZoneSizeFileNameLoc, serialCoh, 'txt');
            fidCZN = fopen(filenameCZN,'r');
            if (fidCZN < 0)
                generateHistoriesTemp = 1;
            else
                fclose(fidCZN);

                nameN = [historyFileName, modifierForHistoryFilesLoc];
                for index = 1:  length(flagnumCoh)
                    flag = flagnumCoh(index);
                    modFileN = getFileName(directory, runname, middlename, flag, nameN, serialCoh, 'txt');
                    fidM = fopen(modFileN,'r');
                    if (fidM < 0)
                        generateHistoriesTemp = 1;
                    else
                        fclose(fidM);
                    end
                end

                if (generateHistoriesTemp == 0)
                    filenameCZ = getFileName(directory, runname, middlename, -1, cohesiveZoneSizeFileNameLoc, serialCoh, 'txt');
                    fidM = fopen(filenameCZ,'r');
                    if (fidM < 0)
                        generateHistoriesTemp = 1;
                    else
                        fclose(fidM);
                    end
                end
            end
        end
        if (generateHistoriesTemp == 1)
    %[cohZoneReduction, dataTimeSortedSpaceClusterReduction, cohZoneReductionDerivative, dataTimeSortedSpaceClusteredReducedDerivative] = 
            computeProcessZoneSize(directory, runname, middlename, flagnumCoh, historyFileName, serialCoh, 'txt', historyStatFileName, serialStat, 'txt', ...
            flagDataFileTemp(CZstartIndex), flagDataFileTemp(CZendIndex), flagDataFileTemp(CTindex), flagDataFileTemp(startTimeIndex), ...
            flagDataFileTemp(endTimeIndex), flagDataFileTemp(timeIncrementInex), flagDataFileTemp(maxDistInClusterIndex), ...
            flagDataFileTemp(allFlagsReductionIndex), flagDataFileTemp(CZstartReductionIndex), flagDataFileTemp(CZendReductionIndex),...
            cracktipVSymbol, cracktipVIndex, processZoneSymbol, processZoneIndex, flagDataFileTemp(derMethodIndex), flagDataFileTemp(maxPIndexDerDiffIndex), ...
            cohesiveZoneSizeFileNameLoc, modifierForHistoryFilesLoc, flagDataFileTemp, ...
            flagDataFileTemp(startCohFaceIndex), flagDataFileTemp(endCohFaceIndex), flagDataFileTemp(CrIndex));
        end
    end
end



for file = 1:numFiles
    fileReadNoInNew = fileReadNoInNew + 1;
    flagValueFile{fileReadNoInNew} = flagValueFileTemp;
    flagDataFile{fileReadNoInNew} = flagDataFileTemp;
    [Sizes, xcols, ycols, curves, linespecs, symbols, xaxiss, yaxiss,  xmaxDists, ymaxDists, markers, startingPtss, colSizes, maxCrosss, ...
        minVs, minCoords, min_eIDs, min_ids, maxVs, maxCoords, max_eIDs, max_ids, counters, averages, sums, sDiviations, ...
        fieldNames,flagnums, names, serials, exts, newCurveEnd, minVTs, minCoordTs, maxVTs, maxCoordTs, averageTs] = ...
    readMultiProfileSingleFile(fid, directory, runNoIn,  runname, middlename, fileReadNoInNew,  flagNoIn, ...
        newCurveEnd, readStat, subCnfSymbols, plotBlack); 
    [m, plotSize] = size(Sizes);
    for plotNo = 1:plotSize
        if (length(Sizes{plotNo}) == 0)
            continue;
        end
        if (length(plotComponentSize) < plotNo)
            plotComponentSize(plotNo) = 1;
        else
            plotComponentSize(plotNo) = plotComponentSize(plotNo) + 1;
        end
        plotFileNumber{plotNo}{plotComponentSize(plotNo)} = fileReadNoInNew;
        Size{plotNo}{plotComponentSize(plotNo)} = Sizes{plotNo};
        xcol{plotNo}{plotComponentSize(plotNo)} = xcols{plotNo};
        ycol{plotNo}{plotComponentSize(plotNo)} = ycols{plotNo};
        curve{plotNo}{plotComponentSize(plotNo)} = curves{plotNo};
        linespec{plotNo}{plotComponentSize(plotNo)} = linespecs{plotNo};
        symbol{plotNo}{plotComponentSize(plotNo)} = symbols{plotNo};
        xaxis{plotNo}{plotComponentSize(plotNo)} = xaxiss{plotNo};
        yaxis{plotNo}{plotComponentSize(plotNo)} = yaxiss{plotNo};        
        xmaxDist{plotNo}{plotComponentSize(plotNo)} = xmaxDists{plotNo};        
        ymaxDist{plotNo}{plotComponentSize(plotNo)} = ymaxDists{plotNo};        
        marker{plotNo}{plotComponentSize(plotNo)} = markers{plotNo};        
    end
%statistics related
    if (readStat == 1)
        startingPts{file} = startingPtss;
        colSize{file} = colSizes;
        maxCross{file} = maxCrosss;
        minV{file} = minVs;
        minCoord{file} = minCoords;
        min_eID{file} = min_eIDs;
        min_id{file} = min_ids;
        maxV{file} = maxVs;
        maxCoord{file} = maxCoords;
        max_eID{file} = max_eIDs;
        max_id{file} = max_ids;
        counter{file} = counters;
        average{file} = averages;
        sum{file} = sums;
        sDiviation{file} = sDiviations;
        fieldName{file} = fieldNames;
        minVT{file} = minVTs;
        minCoordT{file} = minCoordTs;
        maxVT{file} = maxVTs;
        maxCoordT{file} = maxCoordTs;
        averageT{file} = averageTs;
    end
    
    directoryO{file} = directory;
    runnameO{file} = runname;
    middlenameO{file} = middlename;
    name{file} = names;
    flagnum{file} = flagnums;
    serial{file} = serials;
    ext{file} = exts;
   
end