function plotVDS(configFile, folderName)

clearvars -except configFile folderName
%plotVDS() plots (V)ector of (D)ata (S)tats based on configuration file read

addpath('aux_functions');
if nargin < 1
   %configFile = 'ConfigSample'; 
   configFile = 'ConfigSample_ss'; 
end
if nargin < 2;
    folderName = 'output_plots';
end
t = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z');
fprintf(1,'START_TIME:=');
disp(t);

global philipLabels;
philipLabels = {'t', 's00L', 's00R', 's01L', 's01R', 'e00', 'e01', 's11T', 's11B', 's10T', 's10B', 'e11', 'e10'};

%CONFIG FILE READ
%strainStressOpts(1): Philip's old format stress strain
%strainStressOpts(2): Reza's new one, flags with option: pzr
%strainStressOpts(3): Reza's new one, flags with option: pzp (post
[defaults, data, mainDirs, plots, field2Latex, configAllRunsSyncNew, newRunMaps, runsAdditionalParaMaps, strainStressOpts] = readVDSPlotConfig(configFile);
%JOB QUEUE GENERATION
[jobs,numAxes,idAxes] = generatePlotQueue(defaults, data, mainDirs, plots, field2Latex);
sentinelInput = struct('jobs',{jobs},'numAxes',[numAxes],'idAxes',{idAxes},'defaults',defaults, 'ssOpts', strainStressOpts); %, 'runName2Loc', {newRunMaps}, 'runsAddedParas', {runsAdditionalParaMaps});

%DEBUGGING
%======================================
debugJobsPrint(sentinelInput.jobs,sentinelInput.numAxes,sentinelInput.idAxes);
%======================================

%PLOTTING OF JOBS
close all;
clearvars -except sentinelInput folderName configAllRunsSyncNew newRunMaps runsAdditionalParaMaps
%meshing = {'sync','mesh'}; 
meshing = {'sync'}; 
for m = 1:length(meshing)
        safeMatlabDefaultRestore();
        sentinel_vds_plot('-mopt',meshing{m},'-ftype','','-jobs',sentinelInput, ...
            '-folder', folderName, '-fconfsigeps', configAllRunsSyncNew, '-runName2Loc', newRunMaps, '-runsAddedParas', runsAdditionalParaMaps);
        
        clear sentinel_vds_plot
        if sentinelInput.defaults.figureDefaults.save.active == 1 || strcmpi(sentinelInput.defaults.figureDefaults.visible,'off') 
            close all      
        end
end
t = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z');
fprintf(1,'END_TIME:=');
disp(t);
fprintf(1,'\n');
end

function [jobs,numAxes,idAxes] = generatePlotQueue(defaults, data, mainDirs, plots, field2Latex)
    lenRuns = length(mainDirs.runs);
    lenPlots = length(plots);    
    NUM_AX_TYPES = 2;
    S_AX = 1;
    M_AX = 2;
    
    jobs = cell(1,NUM_AX_TYPES);
    numAxes = zeros(1,NUM_AX_TYPES);
    idAxes = cell(1,NUM_AX_TYPES);
    for aid = 1:NUM_AX_TYPES
       idAxes{aid} = []; 
    end
    
    sOffset = 0;
    mOffset = 0;
    for h = 1:lenPlots 
        lenSuff = length(plots{h}.suffix);
        lenX = length(plots{h}.x);
        lenY = length(plots{h}.y);
        lenZ = length(plots{h}.z); %Should be a max of one for now
               
        lenMultiAx = 0;
        lenSingleAx = 0;
        if plots{h}.multiRun == 1
            lenMultiAx = lenSuff * lenX * lenY;
            if lenZ > 0
                lenMultiAx = lenMultiAx * lenZ;
            end
        end
        numAxes(M_AX) = numAxes(M_AX) + lenMultiAx;
        if plots{h}.singleRun == 1
            lenSingleAx = lenSuff * lenRuns * lenX;
        end
        numAxes(S_AX) = numAxes(S_AX) + lenSingleAx;
        
        sCounter = 0;
        mCounter = 0;
        si = 0;        
        for i = 1:lenRuns 
            mCounter = 0;
            mi = 0;
            for s = 1:lenSuff                 
                for j = 1:lenX
                    si = si + 1;
                    sAxInterm = sOffset + si;
                    for k = 1:lenY   
                        mi = mi + 1;
                        mAxInterm = mOffset + mi;                        
                        tmpJob = cell(NUM_AX_TYPES,1);
                        for tj = 1:NUM_AX_TYPES
                            obj = jobstruct();
                            if tj == S_AX && plots{h}.singleRun == 1
                                tmpJob{S_AX} = obj;
                            end
                            if tj == M_AX && plots{h}.multiRun == 1
                                tmpJob{M_AX} = obj;
                            end
                        end
                        for l = 1:lenZ
                           THROW('3D TYPE PLOTTING NOT SUPPORTED YET!'); 
                        end 

                        if ~isempty(tmpJob{S_AX})
                            %tmpJob{S_AX}.axNo = (h-1)*lenSuff*lenRuns*lenX + (s-1)*lenRuns*lenX + (i-1)*lenX + j;
                            tmpJob{S_AX}.axNo = sAxInterm;
                            if ~any(idAxes{S_AX} == tmpJob{S_AX}.axNo)
                                idAxes{S_AX} = [idAxes{S_AX},tmpJob{S_AX}.axNo];
                            end
                            tmpJob{S_AX}.runFolder = mainDirs.runs{i}.folder;
                            tmpJob{S_AX}.xData = plots{h}.x{j};
                            tmpJob{S_AX}.yData = plots{h}.y{k};                        
                            tmpJob{S_AX}.xLab = labelFromData(tmpJob{S_AX}.xData, data, field2Latex); %'';
                            tmpJob{S_AX}.yLab = '';
                            xLatexStr = tmpJob{S_AX}.xLab; %labelFromData(tmpJob{S_AX}.xData, data, field2Latex);
                            yLatexStr = labelFromData(tmpJob{S_AX}.yData, data, field2Latex); 
                            tmpJob{S_AX}.xLimits = setLimits(1, tmpJob{S_AX}.xData, data, defaults);
                            tmpJob{S_AX}.yLimits = setLimits(2, tmpJob{S_AX}.yData, data, defaults);
                            tmpJob{S_AX}.legendText = yLatexStr; %[yLatexStr,'\ vs\ ',xLatexStr];                      
                            tmpJob{S_AX}.legendLocation = plots{h}.legendLocation;
                            tmpJob{S_AX}.bestFitActive = plots{h}.bestFit;
                            tmpJob{S_AX}.bestFitLine = defaults.lineDefaults.bfit;
                            tmpJob{S_AX}.line = getLineSpec(tmpJob{S_AX}.yData,data,defaults);
                            tmpJob{S_AX}.suffix = plots{h}.suffix{s};
                        else
                            if plots{h}.singleRun == 1
                                THROW('Internal Error.');
                            end
                        end
                        if ~isempty(tmpJob{M_AX})                            
                            %tmpJob{M_AX}.axNo = (h-1)*lenSuff*lenX*lenY + (s-1)*lenX*lenY + (j-1)*lenY + k;
                            tmpJob{M_AX}.axNo = mAxInterm;
                            if ~any(idAxes{M_AX} == tmpJob{M_AX}.axNo)
                                idAxes{M_AX} = [idAxes{M_AX},tmpJob{M_AX}.axNo];
                            end
                            tmpJob{M_AX}.runFolder = mainDirs.runs{i}.folder;
                            tmpJob{M_AX}.xData = plots{h}.x{j};
                            tmpJob{M_AX}.yData = plots{h}.y{k};                        
                            tmpJob{M_AX}.xLab = labelFromData(tmpJob{M_AX}.xData, data, field2Latex);
                            tmpJob{M_AX}.yLab = labelFromData(tmpJob{M_AX}.yData, data, field2Latex);
                            tmpJob{M_AX}.xLimits = setLimits(1, tmpJob{M_AX}.xData, data, defaults);
                            tmpJob{M_AX}.yLimits = setLimits(2, tmpJob{M_AX}.yData, data, defaults);
                            tmpJob{M_AX}.legendText = mainDirs.runs{i}.latexString;
                            tmpJob{M_AX}.legendLocation = plots{h}.legendLocation;
                            tmpJob{M_AX}.bestFitActive = plots{h}.bestFit;
                            tmpJob{M_AX}.bestFitLine = defaults.lineDefaults.bfit;
                            tmpJob{M_AX}.line = mainDirs.runs{i}.line;
                            tmpJob{M_AX}.suffix = plots{h}.suffix{s};
                        else
                            if plots{h}.multiRun == 1
                                THROW('Internal Error.');
                            end
                        end


                        %FINALIZE
                        if ~isempty(tmpJob{S_AX}) 
                            jobs{S_AX}{length(jobs{S_AX})+1} = tmpJob{S_AX};
                        end
                        if ~isempty(tmpJob{M_AX}) 
                            jobs{M_AX}{length(jobs{M_AX})+1} = tmpJob{M_AX}; 
                        end
                    end                
                end
                mCounter = mCounter + mi;                
            end 
            sCounter = sCounter + si;            
        end
        mOffset = mOffset + mCounter;
        sOffset = sOffset + sCounter;
    end
    
    for aid = 1:NUM_AX_TYPES
       if length(idAxes{aid}) ~= numAxes(aid)
          msg = sprintf('number of axes ids generated[%i] and predetermined number[%i] do not agree.',length(idAxes{aid}),numAxes(aid));
          THROW(msg); 
       end
    end
end

function lineSpec = getLineSpec(dataName,dataObj,defaultsObj)                       
tmpInd = find(cellfun(@(x) strcmp(x,dataName),dataObj.names,'UniformOutput',true));
if length(tmpInd) > 1
    THROW('field name conflict. consider renaming field to avoid name conflicts.');
end

lineSpec = {};
if isempty(tmpInd)
    lineSpec = defaultsObj.lineDefaults.line;
else
    lineSpec = dataObj.fields{tmpInd(1)}.line;
end    
end

function limits = setLimits(axDirection, dataName, dataObj, defaultsObj)
if axDirection < 1 || axDirection > 3
    msg = sprintf('Invalid axis direction index[%i].',axDirection);
    THROW(msg); 
end

tmpInd = find(cellfun(@(x) strcmp(x,dataName),dataObj.names,'UniformOutput',true));
if length(tmpInd) > 1
    THROW('field name conflict. consider renaming field to avoid name conflicts.');
end

limits = {};
if isempty(tmpInd)
    switch axDirection
        case 1
            limits = defaultsObj.axisDefaults.xLimit;
        case 2
            limits = defaultsObj.axisDefaults.yLimit;
        case 3
            limits = defaultsObj.axisDefaults.zLimit;
        otherwise
            msg = sprintf('Invalid direction[%i]',axDirection);
            THROW(msg);
    end
else
    limits = dataObj.fields{tmpInd(1)}.limit;
end    
end