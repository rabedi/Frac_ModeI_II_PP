function MAINFILE_operatorSpaceMesh(configName, serialNumbers, runNames, fileNamesIn, runFolder, outputPhysicsDirectory, deformationScale, doCLS, ...
 outputFolder, nameFlds, nameFldsLatex, timeGiven, timeMinGiven, timeMaxGiven, ...
 modifyInput, xlim, ylim, printOption, outputDirectoryMidName, startFileName)
if (length(serialNumbers) == 0)
	return;
end


%Modified to incorporate the addition of a option flag within the
%'confgName' function argument. if not appended to argument string the
%default is '-mesh'.
%configName = '-mesh configFileName': plot spaceMesh
%configName = '-sync configFileName': plot synchronized solution at given
%time
%configName = '-both configFileName': plot bout spaceMesh and synchronized
%solutions
global visSet; visSet = 'on';
global globalVisibility; globalVisibility = 'off';

global superImpTmpGlobal;
global flag2LineWMap;
global uniColorMFOSM; uniColorMFOSM = [];
global uniLineWidthMFOSM; uniLineWidthMFOSM = [];

tags = {'-mesh','-sync','-both'};
opt = '';
len = length(configName);
for tg = 1:length(tags)
   loc = strfind(configName,tags{tg});
   if isempty(loc)
       continue;
   else
       if (loc + length(tags{tg}))==len
           continue;
       else
           if ~isspace(configName(loc + length(tags{tg})))
              continue;
           else
               opt = tags{tg};
               configName = configName((loc + length(tags{tg}) + 1):len);
           end
       end
   end
end
if isempty(opt) 
    opt = '-mesh'; 
end

w = warning('off','all');

%========================================== 
% 5/26/2017
runLength = length(runFolder);
szGivenFiles = zeros(runLength,1);

printFinal = struct('active',0,'file','default.png','fieldOverride','all');
if runLength > 1
   printFinal.active = 1;
   printFinal.fieldOverride = 'D';
end

szGivenFiles = 0;
if (nargin > 1)
    for snLen = 1:runLength
        szGivenFiles(snLen) = length(serialNumbers{snLen});
    end
end

allEqual = @(x)length(unique(x))==1;
if allEqual(szGivenFiles) ~= 1
    THROW('Number for serial numbers but be in agreement for multiplot superimpose option.');
end
uniSz = szGivenFiles(end);
clearvars = szGivenFiles;
%========================================== 

if nargin < 7
    deformationScale = -1;
end
if nargin < 8
    doCLS = 1;
end
if nargin < 15
    modifyInput = 0;
end

global configGen;
global configSync;

global s_serialStart;
global s_serialStep;
global s_serialEnd;

global vpsObj;
global vssObj;

global FIG;
global AX;

global s_dirOut;

addpath('../');

%................................
if strcmp(opt,'-mesh')
    vpsObj = Vector_pSpec();
elseif strcmp(opt,'-sync')
     vssObj = Vector_syncSpec();   
elseif strcmp(opt,'-both')
    vpsObj = Vector_pSpec();
    vssObj = Vector_syncSpec();
end
%................................

configGen = readSpaceMeshConfigFile(opt, configName, modifyInput);    
if (strcmp(outputFolder, 'none') == 0)
    configGen{8} = outputFolder;
end

if (modifyInput == 1)
    returnVal = modifySpaceMeshConfig(xlim, ylim, printOption, outputDirectoryMidName, startFileName);
    if (returnVal == 0)
        return;
    end
end

%FIG = setDefaultPlotVisible(visSet,'reset');
%spaceMesh.................................................................
%FIG = cell(1,uniSz);
%AX = cell(1,uniSz);

if strcmp(opt,'-mesh') || strcmp(opt,'-both')
    %if (szGivenFiles > 0)
    if (uniSz > 0)
        uniqueIdentifier = 0;
        for j = 1:uniSz
            [FIG,AX] = setDefaultPlotVisible(globalVisibility,'reset');
            for i = 1:runLength               
                plotSpaceMeshSerialNumber(serialNumbers{i}(j), ...
                    nameFlds, nameFldsLatex, timeGiven, timeMinGiven, timeMaxGiven, ...
                    modifyInput, fileNamesIn{i}{j}, runNames{i}{j}, runFolder{i}, outputPhysicsDirectory, printFinal);                
            end
            %========================================== 
            % 5/26/2017
            if printFinal.active == 1
                OutputFigureDir = fullfile(configGen{s_dirOut},['m_',printFinal.fieldOverride]);
                if isdir(OutputFigureDir)
                    % continue
                else
                    mkdir(OutputFigureDir);
                end
                %
                printFinal.file = fullfile(OutputFigureDir,['MultiMesh-runIndex_',num2str(j),'-fld_',printFinal.fieldOverride,'.png']);
                while exist(printFinal.file, 'file') == 2
                    printFinal.file = fullfile(OutputFigureDir,['MultiMesh-runIndex_',num2str(j),'-fld_',printFinal.fieldOverride,'-image',num2str(uniqueIdentifier),'.png']);
                    uniqueIdentifier = uniqueIdentifier + 1;
                end
                %
                PRINT(FIG,printFinal.file);
            end
            %==========================================             
        end
    else
        for cnf = configGen{s_serialStart}:configGen{s_serialStep}:configGen{s_serialEnd}
            [FIG,AX] = setDefaultPlotVisible(globalVisibility,'reset');
            plotSpaceMeshSerialNumber(cnf, ...
                nameFlds, nameFldsLatex, timeGiven, timeMinGiven, timeMaxGiven, ...
                modifyInput);
        end
    end
end
%..........................................................................


%syncPlot..................................................................
%Need to be altered with main function argument alterations to take into
%accound two sets of certain arguments (for sync|spaceMesh)
%FIG = cell(1,uniSz);
%AX = cell(1,uniSz);

if strcmp(opt,'-sync') || strcmp(opt,'-both')
    
    %sync deformation scale is overriden
    scalingDefaultFromFile = configSync.scalingFactor;
    if deformationScale > -1.0
       configSync.scalingFactor = deformationScale;
    end
    %end_override
    
    %if (szGivenFiles > 0)
    if (uniSz > 0)
        uniqueIdentifier = 0;
        for j = 1:uniSz            
            [FIG,AX] = setDefaultPlotVisible(globalVisibility,'reset');
            
            %for manual legend where applicable
            legLineWidth = cell(runLength,1);
            legColor = cell(runLength,1);
            legLineStyle = cell(runLength,1);
            legMarker = cell(runLength,1);
            legMarkerSize = cell(runLength,1);
            
            for i = 1:runLength
                if printFinal.active == 1
                   if superImpTmpGlobal.uniqueClr == 1 
                        uniColorMFOSM = superImpTmpGlobal.lineSpecs{i}.lc;
                        legColor{i} = uniColorMFOSM;
                   end
                end
                plotSyncSerialNumber(serialNumbers{i}(j), modifyInput, fileNamesIn{i}{j}, runNames{i}{j}, runFolder{i}, outputPhysicsDirectory, printFinal);               
                uniColorMFOSM = [];
                %
                legLineWidth{i} = uniLineWidthMFOSM;
                uniLineWidthMFOSM = [];
            end
            %========================================== 
            % 5/26/2017
            if printFinal.active == 1
                %manual legend set
                manualLegend(superImpTmpGlobal.legendText,legLineWidth, legColor, legLineStyle, legMarker, legMarkerSize);
                
                OutputFigureDir = fullfile(configGen{s_dirOut},['s_',printFinal.fieldOverride]);
                if isdir(OutputFigureDir)
                    % continue
                else
                    mkdir(OutputFigureDir);
                end
                %
                printFinal.file = fullfile(OutputFigureDir,['MultiSync-runIndex_',num2str(j),'-fld_',printFinal.fieldOverride,'.png']);
                while exist(printFinal.file, 'file') == 2
                    printFinal.file = fullfile(OutputFigureDir,['MultiSync-runIndex_',num2str(j),'-fld_',printFinal.fieldOverride,'-image',num2str(uniqueIdentifier),'.png']);
                    uniqueIdentifier = uniqueIdentifier + 1;
                end

                %
                PRINT(FIG,printFinal.file);
            end
            %==========================================            
        end
    else
        for cnf = configSync.serialNum(1):configSync.serialNum(2):configSync.serialNum(3)
            [FIG,AX] = setDefaultPlotVisible(globalVisibility,'reset');
            plotSyncSerialNumber(cnf, modifyInput);
        end
    end
    
    configSync.scalingFactor = scalingDefaultFromFile;
end
%..........................................................................

setDefaultPlotVisible('on');

if (doCLS)
    cls_
end

warning(w);
uniColorMFOSM = [];

end