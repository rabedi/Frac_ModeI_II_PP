classdef aSDG_old_Config
    properties
        rootFolderBase = '../../../';
        postFolderName = 'physics';
        runs_hasZpp;
        runFoldersParameters;
        runSeparatingValuesMatrix;
        num_runs = 0;
        splitC = splitter_Config;

        option = 1; % 1 : min / 2 : ave / 3 : max (of time of front meshes used for this purpose)

        runSeparatingNames = {'xy', 'random', 'tau', 'aDot', 'resolution', 'meshNo', 'adaptive', 'tolerance'};
        runSeparatingNamesLatex = {'\mathrm{xy}', 'l_c^\prime', '\tau', '\dot{a}', '\mathrm{res}', 'n_\mathrm{mesh}', '\mathrm{adapt}', '\mathrm{tol}'};
        num_runSeparating = 8;
        
        
        % Summary file, folder, and what will be generated and put in there
        resultsRoot = '../../../matlabResults';
        resultsSummaryName = 'summaryFile.txt';
        summaryFileInclude_criticalPts = 1;
        summaryFileInclude_lastFrame = 1;
        summaryData = gen_textIndexedDatasets;

        copy_front_summary_files = 1;
        copy_zpp_files_2_summary_folder = 1;
        copy_pp_files_2_summary_folder = 1;
        generate_combined_zpp_files = 0;
        
        % time history configs
        generateTimeHistoryConfigs;
        timeHistoryBeginPart;
        timeHistoryEndPart;
        timeHistoryEndPartStrings;
        timeHistoryEndPartStrings_sz = 0;
        timeHistoryOutputFolderRoot;
        timeHistoryConfigFolderRoot;
        timeHistoryMatlabScriptName;
        timeHistoryMatlabLogName;
        

        % front / front sync related files
        frontConfigFolderRoot = 'MicroFrontConfig';
        frontOutputFolderRoot = 'MicroFront';
        frontMatlabScriptName = 'MicroFrontScript';
        frontMatlabLogName = 'MicroFrontLog';
        frontSubConfigName = 'ConfigSampleDMicro.txt';
        
        frontConfigs;

    
        zpp_generate_IfNeeded = 1;
        zpp_removeInNotHaveIt = 1;
        configAllRunsSyncNew_aSDG = pp_synFilesAllR; % flag for this: _configSyncNew
        % read with flag _configSyncNew
        configAllRunsSyncNewFileName_aSDG = '_config_AllRun.txt';
    end
    methods
        function objout = fromFile(obj, configName)
            if (nargin < 1)
                configName = 'config_aSDG.txt';
            end
            fid = fopen(configName, 'r');
            if (fid < 0)
                configName;
                msg = ['Cannot open file %s\n', configName];
                THROW(msg);
            end
            
%            runSeparatingNames_PlusLatex_read = 0;
            
            buf = READ(fid,'s');
            if (strcmp(buf, '{') == 0)
                buf
                THROW('invalid format\n');
            end
%            [buf, neof] = fscanf(fid, '%s', 1);
            buf = READ(fid,'s');
%            while ((strcmp(buf, '}') == 0) && (neof))
            while (strcmp(buf, '}') == 0)
                if (strcmp(buf, 'rootFolderBase') == 1)
                    obj.rootFolderBase = READ(fid,'s');
                elseif (strcmp(buf, 'postFolderName') == 1)
                    obj.postFolderName = READ(fid, 's');
                elseif (strcmp(buf, 'splitConfig') == 1)
                    obj.splitC = obj.splitC.read(fid);
                elseif (strcmp(buf, 'option') == 1)
                    obj.option = READ(fid,'d');
                elseif (strcmp(buf, 'generateTimeHistoryConfigs') == 1)
                    obj.generateTimeHistoryConfigs = READ(fid,'d');
                elseif (strcmp(buf, 'timeHistoryBeginPart') == 1)
                    obj.timeHistoryBeginPart = READ(fid,'s');
                elseif (strcmp(buf, 'timeHistoryEndPart') == 1)
                    obj.timeHistoryEndPart = READ(fid,'s');
                elseif (strcmp(buf, 'timeHistoryOutputFolderRoot') == 1)
                    obj.timeHistoryOutputFolderRoot = READ(fid,'s');
                elseif (strcmp(buf, 'timeHistoryConfigFolderRoot') == 1)
                    obj.timeHistoryConfigFolderRoot = READ(fid,'s');
                elseif (strcmp(buf, 'timeHistoryMatlabScriptName') == 1)
                    obj.timeHistoryMatlabScriptName = READ(fid,'s');
                elseif (strcmp(buf, 'timeHistoryMatlabLogName') == 1)
                    obj.timeHistoryMatlabLogName = READ(fid,'s');
                elseif (strcmp(buf, 'frontConfigFolderRoot') == 1)
                    obj.frontConfigFolderRoot = READ(fid,'s');
                elseif (strcmp(buf, 'frontOutputFolderRoot') == 1)
                    obj.frontOutputFolderRoot = READ(fid,'s');
                elseif (strcmp(buf, 'frontMatlabScriptName') == 1)
                    obj.frontMatlabScriptName = READ(fid,'s');
                elseif (strcmp(buf, 'frontMatlabLogName') == 1)
                    obj.frontMatlabLogName = READ(fid,'s');
                elseif (strcmp(buf, 'frontSubConfigName') == 1)
                    obj.frontSubConfigName = READ(fid,'s');
                elseif (strcmp(buf, 'runSeparatingNames_PlusLatex') == 1)
                   obj.runSeparatingNames = cell(0);
                   obj.runSeparatingNamesLatex = cell(0);
                   cntr = 0;
                   
                   buf = READ(fid,'s');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('invalid format\n');
                    end
                    buf = READ(fid,'s');
        %            while ((strcmp(buf, '}') == 0) && (neof))
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                       obj.runSeparatingNames{cntr} = buf;
                       obj.runSeparatingNamesLatex{cntr} = READ(fid, 's');
                        buf = READ(fid,'s');
                    end
                    obj.num_runSeparating = length(obj.runSeparatingNames);
                elseif (strcmp(buf, 'Runs') == 1)
                   buf = READ(fid,'s');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('invalid format\n');
                    end
                    tmpr = aSDG_runProperties;
                    [tmpr, valid] = tmpr.fromFile(fid);
                    cntr = 0;
                    while (valid)
                        cntr = cntr + 1;
                        obj.runFoldersParameters{cntr} = tmpr;
                        tmpr = aSDG_runProperties;
                        [tmpr, valid] = tmpr.fromFile(fid);
                    end
                   obj.num_runs = cntr;
                elseif (strcmp(buf, 'resultsRoot') == 1)
                    obj.resultsRoot = READ(fid, 's');
                    [status,msg,msgID] = mkdir(obj.resultsRoot);
                    sz = length(obj.resultsRoot);
                    if (obj.resultsRoot(sz) ~= '/')
                        obj.resultsRoot = [obj.resultsRoot, '/'];
                    end
                elseif (strcmp(buf, 'resultsSummaryName') == 1)
                    obj.resultsSummaryName = READ(fid, 's');
                elseif (strcmp(buf, 'summaryFileInclude_criticalPts') == 1)
                    obj.summaryFileInclude_criticalPts = READ(fid, 'd');
                elseif (strcmp(buf, 'summaryFileInclude_lastFrame') == 1)
                    obj.summaryFileInclude_lastFrame = READ(fid, 'd');
                elseif (strcmp(buf, 'copy_front_summary_files') == 1)
                    obj.copy_front_summary_files = READ(fid, 'd');
                elseif (strcmp(buf, 'copy_zpp_files_2_summary_folder') == 1)
                    obj.copy_zpp_files_2_summary_folder = READ(fid, 'd');
                elseif (strcmp(buf, 'copy_pp_files_2_summary_folder') == 1)
                    obj.copy_pp_files_2_summary_folder = READ(fid, 'd');
                elseif (strcmp(buf, 'generate_combined_zpp_files') == 1)
                    obj.generate_combined_zpp_files = READ(fid, 'd');
                elseif (strcmp(buf, 'zpp_generate_IfNeeded') == 1)
                    obj.zpp_generate_IfNeeded = READ(fid, 'd');
                elseif (strcmp(buf, 'zpp_removeInNotHaveIt') == 1)
                    obj.zpp_removeInNotHaveIt = READ(fid, 'd');
                elseif (strcmp(buf, '_configSyncNew') == 1)
                    tmps = READ(fid,'s');
                    if (strcmp(tmps, 'default') == 0)
                        obj.configAllRunsSyncNewFileName_aSDG = tmps;
                        if (strcmp(obj.configAllRunsSyncNewFileName_aSDG, 'direct') == 1)
                            obj.configAllRunsSyncNew_aSDG = obj.configAllRunsSyncNew_aSDG.fromFile(fid);
                        else
                            fidCN = fopen(obj.configAllRunsSyncNewFileName_aSDG, 'r');
                            obj.configAllRunsSyncNew_aSDG = obj.configAllRunsSyncNew_aSDG.fromFile(fidCN);
                            fclose(fidCN);
                        end
                    end
                else
                    buf
                    THROW('Invalid key\n');
                end
                buf = READ(fid, 's');
            end
            fclose(fid);


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            %%%%%% taking care of zpp files
            % -1 even not having the front, 0 not having zpp, 1 has zpp

            runs_zppStatus = zeros(obj.num_runs, 1);
          
            for ri = 1:obj.num_runs
                obj.runFoldersParameters{ri}.physicsFolder = obj.postFolderName;
                obj.runFoldersParameters{ri}.rootFolderBase = obj.rootFolderBase;
                obj.runFoldersParameters{ri} = obj.runFoldersParameters{ri}.Finalize();
                
                zppStatus = obj.runFoldersParameters{ri}.zppFlag;
                runs_zppStatus(ri) = zppStatus;
            end

            % 0 don't work with zpp files
            % 1 uses them if exist, skip a folder if zpp does not exist
            % 2 creates zpp for those that miss zpp
            
            if (obj.zpp_generate_IfNeeded == 1)
                ris_to_Process_zpp = [];
                cntr_zpp = 0;
                for ri = 1:obj.num_runs
                    if (runs_zppStatus(ri) == 0)
                        cntr_zpp = cntr_zpp + 1;
                        ris_to_Process_zpp(cntr_zpp) = ri;
                    end
                end
                fprintf(1, 'Number of runs that need zpp processing\t%d\n', cntr_zpp);
                for k = 1:cntr_zpp
                    ri = ris_to_Process_zpp(k);
                    fprintf(1, 'k = %d, run number = %d, run older = %s\n', k, ri, obj.runFoldersParameters{ri}.runFolder);
                end
                fprintf(1, 'Genering zpps ...\n');
                for k = 1:cntr_zpp
                    ri = ris_to_Process_zpp(k);
                    fprintf(1, 'Processing k = %d, run number = %d, run older = %s\n', k, ri, obj.runFoldersParameters{ri}.runFolder);
                    runFolder = obj.runFoldersParameters{ri}.runFolderComplete;
                    pp1r = pp_synFiles1R;
                    [pp1r, regenBrief, E, nu, planeMode, t0, normalizationsUVSEps, voightStiffness] = ...
                    pp1r.ProcessAllSyncFiles(runFolder, obj.configAllRunsSyncNew_aSDG, obj.runFoldersParameters{ri}.runMap);
                    obj.runFoldersParameters{ri} = obj.runFoldersParameters{ri}.Finalize();

                    regenBrief = 1;
                    zpp1r = zpp_DamageHomogenization1R;
                    zpp1r = zpp1r.Process_zpp_file(obj.configAllRunsSyncNew_aSDG, obj.runFoldersParameters{ri}.runMap, pp1r, ...
                            regenBrief, E, nu, planeMode, t0, normalizationsUVSEps, voightStiffness);
                        
                    runs_zppStatus(ri) = obj.runFoldersParameters{ri}.zppFlag;
                    fclose('all');
%                    close('all');
                end
                fprintf(1, 'zpps files generated, started reading them and processing results ...\n');
            end
            
            if (obj.zpp_removeInNotHaveIt == 1)
                ris_to_remove = [];
                ris_to_keep = [];
                cntr_zpp_remove = 0;
                cntr_zpp_keep = 0;
                for ri = 1:obj.num_runs
                    if (runs_zppStatus(ri) ~= 1)
                        cntr_zpp_remove = cntr_zpp_remove + 1;
                        ris_to_remove(cntr_zpp_remove) = ri;
                    else
                        cntr_zpp_keep = cntr_zpp_keep + 1;
                        ris_to_keep(cntr_zpp_keep) = ri;
                    end
                end
                
                fprintf(1, 'Number of runs that will be removed for not having zpp\t%d\n', cntr_zpp_remove);
                for k = 1:cntr_zpp_remove
                    ri = ris_to_remove(k);
                    fprintf(1, 'k = %d, run number = %d, run older = %s\n', k, ri, obj.runFoldersParameters{ri}.runFolder);
                end
                
                if (cntr_zpp_remove > 0)
                    runFoldersParametersTmp = obj.runFoldersParameters;
                    clear obj.runFoldersParameters;
                    obj.runFoldersParameters = cell(1, cntr_zpp_keep);
                    for i = 1:cntr_zpp_keep
                        ri = ris_to_keep(i);
                        obj.runFoldersParameters{i} = runFoldersParametersTmp{ri};
                    end
                    obj.num_runs = length(obj.runFoldersParameters);
                end
            end
            copy_pp_files = obj.copy_front_summary_files || obj.copy_zpp_files_2_summary_folder || obj.copy_pp_files_2_summary_folder;
            if (copy_pp_files)
                for ri = 1:obj.num_runs
                    runDirPara = obj.runFoldersParameters{ri};
                    zppFlag = runDirPara.zppFlag;
                    if (zppFlag ~= 1)
                        continue;
                    end
                    fldPhysDest = [obj.resultsRoot, runDirPara.runFolder, '/', runDirPara.physicsFolder];
                    fldSrc = runDirPara.runFolderComplete;
                    fldDest = fldPhysDest;
                    [status,msg,msgID] = mkdir(fldDest);
                    if (obj.copy_front_summary_files)
                        files = {'boundingBox.txt', 'front.all', 'front.last', 'frontSync.last'};
                        for k = 1:length(files)
                            fl = files{k};
                            fileSrc = [fldSrc, '/', fl];
                            fileDest = [fldPhysDest, '/', fl];
                            [status,msg,msgID] = copyfile(fileSrc, fileDest);
                        end
                    end
                    fldrFront = runDirPara.front_folder_name;
                    fldSrc = [fldSrc, '/', fldrFront];
                    fldDest = [fldDest, '/', fldrFront];                
                    [status,msg,msgID] = mkdir(fldDest);
                    
                    cntr_f = 0;
                    files = cell(0);
                    if (obj.copy_zpp_files_2_summary_folder)
                        fl = [runDirPara.runName, runDirPara.phyName, runDirPara.midName, 'Sync.zppBSync'];
                        cntr_f = cntr_f + 1;
                        files{cntr_f} = fl;
                    end
                    if (obj.copy_pp_files_2_summary_folder)
                        fl = [runDirPara.runName, runDirPara.phyName, runDirPara.midName, 'Sync.ppBSync'];
                        cntr_f = cntr_f + 1;
                        files{cntr_f} = fl;
                    end
                    for k = 1:length(files)
                        fl = files{k};
                        fileSrc = [fldSrc, '/', fl];
                        fileDest = [fldDest, '/', fl];
                        [status,msg,msgID] = copyfile(fileSrc, fileDest);
                    end
                end
            end
                
            if (obj.num_runs == 0)
                objout = obj;
                return;
            end
            
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % time history part
            
            if (strcmp(obj.timeHistoryConfigFolderRoot, 'none') == 1)
                obj.timeHistoryConfigFolderRoot = '';
            end
            obj.runSeparatingValuesMatrix = zeros(obj.num_runs, obj.num_runSeparating);
            for i = 1:obj.num_runs
                for j = 1:obj.num_runSeparating
                    obj.runSeparatingValuesMatrix(i, j) = obj.runFoldersParameters{i}.values{j};
                end
            end
            obj.splitC = obj.splitC.setDataValues_Names(obj.runSeparatingValuesMatrix, obj.runSeparatingNames, obj.runSeparatingNamesLatex);
            obj.splitC = obj.splitC.finalize_splitters();

            
            cntr = 0;
            fidthe = fopen(obj.timeHistoryEndPart, 'r');
            if (fidthe < 0)
                fprintf('Cannot open timeHistoryEndPart\t%s\n', obj.timeHistoryEndPart);
                THROW('Cannot open file\n');
            end
            str = fgetl(fidthe);
            while ischar(str)
                cntr = cntr + 1;
                obj.timeHistoryEndPartStrings{cntr} = str;
                str = fgetl(fidthe);
            end
            fclose(fidthe);
            
            obj.timeHistoryEndPartStrings_sz = cntr;
            szz = length(obj.timeHistoryOutputFolderRoot);
            [status,msg,msgID] = mkdir(obj.timeHistoryOutputFolderRoot);
            if ((szz > 0) && (obj.timeHistoryOutputFolderRoot(szz) ~= '/'))
                obj.timeHistoryOutputFolderRoot = [obj.timeHistoryOutputFolderRoot, '/'];
            end
            szz = length(obj.timeHistoryConfigFolderRoot);
            [status,msg,msgID] = mkdir(obj.timeHistoryConfigFolderRoot);
            if ((szz > 0) && (obj.timeHistoryConfigFolderRoot(szz) ~= '/'))
                obj.timeHistoryConfigFolderRoot = [obj.timeHistoryConfigFolderRoot, '/'];
            end

            szz = length(obj.frontConfigFolderRoot);
            [status,msg,msgID] = mkdir(obj.frontConfigFolderRoot);
            if ((szz > 0) && (obj.frontConfigFolderRoot(szz) ~= '/'))
                obj.frontConfigFolderRoot = [obj.frontConfigFolderRoot, '/'];
            end
            
            szz = length(obj.frontOutputFolderRoot);
            [status,msg,msgID] = mkdir(obj.frontOutputFolderRoot);
            if ((szz > 0) && (obj.frontOutputFolderRoot(szz) ~= '/'))
                obj.frontOutputFolderRoot = [obj.frontOutputFolderRoot, '/'];
            end

            szz = length(obj.frontMatlabScriptName);
            [status,msg,msgID] = mkdir(obj.frontMatlabScriptName);
            if ((szz > 0) && (obj.frontMatlabScriptName(szz) ~= '/'))
                obj.frontMatlabScriptName = [obj.frontMatlabScriptName, '/'];
            end
            
            obj.timeHistoryMatlabScriptName	= [obj.timeHistoryConfigFolderRoot, obj.timeHistoryMatlabScriptName];
            obj.timeHistoryMatlabLogName	= [obj.timeHistoryConfigFolderRoot, obj.timeHistoryMatlabLogName];
            
            objout = obj;
        end

        function objout = Process(obj)

            snp = 0;
            numSplitModes = length(obj.splitC.breaker1Louts);
            if (obj.generateTimeHistoryConfigs > 0)
                %%% generating config files for time history comparisons
                fidLogTH = fopen([obj.timeHistoryMatlabLogName, '.log'], 'w');
                for splitM = 1:numSplitModes

                    nmTmp = [obj.timeHistoryMatlabScriptName, '_split_', num2str(splitM)];
                    fidscriptTH = fopen([nmTmp, '.m'], 'w');
                    nameLast = [nmTmp, '.last'];
                    fidLastTH = fopen(nameLast, 'w');
                    fprintf(fidLastTH, '-1\n');
                    fclose(fidLastTH);
                    
                    openFileMsg1 = ['fidl = fopen(''', nameLast, ''', ''r'');'];
                    openFileMsg2 = 'lastSuccessful = fscanf(fidl, ''%d'', 1);';
                    fprintf(fidscriptTH, '%s\n', openFileMsg1);
                    fprintf(fidscriptTH, '%s\n', openFileMsg2);
                    fprintf(fidscriptTH, 'fclose(fidl);');
                    fprintf(fidscriptTH, '\n');
                    cntrInst = 0;
                    
                    outer = obj.splitC.breaker1Louts{splitM};
                    numLeaves = outer.numLeaves;
                    for leaveO = 1:numLeaves
                        splitOut = obj.splitC.breaker1Louts{splitM}.leaves{leaveO};
                        nameCombined = splitOut.nameCombined;
                        nameFileMain = [num2str(splitM), '_', nameCombined];
                        nameFile = ['Config_split_', nameFileMain, '.vconfig'];
                        namePltFolder = ['output_plots_', nameFileMain];

                        nameFile = [obj.timeHistoryConfigFolderRoot, nameFile];
                        namePltFolder = [obj.timeHistoryOutputFolderRoot, namePltFolder];
                
                        msg1 = ['if (lastSuccessful < ', num2str(cntrInst), ')'];
                        fprintf(fidscriptTH, '%s\n', msg1);
                
                        cmnd = ['plotVDS(''', nameFile, ''', ''', namePltFolder, ''');'];
                        fprintf(fidscriptTH, '\t');
                        fprintf(fidscriptTH, '%s\n', cmnd);

                        
                        openFileMsg1 = ['fidl = fopen(''', nameLast, ''', ''w'');'];
                        openFileMsg2 = ['fprintf(fidl, ''', num2str(cntrInst), ''');'];
                        openFileMsg3 = 'fprintf(fidl, ''\n'');';
                        fprintf(fidscriptTH, '\t');
                        fprintf(fidscriptTH, '%s\n', openFileMsg1);
                        fprintf(fidscriptTH, '\t');
                        fprintf(fidscriptTH, '%s\n', openFileMsg2);
                        fprintf(fidscriptTH, '\t');
                        fprintf(fidscriptTH, '%s\n', openFileMsg3);
                        fprintf(fidscriptTH, '\t');
                        fprintf(fidscriptTH, 'fclose(fidl);\n');

                        fprintf(fidscriptTH, '\t');
 %                       fprintf(fidscriptTH, 'fclose(''all'');\n');
 %                       fprintf(fidscriptTH, '\t');
                        fprintf(fidscriptTH, 'close(''all'');\n');
                        fprintf(fidscriptTH, 'end\n');
                        
                        cntrInst = cntrInst + 1;

    %                    nameCombinedLatex = splitOut.nameCombinedLatex;
                        numLeavesIn = splitOut.numLeaves;
                        folders = cell(0);
                        legs = cell(0);
                        cntr = 0;
                        for leaveI = 1:numLeavesIn
                            splitIn = splitOut.leaves{leaveI};
                            dataInds = splitIn.dataIndices;
                            for p = 1:length(dataInds)
                                k = dataInds(p);
                                folder = obj.runFoldersParameters{k}.runFolder;
    %                            leg = splitOut.nameCombined;
                                leg = splitIn.nameCombinedLatex;
                                cntr = cntr + 1;
                                legs{cntr} = leg;
                                folders{cntr} = folder;
                            end
                        end
                        [status,msg,msgID] = copyfile(obj.timeHistoryBeginPart, nameFile);
                        fidVCConfig = fopen(nameFile, 'a');

                        fprintf(fidLogTH, 'nameFile\t%s\n', nameFile);
                        fprintf(fidLogTH, 'namePltFolder\t%s\n', namePltFolder);
                        szz = length(folders);
                        fprintf(fidLogTH, 'sz\t%d\n{\n', szz);
                        for ii = 1:szz
                            fprintf(fidLogTH, '\t%s\t{%s}\t{ ms s ls - }\n', folders{ii}, legs{ii});
                        end
                        fprintf(fidLogTH, '}\n');

                        % vc config
                        fprintf(fidVCConfig, '\n{\n');
                        for ii = 1:szz
                            fprintf(fidVCConfig, '\t%s\t{%s}\t{ ms s ls - }\n', folders{ii}, legs{ii});
                        end
                        fprintf(fidVCConfig, '}\n');

                        for mm = 1:obj.timeHistoryEndPartStrings_sz
                            fprintf(fidVCConfig, '%s\n', obj.timeHistoryEndPartStrings{mm});
                        end
                        fclose(fidVCConfig);
                    end
                    fclose(fidscriptTH);
                end
                fclose(fidLogTH);
            end
            
            
            % dealing with front / front sync configs
            stNamesNum = 0:10;
            for mm = 1:length(stNamesNum)
                stNamesStr{mm} = ['st', num2str(stNamesNum(mm) - 1)];
            end
            for splitM = 1:numSplitModes
                outer = obj.splitC.breaker1Louts{splitM};
                numLeaves = outer.numLeaves;
                for leaveO = 1:numLeaves
                    splitOut = obj.splitC.breaker1Louts{splitM}.leaves{leaveO};
                    nameCombined = splitOut.nameCombined;
                    nameCombinedLatex = splitOut.nameCombinedLatex;
                    numLeavesIn = splitOut.numLeaves;

                    frConf = aSDG_front_sync_plotConfig;
                    frConf.subConfigName = obj.frontSubConfigName;
                    frConf.splitName = ['split_', num2str(splitM)];
                    frConf.outerName = nameCombined;
                    frConf.outerNameLatex = nameCombinedLatex;

                    frConf.stageNames = stNamesStr;
                    numStage = length(stNamesStr);
                    spltOuter = [frConf.splitName, ',' ,frConf.outerName];
                    frConf.configFileNameWOStage_root = obj.frontConfigFolderRoot;
                    frConf.configFileNameWOStage = spltOuter;
                    frConf.outputFolderNameWOStage_root = obj.frontOutputFolderRoot;
                    frConf.outputFolderNameWOStage = spltOuter;
                    frConf.stageData = cell(numStage, 1);
                    for zz = 1:numStage
                        frConf.stageData{zz} = aSDG_front_sync_plot_1stage_Config;
                    end

                    frConf.splitNo = splitM;
                    frConf.outerNo = leaveO;
                    frConf.numInner = numLeavesIn;
                    
                    frConf.innerFolders = cell(numLeavesIn, 1);
                    frConf.innerLabels = cell(numLeavesIn, 1);
                    frConf.innerLabelsLatex = cell(numLeavesIn, 1);
                    frConf.activeStagesCount = zeros(length(frConf.stageNames), 1);
                        
                    cntrTmp = 0;
                    for leaveI = 1:numLeavesIn
                        splitIn = splitOut.leaves{leaveI};
                        dataInds = splitIn.dataIndices;
                        for p = 1:length(dataInds) 
                            k = dataInds(p);
                            cntrTmp = cntrTmp + 1;
                            frConf.runNumber2Pos(k) = cntrTmp;
                            frConf.pos2runNumber(cntrTmp) = k;
                            folder = obj.runFoldersParameters{k}.runFolder;
                            leg = splitIn.nameCombinedLatex;
                            frConf.innerFolders{leaveI} = folder;
                            frConf.innerLabelsLatex{leaveI} = leg;
                            frConf.innerLabels{leaveI} = splitIn.nameCombined;
                        end
                    end
%                   [status,msg,msgID] = copyfile(obj.timeHistoryBeginPart, nameFile);
                    obj.frontConfigs{splitM}{leaveO} = frConf;
                end
            end
                    
            
            if (obj.generateTimeHistoryConfigs == 2)
                objout = obj;
                return;
            end
            
            hasSummaryFile = (strcmp(obj.resultsSummaryName, 'none') == 0);
            summaryFile = '';

            stage_split_configFiles = cell(0);
            
            for ri = 1:obj.num_runs
                runFolder = obj.runFoldersParameters{ri}.runFolderComplete;
                fprintf(1, 'processing run %d/%d\t%s\n', ri, obj.num_runs, obj.runFoldersParameters{ri}.runFolder); 
                asdg_sum = aSDG_old_run_summary1R;
                
                combine_zpp_ene_file_name = '';
                if (obj.generate_combined_zpp_files)
                    fldrFront = obj.runFoldersParameters{ri}.front_folder_name;
                    zpp_ene_Folder = [obj.resultsRoot, obj.runFoldersParameters{ri}.runFolder, '/', obj.runFoldersParameters{ri}.physicsFolder, '/', fldrFront];
                    combine_zpp_ene_file_name = [zpp_ene_Folder, '/', 'zpp_ene.all']; 
                end
                asdg_sum = asdg_sum.Process_aSDG_old_run_summary1R(runFolder, obj.option, obj.generate_combined_zpp_files, combine_zpp_ene_file_name);
                if (obj.generate_combined_zpp_files)
                    destFolder = [obj.runFoldersParameters{ri}.runFolderComplete, '/', fldrFront];
                    combine_zpp_ene_file_name_dest = [destFolder, '/', 'zpp_ene.all']; 
                    [status,msg,msgID] = copyfile(combine_zpp_ene_file_name, combine_zpp_ene_file_name_dest);
                end
                
                cpNums = [];
                cntr = 0;
                numCP = asdg_sum.cpt_numPts;

                if (obj.summaryFileInclude_criticalPts)
                    for i = numCP:-1:2
                        vld = asdg_sum.cpt_valid(i);
                        if (vld)
                            cntr = cntr + 1;
                            cpNums(cntr) = i;
                        end
                    end
                end
                if (obj.summaryFileInclude_lastFrame)
                    vld = asdg_sum.cpt_valid(1);
                    if (vld)
                        cntr = cntr + 1;
                        cpNums(cntr) = 1;
                    end
                end
                numStages = cntr;
                
                
                %%%%%%%%%%% taking care of front, front sync files
                front_szOut = obj.splitC.serialNo2_sz(ri);
                front_splitSchemes = obj.splitC.serialNo2_outerScemeNo{ri};
                front_outerNums = obj.splitC.serialNo2_outer_No{ri};
                for ii = 1:front_szOut
                    splitM = front_splitSchemes(ii);
                    leaveO = front_outerNums(ii);
                    frConf = obj.frontConfigs{splitM}{leaveO};

                    folderName = obj.runFoldersParameters{ri}.runFolder;
                    pos = frConf.runNumber2Pos(ri);
                    folderFieldsNameCombinedTmp = frConf.innerLabels{pos};
                    folderFieldsNameCombinedLatexTmp = frConf.innerLabelsLatex{pos};
                    
                    for si = 1:numStages
                        st = cpNums(si);
                        stNameLatex = ['\mathrm{st}=', num2str(st - 1), ','];
                        stName = ['st', num2str(st - 1), ',']; 
                        folderFieldsNameCombined = [stName, folderFieldsNameCombinedTmp];
                        folderFieldsNameCombinedLatex = [stNameLatex, folderFieldsNameCombinedLatexTmp];

                        syncNo = asdg_sum.cpt_sync_sn(st);
                        frontNo = asdg_sum.cpt_patch_sn(st);
                        time = asdg_sum.cpt_times(st);
                        timeMin = asdg_sum.criticalPtSummaryData{st}.timeMin_front;
                        timeMax = asdg_sum.criticalPtSummaryData{st}.timeMax_front;
                        
                        frConf.stageData{st} = frConf.stageData{st}.Updata(syncNo, frontNo, folderName, folderFieldsNameCombined, folderFieldsNameCombinedLatex, time, timeMin, timeMax);
                        [firstFile, configName] = frConf.PrintStage(st);
                        if (firstFile)
                            if (length(stage_split_configFiles) < st)
                                stage_split_configFiles{st} = cell(0);
                            end
                            if (length(stage_split_configFiles{st}) < splitM)
                                stage_split_configFiles{st}{splitM} = cell(0);
                            end
                            sztmp = length(stage_split_configFiles{st}{splitM});
                            stage_split_configFiles{st}{splitM}{sztmp + 1} = configName;
                        end
                    end
                    obj.frontConfigs{splitM}{leaveO} = frConf;
                end
                obj.frontConfigs{splitM}{leaveO} = frConf;
            

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % summary number of points
                if (ri == 1)
                    [scalarNames, scalarNamesLatex] = asdg_sum.get_cp_Names(obj.runSeparatingNames, obj.runSeparatingNamesLatex);

                    if (hasSummaryFile)
                        obj.summaryData.nameXAxes = 't';
                        obj.summaryData.dataNamexLatex = 't';
                        obj.summaryData.dataNameSerialLatex = 'n';
                        obj.summaryData.treatAllAsCell = 1;

                        obj.summaryData.sepDataLocs = 1:obj.num_runSeparating;

                        numDataSets = length(scalarNames);
                        obj.summaryData.data = cell(numDataSets, 1);
                        obj.summaryData.dataOrders = zeros(numDataSets, 1);
                        obj.summaryData.numDataSets = numDataSets;
                        obj.summaryData.dataNames = scalarNames;
                        obj.summaryData.dataNamesLatex = scalarNamesLatex;
                    end
                end                    

                if (hasSummaryFile)
                    for sti = 1:numStages
                        stage = cpNums(sti);
                        snp = snp + 1;
                        [scalarValues, vld] = asdg_sum.get_cp_Values(stage, obj.runFoldersParameters{ri}.values);
                        
                        for fld = 1:numDataSets
                            obj.summaryData.data{fld}{snp} = scalarValues{fld};
                        end
                        obj.summaryData.xAxesVals(snp) = asdg_sum.cpt_times(stage);
                    end
                end
            end

            len_st = length(stage_split_configFiles);
            commandName = 'MAINplotAUTOSEVERALRunSpaceMeshSCRIPT';
            for st = 1:len_st
                len_split = length(stage_split_configFiles{st});
                stName = ['st', num2str(st - 1)]; 
                for splitM = 1:len_split
                    splitName = ['_split_', num2str(splitM)];
                    fileName_scriptWOExt = [obj.frontMatlabScriptName, stName, splitName];
%                    len_files = stage_split_configFiles{st}{splitM}{sztmp + 1}
                    gen_create_command_script(fileName_scriptWOExt, commandName, stage_split_configFiles{st}{splitM});
                end
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % summary files
            if (hasSummaryFile)
            	obj.summaryData.numPts = snp;
                summaryFile = [obj.resultsRoot, obj.resultsSummaryName];
                fidsum = fopen(summaryFile, 'w');
                obj.summaryData.toFile(fidsum);
                fclose(fidsum);
            end
   
            
            objout = obj;
        end

        function objout = MAIN(obj, configName)
            obj = obj.fromFile(configName);
            objout = obj.Process();
        end
    end
end