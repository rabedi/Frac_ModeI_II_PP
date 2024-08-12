function [defaults, dataFields, runs, plots, field2latex, configAllRunsSyncNew, newRunMaps, runsAdditionalParaMaps, strainStressOpts] = readVDSPlotConfig(configFile)

%strainStressOpts(1): Philip's old format stress strain
%strainStressOpts(2): Reza's new one, flags with option: zpr
%strainStressOpts(3): Reza's new one, flags with option: zpp (post
%processed of pzr)
strainStressOpts = zeros(3, 1);

configAllRunsSyncNew = pp_synFilesAllR;
configAllRunsSyncNewFileName = 'default'; % options are 
%       direct: directly read from the config file name
%       default reads the config from _config_AllRun.txt
%       or any other file name

configAllRunsSyncNewFileName = '_config_AllRun.txt';

addpath('../');
addpath('aux_functions');
ext = '.vconfig';
if nargin < 1
   configFile = ['ConfigSample',ext]; 
else
   configFile = [configFile, ext];
end
global defs;

fid = fopen(configFile,'r');
if fid < 1
   configFile
   msg = sprintf('configuration file not accessible:{%s}.',configFile);
   THROW(msg); 
end

%BEGIN READ
field2latex = [];

buf = READ(fid,'s');
if strcmpi(buf,'{') == 1
    buf = READ(fid,'s');
    while strcmpi(buf,'}') ~= 1
        if strcmpi(buf,'_defaults') == 1
            defs = readDefaultSpecs(fid);
        elseif strcmpi(buf,'_data') == 1
            dats = readDataSpecs(fid);
%       elseif strcmpi(buf,'_fld_latex') == 1
%             field2latex = readLatexNameFile(fid);    
        elseif strcmpi(buf,'_runs') == 1
            runs = readRunsSpecs(fid);   
        elseif strcmpi(buf,'_plots') == 1
            [plots, strainStressOpts(1)] = readPlotsSpecs(fid);
        elseif strcmpi(buf,'_configSyncNew') == 1
            tmps = READ(fid,'s');
            if (strcmp(tmps, 'default') == 0)
            configAllRunsSyncNewFileName = tmps;
                if (strcmp(configAllRunsSyncNewFileName, 'direct') == 1)
                    configAllRunsSyncNew = configAllRunsSyncNew.fromFile(fid);
                end
            end
        elseif strcmpi(buf,'}') ~= 1
            msg = sprintf('invalid option {%s}.',buf);
            THROW(msg);
        end                       
        buf = READ(fid,'s');
    end
else
    msg = sprintf('file must begin with "{" character. invalid{%s}',buf);
    THROW(msg);  
end 

            
if (strcmp(configAllRunsSyncNewFileName, 'direct') == 0)
    fidCN = fopen(configAllRunsSyncNewFileName, 'r');
    configAllRunsSyncNew = configAllRunsSyncNew.fromFile(fidCN);
    fclose(fidCN);
end
if (length(configAllRunsSyncNew.fld2printInBriefRaw) > 0)
    strainStressOpts(2) = 1;
end
if (length(configAllRunsSyncNew.fld2printInBriefPP) > 0)
    strainStressOpts(3) = 1;
end
    
if isempty(field2latex)
   field2latex = ftexMap('none', configAllRunsSyncNew);
end
defaults = defs;
dataFields = dats;


newRunMaps = gen_map;
ln = length(runs.runs);
for i = 1:ln
    newRunMaps.AddKeyVal(runs.runs{i}.folder, num2str(i));
    runsAdditionalParaMaps{i} = runs.runs{i}.map;
end

end

%==============================================================
%==============================================================
function outObj =  readDefaultSpecs(fid)
outObj = mDefaults(fid); 
end
function outObj =  readDataSpecs(fid)
global defs
if fid < 1
   msg = sprintf('input file became accessible:fid{%i}.',fid);
   THROW(msg); 
end
outObj = struct('names',{{}},'fields',{{}});
pool = [];
%BEGIN READ
buf = READ(fid,'s');
if strcmpi(buf,'{') == 1
    buf = READ(fid,'s');
    while strcmpi(buf,'}') ~= 1
        [~,status] = str2num(buf);
        if status ~= 1           
            THROW('invalid index')
        end
        index = str2num(buf) + 1;
        if any(pool == index) == 1
           msg = sprintf('_data block field index (%i) repeated',index-1);
           THROW(msg);
        end
        pool = [pool,index];
        tmp = struct('name',[],...
            'latexString',[],...
            'line',[],...
            'limit',[]);
        tmp.name = READ(fid,'s');
        tmp.latexString = READ(fid,'s');
        tmp.line = readLineSpec(tmp.line,fid);
        tmp.line = defs.setLineDefaults(tmp.line);
        tmp.limit = readLimits(tmp.limit,fid);
        buf = READ(fid,'s');
        outObj.names{index} = tmp.name;
        outObj.fields{index} = tmp;
    end
else
    msg = sprintf('invalid option {%s}.',buf);
    THROW(msg);  
end 
end
% function field2latex = readLatexNameFile(fidIn)
% if fidIn < 1
%    msg = sprintf('input file became accessible:fid{%i}.',fidIn);
%    THROW(msg); 
% end
% 
% latexFile = READ(fidIn,'s');
% field2latex = ftexMap(latexFile);
% end
function outObj =  readRunsSpecs(fid)
global defs
if fid < 1
   msg = sprintf('input file became accessible:fid{%i}.',fid);
   THROW(msg); 
end
%BEGIN READ
outObj = struct('folders',{{}},'runs',{{}});
%BEGIN READ
buf = READ(fid,'s');
if strcmpi(buf,'{') == 1
    buf = READ(fid,'s');
    index = 1;
    while strcmpi(buf,'}') ~= 1
        tmp = struct('folder',[],...
            'latexString',[],...
            'line',[], 'map', []);
        tmp.folder = buf;
        tmp.latexString = READ(fid,'s');
        tmp.line = readLineSpec(tmp.line,fid);
        tmp.line = defs.setLineDefaults(tmp.line);

        tmp.map = gen_map;
        [buf, success] = tmp.map.Read_gen_Map(fid);
        if (success == 1)
            buf = READ(fid,'s');
        end
        hasout = hasOutput('../../../',tmp.folder,'physics');
        if hasout == 0
           fprintf(1,'[%s]Skipped: Does not contain output for post-processing.\n',tmp.folder);
        else 
            outObj.folders{index} = tmp.folder;
            outObj.runs{index} = tmp;
            index = index + 1;
        end
    end
else
    msg = sprintf('block must begin with "{" character. invalid{%s}',buf);
    THROW(msg);  
end
end
function [outObj, hasPhilipsss] =  readPlotsSpecs(fid)
global defs
global philipLabels;

hasPhilipsss = 0;
if fid < 1
   msg = sprintf('input file became accessible:fid{%i}.',fid);
   THROW(msg); 
end
outObj = {};
%BEGIN READ
index = 1;
buf = READ(fid,'s');
if strcmpi(buf,'{') == 1
    buf = READ(fid,'s');
    while strcmpi(buf,'}') ~= 1                 
        if strcmpi(buf,'{') == 1
            outObj{index} = struct('x',{{}},...
                'y',{{}},...
                'yy',{{}},...
                'yyn',{{}},...
                'z',{{}},...
                'singleRun',1,...
                'multiRun',0,...
                'bestFit',0,...
                'legendLocation',[],...
                'suffix',{{'ldnum_0'}});
            buf = READ(fid,'s');
            while strcmpi(buf,'}') ~= 1
                if strcmpi(buf,'x') == 1
                    outObj{index}.x = READ(fid,'s','{}');
                elseif strcmpi(buf,'y') == 1
                    outObj{index}.y = READ(fid,'s','{}');
                elseif strcmpi(buf,'yy') == 1
                    outObj{index}.yy = READ(fid,'s','{}');
                elseif strcmpi(buf,'yyn') == 1
                    outObj{index}.yyn = READ(fid,'s','{}');
                elseif strcmpi(buf,'z') == 1
                    outObj{index}.z = READ(fid,'s','{}');
                elseif strcmpi(buf,'srun') == 1
                    outObj{index}.singleRun = READ(fid,'b');
                elseif strcmpi(buf,'mrun') == 1
                    outObj{index}.multiRun = READ(fid,'b');
                elseif strcmpi(buf,'bfit') == 1
                    outObj{index}.bestFit = READ(fid,'b');
                elseif strcmpi(buf,'legloc') == 1
                    outObj{index}.legendLocation = READ(fid,'s');
                elseif strcmpi(buf,'suffix') == 1
                    outObj{index}.suffix = READ(fid,'s','{}');
                elseif strcmp(buf,'}')~=1  
                    msg = sprintf('invalid option{%s}.',buf);
                    THROW(msg);  
                end
                buf = READ(fid,'s');
            end
            if (hasPhilipsss == 0)
                for k = 1:length(philipLabels)
                    str = philipLabels{k};
                    for m = 1:length(outObj{index}.x)
                        if (strcmp(outObj{index}.x{m}, str) == 1)
                            hasPhilipsss = 1;
                            break;
                        end
                    end
                    for m = 1:length(outObj{index}.y)
                        if (strcmp(outObj{index}.y{m}, str) == 1)
                            hasPhilipsss = 1;
                           break;
                        end
                    end
                end
            end
            if length(outObj{index}.z) > 1
                msg = sprintf('z field only supports single entry of "var" for now.');
                THROW(msg);  
            end
            if ~isempty(outObj{index}.z)
                if ~isempty(outObj{index}.yy) || ~isempty(outObj{index}.yyn)
                    msg = sprintf('yy and/or yyn fields not supported when z field is specified for plotting.');
                    THROW(msg)
                end
            end
            if isempty(outObj{index}.legendLocation)
                outObj{index}.legendLocation = defs.legendDefaults.location;
            end
            index = index + 1;
        else
            msg = sprintf('block must begin with "{" character. invalid{%s}',buf);
            THROW(msg);  
        end 
        buf = READ(fid,'s');
    end
else
    msg = sprintf('block must begin with "{" character. invalid{%s}',buf);
    THROW(msg);  
end 
end
%==============================================================
%==============================================================
%AUX FUNCTIONS

