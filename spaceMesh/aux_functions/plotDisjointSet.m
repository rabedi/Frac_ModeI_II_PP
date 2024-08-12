function plotDisjointSet(varargin)
clc
close all;

addpath('../');
addpath('aux_functions');
global TOPDIR; TOPDIR = '../../'; 


% serialNumbers = [0 1 0];   
fileNameBase = 'ds';   
outputPhysicsDirectory = 'physics';   
runFolder = '';


N = nargin;
if mod(N,2)~=0
   THROW('insufficent number of input, must be flag-option pair.'); 
end

xIn = 'serial';
yIn = 'measure';

allData = {'time','serial','set','measure','count'};
allLabels = {'t','serial','ID^{dset}','L^{total}','n'};
lineMarker = {'+','o','*','x','s','d','^','v','>','<','p','h'};
lineSpec = {'-','--',':','-.'};
fontSz = 20;
legendFontSz = (2/3) * fontSz;
titleFontSz = 20;
interp = 'latex';

global allData_plotDisjointSet; allData_plotDisjointSet = allData;
global allLabels_plotDisjointSet; allLabels_plotDisjointSet = allLabels;

i = 1;
while(i <= N)
   if strcmpi(varargin{i},'-f')==1
       i = i + 1;
       runFolder = fullfile('..',varargin{i});
   elseif strcmpi(varargin{i},'-x')==1
       i = i + 1;
       xIn = varargin{i};
   elseif strcmpi(varargin{i},'-y')==1
       i = i + 1;
       yIn = varargin{i};
   elseif strcmpi(varargin{i},'-tinc')==1
       i = i + 1;
       delt_plotDisjointSet = varargin{i};        
   elseif strcmpi(varargin{i},'-d')==1
       i = i + 1;
       outputPhysicsDirectory = varargin{i};
%    elseif strcmpi(varargin{i},'-sn')==1
%        i = i + 1;
%        serialNumbers = varargin{i};
   elseif strcmpi(varargin{i},'-bn')==1
       i = i + 1;
       fileNameBase = varargin{i};
   else
       THROW('Invalid Option');
   end
   i = i + 1;
end

if isempty(runFolder)
   runFolder = fullfile('..',getCurrentWorkingRunFolder());    
end

xFound = find(cellfun(@(x) strcmp(x,xIn),allData,'UniformOutput',true));
if isempty(xFound)
    msg = sprintf('Invalid x data [%s].',xIn);
    THROW(msg);
else
    xLab2Use = allLabels{xFound(1)};
end
yFound = find(cellfun(@(y) strcmp(y,yIn),allData,'UniformOutput',true));
if isempty(yFound)
    msg = sprintf('Invalid y data [%s].',yIn);
    THROW(msg);
else
    yLab2Use = allLabels{yFound(1)};
end

% if length(serialNumbers) ~= 3
%    THROW('Serial name must be vector of size 3; i.e. [serialStart serialIncrement serialEnd].'); 
% end

%==========================================================================
disjointDir = 'output_disjointSet';
frontFileName = 'front';
frontAllPath = fullfile(TOPDIR,runFolder,outputPhysicsDirectory);
fc = frontClass();
fid = fopen(fullfile(frontAllPath,[frontFileName,'.all']),'r');
if fid < 1
   msg = sprintf('File [%s] not open for read.\n',fullfile(frontAllPath,[frontFileName,'.all'])); 
   THROW(msg);
end
fc.readAll(fid);
fclose(fid);
%==========================================================================


X = {};
count = 0;
if fc.numFiles ~= 0
    for i = 1:fc.numFiles
    %for i = serialNumbers(1):serialNumbers(2):serialNumbers(3)   
       filePathBase = fullfile(TOPDIR,runFolder,outputPhysicsDirectory,disjointDir,[fileNameBase,sprintf('%010d',fc.fronts{i}.sn)]); 
       refs = readReferencedFile([filePathBase,'.refs']); 

       if isempty(X)
           X = cell(length(refs),1); 
            for j = 1:length(refs)
                X{j} = struct('index',[],'refID',-1,'set',[],'serial',[],'n',[],'L',[],'t',[]);   
            end
       end
       count = count + 1;
       t_ave = (fc.fronts{i}.timeMin + fc.fronts{i}.timeMax)/2;
       for j = 1:length(refs)
           if i ~= 1%serialNumbers(1)
                ind = findID(X,refs{j}.refID);
                indepVar = count;
                X{ind}.index = [X{ind}.index, indepVar];
                X{ind}.set = [X{ind}.set, refs{j}.set];
                X{ind}.serial = [X{ind}.serial, fc.fronts{i}.sn];
                X{ind}.n = [X{ind}.n, refs{j}.n];
                X{ind}.L = [X{ind}.L, refs{j}.L];
                X{ind}.t = [X{ind}.t, t_ave];
           else
                indepVar = count;
                X{j} = struct('index',[indepVar],'refID',refs{j}.refID,'set',[refs{j}.set],'serial',[fc.fronts{i}.sn],'n',[refs{j}.n],'L',[refs{j}.L],'t',[t_ave]); 
           end
       end
    end
    %PLOTTING
    fig = figure;
    ax = axis;
    hold on;
    [Xf, Yf, tle, xlb, ylb, leg] = getPlotDataBasedOnFields(xIn, yIn, length(refs), X);

    title(['$',tle,'$'],'Interpreter',interp,'fontSize',titleFontSz)
    xlabel(['$',xlb,'$'],'Interpreter',interp,'fontSize',fontSz)
    ylabel(['$',ylb,'$'],'Interpreter',interp,'fontSize',fontSz)
    for j = 1:length(refs)   
        markerInd = mod((j-1),length(lineMarker)-1) + 1;
        lineInd = mod((floor((j-1)/(length(lineMarker)-1) + 1) - 1),length(lineSpec) - 1) + 1;
        plot(Xf{j},Yf{j},'LineStyle',lineSpec{lineInd},'Marker',lineMarker{markerInd},'LineWidth',1.5);
    end
    legend(leg,'Interpreter',interp,'fontSize',legendFontSz);
end
end

function [X, Y, tle, xlb, ylb, leg] = getPlotDataBasedOnFields(xfld, yfld, numRefs, data)
global allData_plotDisjointSet allLabels_plotDisjointSet
leg = cell(numRefs,1);
X = cell(numRefs,1);
Y = cell(numRefs,1);

xFound = find(cellfun(@(x) strcmp(x,xfld),allData_plotDisjointSet,'UniformOutput',true));
xlb = allLabels_plotDisjointSet{xFound(1)};
yFound = find(cellfun(@(y) strcmp(y,yfld),allData_plotDisjointSet,'UniformOutput',true));
ylb = allLabels_plotDisjointSet{yFound(1)};
tle = [yfld,'\ vs\ ',xfld];

XY = cell(numRefs,1);
FXFY = {xfld,yfld};
for j = 1:numRefs
    XY{j} = cell(length(FXFY),1);
    for k = 1:length(FXFY)
    %'time','serial','set','measure','count'
    %DATA_SELECT
       if strcmpi(FXFY{k},'time') == 1
           XY{j}{k} = data{j}.t;
       elseif strcmpi(FXFY{k},'serial') == 1
           XY{j}{k} = data{j}.serial;
       elseif strcmpi(FXFY{k},'set') == 1
           XY{j}{k} = data{j}.set;
       elseif strcmpi(FXFY{k},'measure') == 1
           XY{j}{k} = data{j}.L;
       elseif strcmpi(FXFY{k},'count') == 1
           XY{j}{k} = data{j}.n;           
       end    
    %END_DATA_SELECT
    end
    
    [X{j},indices] = sort(XY{j}{1});
    Y{j} = XY{j}{2}(indices);  
    leg{j} = ['$ID_{ref}:\ ',num2str(data{j}.refID),'$'];
end
end


%AUX FUNCTION
function referencedDisjointSetStruct = readReferencedFile(refFileName)
    fid = fopen(refFileName,'r');
    if fid < 1
        str = ['File:[',refFileName,'] not accessible for read'];
        THROW(str);
    end
        
    buf = READ(fid,'s');
    numSets = READ(fid,'i');
    
    referencedDisjointSetStruct = cell(1,numSets);
    
    for i = 1:numSets
        allDisjointSetStruct{i} = struct('refID',-1,'set',-1,'n',0,'L',0.0);
        
        buf = READ(fid,'s');
        referencedDisjointSetStruct{i}.refID = READ(fid,'i');
        buf = READ(fid,'s');
        referencedDisjointSetStruct{i}.set = READ(fid,'i');
        buf = READ(fid,'s');
        referencedDisjointSetStruct{i}.n = READ(fid,'i');
        buf = READ(fid,'s');
        referencedDisjointSetStruct{i}.L = READ(fid,'d');
    end
    
    fclose(fid);
end

function allDisjointSetStruct = readAllFile(allFileName)
    fid = fopen(allFileName,'r');
    if fid < 1
        str = ['File:[',allFileName,'] not accessible for read'];
        THROW(str);
    end
        
    buf = READ(fid,'s');
    numSets = READ(fid,'i');
    
    allDisjointSetStruct = cell(1,numSets);
    for i = 1:numSets
        allDisjointSetStruct{i} = struct('set',-1,'n',0,'L',0.0);
        
        buf = READ(fid,'s');
        allDisjointSetStruct{i}.set = READ(fid,'i');
        buf = READ(fid,'s');
        allDisjointSetStruct{i}.n = READ(fid,'i');
        buf = READ(fid,'s');
        allDisjointSetStruct{i}.L = READ(fid,'d');
    end
    
    fclose(fid);
end

function index = findDS(allDisjointSetStruct,groupdSET)
    success = 0;
      
    found = cellfun(@(x) groupdSET == x.set, allDisjointSetStruct, 'UniformOutput', false);
    index = find(cellfun(@(x) x==1,found));
end

function index = findID(allDisjointSetStruct,ID)
    success = 0;
    
    found = cellfun(@(x) ID == x.refID, allDisjointSetStruct, 'UniformOutput', false);
    index = find(cellfun(@(x) x==1,found)); 
end