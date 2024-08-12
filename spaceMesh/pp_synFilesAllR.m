classdef pp_synFilesAllR % all runs
    properties
        % there are 3 levels of computation: 1. Base (sync processed), 2.
        % Brief (fields that are asked to be computed), 3. post-process of
        % brief -> homogenized damage value, energy dissipation, ...
        % level 1:
        extCompleteFile = 'ppSync';

        % level 2
        briefFileExt = 'ppBSync';
        % options: header ext = 'none': names printed for every single pt,
        % == 'same' : names are printed in the same file
        % other: header printed in a separate file
        briefFileExtHeader = 'ppBSyncHeader';
        
        % level 3: added to data in level 2 files: it includes dissipation,
        % homogenized damage, etc. that are computed from already existing
        % files
        
        % for each data set there are two booleans: A) Whether it's needed
        % or not; B) whether it should be regenerated (if files already
        % exist)
        % group B
        regenerateBaseFile = 0;
        regenerateBriefFile = 0;
        
        % group A that will be decided based on fields needing computation
        needBriefFile = 0;
        % this needs data from Brief file that are processed again (for
        % example homogenized damage from sigma-epsilon, ...)
        needBriefPPData = 0;
        
        bbFile = 'boundingBox.txt';
        nonzeroSlnTimeZero = -1; % some runs start from nonzero IC, this flag = 0 means IC is zero, 1 -> it's 1, -1 means it's not determined
        
        % step size between 0-1 for scalar values
        step4ScalarCDFs = 0.1;
        % numAngleRanges pp_energyDispInterior's are generated wach one
        % containing angles between 0-180
        numAngleRanges = 18;
        
        % within each run, how many crack angle bins are created for
        % calculating PDFs within them
        crackBinSize = 180;
        newNormalizationsUVSEps = [];
        
        % what fields to print in summary files
        % zpr are all things computed from base file
        % zpp are all things computed from pp file
%        fld2printInBriefRaw = {'zpr_stssh_xx', 'zpr_stssh_yy', 'zpr_stssh_xy', 'zpr_stnst_xx', 'zpr_stnst_yy', 'zpr_stnst_xy', 'zpr_fraca_angle_stat_len_mean', 'zpr_fraca_angle_stat_len_r'};
% names start with 
%   zpr
        fld2printInBriefRaw = cell(0);
        fld2printInBriefRawLatexName = cell(0);

% names start with 
%   zpp
        fld2printInBriefPP = cell(0);
        fld2printInBriefPPLatexName = cell(0);
        
        frontFileName = 'frontSync';

%%% processed data (damage homogenized, ...)
        bProcess_zpp_data = 0; % boolean, specifying if this should be done
        zppConfig = zpp_DamageHomogenization1RConfig;
    
    end
    methods
        function objout = fromFile(obj, fid)
            buf = READ(fid,'s');
            if (strcmp(buf, '{') == 0)
                buf
                THROW('invalid format\n');
            end
%            [buf, neof] = fscanf(fid, '%s', 1);
            buf = READ(fid,'s');
%            while ((strcmp(buf, '}') == 0) && (neof))
            while (strcmp(buf, '}') == 0)
                if (strcmp(buf, 'frontFileName') == 1)
                    obj.frontFileName = READ(fid,'s');
                elseif (strcmp(buf, 'bbFile') == 1)
                    obj.bbFile = READ(fid,'s');
               elseif (strcmp(buf, 'regenerateBaseFile') == 1)
                    obj.regenerateBaseFile = READ(fid,'d');
               elseif (strcmp(buf, 'regenerateBriefFile') == 1)
                    obj.regenerateBriefFile = READ(fid,'d');
                elseif (strcmp(buf, 'extCompleteFile') == 1)
                    obj.extCompleteFile = READ(fid,'s');
                elseif (strcmp(buf, 'briefFileExt') == 1)
                    obj.briefFileExt = READ(fid,'s');
                elseif (strcmp(buf, 'briefFileExtHeader') == 1)
                    obj.briefFileExtHeader = READ(fid,'s');
                elseif (strcmp(buf, 'briefFileExtHeader') == 1)
                    obj.briefFileExtHeader = READ(fid,'d');
                elseif (strcmp(buf, 'step4ScalarCDFs') == 1)
                    obj.step4ScalarCDFs = READ(fid,'g');
                elseif (strcmp(buf, 'numAngleRanges') == 1)
                    obj.numAngleRanges = READ(fid,'d');
                elseif (strcmp(buf, 'nonzeroSlnTimeZero') == 1)
                    obj.nonzeroSlnTimeZero = READ(fid,'d');
                elseif (strcmp(buf, 'crackBinSize') == 1)
                    obj.crackBinSize = READ(fid,'d');
                elseif (strcmp(buf, 'newNormalizationsUVSEps') == 1)
                    buf2 = READ(fid,'s');
                    if (strcmp(buf2, '{') == 0)
                        buf2
                        THROW('invalid format\n');
                    end
                    cntr = 0;
                    buf2 = READ(fid,'s');
                    while (strcmp(buf2, '}') == 0)
                        cntr = cntr + 1;
                        obj.newNormalizationsUVSEps(cntr) = str2num(buf2);
                        buf2 = READ(fid,'s');
                    end
                elseif ((strcmp(buf, 'fld2printInBriefRaw') == 1) || (strcmp(buf, 'fld2printInBrief_zpr') == 1))
                    buf2 = READ(fid,'s');
                    if (strcmp(buf2, '{') == 0)
                        buf2
                        THROW('invalid format\n');
                    end
        %            [buf, neof] = fscanf(fid, '%s', 1);
                    offset = length(obj.fld2printInBriefRaw);
                    cntr = 0;
                    buf2 = READ(fid,'s');
                    while (strcmp(buf2, '}') == 0)
                            latexName = READ(fid,'s');
%                        if (strncmp(buf2, 'zpr', 3) == 1)
                            add = 1;
                            for j = 1:length(obj.fld2printInBriefRaw)
                                if (strcmp(obj.fld2printInBriefRaw{j}, buf2) == 1)
                                    add = 0;
                                    break;
                                end
                            end
                            if (add)
                                cntr = cntr + 1;
                                obj.fld2printInBriefRaw{cntr + offset} = lower(buf2);
                                obj.fld2printInBriefRawLatexName{cntr + offset} = latexName;
                            end
 %                       end
                        buf2 = READ(fid,'s');
                    end
                elseif ((strcmp(buf, 'fld2printInBriefPP') == 1) || (strcmp(buf, 'fld2printInBrief_zpp') == 1))
                    buf2 = READ(fid,'s');
                    if (strcmp(buf2, '{') == 0)
                        buf2
                        THROW('invalid format\n');
                    end
        %            [buf, neof] = fscanf(fid, '%s', 1);
                    offset = length(obj.fld2printInBriefPP);
                    cntr = 0;
                    buf2 = READ(fid,'s');
                    while (strcmp(buf2, '}') == 0)
                            latexName = READ(fid,'s');
%                        if (strncmp(buf2, 'zpr', 3) == 1)
                            add = 1;
                            for j = 1:length(obj.fld2printInBriefPP)
                                if (strcmp(obj.fld2printInBriefPP{j}, buf2) == 1)
                                    add = 0;
                                    break;
                                end
                            end
                            if (add)
                                cntr = cntr + 1;
                                obj.fld2printInBriefPP{cntr + offset} = lower(buf2);
                                obj.fld2printInBriefPPLatexName{cntr + offset} = latexName;
                            end
 %                       end
                        buf2 = READ(fid,'s');
                    end
                elseif (strcmp(buf, 'zppConfig') == 1)
                    obj.bProcess_zpp_data = READ(fid, 's');
                    obj.zppConfig = obj.zppConfig.Read(fid);
                else
                    buf
                    THROW('Invalid key\n');
                end
                buf = READ(fid, 's');
            end
            
            for k = 1:2
                if (k == 1)
                    addedFlds = obj.zppConfig.rawDataDamageNames;
                else
                    addedFlds = obj.zppConfig.rawData2IntegrateInTimeNames;
                end
                sz = length(addedFlds);
                cntr = length(obj.fld2printInBriefRaw);
                add = 1;
                for i = 1:sz
                    buf2 = addedFlds{i};
                    for j = 1:length(obj.fld2printInBriefRaw)
                        if (strcmp(obj.fld2printInBriefRaw{j}, buf2) == 1)
                            add = 0;
                            break;
                        end
                    end
                    if (add)
                        fldNeededInRaw = buf2
                        THROW('Add fldNeededInRaw in fld2printInBriefRaw in pp config file\n');
                    end
                end
            end
            
            for k = 1:2
                if (k == 1)
                    addedFlds = obj.zppConfig.rawDataDamageNames;
                else
                    addedFlds = obj.zppConfig.rawData2IntegrateInTimeNames;
                end
                sz = length(addedFlds);
                cntr = length(obj.fld2printInBriefPP);
                add = 1;
                for i = 1:sz
                    buf2 = addedFlds{i};
                    for j = 1:length(obj.fld2printInBriefPP)
                        if (strcmp(obj.fld2printInBriefPP{j}, buf2) == 1)
                            add = 0;
                            break;
                        end
                    end
                    if (add)
                        nm_zpr = addedFlds{i}; 
                        fndIndex = -1;
                        for j = 1:length(obj.fld2printInBriefRaw)
                            if (strcmp(obj.fld2printInBriefRaw{j}, nm_zpr) == 1)
                                fndIndex = j;
                                break;
                            end
                        end
                        if (fndIndex >= 0)
                            loc =  length(obj.fld2printInBriefPP) + 1;
                            nmzpp = strrep(addedFlds{i}, 'zpr', 'zppr');
                            obj.fld2printInBriefPP{loc} = nmzpp; %obj.fld2printInBriefRaw{fndIndex};
                            obj.fld2printInBriefPPLatexName{loc} = obj.fld2printInBriefRawLatexName{fndIndex};
                        end
                    end
                end
            end
            objout = obj;
        end
    end
end
