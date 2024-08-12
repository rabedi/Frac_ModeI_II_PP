classdef aSDG_front_sync_plotConfig
    properties
        subConfigName = 'ConfigSampleDMicro.txt';
        splitName;
        outerName;
        outerNameLatex;
        innerFolders;
        innerLabels;
        innerLabelsLatex;
        stageNames;
        configFileNameWOStage_root;
        configFileNameWOStage;
        outputFolderNameWOStage_root;
        outputFolderNameWOStage;
        runsOutputNamesWOStage;

        stageData;
        %aSDG_front_sync_plot_1stage_Config

        splitNo;
        outerNo;
        numInner;
        numStages;
        % how many entries are added for a given stage
        activeStagesCount;
        

        runNumber2Pos;
        pos2runNumber;
        
        % with numStages
        fids;
        front_pns;
        front_sync_ns;
    end
    methods 
        function [firstFile, configName] = PrintStage(obj, st)
            stname = ['st', num2str(st - 1), '_'];
            configName = [obj.configFileNameWOStage_root, 'FrontConfig_', stname, obj.configFileNameWOStage, '.txt'];
            outputFolder = [obj.outputFolderNameWOStage_root, stname, obj.outputFolderNameWOStage];
            
            fidc = fopen(configName, 'w');
            fprintf(fidc, 'version 1\n');
            fprintf(fidc, 'outputFolder\t%s\n', outputFolder);
            fprintf(fidc, 'runPreName:		{ ../../.. } \n');
            fprintf(fidc, 'BaseConfigName:		%s\n', obj.subConfigName);
            fprintf(fidc, 'start>>\n');
            printFolderNameCombined = 1;
            printFolderNameCombinedLatex = 1;
            printTime = 1;
            obj.stageData{st}.Print(fidc, printFolderNameCombined, printFolderNameCombinedLatex, printTime);
            firstFile = (obj.stageData{st}.num == 1);
            fprintf(fidc, 'end\n');
            fclose(fidc);
        end
    end
end