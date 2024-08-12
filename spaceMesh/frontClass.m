classdef frontClass < handle
    %frontClass used to store front outputs
    
    properties(Access = public)
        fronts;         %structs of front information
        % rows are front number, cols (1, 2, 3) are timeMin, Ave, Max of
        % the front
        times;
        
        numFiles;
    end
    
    methods(Access = public)
        function obj = frontClass()
            obj.fronts = {};
            obj.numFiles = 0;
        end
        
        function readLast(obj, fid)
           szNew = length(obj.fronts) + 1;
           tmpStruct = struct( 'folder',[],...
                                'runName',[],...
                                'phy',[],...
                                'midName',[],...
                                'sn',[],...
                                'exts',[],...
                                'file',[],...	
                                'fileStat',[],...
                                'stepIndex',[],...
                                'timeMin',[],...
                                'timeMax',[],...
                                'numNewCrack',[],...
                                'crackNewLength',[],...
                                'numAllCrack',[],...
                                'crackAllLength',[]);
           if fid > 0
               buf = READ(fid,'s');
               while ~feof(fid)
                   if strcmpi(buf,'folder')
                       tmpStruct.folder = READ(fid,'s');
                   elseif strcmpi(buf,'runName')
                       tmpStruct.runName = READ(fid,'s');
                   elseif strcmpi(buf,'phy')
                       tmpStruct.phy = READ(fid,'s');
                   elseif strcmpi(buf,'midName')
                       tmpStruct.midName = READ(fid,'s');
                   elseif strcmpi(buf,'sn')
                       tmpStruct.sn = READ(fid,'i');
                   elseif strcmpi(buf,'exts')
                       tmpStruct.exts = READ(fid,'s',2);
                   elseif strcmpi(buf,'file')
                       tmpStruct.file = READ(fid,'s');
                   elseif strcmpi(buf,'fileStat')
                       tmpStruct.fileStat = READ(fid,'s');
                   elseif strcmpi(buf,'stepIndex')
                       tmpStruct.stepIndex = READ(fid,'i');
                   elseif strcmpi(buf,'timeMin')
                       tmpStruct.timeMin = READ(fid,'d');
                   elseif strcmpi(buf,'timeMax')
                       tmpStruct.timeMax = READ(fid,'d');
                   elseif strcmpi(buf,'numNewCrack')
                       tmpStruct.numNewCrack = READ(fid,'i');
                   elseif strcmpi(buf,'crackNewLength')
                       tmpStruct.crackNewLength = READ(fid,'d'); 
                   elseif strcmpi(buf,'numAllCrack')    
                       tmpStruct.numAllCrack = READ(fid,'i');
                   elseif strcmpi(buf,'crackAllLength')    
                       tmpStruct.crackAllLength = READ(fid,'d');
                   else    
                        THROW('Invalid header option')
                   end    
                   
                   buf = READ(fid,'s');
               end
               obj.fronts{szNew} = tmpStruct;
               obj.times(szNew, 1) = tmpStruct.timeMin;
               obj.times(szNew, 3) = tmpStruct.timeMax;
                obj.times(szNew, 2) = 0.5 * (obj.times(szNew, 1) + obj.times(szNew, 3));
               
               obj.numFiles = szNew;
           else
              THROW('ERROR: File not open for read'); 
           end
        end
        
        function readAll(obj, fid)
            
           buf = fgetl(fid);
           while ischar(buf)
               if isempty(buf)
                   buf = fgetl(fid);
               else
                   break;
               end
           end
           
           while ischar(buf) %~feof(fid)
               szNew = length(obj.fronts) + 1;
               tmpStruct = struct( 'folder',[],...
                                'runName',[],...
                                'phy',[],...
                                'midName',[],...
                                'sn',[],...
                                'exts',[],...
                                'file',[],...	
                                'fileStat',[],...
                                'stepIndex',[],...
                                'timeMin',[],...
                                'timeMax',[],...
                                'numNewCrack',[],...
                                'crackNewLength',[],...
                                'numAllCrack',[],...
                                'crackAllLength',[]);
                                
                 buf = strsplit( buf, {' ','\t'});
                 idx = cellfun(@(x)isempty(x), buf);
                 buf(idx) = [];
                 
                 len = length(buf);
                 curr = 1;
               while curr <= len
                   if strcmpi(buf{curr},'folder')
                       tmpStruct.folder = buf{curr + 1};
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'runName')
                       tmpStruct.runName = buf{curr + 1};
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'phy')
                       tmpStruct.phy = buf{curr + 1};
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'midName')
                       tmpStruct.midName = buf{curr + 1};
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'sn')
                       tmpStruct.sn = str2num(buf{curr + 1});
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'exts')
                       tmpStruct.exts = buf(curr + 1:curr + 2);
                       curr = curr + 3;
                   elseif strcmpi(buf{curr},'file')
                       tmpStruct.file = buf{curr + 1};
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'fileStat')
                       tmpStruct.fileStat = buf{curr + 1};
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'stepIndex')
                       tmpStruct.stepIndex = str2num(buf{curr + 1});
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'timeMin')
                       tmpStruct.timeMin =str2double(buf{curr + 1});
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'timeMax')
                       tmpStruct.timeMax = str2double(buf{curr + 1});
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'numNewCrack')
                       tmpStruct.numNewCrack = str2num(buf{curr + 1});
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'crackNewLength')
                       tmpStruct.crackNewLength = str2double(buf{curr + 1});
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'numAllCrack')    
                       tmpStruct.numAllCrack = str2num(buf{curr + 1});
                       curr = curr + 2;
                   elseif strcmpi(buf{curr},'crackAllLength')    
                       tmpStruct.crackAllLength = str2double(buf{curr + 1});
                       curr = curr + 2;
                   else    
                        THROW('Invalid header option')
                   end    
               end
               obj.fronts{szNew} = tmpStruct;
               obj.times(szNew, 1) = tmpStruct.timeMin;
               obj.times(szNew, 3) = tmpStruct.timeMax;
                obj.times(szNew, 2) = 0.5 * (obj.times(szNew, 1) + obj.times(szNew, 3));
               obj.numFiles = szNew;
               
               buf = fgetl(fid);
               while ischar(buf)
                   if isempty(buf)
                       buf = fgetl(fid);
                   else
                       break;
                   end
               end               
           end
        end
        
        function printFrontEntry(obj, fid, index)
           if fid < 0
               THROW('Output file not accessible for writing.');
           end
           if index > 0 && index <= obj.numFiles
                format = 'folder  %s  runName  %s  phy	%s	midName  %s  sn  %i  timeMin  %d  timeMax  %d  numNewCrack  %i	crackNewLength  %d  numAllCrack  %i  crackAllLength  %d\n';
                fprintf(fid,format,obj.fronts{index}.folder,...
                                obj.fronts{index}.runName,...
                                obj.fronts{index}.phy,...
                                obj.fronts{index}.midName,...
                                obj.fronts{index}.sn,...                            
                                obj.fronts{index}.timeMin,...
                                obj.fronts{index}.timeMax,...
                                obj.fronts{index}.numNewCrack,...
                                obj.fronts{index}.crackNewLength,...
                                obj.fronts{index}.numAllCrack,...
                                obj.fronts{index}.crackAllLength);
           else
                THROW('index out of range.');
           end
           
        end
    
        % option 1, 2, 3 are timeMin, Ave, Max of front
        function [index, sn, numNewCrackV, crackNewLengthV, numAllCrackV, crackAllLengthV, timeMin, timeMax] = get_index_fromTime(obj, time, option, forceMax)
            if (nargin < 4)
                forceMax = 0;
            end
            sz = obj.numFiles;
            if (~forceMax)
                suc = 0;
                for index = 1:sz
                    tm = obj.times(index, option);
                    if (tm >= time)
                        suc = 1;
                        break;
                    end
                end
            else
                suc = 1;
                index = sz;
            end
            if (suc == 0)
                index = -1;
                sn = -1;
                numNewCrackV = 0;
                crackNewLengthV = 0;
                numAllCrackV = 0;
                crackAllLengthV = 0;
                timeMin = 0;
                timeMax = 0;
                return;
            end
            sn = obj.fronts{index}.sn;
            numNewCrackV = obj.fronts{index}.numNewCrack;
            crackNewLengthV = obj.fronts{index}.crackNewLength;
            numAllCrackV = obj.fronts{index}.numAllCrack;
            crackAllLengthV = obj.fronts{index}.crackAllLength;
            timeMin = obj.times(index, 1);
            timeMax = obj.times(index, 3);
        end
    end
end
