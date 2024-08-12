%==========================================================================
%   plotPDeltaFromSync(arg0,...)
%
%   this function uses data from sync files (field data) that corresponds
%   to displacement and force fields to determine net displacement and net
%   traction for each solution slab/sync file.
%
%   IOModeIn: determines whether data file will be (generated, written, and
%   plotted) indicated by 'w' or if plot is created by reading in an
%   already generated data file indicted by 'r'.
%
%   IF IOModeIn = 'r' or 'w'
%   -f <...> : if above is 'r', this is the full file path of the read file
%              if above is 'w', this is ONLY the name of the output filename   
%
%   IF IOModeIn = 'w'
%   -d <...> : old code home directory (eg. 'old_YYYY_MM_DD') 
%   -p <...> : boolean to indicate if data is (1)cleared from memory after
%               printed or kept until the end of function run(0) 
%   -i <...> : serial number interval for sync files 
%               format: [serialStart serialEnd] 
%==========================================================================

function plotPDeltaFromSync(IOModeIn,varargin)
clearvars -except varargin IOModeIn
close all; clc

addpath('spaceMesh');
N = length(varargin);

% Boolean to print totalRun time to file and console output
PRINT_TIME = 1;

%---GLOBAL VARIABLES DECLARATION---
global IOMode 
IOMode = 'w';

global flgLoc locNames
flgLoc = struct('EAST',3,'WEST',5,'NORTH',4,'SOUTH',2);
locNames = fieldnames(flgLoc);

global delX delY
delX = 'uin0';
delY = 'uin1';

global PX PY
PX = 's0';
PY = 's1';

global outputFileName
outputFileName = 'PDelta_Output.txt';

global outputDirectory
global outputFilePath
global fullSynFilePathBase
global fileHomeDirectory
global physicsDirectory
global serialRange
global totalTime
%---END GLOBAL VAR DEF-------------


%---INPUT ARG ASSIGNMENTS---
fileHomeDirectory = '';
fullSynFilePathBase = '';
serialRange = [];
printAndDiscard = 1;

if nargin >= 1
   if (strcmpi(IOModeIn,'r') ~= 1 ) && (strcmpi(IOModeIn,'w') ~= 1)
       THROW('Invalid IO option. Argument list must begin with (w)rite or (r)ead argument.');
   end
   IOMode = IOModeIn; 
end
if mod(N,2)~=0
    THROW('Insufficient number of input arguments.');
end

for n = 1:N
   if strcmpi(varargin{n},'-d') == 1
        n = n + 1;
        fileHomeDirectory = varargin{n};
   elseif strcmpi(varargin{n},'-f') == 1
        n = n + 1;
        outputFileName = varargin{n};     
   elseif strcmpi(varargin{n},'-p') == 1
        n = n + 1;
        printAndDiscard = varargin{n};
   elseif strcmpi(varargin{n},'-i') == 1
        n = n + 1;
        tempRange = varargin{n};
        if length(tempRange) < 2 || length(tempRange) > 3
            THROW('Invalid number of serial range input.');
        elseif length(tempRange) == 2
            fileHomeDirectory = tempRange;
        elseif length(tempRange) == 3
            %DO NOTHING FOR NOW
        end 
   end
end

if isempty(fileHomeDirectory)
    fileHomeDirectory = '..';
else
    fileHomeDirectory =fullfile('../..',fileHomeDirectory);
end
physicsDirectory = fullfile(fileHomeDirectory,'physics');
fullSynFilePathBase = fullfile(physicsDirectory,'frontSync');

%---OUTPUT FILE AND DIRECTORY ASSIGNMENT-----------------------------------
out = -1;
%if printAndDiscard == 1
if strcmpi(IOMode,'w') == 1
    outputDirectory = fullfile(fileHomeDirectory,'matlabOld','spaceMesh','Output_SyncMesh');
    if (exist(outputDirectory,'dir') ~= 7)
        mkdir(fullfile(fileHomeDirectory,'matlabOld','spaceMesh'),'Output_SyncMesh');
    end

    outputFilePath = fullfile(outputDirectory,outputFileName);
    out = fopen(outputFilePath,'w');
elseif strcmpi(IOMode,'r') == 1
    out = fopen(outputFileName,'r');
end
%end
%--------------------------------------------------------------------------
%END INPUT ARG ASSIGN


%-----MAIN CODE--------------------------------
%local variable declarations
fileList = {};
varLength = 0;
tt = tic;

if strcmpi(IOMode,'w') == 1
    fileList = getFileList(fullSynFilePathBase, serialRange);
    varLength = length(fileList);
    printSyncHeader(out, varLength);
elseif strcmpi(IOMode,'r') == 1
    varLength = READ(out,'i',1);
end

syncObj = cell(varLength,1);

Px = NaN.*ones(varLength,1);
Py = NaN.*ones(varLength,1);
Dx = NaN.*ones(varLength,1);
Dy = NaN.*ones(varLength,1);

for i = 1 : varLength
    syncObj{i} = struct('serial', -1,...
                        'time', 0,...
                        'sSpecs', [],...
                        'bFields', [],...
                        'iFields', struct('iCrackLengths',0),...
                        'runTime', 0,...
                        'PD', struct('Px',0,'Py',0,'Dx',0,'Dy',0));
    %startTimer
    it = tic;
                    
    if strcmpi(IOMode,'r') == 1
        syncObj{i} = getLinePDFile(out);
        
        %endTimer
        syncObj{i}.runTime = toc(it);
    elseif strcmpi(IOMode,'w') == 1 
        %---serial number values-----------
        syncObj{i}.serial = fileList{i}.sn;
        %----------------------------------
        %---time values--------------------
        syncObj{i}.time = (fileList{i}.timeMax - fileList{i}.timeMin)/2;
        %----------------------------------
        %---Boundary Averaged Quantities---
        syncObj{i}.bFields = struct(locNames{1},[],locNames{2},[],locNames{3},[],locNames{4},[]);
        syncObj{i}.bFields.(locNames{1}) = struct('P',0,'Delta',0,'Length',0);
        syncObj{i}.bFields.(locNames{2}) = struct('P',0,'Delta',0,'Length',0);
        syncObj{i}.bFields.(locNames{3}) = struct('P',0,'Delta',0,'Length',0);
        syncObj{i}.bFields.(locNames{4}) = struct('P',0,'Delta',0,'Length',0);
        %----------------------------------

        [pathstr,name,~] = fileparts(fileList{i}.file);
        syncFileBase = fullfile(physicsDirectory,pathstr,name);

        syncObj{i}.sSpecs = Vector_syncSpec();
        syncObj{i}.sSpecs.read(syncFileBase);

        syncObj{i} = updateParentBoundaryAveragedValues(syncObj{i});
        
        syncObj{i}.PD = getPDelta(syncObj{i});
        
        %endTimer
        syncObj{i}.runTime = toc(it);
        
        %PRINT
        printSyncRun(out, syncObj{i});
    end

    %TEMP BLOCK FOR PLOT OUTPUT DEBUG     
    Px(i) = syncObj{i}.PD.Px;
    Py(i) = syncObj{i}.PD.Py;
    Dx(i) = syncObj{i}.PD.Dx;
    Dy(i) = syncObj{i}.PD.Dy;
    %END TEMP

    %PRINT AND DISCARD
    if (printAndDiscard == 1) && (strcmpi(IOMode,'w') == 1)
        syncObj{i} = {};
        fileList{i} = {};
    end   
    %END PRINT AND DISCARD
end

%==================================
% PRINTING BLOCK
interp = 'tex';

figure(1)
ax1 = axes();
plot(ax1,Dx,Px,'*');
axis(ax1,'equal');
title('P_{0} versus \Delta U_{0}','Interpreter',interp);
xlabel('\Delta U_{0}','Interpreter',interp);
ylabel('P_{0}','Interpreter',interp);

figure(2)
ax2 = axes();
plot(ax2,Dy,Py,'*');
axis(ax2,'equal');
title('P_{1} versus \Delta U_{1}','Interpreter',interp);
xlabel('\Delta U_{1}','Interpreter',interp);
ylabel('P_{1}','Interpreter',interp);
%==================================

%---END MAIN---
totalTime = toc(tt);


%STAT PRINT-------------
hrs = floor(totalTime/3600);
mins = floor((totalTime-hrs)/60);
sec = totalTime - (hrs*3600 + mins*60);
if PRINT_TIME == 1
    fprintf(1,'*** run time: %i[h] %i[m] %.5f[s] ***\n',hrs,mins,sec);
    if strcmpi(IOMode,'w') == 1
        fprintf(out,'# =====================================================================================================\n');
        fprintf(out,'# *** run time: %i[h] %i[m] %.5f[s] ***',hrs,mins,sec);        
    end
end
%if printAndDiscard == 1
    fclose(out);
%end
end

function effFronts = getFileList(fullSynFilePathBase, serialNums)
printAll = 1;
    if ~isempty(serialNums)
        if length(serialNums) == 2
            printAll = 0;
        else
            THROW('serialNums range must be of length two specifying min and max serial numbers');
        end        
    end
    fileName = strcat(fullSynFilePathBase,'.all');
    fid = fopen(fileName,'r');
    if fid < 0
       THROW('frontSyn.all is not open for read.'); 
    end
    
    allFronts = frontClass();
    allFronts.readAll(fid);
    
    if allFronts.numFiles < 1
        THROW('number of sync files is insufficient for processing.');
    end
    
    if printAll == 1
       effFronts = allFronts.fronts;
       return;
    end
    
    j = 1;
    effFronts = {};
    for i = 1 : allFronts.numFiles
        if allFronts.fronts{i}.sn >= serialNums(1) && allFronts.fronts{i}.sn <= serialNums(2)
            effFronts{j} = allFronts.fronts{i};
            j = j + 1;
        end
    end
end

function syncObject = updateParentBoundaryAveragedValues(syncObject)
global delX delY
global PX PY

hasBoundary = 0;
bdryFlags = [];

   sz = length(syncObject.sSpecs);
 
   dxi = syncObject.sSpecs.find(delX);
   dyi = syncObject.sSpecs.find(delY);
   pxi = syncObject.sSpecs.find(PX);
   pyi = syncObject.sSpecs.find(PY);

   lenSeg = length(syncObject.sSpecs.segments);       
   for j = 1 : lenSeg
       allBdryPts = 1;
        
       %---CHECK----------
       if syncObject.sSpecs.segments{j}.numP == 0
           continue;
       end
       %------------------
       
       hasBoundary = hasBoundary || syncObject.sSpecs.segments{j}.dat{1}.b;
       allBdryPts = allBdryPts && syncObject.sSpecs.segments{j}.dat{1}.b;

       for k = 2 : syncObject.sSpecs.segments{j}.numP
           hasBoundary = hasBoundary || syncObject.sSpecs.segments{j}.dat{k}.b;
           allBdryPts = allBdryPts && syncObject.sSpecs.segments{j}.dat{k}.b;

           x1 = syncObject.sSpecs.segments{j}.dat{k-1};
           x2 = syncObject.sSpecs.segments{j}.dat{k};

           [syncObject.bFields, updated] = updateBAV(syncObject.bFields, x1, x2, dxi, dyi, pxi, pyi);
           if updated 
              bdryFlags = [bdryFlags,x1.flg,x2.flg];
              [bdryFlags,~,~] = unique(bdryFlags);
           else
              len = sqrt(sum((x1.X - x2.X).^2));
              syncObject.iFields.iCrackLengths = syncObject.iFields.iCrackLengths + len;
           end
       end           
   end
    
    if hasBoundary == 0 || length(bdryFlags) ~= 4
        THROW('Domain is ill-defined: closed domain boundary not specified.');
    end
end

function bOrientation = boundaryOrientation(x1, x2)
global flgLoc locNames
    bOrientation = 'NONE';
    proceed = (x1.b && x2.b) && (x1.flg == x2.flg);
    if proceed
        for i = 1 : length(locNames)
            if (flgLoc.(locNames{i}) == x1.flg)
                bOrientation = locNames{i};
                break;
            end
        end
%         if x1.X(1) == x2.X(1) % vertical
%             if x1.X(1) == xlims(1)
%                 bOrientation = 'WEST';
%             elseif x1.X(1) == xlims(2)
%                 bOrientation = 'EAST';
%             end
%         elseif x1.X(2) == x2.X(2) % horizontal
%            if x1.X(2) == ylims(1)
%                 bOrientation = 'SOUTH';
%             elseif x1.X(2) == ylims(2)
%                 bOrientation = 'NORTH';
%            end
%         end
    end
end

function [BAVObj, bool] = updateBAV(BAVObj, x1, x2, dxi, dyi, pxi, pyi)
    ori = boundaryOrientation(x1, x2);
    bool = 0;
    if strcmpi(ori,'none') == 0 %boundary segment
        len = sqrt(sum((x1.X - x2.X).^2));
        if strcmpi(ori,'north') == 1 || strcmpi(ori,'south') == 1
            Pi = pyi;
            Di = dyi;
        elseif strcmpi(ori,'east') == 1 || strcmpi(ori,'west') == 1
            Pi = pxi;
            Di = dxi;
        end
        PAve = (( x1.flds(Pi) + x2.flds(Pi) )/2);
        DispAve = (( x1.flds(Di) + x2.flds(Di) )/2);
            
        BAVObj.(ori).P = BAVObj.(ori).P + ( PAve * len);
        BAVObj.(ori).Delta = BAVObj.(ori).Delta + ( DispAve * len);
        BAVObj.(ori).Length = BAVObj.(ori).Length + len;
        bool = 1;
    end    
end

function PD = getPDelta(syncObj)
    PD = struct('Px',[],'Py',[],'Dx',[],'Dy',[]);
    PD.Px = (syncObj.bFields.EAST.P / syncObj.bFields.EAST.Length);
    PD.Py = (syncObj.bFields.NORTH.P / syncObj.bFields.NORTH.Length);
    PD.Dx = (syncObj.bFields.EAST.Delta / syncObj.bFields.EAST.Length) - (syncObj.bFields.WEST.Delta / syncObj.bFields.WEST.Length);
    PD.Dy = (syncObj.bFields.NORTH.Delta / syncObj.bFields.NORTH.Length) - (syncObj.bFields.SOUTH.Delta / syncObj.bFields.SOUTH.Length);
end

function printSyncHeader(fid,numberOfEntries)
fprintf(fid,'# Number of Entries\n');
fprintf(fid,'%i\n',numberOfEntries);
fprintf(fid,'# =====================================================================================================\n');
fprintf(fid,'# SerialNo.\t RunTime[s]\t DeltaU0\t\t P0\t\t\t\t DeltaU1\t\t P1\t\t\t\t TotalCrackLength\n');
fprintf(fid,'# =====================================================================================================\n');
end

function printSyncRun(fid, syncObj)
if fid < 0
    THROW('file not open for output.');
end
    
PD = getPDelta(syncObj);
fprintf(fid,'%10.0f\t %5.5f\t %.5e\t %.5e\t %.5e\t %.5e\t %.5e\n',...
        syncObj.serial,syncObj.runTime,...
        PD.Dx,PD.Px,...
        PD.Dy,PD.Py,...
        syncObj.iFields.iCrackLengths);
end

function synObjEntry = getLinePDFile(fid)
    synObjEntry = struct('serial', -1,...
                        'time', 0,...
                        'sSpecs', [],...
                        'bFields', [],...
                        'iFields', struct('iCrackLengths',0),...
                        'runTime', 0,...
                        'PD', struct('Px',0,'Py',0,'Dx',0,'Dy',0));
    synObjEntry.serial = READ(fid,'i',1);
    synObjEntry.time = READ(fid,'f',1);
    synObjEntry.PD.Dx = READ(fid,'f',1);
    synObjEntry.PD.Px = READ(fid,'f',1);
    synObjEntry.PD.Dy = READ(fid,'f',1);
    synObjEntry.PD.Py = READ(fid,'f',1);
    synObjEntry.iFields.iCrackLengths = READ(fid,'f',1);
end