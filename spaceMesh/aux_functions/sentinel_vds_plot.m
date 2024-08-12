function sentinel_vds_plot(varargin)
%close all;                                
%clc;
clearvars -except varargin
NUM_AX_TYPES = 2;
S_AX = 1;
M_AX = 2;

addpath('../');  
addpath('aux_functions');
global TOPDIR; TOPDIR = '../../'; 
global DIM; DIM = 2;

global delim; delim = '::';
% global xlab; xlab = '';
% global ylab; ylab = '';
% global yylab; yylab = '';
% global yynlab; yynlab = '';
% global zlab; zlab = '';
warning('off','MATLAB:MKDIR:DirectoryExists');
figureOutputDir = 'output_plots';

fld2texFile = '';
fld2latex = [];
unitDefaults = mDefaults();
globalDefaults = [];

outputPhysicsDirectory = 'physics';
meshopt = 'sync';
forcedFitType = '';
unitAxHandle = [];
sentinel = {};

ax = {};  %axes handles container
fig = {}; %figure handles container
axNumCurves = {};
axCurvesCounter = {};
s_m = {};
legText = {};
jobs = {};
strainStressOpts = zeros(3, 1);

unitJob = {{jobstruct()}};
unitJob{1}{1}.axNo = 1;
unitJob{1}{1}.runFolder = getCurrentWorkingRunFolder();
unitJob{1}{1}.line.lc = RGB('b');
unitJob{1}{1}.line.ls = 'none';
unitJob{1}{1}.line.lw = 1.0;
unitJob{1}{1}.line.ms = 'o';
unitJob{1}{1}.bestFitLine.lc = RGB('k');
unitJob{1}{1}.bestFitLine.ls = '-';
unitJob{1}{1}.bestFitLine.lw = 2.0;
unitJob{1}{1}.bestFitLine.ms = 'none';
unitJob{1}{1}.bestFitActive = 1;
unitJob{1}{1}.legendLocation = unitDefaults.legendDefaults.location;

configAllRunsSyncNew = cell(0);

N = length(varargin); %nargin;
if mod(N,2)~=0
   THROW('insufficent number of input, must be flag-option pair.'); 
end

i = 1;
while(i <= N)
   if strcmpi(varargin{i},'-mopt')==1
       i = i + 1;
       meshopt = varargin{i};
   elseif strcmpi(varargin{i},'-ftype')==1
       i = i + 1;
       forcedFitType = varargin{i};
   elseif strcmpi(varargin{i},'-fconfsigeps')==1
       i = i + 1;
       configAllRunsSyncNew = varargin{i};
   elseif strcmpi(varargin{i},'-folder')==1
       i = i + 1;
       figureOutputDir = varargin{i};
   elseif strcmpi(varargin{i},'-runName2Loc')==1
       i = i + 1;
       runName2Loc = varargin{i};
   elseif strcmpi(varargin{i},'-runsAddedParas')==1
       i = i + 1;
       runsAddedParas = varargin{i};
%==========================================================================
% These input can be specified together
   elseif strcmpi(varargin{i},'-fit')==1
       i = i + 1;
       unitJob{1}{1}.bestfitActive = varargin{i};    
   elseif strcmpi(varargin{i},'-f')==1
       i = i + 1;
       unitJob{1}{1}.runFolder = fullfile('..',varargin{i});
   elseif strcmpi(varargin{i},'-d')==1
       i = i + 1;
       outputPhysicsDirectory = varargin{i};
   elseif strcmpi(varargin{i},'-x')==1
       i = i + 1;
       unitJob{1}{1}.xData = varargin{i};
   elseif strcmpi(varargin{i},'-y')==1
       i = i + 1;
       unitJob{1}{1}.yData = varargin{i};
%    elseif strcmpi(varargin{i},'-yy')==1
%        i = i + 1;
%        yylab = varargin{i};
%    elseif strcmpi(varargin{i},'-yyn')==1
%        i = i + 1;
%        yynlab = varargin{i};       
   elseif strcmpi(varargin{i},'-z')==1
       i = i + 1;
       unitJob{1}{1}.zData = varargin{i};
   elseif strcmpi(varargin{i},'-suff')==1
       i = i + 1;
       unitJob{1}{1}.suffix = varargin{i};
   elseif strcmpi(varargin{i},'-lc')==1
       i = i + 1;
       unitJob{1}{1}.line.lc = RGB(varargin{i}); 
   elseif strcmpi(varargin{i},'-ls')==1
       i = i + 1;
       unitJob{1}{1}.line.ls = varargin{i};
   elseif strcmpi(varargin{i},'-lw')==1
       i = i + 1;
       unitJob{1}{1}.line.lw = varargin{i};
   elseif strcmpi(varargin{i},'-ms')==1
       i = i + 1;
       unitJob{1}{1}.line.ms = varargin{i};
   elseif strcmpi(varargin{i},'-ax')==1
       i = i + 1;
       unitAxHandle = varargin{i};   
   elseif strcmpi(varargin{i},'-latexf')==1
       i = i + 1;
       fld2texFile = varargin{i};  
%==========================================================================
% OR
%==========================================================================
% all of the above block quantites will be overriden by struct of job plot 
% job configurations hence do not need to be specified if '-job' is used
   elseif strcmpi(varargin{i},'-jobs')==1
       i = i + 1;
       sentinel = varargin{i};
       jobs = sentinel.jobs; 
       strainStressOpts = sentinel.ssOpts;
   else
       msg = sprintf('Invalid option{%s}',varargin{i});
       THROW(msg);
   end
   i = i + 1;
end

mkdir(figureOutputDir);
warning('on','MATLAB:MKDIR:DirectoryExists');

deleteMapEntries = (sentinel.numAxes(M_AX) == 0);

%FIELD STRING TO LATEX MAPPING
if isempty(fld2texFile)
    fld2latex = ftexMap('none', configAllRunsSyncNew);
else
    fld2latex = ftexMap(fld2texFile, configAllRunsSyncNew);
end
%
%
%PLOT JOB, AXES AND FIGURE INITIALIZATION
if isempty(jobs)
    jobs = unitJob;
    globalDefaults = unitDefaults;
    if isempty(unitAxHandle)
        ax = {{axes()}};
        fig = {{gcf}};        
    else
        if ~isvalid(unitAxHandle)
            THROW('Invalid axis handle.\n');
        end
        ax = {{unitAxHandle}};
        fig = {{gcf}};
    end
    axNumCurves = {{1}};
    axCurvesCounter = {{0}};
    legText = {{{}}}; 
    s_m = {{'s'}};
else
    globalDefaults = sentinel.defaults;
    jSz = length(sentinel.numAxes);
    ax = cell(1,jSz);
    fig = cell(1,jSz);
    axNumCurves = cell(1,jSz);
    axCurvesCounter = cell(1,jSz);
    s_m = cell(1,jSz);
    legText = cell(1,jSz);
    for i = 1:jSz
        ax{i} = cell(1,max(sentinel.idAxes{i}));
        fig{i} = cell(1,max(sentinel.idAxes{i}));
        axNumCurves{i} = cell(1,max(sentinel.idAxes{i}));
        axCurvesCounter{i} = cell(1,max(sentinel.idAxes{i}));
        s_m{i} = cell(1,max(sentinel.idAxes{i}));
        legText{i} = cell(1,max(sentinel.idAxes{i}));
                
        
        for j = 1:sentinel.numAxes(i)
            axno = sentinel.idAxes{i}(j);
            fig{i}{axno} = figure;
            ax{i}{axno} = axes();
            axNumCurves{i}{axno} = 0;
            axCurvesCounter{i}{axno} = 0;
            s_m{i}{axno} = '';
            legText{i}{axno} = {};
        end
        %SET NUM CURVES
        for j = 1:length(jobs{i})
            axno = jobs{i}{j}.axNo;
            axNumCurves{i}{axno} = axNumCurves{i}{axno} + 1;
        end
       
    end
end

%SET ALL DEFAULTS
setDefaults(ax,fig,globalDefaults);

%READ IN
frontAllFile = '';
if strcmpi(meshopt,'sync')==1
    frontAllFile = 'frontSync';
elseif strcmpi(meshopt,'mesh')==1
    frontAllFile = 'front';
else
    msg = sprintf('invalid option{%s}',meshopt);
    THROW(msg)
end
%mapping rf:runFolder, suff:suffix
var_map = struct('rfKeys',{{}},'suffKeys',{{}},'objMatrix',{{}});
static_map = struct('rfKeys',{{}},'objMatrix',{{}});
copyCounter = 1;

% cell of runs new sync file post-processing
numFolders = length(runName2Loc.keys);
pp1rs = cell(numFolders);
% process of pp1rs data (e.g. homogenization of damage, etc.)
zpp1rs = cell(numFolders);

% reading all sync at once

% for runIndex = 1:numFolders
% %    frontAllPath = fullfile(TOPDIR,runFolder,outputPhysicsDirectory);
% 
%     pp1rs{runIndex} = pp_synFiles1R;
%     folder = runName2Loc.keys{runIndex};
%     if isempty(folder)
%         runFolder = '';
%     else
%         runFolder = fullfile('..',folder);
%     end
%     frontAllPathIn = fullfile(TOPDIR, runFolder, outputPhysicsDirectory);
%     %'../../../old_2017_09_29_MicriUST_NA064_NP00_infxinf_tau1ep16em2_x_a013/physics';
%     addedParas = runsAddedParas{runIndex};
% 
%     if (strainStressOpts(2) ~= 0)
%         fprintf(1, 'sync: %s\t', runFolder);
%         pp1rs{runIndex} = pp1rs{runIndex}.ProcessAllSyncFiles(frontAllPathIn, configAllRunsSyncNew, runsAddedParas{runIndex});
%     end
%     fprintf(1, '\n');
% end

for i = 1:length(jobs)
    for j = 1:length(jobs{i})
        
        axno = jobs{i}{j}.axNo;             
        [runIndex, foundFolder] = runName2Loc.AccessNumber(jobs{i}{j}.runFolder);
        if (~foundFolder)
            i
            j
            jobs{i}{j}.runFolder
            msg = ['Cannot find the folder ', jobs{i}{j}.runFolder, ' in the map\n']; 
            THROW(msg);
        end

        if ((strainStressOpts(2) ~= 0) && ... % has new sync processing option
             (isempty(pp1rs{runIndex}))) % new way of reading sync file

             folder = jobs{i}{j}.runFolder; %runName2Loc.keys{runIndex};
             if isempty(folder)
                runFolder = '';
             else
                runFolder = fullfile('..',folder);
             end
             frontAllPathIn = fullfile(TOPDIR, runFolder, outputPhysicsDirectory);
             fprintf(1, 'Read:sync: %s\t', runFolder);
             pp1rs{runIndex} = pp_synFiles1R;
             [pp1rs{runIndex}, regenBrief, E, nu, planeMode, t0, normalizationsUVSEps, voightStiffness] = ...
                pp1rs{runIndex}.ProcessAllSyncFiles(frontAllPathIn, configAllRunsSyncNew, runsAddedParas{runIndex});

            if (configAllRunsSyncNew.bProcess_zpp_data)
                zpp1rs{runIndex} = zpp_DamageHomogenization1R;
                zpp1rs{runIndex} = zpp1rs{runIndex}.Process_zpp_file(configAllRunsSyncNew, runsAddedParas{runIndex}, pp1rs{runIndex}, ...
                            regenBrief, E, nu, planeMode, t0, normalizationsUVSEps, voightStiffness);
            end
        end
        
        tmpObjs = [];
        [tmpVar,tmpStatic,found] = mapfind(var_map,static_map,jobs{i}{j}.runFolder,jobs{i}{j}.suffix);
       
        if found == 0
            stress_strain = 2; % always generate the files from sync (if 1, it will not regenerate if pudat and stat files exist)
            if (strainStressOpts(1) == 0)
                stress_strain = 0;
            end
            tmpObjs = ReadAllVDatStatsFilesMatrix(tmpStatic,jobs{i}{j}.runFolder,outputPhysicsDirectory,frontAllFile,jobs{i}{j}.suffix, 1, stress_strain, runsAddedParas{runIndex});
            if ~isempty(tmpObjs.var)
               [var_map, static_map] = mapinsert(var_map,static_map,jobs{i}{j}.runFolder,jobs{i}{j}.suffix,tmpObjs.var,tmpObjs.static);
            else
               disp('SKIPPED: Run files corrupted\n');
               printJob(jobs{i}{j});
               continue; 
            end
        else
            tmpObjs = struct('var',tmpVar,'static',tmpStatic);
            if isempty(tmpObjs.var)
                THROW('tmpObj not set properly.');
            end
            %disp('tmp debug print.\n');
        end
        
        %SET CURRENT AXIS AND FIGURE
        set(0,'CurrentFigure',fig{i}{axno});
        set(fig{i}{axno},'CurrentAxes', ax{i}{axno});
        
        if isempty(sentinel)
            jobs{i}{j}.xLab = labelFromLatexMap(jobs{i}{j}.xData,fld2latex);
            if i == M_AX                
                jobs{i}{j}.yLab = labelFromLatexMap(jobs{i}{j}.yData,fld2latex);
                if ~isempty(jobs{i}{j}.zData)
                    jobs{i}{j}.zLab = labelFromLatexMap(jobs{i}{j}.zData,fld2latex);
                end
            end
        end

        if i == S_AX
            s_m{i}{axno} = jobs{i}{j}.runFolder;
        elseif i == M_AX
            s_m{i}{axno} = [labelFromLatexMap(jobs{i}{j}.xData,fld2latex,1),'-',labelFromLatexMap(jobs{i}{j}.yData,fld2latex,1)];
            if ~isempty(jobs{i}{j}.zData)
                s_m{i}{axno} = [s_m{i}{axno},'-',labelFromLatexMap(jobs{i}{j}.zData,fld2latex,1)];
            end 
        else
           THROW('Invaild Index'); 
        end

        %sz = length(tmpObjs);
        sz = length(tmpObjs.static.serial);
        
%         Xholder = NaN.*ones(sz,1);
%         Yholder = NaN.*ones(sz,1);
%         Zholder = NaN.*ones(sz,1);
%        for s = 1:sz    
%            [xi,yi,zi] = getField(tmpObjs{s},jobs{i}{j}.xData,jobs{i}{j}.yData,jobs{i}{j}.zData);   
%            Xholder(s) = xi;
%            Yholder(s) = yi;
%            if ~isempty(zi)
%                Zholder(s) = zi;
%            end
%        end 
        
        if (strcmpi(meshopt,'mesh')==1) && (fld2latex.isStressStrain(jobs{i}{j}.xData) || fld2latex.isStressStrain(jobs{i}{j}.yData) || fld2latex.isStressStrain(jobs{i}{j}.zData))
            X = [nan];
            Y = [nan];
            Z = [nan];
        else
            [Xholder,Yholder,Zholder] = getField(tmpObjs, pp1rs{runIndex}, zpp1rs{runIndex}, jobs{i}{j}.xData,jobs{i}{j}.yData,jobs{i}{j}.zData,fld2latex);
            if length(Xholder)~=length(Yholder)
               THROW('vector dimensions do not agree for X and Y.');            
            end
            if ~isempty(Zholder) && length(Xholder)~=length(Zholder)
               THROW('vector dimensions of Z does not agree with X and Y.'); 
            elseif all(isnan(Zholder))
               Zholder = []; 
            end

            X = Xholder;
            Y = Yholder;
            Z = Zholder;

            %CHECK FOR NAN
            if any(isnan(abs(X))) == 1
                Y = Y(~isnan(abs(X)));
                if ~isempty(Z)
                    Z = Z(~isnan(abs(X)));
                end
                X = X(~isnan(abs(X)));
            end
            if any(isnan(abs(Y))) == 1
                X = X(~isnan(abs(Y)));
                if ~isempty(Z)
                    Z = Z(~isnan(abs(Y)));
                end
                Y = Y(~isnan(abs(Y)));
            end
            if ~isempty(Z) && any(isnan(abs(Z))) == 1
                X = X(~isnan(abs(Z)));
                Y = Y(~isnan(abs(Z)));
                Z = Z(~isnan(abs(Z)));
            end
            %CHECK FOR INFINITY
            if any(isinf(abs(X))) == 1
                Y = Y(~isinf(abs(X)));
                if ~isempty(Z)
                    Z = Z(~isinf(abs(X)));
                end
                X = X(~isinf(abs(X)));
            end
            if any(isinf(abs(Y))) == 1
                X = X(~isinf(abs(Y)));
                if ~isempty(Z)
                    Z = Z(~isinf(abs(Y)));
                end
                Y = Y(~isinf(abs(Y)));
            end
            if ~isempty(Z) && any(isinf(abs(Z))) == 1
                X = X(~isinf(abs(Z)));
                Y = Y(~isinf(abs(Z)));
                Z = Z(~isinf(abs(Z)));
            end       
            if isempty(X) || isempty(Y)
               printJob(jobs{i}{j}); 
               THROW('X or Y was not set properly.'); 
            end
        end

        %POST-PROCESSING
        h = [];
        hold(ax{i}{axno},'on');
        if isempty(Z)
            [X, indices] = sort(X);
            Y = Y(indices);
            
            h = plot(ax{i}{axno},X,Y);                
        else
            h = plot3(ax{i}{axno},X,Y,Z);
        end
        try
            set(h,'LineStyle',jobs{i}{j}.line.ls,...
                'LineWidth',jobs{i}{j}.line.lw,...
                'Marker',jobs{i}{j}.line.ms,...
                'MarkerSize',jobs{i}{j}.line.mw);        
            if  ~isempty(jobs{i}{j}.line.lc)
                set(h,'Color',jobs{i}{j}.line.lc); 
            end
        catch e
            disp('Internal error.\n');
            disp(e);
        end
        legText{i}{axno} = [legText{i}{axno},['$$ ',jobs{i}{j}.legendText,' $$']];
        
        %+++++CURVE FITTING
        %====================================
        if jobs{i}{j}.bestFitActive == 1
            curveFit = autofit(X,Y,Z,forcedFitType);            
            if ~isempty(curveFit)
                cfh = [];
                if isempty(Z)                    
                    fY = feval(curveFit.object, X);                    
                    cfh = plot(ax{i}{axno},X,fY);
                    try
                        set(cfh,'LineStyle',jobs{i}{j}.bestFitLine.ls,...
                        'LineWidth',jobs{i}{j}.bestFitLine.lw,...
                        'Marker',jobs{i}{j}.bestFitLine.ms,...
                        'MarkerSize',jobs{i}{j}.bestFitLine.mw);
                        if  ~isempty(jobs{i}{j}.bestFitLine.lc)
                            set(cfh,'Color',jobs{i}{j}.bestFitLine.lc); 
                        end
                    catch e
                        disp('Internal error.\n');
                        disp(e);
                    end
                    legText{i}{axno} = [legText{i}{axno},['$$ ',jobs{i}{j}.legendText,sprintf('(bf:%s)',curveFit.type),' $$']];
                else
                    THROW('NOT IMPLEMENTED FOR 3D PLOTS YET');
                    %cfh = plot(curveFit.object);
                end                
            else
                % Cannot fit data to any specified form
            end
        end
        %====================================
        title('');
        if ~isempty(jobs{i}{j}.xLab)
            xlabel(['$$ ',jobs{i}{j}.xLab,' $$'], 'Interpreter', 'latex');
        end
        if ~isempty(jobs{i}{j}.yLab)
            ylabel(['$$ ',jobs{i}{j}.yLab,' $$'], 'Interpreter', 'latex');
        end
        if ~isempty(Z)
            if ~isempty(jobs{i}{j}.zLab)
                zlabel(['$$ ',jobs{i}{j}.zLab,' $$']);
            end
        end
        
        %//////////////////////////////////////////////////////////////////////////
        axCurvesCounter{i}{axno} = axCurvesCounter{i}{axno} + 1;
        if axCurvesCounter{i}{axno} >= axNumCurves{i}{axno}
           fileName = '';
            if globalDefaults.figureDefaults.save.active == 1
                tmpJob = jobs{i}{j};
                if isempty(tmpJob)
                   THROW('Axes assignment error.'); 
                end
                %        grid(gca,'on');
                % legend(ax{i}{axno},'off');
                legLoc = tmpJob.legendLocation;        
                if strcmpi(globalDefaults.legendDefaults.in_out,'outside')==1
                    legLoc = [legLoc,'outside'];
                end
                try   
                    %warning('MATLAB:legend:IgnoringExtraEntries','off');
                    legend(ax{i}{axno},legText{i}{axno},'Location',legLoc, 'Interpreter', 'latex');
                    %warning('MATLAB:legend:IgnoringExtraEntries','on');
                    msgstr = lastwarn;
                    %if strcmpi(msgstr,'Ignoring extra legend entries.') ==1
                    if ~isempty(strfind(lower(msgstr),'legend')) || ~isempty(strfind(lower(msgstr),'plot'))
                       error(msgstr); 
                    end
                catch excep
                    % SHOULD BE AN ERROR BUT PLOT STILL OCCURS...MONITOR IN
                    % FUTURE FOR POTENTIAL ERRORS
                    THROW('Legend error.');
                end
                if isempty(sentinel)
                    fieldsVs = [labelFromLatexMap(tmpJob.xData,fld2latex,1),'-',labelFromLatexMap(tmpJob.yData,fld2latex,1)];
                    if ~isempty(tmpJob.zData)
                        fieldsVs = [fieldsVs ,'-',labelFromLatexMap(tmpJob.zData,fld2latex,1)];
                    end
                    fileName = [tmpJob.runFolder,'_',fieldsVs,'_',meshopt,'_',tmpJob.suffix];
                else                  
                    if i == S_AX
                       fileName = [s_m{i}{axno},'_sr','_',meshopt,'_',tmpJob.suffix];
                    elseif i == M_AX
                       fileName = [s_m{i}{axno},'_mr','_',meshopt,'_',tmpJob.suffix]; 
                    else
                       THROW('Invaild Index'); 
                    end
                end
                for k = 1:length(globalDefaults.figureDefaults.save.exts)
                    if strcmp(globalDefaults.figureDefaults.save.exts{k},'fig') == 1
                       set(fig{i}{axno},'Visible','on'); 
                    end
                    
                    % CHECK FOR INSTANCE OF FILE ALREADY EXISTING
                    tmpName = fileName;
                    while exist([fullfile(figureOutputDir,tmpName),'.',globalDefaults.figureDefaults.save.exts{k}],'file') == 2
                        copyCounter = copyCounter + 1;
                        tmpName = [fileName,'_image',num2str(copyCounter)]; 
                    end
                    copyCounter = 1;
                    % END_CHECK FOR INSTANCE OF FILE ALREADY EXISTING
                    
                    saveas(fig{i}{axno},[fullfile(figureOutputDir,tmpName),'.',globalDefaults.figureDefaults.save.exts{k}]);
                    
                    if strcmp(globalDefaults.figureDefaults.save.exts{k},'fig') == 1
                       set(fig{i}{axno},'Visible',globalDefaults.figureDefaults.visible);
                       set(ax{i}{axno},'Visible',globalDefaults.figureDefaults.visible);
                    end
                end
            end 
        end
        %//////////////////////////////////////////////////////////////////////////
    end
end

%RESTORE MATLAB DEFAULTS
safeMatlabDefaultRestore();
end

function [varobj, staticobj, found] = mapfind(varmap, staticmap, rkey, skey)
%static_map = struct('rfKeys',{{}},'objMatrix',{{}});
found = 0;
varobj = {};
staticobj = {};
rfind = find(cellfun(@(x) strcmp(x,rkey),staticmap.rfKeys,'UniformOutput',true));
if isempty(rfind)
    return;
else
    staticobj = staticmap.objMatrix{rfind(1)};
    if isempty(staticobj)
        return;
    end
end
if found == 1 && isempty(staticobj)
    THROW('static map object not set properly for output.');
end

%var_map = struct('rfKeys',{{}},'suffKeys',{{}},'objMatrix',{{}});
rfind = find(cellfun(@(x) strcmp(x,rkey),varmap.rfKeys,'UniformOutput',true));
sfind = find(cellfun(@(x) strcmp(x,skey),varmap.suffKeys,'UniformOutput',true));
if isempty(rfind) || isempty(sfind)
    return;
else
    varobj = varmap.objMatrix{rfind(1),sfind(1)};
    if ~isempty(varobj)
        found = 1;
    else
        found = 0;
        return;
    end
end
if found == 1 && isempty(varobj)
    THROW('variable map object not set properly for output.');
end
end
function [varmap, staticmap] = mapinsert(varmap, staticmap, rkey, skey, varobj, staticobj)
% FOR NOW IMPLEMENTATION ASSUMES ENTRY DID NOT EXIST PRIOR TO CALL    
%[~, found] = mapfind(map, rkey, skey);
    rfind = find(cellfun(@(x) strcmp(x,rkey),staticmap.rfKeys,'UniformOutput',true));

    rfPos = length(staticmap.rfKeys) + 1;
    if ~isempty(rfind)
        rfPos = rfind(1);
    else
        staticmap.rfKeys{rfPos} = rkey;
    end
   
    staticmap.objMatrix{rfPos} = staticobj;

%if found ~= 1
    rfind = find(cellfun(@(x) strcmp(x,rkey),varmap.rfKeys,'UniformOutput',true));
    sfind = find(cellfun(@(x) strcmp(x,skey),varmap.suffKeys,'UniformOutput',true));

    rfPos = length(varmap.rfKeys) + 1;
    if ~isempty(rfind)
        rfPos = rfind(1);
    else
        varmap.rfKeys{rfPos} = rkey;
    end
    
    suffPos = length(varmap.suffKeys) + 1;
    if ~isempty(sfind)
        suffPos = sfind(1);
    else
        varmap.suffKeys{suffPos} = skey;
    end
    
    varmap.objMatrix{rfPos,suffPos} = varobj;
%end 
end

function [X,Y,Z] = getField(vdsObj, pp1r, zpp1r, xlab, ylab, zlab, fld2latex)
%global DIM
% global xlab ylab zlab
global delim

X = [];
Y = [];
Z = [];

m = 1;
M = 2;
mu = 3;
sig = 4;
num_stats = 4;

len = length(vdsObj.static.serial);
names = {xlab, ylab, zlab};
out = NaN.*ones(len,length(names));
lenOut = size(out,2);
for i = 1:lenOut
    fullname = names{i};
    fldName = {};
    stat = {};
    
    if isempty(fullname)
       continue; 
    end
    
    [fullname,corrBool] = parseNames(fullname);
    lenName = length(fullname);
    
    %PARSE NAME
    for j = 1:lenName
        found = strfind(fullname{j},delim);
        if isempty(found)
            stat{j} = 'mean';
            fldName{j} = fullname{j};
        else
            stat{j} = fullname(found+(length(delim)):end);
            fldName{j} = fullname{j}(1:(found-1));
        end
    end
    
    if lenName == 1
        switch fldName{1}
            case 'count'
                out(:,i) = vdsObj.var.count;
                continue;
            case 'measure'
                out(:,i) = vdsObj.var.measure;
                continue;
            case 'serial'
                out(:,i) = vdsObj.static.serial;
                continue;
            case 'time'
                out(:,i) = vdsObj.static.t(:,m);
                continue;    
        end
    end
    
    %STRESS-STRAIN FIELDS
    if lenName == 1
 %      if vdsObj.energyActive == 1
        if ((vdsObj.static.ssActive == 1) || (~isempty(pp1r))) 
            nm = fldName{j};
%             if (strcmp(nm, 'e00') == 1)
%                 nm = 'zpr_stnst_xx';
%             elseif (strcmp(nm, 's00L') == 1)
%                 nm = 'zpr_stssh_xx';
%             elseif (strcmp(nm, 's00R') == 1)
%                 nm = 'zpr_stssh_yy';
%             end
            [isSS, ssindex] = isStressStrain(fld2latex, nm);
            if (isSS > 1)
                try
                    if (strncmp(nm, 'zpr', 3) == 1) % raw data
                       out(:,i) = pp1r.getDataVectorByDataName(nm);
                    elseif (strncmp(nm, 'zpp', 3) == 1) % processed damage data
                       dataPts = zpp1r.getDataVectorByDataName(nm);
                       for k = 1:len 
                            out(k, i) = dataPts(k);
                       end
                    else
                        fld2latex
                        THROW('invalid fld2latex\n');
                    end
                    continue;
                catch e                    
                    THROW(e.identifier);
                end
            elseif (isSS == 1) % Philip's way
                try
                    out(:,i) = vdsObj.static.ss(:,ssindex);
                    continue;
                catch e                    
                    THROW(e.identifier);
                end
            end
        end          
    end
    
    %ENERGY FIELDS
    if lenName == 1
 %      if vdsObj.energyActive == 1
        if vdsObj.static.enActive == 1
          [numericString,valid] = vdsObj.static.enClass.validString(fldName{1});
          if valid == 1              
            %==============================================================
            %tmpVal = vdsObj.enClass.getByStr(numericString);
            [indStr,valid] = vdsObj.static.enClass.validString(numericString); 
            if (valid ~= 1)
                msg = sprintf('Invalid energy indexing{%s}',indStrIn);
                THROW(msg);
            end            
            [r,status] = str2num(indStr(1:2));
            if (status ~= 1)
                msg = sprintf('Invalid energy indexing{%s}',indStr(1:2));
                THROW(msg);
            end
            [c,status] = str2num(indStr(3:4));
            if (status ~= 1)
                msg = sprintf('Invalid energy indexing{%s}',indStr(3:4));
                THROW(msg);
            end
            if vdsObj.static.enClass.validIndices(r,c) == 1
                tmpVal = squeeze(vdsObj.static.en(r,c,:));
            end 
            %==============================================================

            if any(~isnan(tmpVal))
                out(:,i) = tmpVal;
                continue;
            end            
          end          
       end
    end
    
    % GET FIELD INDEX
    index = cell(lenName,1);
    for j = 1:lenName
        index{j} = find(cellfun(@(x) strcmpi(x,fldName{j}),vdsObj.var.names,'UniformOutput',true));
        if isempty(index{j}) && strcmpi(fldName{j},'cov')~=1
           msg = sprintf('Invalid field{%s}',fldName{j});
           THROW(msg); 
        elseif strcmpi(fldName{j},'cov')==1 && lenName > 1
           THROW('cov cannot be concatenated with other fields.'); 
        end
    end  
    % VARIANCE AT Z
    if  i == lenOut 
%         if strcmpi(fldName{1},'cov')~=1
%             THROW('variance must be -z quantity proceeded by two valid -x and -y fields.');
%         end
        if strcmpi(fldName{1},'cov')==1
                varI = find(cellfun(@(x) strcmpi(x,names{1}),vdsObj.var.names,'UniformOutput',true));
                varJ = find(cellfun(@(x) strcmpi(x,names{2}),vdsObj.var.names,'UniformOutput',true));
                if isempty(varI) || isempty(varJ)
                   msg = sprintf('-x(%s) and/or -y(%s) is not valid field to plot.',names{1},names{2}); 
                   THROW(msg); 
                end
                out(:,i) = squeeze(vdsObj.var.covs(varI,varJ,:));
                continue;
        end
    end
    %COVARIANCE AND CORRELATION WITH '|' and '||' NOTATION
    if lenName == 2
        if corrBool == 0
           %out(i) = vdsObj.covariance(index{1},index{2});
           out(:,i) = squeeze(vdsObj.var.covs(index{1},index{2},:));
           continue;
        elseif  corrBool == 1
            tmpstd = squeeze(vdsObj.var.vals(sig,index{1},:).*vdsObj.var.vals(sig,index{2},:));
            indices = tmpstd~=0.0;
            tmpstd = tmpstd(indices); 
%            if (vdsObj.stdev(index{1})*vdsObj.stdev(index{2})) == 0.0  
%                out(i) = 0.0;
%            else
%                out(i) = vdsObj.covariance(index{1},index{2}) / (vdsObj.stdev(index{1})*vdsObj.stdev(index{2}));
%            end 
            out(:,i) = squeeze(vdsObj.var.covs(index{1},index{2},indices)) ./ tmpstd;
            continue;
        end 
    elseif lenName == 1
    % RETRIEVE STAT VALUE FOR X OR Y
        switch stat{1}
            case 'min'
                %out(i) = vdsObj.min{index{1}}.val;
                out(:,i) = squeeze(vdsObj.var.vals(m,index{1},:));
                continue;
            case 'max'
                %out(i) = vdsObj.max{index{1}}.val;
                out(:,i) = squeeze(vdsObj.var.vals(M,index{1},:));
                continue;
            case 'mean'
                %out(i) = vdsObj.mean(index{1});
                out(:,i) = squeeze(vdsObj.var.vals(mu,index{1},:));
                continue;
            case 'stdev'
                %out(i) = vdsObj.stdev(index{1});
                out(:,i) = squeeze(vdsObj.var.vals(sig,index{1},:));
                continue;
            otherwise
                msg = sprintf('Invalid statistics{%s}',stat{1});
                THROW(msg);
        end
    end

        %Should never reach this point unless something is wrong
        THROW('invalid field inputs. Please check!.');
end

%if any(isnan(out(:,1))) || any(isnan(out(:,2)))
%   THROW('output X and/or Y not set correctly.'); 
%end
X = out(:,1);
Y = out(:,2);
if ~isempty(zlab)
    Z = out(:,3);
end
end

function [X,Y,Z] = getFieldOLD(vdsObj, xlab, ylab, zlab)
%global DIM
% global xlab ylab zlab
global delim

X = [];
Y = [];
Z = [];

names = {xlab, ylab, zlab};
out = NaN.*ones(length(names),1);
lenOut = length(out);
for i = 1:lenOut
    fullname = names{i};
    fldName = {};
    stat = {};
    
    if isempty(fullname)
       continue; 
    end
    
    [fullname,corrBool] = parseNames(fullname);
    lenName = length(fullname);
    
    %PARSE NAME
    for j = 1:lenName
        found = strfind(fullname{j},delim);
        if isempty(found)
            stat{j} = 'mean';
            fldName{j} = fullname{j};
        else
            stat{j} = fullname(found+(length(delim)):end);
            fldName{j} = fullname{j}(1:(found-1));
        end
    end
    
    if lenName == 1
        switch fldName{1}
            case 'count'
                out(i) = vdsObj.count;
                continue;
            case 'measure'
                out(i) = vdsObj.measure;
                continue;
            case 'serial'
                out(i) = vdsObj.serial;
                continue;
            case 'time'
                out(i) = vdsObj.t_min;
                continue;    
        end
    end
    
    %ENERGY FIELDS
    if lenName == 1
       if vdsObj.energyActive == 1
          [numericString,valid] = vdsObj.energy.validString(fldName{1});
          if valid == 1
            tmpVal = vdsObj.energy.getByStr(numericString); 
            if ~isnan(tmpVal)
                out(i) = tmpVal;
                continue;
            end            
          end          
       end
    end
    
    % GET FIELD INDEX
    index = cell(lenName,1);
    for j = 1:lenName
        index{j} = find(cellfun(@(x) strcmpi(x,fldName{j}),vdsObj.names,'UniformOutput',true));
        if isempty(index{j}) && strcmpi(fldName{j},'cov')~=1
           msg = sprintf('Invalid field{%s}',fldName{j});
           THROW(msg); 
        elseif strcmpi(fldName{j},'cov')==1 && lenName > 1
           THROW('cov cannot be concatenated with other fields.'); 
        end
    end  
    % VARIANCE AT Z
    if  i == lenOut 
%         if strcmpi(fldName{1},'cov')~=1
%             THROW('variance must be -z quantity proceeded by two valid -x and -y fields.');
%         end
        if strcmpi(fldName{1},'cov')==1
                varI = find(cellfun(@(x) strcmpi(x,names{1}),vdsObj.names,'UniformOutput',true));
                varJ = find(cellfun(@(x) strcmpi(x,names{2}),vdsObj.names,'UniformOutput',true));
                if isempty(varI) || isempty(varJ)
                   msg = sprintf('-x(%s) and/or -y(%s) is not valid field to plot.',names{1},names{2}); 
                   THROW(msg); 
                end
                out(i) = vdsObj.covariance(varI,varJ);
                continue;
        end
    end
    %COVARIANCE AND CORRELATION WITH '|' and '||' NOTATION
    if lenName == 2
        if corrBool == 0
           out(i) = vdsObj.covariance(index{1},index{2});
           continue;
        elseif  corrBool == 1
           if (vdsObj.stdev(index{1})*vdsObj.stdev(index{2})) == 0.0  
               out(i) = 0.0;
           else
               out(i) = vdsObj.covariance(index{1},index{2}) / (vdsObj.stdev(index{1})*vdsObj.stdev(index{2}));
           end     
           continue;
        end 
    elseif lenName == 1
    % RETRIEVE STAT VALUE FOR X OR Y
        switch stat{1}
            case 'min'
                out(i) = vdsObj.min{index{1}}.val;
                continue;
            case 'max'
                out(i) = vdsObj.max{index{1}}.val;
                continue;
            case 'mean'
                out(i) = vdsObj.mean(index{1});
                continue;
            case 'stdev'
                out(i) = vdsObj.stdev(index{1});
                continue;
            otherwise
                msg = sprintf('Invalid statistics{%s}',stat{1});
                THROW(msg);
        end
    end

        %Should never reach this point unless something is wrong
        THROW('invalid field inputs. Please check!.');
end

if isnan(out(1)) || isnan(out(2))
   THROW('output X and/or Y not set correctly.'); 
end
X = out(1);
Y = out(2);
if ~isempty(zlab)
    Z = out(3);
end
end

function setDefaults(ax,fig,defaults)
% ref: http://www.mathworks.com/help/matlab/creating_plots/default-property-values.html?searchHighlight=remove

    set(groot, 'defaultTextInterpreter', defaults.axisDefaults.interpreter);
    set(groot, 'defaultTextFontSize', defaults.axisDefaults.fontSize);
    set(groot, 'defaultAxesFontSize', defaults.axisDefaults.fontSize);
    
    set(groot, 'defaultLegendInterpreter', defaults.legendDefaults.interpreter);
    set(groot, 'defaultLegendOrientation', defaults.legendDefaults.orientation);
    set(groot, 'defaultLegendBox', defaults.legendDefaults.boxOn);
    set(groot, 'defaultLegendLineWidth', defaults.legendDefaults.boxWidth);
    set(groot, 'defaultLegendFontSize', defaults.legendDefaults.fontSize);
    
    
    for i = 1:length(fig)
        for j = 1:length(fig{i})
            if ~isempty(fig{i}{j})
                if defaults.figureDefaults.fullscreen == 1
                    set(fig{i}{j},'Units','normalized','OuterPosition',[0 0 1 1]);
                end            

                grid0_1 = defaults.axisDefaults.gridOn;
    %             set(ax{i}{j},'XGrid',grid0_1);
    %             set(ax{i}{j},'YGrid',grid0_1);
    %             set(ax{i}{j},'ZGrid',grid0_1);
                grid(ax{i}{j},grid0_1);

                tic = defaults.axisDefaults.ticActive;
                set(ax{i}{j},'XMinorTick',tic);
                set(ax{i}{j},'YMinorTick',tic);
                set(ax{i}{j},'ZMinorTick',tic);

                ax{i}{j}.XLabel.VerticalAlignment = defaults.axisDefaults.xLabVAlign;
                %ax{i}{j}.YLabel.VerticalAlignment = defaults.axisDefaults.yLabVAlign;
                %ax{i}{j}.ZLabel.VerticalAlignment = defaults.axisDefaults.zLabVAlign; 

                %SET VISIBILITY LAST
                vis = defaults.figureDefaults.visible;
                set(fig{i}{j},'Visible',vis);
                %set(ax{i}{j},'Visible',vis);
            end
        end
    end
end

%++ WORKING VERsiON BUTUSES YY AND YYN
% function [X,Y,Z] = getField(vdsObj)
% %global DIM
% global xlab ylab yylab yynlab zlab
% global delim
% 
% names = {};
% if ~isempty(zlab)
%    if isempty(ylab) || ~isempty(yylab) || ~isempty(yynlab)
%        THROW('if zlab is specified only ylab is supported and can be a valid input.')
%    else
%        names = {xlab, ylab, zlab};
%    end
% else
%    if (~isempty(ylab) + ~isempty(yylab) + ~isempty(yynlab)) > 1
%        THROW ('either ylab, yylab or yynlab can be specified at once.');
%    else
%        if ~isempty(ylab)
%            names = {xlab, ylab, zlab};
%        elseif ~isempty(yylab)
%            names = {xlab, yylab, zlab};
%        elseif ~isempty(yynlab)
%            names = {xlab, yynlab, zlab};
%        end
%    end
% end
% 
% out = NaN.*ones(length(names),1);
% vi = [];
% lenOut = length(out);
% for i = 1:lenOut
%     fullname = names{i};
%     fldName = {};
%     stat = {};
%     
%     if isempty(fullname)
%        continue; 
%     end
%     
%     fullname = parseNames(fullname);
%     lenName = length(fullname);
%     
%     %PARSE NAME
%     for j = 1:lenName
%         found = strfind(fullname{j},delim);
%         if isempty(found)
%             stat{j} = 'mean';
%             fldName{j} = fullname{j};
%         else
%             stat{j} = fullname(found+(length(delim)):end);
%             fldName{j} = fullname{j}(1:(found-1));
%         end
%     end
%     
%     if lenName == 1
%         switch fldName{1}
%             case 'count'
%                 out(i) = vdsObj.count;
%                 continue;
%             case 'measure'
%                 out(i) = vdsObj.measure;
%                 continue;
%             case 'serial'
%                 out(i) = vdsObj.serial;
%                 continue;
%             case 'time'
%                 out(i) = vdsObj.t_min;
%                 continue;
%         end
%     end
%     
%     % GET FIELD INDEX
%     index = cell(lenName,1);
%     for j = 1:lenName
%         index{j} = find(cellfun(@(x) strcmpi(x,fldName{j}),vdsObj.names,'UniformOutput',true));
%         if isempty(index{j}) && strcmpi(fldName{j},'cov')~=1
%            msg = sprintf('Invalid field{%s}',fldName{j});
%            THROW(msg); 
%         elseif strcmpi(fldName{j},'cov')==1 && lenName > 1
%            THROW('cov cannot be concatenated with other fields.'); 
%         end
%     end  
%     % VARIANCE AT Z
%     if  isempty(yylab) && isempty(yynlab) && i == lenOut 
% %         if strcmpi(fldName{1},'cov')~=1
% %             THROW('covariance must be -z quantity proceeded by two valid -x and -y fields.');
% %         end
%         if strcmpi(fldName{1},'cov')~=1
%                 varI = find(cellfun(@(x) strcmpi(x,names{1}),vdsObj.names,'UniformOutput',true));
%                 varJ = find(cellfun(@(x) strcmpi(x,names{2}),vdsObj.names,'UniformOutput',true));
%                 if isempty(varI) || isempty(varJ)
%                    msg = sprintf('-x(%s) and/or -y(%s) is not valid field to plot.',names{1},names{2}); 
%                    THROW(msg); 
%                 end
%                 out(i) = vdsObj.covariance(varI,varJ);
%                 continue;
%         end
%     end
%     %CONCATENATED FIELDS FOR YY AND YYN
%     if lenName == 2 && (~isempty(yylab) || ~isempty(yynlab))
%         if ~isempty(yylab)
%            out(i) = vdsObj.covariance(index{1},index{2});
%            continue;
%         elseif ~isempty(yynlab)
%            out(i) = vdsObj.covariance(index{1},index{2}) / (vdsObj.stdev{index{1}}*vdsObj.stdev{index{2}});
%            continue;
%         end 
%     end
% 
%     % RETRIEVE STAT VALUE FOR X OR Y
%     if lenName ~= 1
%        THROW('-x, -y, and -z fields cannot be concatenated fields') 
%     end
%     switch stat{1}
%         case 'min'
%             out(i) = vdsObj.min{index{1}}.val;
%             continue;
%         case 'max'
%             out(i) = vdsObj.max{index{1}}.val;
%             continue;
%         case 'mean'
%             out(i) = vdsObj.mean(index{1});
%             continue;
%         case 'stdev'
%             out(i) = vdsObj.stdev(index{1});
%             continue;
%         otherwise
%             msg = sprintf('Invalid statistics{%s}',stat{1});
%             THROW(msg);
%     end
%     
%     %Should never reach this point unless something is wrong
%     THROW('invalid field inputs. Please check!.');
%  %   end
% end
% 
% if isnan(out(1)) || isnan(out(2))
%    THROW('output X and/or Y not set correctly.'); 
% end
% X = out(1);
% Y = out(2);
% Z = out(3);
% end
