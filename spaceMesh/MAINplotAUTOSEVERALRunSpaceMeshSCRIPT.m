function MAINplotAUTOSEVERALRunSpaceMeshSCRIPT(scriptName, fileLoc)
global voron;

addpath('../');
addpath('aux_functions');

if nargin < 1
    scriptName = 'MAIN_RUNNAMES4SpaceMesh.txt';
end
if nargin < 2
   fileLoc = -1; 
end

fid = fopen(scriptName, 'r');
if (fid < 0)
    THROW(['cannot open script config file: ', scriptName]);
end
doCLS = 0;
version = 0;
outputFolder = 'none';

buf = READ(fid,'s');
if (strcmp(buf, 'version') == 1)
    version = READ(fid, 'd');
    buf = READ(fid,'s');
end
if (version > 0)
    outputFolder = READ(fid,'s');
    buf = READ(fid,'s');
end    
runPreName = READ(fid,'s','{ }');
buf = fscanf(fid, '%s', 1);
configName = fscanf(fid, '%s', 1);

global superImpASR;
%==========================================================================
%==========================================================================
%configuration read in for output directory for mesh and sync log file
global logFileFID;
s_dirOut = 8;

%mainWorkingDir = fullfile(pwd,'../..');

config = shortConfigFileRead(configName);
logFileFID = fopen(fullfile(config{s_dirOut},'sync_mesh.logfile'),'w');
%==========================================================================
%==========================================================================

if isempty(runPreName)
   hasPreName = 0;
   runPreName = '';
else
    runPreName = runPreName{1}; %conversion from (1x1)cell to string
    hasPreName = (strcmpi(runPreName, 'none') == 0);
    if (hasPreName)
        if (runPreName(end) == '/')
            runPreName = runPreName(1:end - 1);
        end
    end  
end

%MAIN FILE BODY------------------------------------------------------------
buf = READ(fid,'s');
if strcmp(buf,'start>>') == 1
    %Proceed...
else
    THROW('ERROR: File structure corrupted');
end

counter = 1;
check = 0;


buf = fgetl(fid);
while ~feof(fid) && isempty(buf)
    buf = fgetl(fid);
end

while (~feof(fid))
    if(fileLoc == counter && fileLoc > 0)
        check = 1;
    elseif (fileLoc ~= counter && fileLoc > 0)
        check = 0;
    elseif (fileLoc < 0)
        check = 1;
    end
    
    % parsed line string and remove empty entries caused by whitespaces
    parsedStr = strsplit( buf, {' ','\t'});
    idx = cellfun(@(x)isempty(x), parsedStr);
    parsedStr(idx) = [];
    %
    
    inputLen = length(parsedStr);
    
    run = struct('numFiles2Operate',[],'intervals',[],'isList',[],'deformScale',[], 'superImp',[], 'flag2LineWidth',[]);
    run.intervals = struct('mesh',[],'sync',[]);
    run.isList = struct('mesh',0,'sync',0);
    run.numFiles2Operate = struct('mesh',[],'sync',[]);
    run.deformScale = struct('mesh',NaN,'sync',-1);
    run.flag2LineWidth = struct('mesh',[],'sync',[]);
    run.numFiles2Operate.mesh = -2;
    run.numFiles2Operate.sync = -2;
    scalingStr = 'scale';
    listStr = '-v';
    f2lwStr = '-f2lw';
        
    superImpASR = struct('n',0,'superImpFlag','multi','lineFlag','line','lineSpecs',[],'textFlag','text','legendText',[],'uniqueClr',1,'uniqueStyle',0);
    
    if (check == 1)
        if (inputLen > 1)
            runFolder = parsedStr{1};
            
            %-----------------------------------------------
            %-----------------------------------------------
            fprintf(logFileFID, 'MAIN: %s\n', runFolder);
            %-----------------------------------------------
            %-----------------------------------------------
            
            rem = parsedStr(2:end);
            nameFlds = 'none';
            nameFldsLatex = 'none';
            timeGiven = -1;
            timeMinGiven = -1;
            timeMaxGiven = -1;
            pos = 1;
            remLen = length(rem);
            
            while (pos < remLen)
                flag = rem{pos};
                szFlag = length(flag);
                if ((szFlag == 0) || (flag(1) == '{'))
                    pos = pos + 1;
                    continue;
                end
                if (strcmp(flag, 'nameFlds') == 1)
                    pos = pos + 1;
                    flag = rem{pos};
                    nameFlds = flag;
                    pos = pos + 1;
                    continue;
                elseif (strcmp(flag, 'nameFldsLatex') == 1)
                    pos = pos + 1;
                    flag = rem{pos};
                    nameFldsLatex = flag;
                    szz = length(nameFldsLatex);
                    if (nameFldsLatex(1) == '"')
                        nameFldsLatex = nameFldsLatex(2:szz);
                    end
                    szz = length(nameFldsLatex);
                    if (nameFldsLatex(szz) == '"')
                        nameFldsLatex = nameFldsLatex(1:szz - 1);
                    end
                    
                    pos = pos + 1;
                    continue;
                elseif (strcmp(flag, 'time') == 1)
                    pos = pos + 1;
                    flag = rem{pos};
                    timeGiven = str2num(flag);
                    pos = pos + 1;
                    continue;
                elseif (strcmp(flag, 'timeMin') == 1)
                    pos = pos + 1;
                    flag = rem{pos};
                    timeMinGiven = str2num(flag);
                    pos = pos + 1;
                    continue;
                elseif (strcmp(flag, 'timeMax') == 1)
                    pos = pos + 1;
                    flag = rem{pos};
                    timeMaxGiven = str2num(flag);
                    pos = pos + 1;
                    continue;
                end 
                
                %==============================================
                %CHECK FOR SYNC DEFORMATION SCALE
                if strcmpi(flag,'-sync') == 1
                    ssFound = find(cellfun(@(x) strcmpi(x,scalingStr),rem,'UniformOutput',true));
                    if ~isempty(ssFound)
                       if length(ssFound) > 1
                          THROW('scaling option can be used only once in a sync block definition paired with valid non-zero float.\n'); 
                       end                   
                       ssi = ssFound(1);
                       [run.deformScale.sync, status] = str2num(rem{ssi + 1});
                       if status ~= 1
                           msg = sprintf('Invalid number of run to superimpose:[%s]. num of runs value must be valid non-zero integer.\n',rem{ssi + 1});
                          THROW(msg) 
                       end
                       rem(ssi:(ssi+1)) = [];
                       remLen = length(rem);
                    end
                end
                %==============================================
                
                %==============================================
                %CHECK FOR VECTOR LIST OPTION
                lsFound = find(cellfun(@(x) strcmpi(x,listStr),rem,'UniformOutput',true));
                if ~isempty(lsFound)                   
                   lsi = lsFound(1);
                   if strcmpi(flag,'-sync') == 1
                       run.isList.sync = 1;
                   elseif strcmpi(flag,'-mesh') == 1
                       run.isList.mesh = 1;
                   else
                       msg = sprintf('Invalid flag:[%s]',flag);
                       THROW(msg);
                   end
                   rem(lsi:lsi) = [];
                   remLen = length(rem);
                end
                %==============================================
                
                %==============================================
                %CHECK FOR FLAG TO LINEWIDTH OVERRIDE OPTION
                f2lwFound = find(cellfun(@(x) strcmpi(x,f2lwStr),rem,'UniformOutput',true));
                if ~isempty(f2lwFound)                   
                   f2li = f2lwFound(1);
                   bracI = f2li + 1;
                   ketI = f2li;
                   if strcmpi(rem{bracI},'{') ~= 1
                       THROW('map type block must begin with "{" character\n.');
                   end
                   
                   closed = 0;
                   for jj = bracI:length(rem)
                       if strcmpi(rem{jj},'{') == 1
                           closed = closed + 1;
                       elseif strcmpi(rem{jj},'}') == 1
                           closed = closed - 1;
                       end
                       if jj == length(rem) && closed ~= 0
                          THROW('map type block must end with "}" character\n.'); 
                       elseif closed == 0                           
                          ketI = jj;
                          break;
                       end
                   end                   
                   
                   if strcmpi(flag,'-sync') == 1
                       run.flag2LineWidth.sync = readMapStr(rem(bracI:ketI));
                   elseif strcmpi(flag,'-mesh') == 1
                       run.flag2LineWidth.mesh = readMapStr(rem(bracI:ketI));
                   else
                       msg = sprintf('Invalid flag:[%s]',flag);
                       THROW(msg);
                   end    
                   
                   rem(bracI-1:ketI) = [];
                   remLen = length(rem);
                end
                %==============================================
                
                %==============================================
                %CHECK FOR SUPERIMPOSE OPTION SCALE
                numAdditionalFolders = 0;
                additionalDirectories = {};
                if strcmpi(flag,'-sync') == 1
                    siFound = find(cellfun(@(x) strcmpi(x,superImpASR.superImpFlag),rem,'UniformOutput',true));
                    if ~isempty(siFound)
                       if length(siFound) > 1
                          THROW('superimposed plot option can be used only once in a sync block definition paired number of total main folders with calling folder inclusive.\n'); 
                       end                   
                       sii = siFound(1);
                       [numAdditionalFolders, status] = str2num(rem{sii + 1});
                       if status ~= 1
                          msg = sprintf('Invalid scaling value:[%s]. scaling value must be valid non-zero float.\n',rem{sii + 1});
                          THROW(msg) 
                       end
                       
                       superImpASR.n = numAdditionalFolders;
                       superImpASR.lineSpecs = cell(1,superImpASR.n);
                       superImpASR.legendText = cell(1,superImpASR.n);
                       
                       numAdditionalFolders = numAdditionalFolders - 1;
                       additionalDirectories = cell(numAdditionalFolders,1);
                       rem(sii:(sii+1)) = [];
                       %remLen = length(rem);
                       
                       [superImpASR.lineSpecs{1}, rem] = stringFindSuperImpLineSpecs(rem);
                       remLen = length(rem);                 
                       stFound = find(cellfun(@(x) strcmpi(x,superImpASR.textFlag),rem,'UniformOutput',true));
                       if ~isempty(stFound)
                          if length(stFound) > 1
                             THROW('superimposed plot option can only have one text field per folder entry.\n'); 
                          end                   
                          sti = stFound(1);
                          superImpASR.legendText{1} = rem{sti + 1};                                                                                                                
                          rem(sti:(sti+1)) = [];
                          remLen = length(rem);
                       end
                       if isempty(superImpASR.legendText{1})
                          superImpASR.legendText{1} = runFolder; 
                       end
                    end
                end
                %==============================================
                
                if (strcmpi(flag,'-mesh') ~= 1 && strcmpi(flag,'-sync') ~= 1)
                    THROW(['ERROR: Invalid tag(',flag,')']);
                else
                    pos = pos + 1;
                    if strcmp(rem{pos},'{')~=1 || pos >= length(rem)
                        THROW('ERROR: Block must start with "{" and end with "}"');
                    else
                        pos = pos + 1; 
                        tmpCell = {};
                        while strcmp(rem{pos},'}')~=1
                            if pos >= length(rem)
                                THROW('ERROR: Block must start with "{" and end with "}"');
                            else
                                tmpCell{length(tmpCell)+1} = rem{pos};
                                pos = pos + 1;
                            end
                        end
                        pos = pos + 1;
                        
                        %-------------------------------------------------- 
                        if strcmpi(flag,'-mesh') == 1
                            run.numFiles2Operate.mesh = str2double(tmpCell{1});
                            checkNum = run.numFiles2Operate.mesh;
                        elseif strcmpi(flag,'-sync') == 1
                            run.numFiles2Operate.sync = str2double(tmpCell{1});
                            checkNum = run.numFiles2Operate.sync;
                        end
                        tempi = cellfun(@(x) str2num(x),tmpCell(2:end),'UniformOutput',false);
                        if length(cell2mat(tempi)) == length(tmpCell(2:end))
                            if strcmpi(flag,'-mesh') == 1
                                run.intervals.mesh = cell2mat(tempi);
                            elseif strcmpi(flag,'-sync') == 1
                                run.intervals.sync = cell2mat(tempi);
                            end
                        else
                            msg = sprintf('non-numeric serial* not permitted with exception of sync scaling option.\n check flag --> %s\n',flag);
                            THROW(msg);
                        end
                        if checkNum == -3 || checkNum == -4
                            if run.isList.(flag(2:end)) == 0
                                if checkNum == -3 && length(tmpCell) < 4
                                    THROW(['serialStart serialStep serialEnd must be declared for NumPlots2generate = -3']);
                                elseif checkNum == -4 && length(tmpCell) < 4
                                    THROW(['timeStart timeStep timeEnd must be declared for NumPlots2generate = -4']);
                                end
                            end
                            
                            if strcmpi(flag,'-mesh') == 1
                                run.intervals.mesh = cell2mat(tempi);                                
                            elseif strcmpi(flag,'-sync') == 1
                                run.intervals.sync = cell2mat(tempi);
                            end
                        else
                            continue;
                        end
                        %--------------------------------------------------
                    end
                end
            end
            
            if numAdditionalFolders > 0
                for naf = 1:numAdditionalFolders
                    buf = fgetl(fid);
                    while ~feof(fid) && isempty(buf)
                        buf = fgetl(fid);
                    end
                    if feof(fid) || ((strcmpi(parsedStr{1}, 'end') == 1) || (strcmpi(parsedStr{1}, 'final') == 1) || (strcmpi(parsedStr{1}, 'last') == 1))
                       THROW('Insufficient number of main directories listed.'); 
                    end
                    % parsed line string and remove empty entries caused by whitespaces
                    parsedStr = strsplit( buf, {' ','\t'});
                    idx = cellfun(@(x)isempty(x), parsedStr);
                    parsedStr(idx) = [];
                    %
                    rem = parsedStr(2:end);
                    
                    if (hasPreName)
                        additionalDirectories{naf} = [runPreName,'/',parsedStr{1}]; 
                    else
                        additionalDirectories{naf} = parsedStr{1};
                    end
                    [superImpASR.lineSpecs{naf+1},~] = stringFindSuperImpLineSpecs(rem);
                    stFound = find(cellfun(@(x) strcmpi(x,superImpASR.textFlag),rem,'UniformOutput',true));
                    if ~isempty(stFound)
                       if length(stFound) > 1
                          THROW('superimposed plot option can only have one text field per folder entry.\n'); 
                       end                   
                       sti = stFound(1);
                       superImpASR.legendText{naf+1} = rem{sti + 1};                                                                                                                
                       rem(sti:(sti+1)) = [];
                       remLen = length(rem);
                    end 
                    if isempty(superImpASR.legendText{naf+1})
                       superImpASR.legendText{naf+1} = parsedStr{1}; 
                    end
                    %-----------------------------------------------
                    %-----------------------------------------------
                    fprintf(logFileFID, 'MAIN: %s\n', additionalDirectories{naf});
                    %-----------------------------------------------
                    %-----------------------------------------------
                end
            end
            run.superImp = superImpASR;
            run.superImp = setEmptyToRandomDefaults(run.superImp);
        else
            if ((strcmpi(parsedStr{1}, 'end') == 1) || (strcmpi(parsedStr{1}, 'final') == 1) || (strcmpi(parsedStr{1}, 'last') == 1))
                return;
            else
                THROW(['ERROR: RunFolder(',parsedStr{1},') is missing input for NumPlots2generate']);
            end
        end
        %------------------------------------------------------------------
        %option -5 exception check
        % check if mesh takes serials from sync but serial is inactive
        if run.numFiles2Operate.mesh == -5 && run.numFiles2Operate.sync == -2
            THROW('sync cannot be inactive when mesh input option is -5');
        end
        
        if run.numFiles2Operate.mesh ~= -2 && numAdditionalFolders > 0
            THROW('multiplot option cannot be active when mesh is not inactive');
        end
        
        if run.numFiles2Operate.sync == -5
            THROW('sync cannot have input option -5');
        end
        %------------------------------------------------------------------
        %------------------------------------------------------------------
        if (hasPreName)
            runFolder = [runPreName, '/', runFolder];            
        end
        
        runFolder = [{runFolder};additionalDirectories];
        voron = contains(runFolder, 'oronoi');
        MAINplotAUTOONERunSpaceMesh(runFolder, configName, run, doCLS, ...
        outputFolder, nameFlds, nameFldsLatex, timeGiven, timeMinGiven, timeMaxGiven); 
        %------------------------------------------------------------------
    end
    
    buf = fgetl(fid);
    while ~feof(fid) && isempty(buf)
        buf = fgetl(fid);
    end
    
    %Stop condition for while-loop and iteration
    if fileLoc == counter
        break;
    end
    counter = counter + 1;
    %...........................................
end
fclose(fid);

if (counter > fileLoc) && fileLoc > 0
    fprintf(1, 'File Location input excessed list size of file %s', scriptName);
end

%==========================================================================
%==========================================================================
%mesh and sync log file closed
fclose(logFileFID);
%==========================================================================
%==========================================================================

cls_
end

function [lineSpec, remain] = stringFindSuperImpLineSpecs(remain)
global superImpASR
lineSpec = {}; 
    
    found = find(cellfun(@(x) strcmpi(x,superImpASR.lineFlag),remain,'UniformOutput',true));
    if ~isempty(found)
       if length(found) > 1
          THROW('superimposed plot option can be used only once in a sync block definition paired number of total main folders with calling folder inclusive.\n'); 
       end                   
       sii = found(1);
       remain(sii) = [];           

       [lineSpec, remain] = sReadLineSpec(lineSpec,remain,sii);
    end
    
end

function superImpObj = setEmptyToRandomDefaults(superImpObj)
lineMarker = {'+','o','*','x','s','d','^','v','>','<','p','h'};
lineSpec = {'-','--',':','-.'};

%TODO: complete so that empty colour and line specs are defaulted to make
%unique line based on if lines are distinguished by colour or style

for i = 1 : length(superImpObj.lineSpecs)
    if isempty(superImpObj.lineSpecs{i})
        
    else
        if isempty(superImpObj.lineSpecs{i}.ls)
            
        end
        if isempty(superImpObj.lineSpecs{i}.lc)
                
        end
    end
end

end

%ref: (Cell Function): http://www.mathworks.com/help/matlab/ref/cellfun.html
