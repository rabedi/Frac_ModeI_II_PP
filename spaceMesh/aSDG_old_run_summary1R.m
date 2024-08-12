classdef aSDG_old_run_summary1R
    properties
        rootFolder;         
        option;

        % all run statistics

        cpt_numPts; % number of critical points (6 aSDG, >= 4 in general)
        cpt_valid;  %boolean, if valid or not 0, 1 i
        cpt_indices; % if nan it's invalid
        cpt_times; % if nan it's invalid
        cpt_patch_sn; % serial number for patches at this instant
        cpt_sync_sn;  % serial number for sync files
        
        % zpp (e.g. damage homogenized)
        cpt_numFlds_zpp; % number of fields stored in cpts 
        cpt_nameFlds_zpp;
        cpt_nameFlds_zpp_latex;
        
        % zpr (raw data)
        cpt_numFlds_zpr; % number of fields stored in cpts
        cpt_nameFlds_zpr;
        cpt_nameFlds_zpr_latex;

        %%%% measures of energy and brittleness
        cpt_Matrix_zpp;
        phi_t_final = nan;
        num_ini = 1; % number of initiation stages
        % for different initiation stages, computes ratio of initiation
        % value to max point value
        ti_tms = nan;
        epsi_epsms = nan;
        sigi_sigms = nan;
        % energy total i stage to max stage
        psiti_psitms = nan;
        % energy recoverable to total energy for initiation stages 
        psiri_psitis = nan;

        namesDamageIni;
        namesDamageIniLatex;
        
        % 0 corresponds to the point where load gets to zero
        tm_t0 = nan;
        epsm_eps0 = nan;
        psim_psi0 = nan;
        % energy recoverable to total energy for max stage
        psirm_psitm = nan;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% where summaries for critical points is saved
        % total energy
        
        
        criticalPtSummaryData = cell(0);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        runName; % e.g. Micro
        phy = 'SL';
        runNamePPhy; % last two together
        front_folderBase = 'output_front';
        front_FolderFull;
        
        fcFront;
        fcSync;
        zppDatBase;
    end
    methods
        function objout = Process_aSDG_old_run_summary1R(obj, rootFolderIn, opionIn, generateCombined_zpp_ene, combine_zpp_ene_file_name)
            obj.rootFolder = rootFolderIn;
            obj.option = opionIn;
            
            nameFrontAll = [obj.rootFolder, '/front.all'];
            nameFrontSyncAll = [obj.rootFolder, '/frontSync.all'];

            % front file 
            obj.fcFront = frontClass();
            fid = fopen(nameFrontAll,'r');
            if fid < 1
               msg = sprintf('File [%s] not open for read.\n', nameFrontAll); 
               THROW(msg);
            end
            obj.fcFront.readAll(fid);
            fclose(fid);

            % front sync 
            obj.fcSync = frontClass();
            fid = fopen(nameFrontSyncAll,'r');
            if fid < 1
               msg = sprintf('File [%s] not open for read.\n', nameFrontSyncAll); 
               THROW(msg);
            end
            obj.fcSync.readAll(fid);
            fclose(fid);

            obj.runName = obj.fcFront.fronts{1}.runName;
            obj.phy = obj.fcFront.fronts{1}.phy;
            obj.runNamePPhy = [obj.runName, obj.phy];
            obj.front_folderBase = obj.fcFront.fronts{1}.folder;
            
            root = '';
            szroot = length(obj.rootFolder);
            if ((szroot > 0) && (obj.rootFolder(szroot) ~= '/'))
                root = [obj.rootFolder, '/'];
            end
            obj.rootFolder = root;
            
            obj.front_FolderFull = [root, obj.front_folderBase];

            obj.zppDatBase = zpp_DamageHomogenization1R;
            zppFileName = [obj.front_FolderFull, '/', obj.runNamePPhy, 'frontSync.zppBSync'];
            fid = fopen(zppFileName, 'r');
            
            if fid < 1
               msg = sprintf('zpp File not generated! [%s] not open for read.\n', zppFileName); 
               THROW(msg);
            end
            obj.zppDatBase = obj.zppDatBase.fromFile(fid);
            fclose(fid);
            obj.cpt_numPts = obj.cpt_numPts + 1;

            obj.criticalPtSummaryData = cell(obj.cpt_numPts, 1);
            
            obj.cpt_numPts = obj.zppDatBase.cpt_numPts + 1;
            obj.cpt_valid = zeros(obj.cpt_numPts, 1);
            obj.cpt_indices = nan * ones(obj.cpt_numPts, 1);
            obj.cpt_times = nan * ones(obj.cpt_numPts, 1);
            obj.cpt_nameFlds_zpp = obj.zppDatBase.cpt_pData.dataNames;
            obj.cpt_nameFlds_zpp_latex = obj.zppDatBase.cpt_pData.dataNamesLatex;
            if (length(obj.cpt_nameFlds_zpp_latex) == 0)
                obj.cpt_nameFlds_zpp_latex = aSDG_zpp_name_to_latexName(obj.cpt_nameFlds_zpp);
            end
            obj.cpt_numFlds_zpp = length(obj.cpt_nameFlds_zpp);
   
            obj.cpt_nameFlds_zpr = obj.zppDatBase.cpt_rawData.dataNames;
            obj.cpt_nameFlds_zpr_latex = obj.zppDatBase.cpt_rawData.dataNamesLatex;
            if (length(obj.cpt_nameFlds_zpr_latex) == 0)
                obj.cpt_nameFlds_zpr_latex = aSDG_zpr_name_to_latexName(obj.cpt_nameFlds_zpr);
            end
            obj.cpt_numFlds_zpr = length(obj.cpt_nameFlds_zpr);

            obj.cpt_patch_sn = nan * ones(obj.cpt_numPts, 1);
            obj.cpt_sync_sn = nan * ones(obj.cpt_numPts, 1);
            
            
            for cp = 0:obj.cpt_numPts - 1
                if (cp == 0)
                    ind = obj.fcSync.numFiles;
                    tm = obj.fcSync.times(ind);
                else
                    ind = obj.zppDatBase.cpt_indices(cp);
                    tm = obj.zppDatBase.summaryCriticalTimes_pData(cp);
                end
                [tmp1cp, vld] = obj.get_aSDG_old_run_summary1R1cp(cp, ind, tm);
                cpind = cp + 1;

                obj.cpt_indices(cpind) = ind;
                obj.cpt_patch_sn(cpind) = tmp1cp.cpDatFront.sn;
                obj.cpt_sync_sn(cpind) =  tmp1cp.cpDatSyncFront.sn;
                obj.cpt_valid(cpind) = vld;
                obj.criticalPtSummaryData{cpind} = tmp1cp;
                obj.cpt_times(cpind) = tm;
            end
            
            % computing energy and brittleness related members
            obj.cpt_Matrix_zpp = obj.zppDatBase.summaryCriticalVals_pData;
            obj.phi_t_final = obj.zppDatBase.phi_t_final;
            offset = 3 + 1; % 1 is added for last solution frame (others are 0, final, m)
            obj.num_ini = obj.cpt_numPts - offset;
            obj.namesDamageIni = cell(obj.num_ini, 1);
            obj.namesDamageIniLatex = cell(obj.num_ini, 1);
            if (obj.num_ini > 0)
                obj.namesDamageIni{1} = 'zpp_D';
                obj.namesDamageIniLatex{1} = 'D';
            end
            for k = 2:obj.num_ini
                kk = k - 1;
                tmpn = obj.zppDatBase.rawDataDamageNames{kk};
                obj.namesDamageIni{k} = tmpn;
                obj.namesDamageIniLatex{k} = tmpn;
                if (strcmp(tmpn, 'zpr_dcracklength') == 1)
                    obj.namesDamageIniLatex{k} = 'D_l';
                elseif (strcmp(tmpn, 'zpr_stn_rel') == 1)
                    obj.namesDamageIniLatex{k} = 'D_\epsilon';
                end
            end

            nantmp = nan * ones(obj.num_ini, 1);
            obj.ti_tms = nantmp;
            obj.epsi_epsms = nantmp;
            obj.sigi_sigms = nantmp;
            obj.psiti_psitms = nantmp;
            obj.psiri_psitis = nantmp;

            ind = offset;
            vldmx = obj.cpt_valid(ind);
            
            if (vldmx)
                time_orsv_ind = 2;      % time (dynamic) of load number (quasi-static) problems
                eps_scalar_ind = 3;     % epsilon scalar
                sig_scalar_ind = 4;     % sigma scalar
                psi_t_ind = 8;          % toal area under sigma eps
                psi_r_ind = 9;          % recoverable part of the energy (0.5 sigma: D sigma)

                % getting max values
                indmat = ind - 1; % one is subtracted as last frame is added
                tm_m = obj.cpt_Matrix_zpp(indmat, time_orsv_ind);
                eps_m = obj.cpt_Matrix_zpp(indmat, eps_scalar_ind);
                sig_m = obj.cpt_Matrix_zpp(indmat, sig_scalar_ind);
                psi_t_m = obj.cpt_Matrix_zpp(indmat, psi_t_ind);
                psi_r_m = obj.cpt_Matrix_zpp(indmat, psi_r_ind);
                obj.psirm_psitm = psi_r_m / psi_t_m;

                for di = 1:obj.num_ini
                    ind = di + offset;
                    vld = obj.cpt_valid(ind);
                    if (vld == 0)
                        continue;
                    end
                    indmat = ind - 1; % one is subtracted as last frame is added
                    tm = obj.cpt_Matrix_zpp(indmat, time_orsv_ind);
                    eps = obj.cpt_Matrix_zpp(indmat, eps_scalar_ind);
                    sig = obj.cpt_Matrix_zpp(indmat, sig_scalar_ind);
                    psi_t = obj.cpt_Matrix_zpp(indmat, psi_t_ind);
                    psi_r = obj.cpt_Matrix_zpp(indmat, psi_r_ind);
   
                    obj.ti_tms(di) = tm / tm_m;
                    obj.epsi_epsms(di) = eps / eps_m;
                    obj.sigi_sigms(di) = sig / sig_m;
                    obj.psiti_psitms(di) = psi_t / psi_t_m;
                    obj.psiri_psitis(di) = psi_r / psi_t;
                end
            
                %cpt_fullDamage_ind = 1;
                % zero crossing point
                ind = 1 + 1;
                vld0 = obj.cpt_valid(ind);
                if (vld0)
                    indmat = ind - 1; % one is subtracted as last frame is added
                    tm_0 = obj.cpt_Matrix_zpp(indmat, time_orsv_ind);
                    eps_0 = obj.cpt_Matrix_zpp(indmat, eps_scalar_ind);
                    psi_t_0 = obj.cpt_Matrix_zpp(indmat, psi_t_ind);

                    obj.tm_t0 = tm_m / tm_0;
                    obj.epsm_eps0 = eps_m / eps_0;
                    obj.psim_psi0 = psi_t_m / psi_t_0;
                end
            end
            

            %%%%%%%%%%%%%%%%%% combined zpp and energy file
            if (generateCombined_zpp_ene)
                runSeparatingNamesAllTimes = cell(0);
                runSeparatingNamesLatexAllTimes = cell(0);
                [scalarNames, scalarNamesLatex] = obj.get_Names_general_time(runSeparatingNamesAllTimes, runSeparatingNamesLatexAllTimes);
                numDataSets = length(scalarNames);

                zppEne = gen_textIndexedDatasets;
                zppEne.nameXAxes = 't';
                zppEne.dataNamexLatex = 't';
                zppEne.dataNameSerialLatex = 'n';
                zppEne.treatAllAsCell = 1;
                zppEne.sepDataLocs = [];
                zppEne.numPts = obj.fcSync.numFiles;

                zppEne.data = cell(numDataSets, 1);
                zppEne.dataOrders = zeros(numDataSets, 1);
                zppEne.numDataSets = numDataSets;
                zppEne.dataNames = scalarNames;
                zppEne.dataNamesLatex = scalarNamesLatex;
                
                for ind = 1:obj.fcSync.numFiles
                    tm = obj.fcSync.times(ind);
%                    [tmp1cp, vld] = obj.get_aSDG_old_run_summary1R1cp(cp, ind, tm);
                    runSeparatingValues = [];
                    [scalarValues, tmp1cp] = get_Values_general_time(obj, ind, tm, runSeparatingValues);
                    
                    for fld = 1:numDataSets
                        zppEne.data{fld}{ind} = scalarValues{fld};
                    end
                    zppEne.xAxesVals(ind) = tm;
                end
                fidze = fopen(combine_zpp_ene_file_name, 'w');
                zppEne.toFile(fidze);
                fclose(fidze );
            end
            
            objout = obj;
        end
        
        function [tmp1cp, vld] = get_aSDG_old_run_summary1R1cp(obj, cp, ind, tm)
            forceMax = (cp == 0);
            tmp1cp = aSDG_old_run_summary1R1cp;

%            tmp1cp.zppDatNames = obj.cpt_nameFlds_zpp;
            tmp1cp.zppDat = nan * ones(obj.cpt_numFlds_zpp, 1);
%            tmp1cp.zprDatNames = obj.cpt_nameFlds_zpr;
            tmp1cp.zprDat = nan * ones(obj.cpt_numFlds_zpr, 1);

            vld = ((ind >= 0) && (tm >= 0));
            tmp1cp.valid = vld;
            if (vld == 0)
                return;
            end
            tmp1cp.cpDatFront.time = tm;
            tmp1cp.cpDatSyncFront.time = tm;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% front 
            [tmp1cp.cpDatFront.index, tmp1cp.cpDatFront.sn, tmp1cp.cpDatFront.numNewCrack, tmp1cp.cpDatFront.crackNewLength, tmp1cp.cpDatFront.numAllCrack, tmp1cp.cpDatFront.crackAllLength, tmp1cp.timeMin_front, tmp1cp.timeMax_front] = obj.fcFront.get_index_fromTime(tm, obj.option, forceMax);
            tmp1cp.delTime_front = tmp1cp.timeMax_front - tmp1cp.timeMin_front;

            snTmp = tmp1cp.cpDatFront.sn;
            energyFileName = [obj.rootFolder, obj.front_folderBase, '/', 'EDenergyfront_All_', num2str(snTmp), '.txt'];
            [tmp1cp.cpDatFront, bool] = tmp1cp.cpDatFront.ComputeEnergies(energyFileName, snTmp);
            if ((bool == 0) && (snTmp >= 0))
                energyFileName
                THROW('Cannot open energyFileName\n');
            end
                

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sync front 
            [tmp1cp.cpDatSyncFront.index, tmp1cp.cpDatSyncFront.sn, tmp1cp.cpDatSyncFront.numNewCrack, tmp1cp.cpDatSyncFront.crackNewLength, tmp1cp.cpDatSyncFront.numAllCrack, tmp1cp.cpDatSyncFront.crackAllLength, tmpTimeMn, tmpTimeMx] = obj.fcSync.get_index_fromTime(tm, obj.option, forceMax);

            snTmp = tmp1cp.cpDatSyncFront.sn;
            energyFileName = [obj.rootFolder, obj.front_folderBase, '/', 'EDenergyfrontSync_All_', num2str(snTmp), '.txt'];
            [tmp1cp.cpDatSyncFront, bool] = tmp1cp.cpDatSyncFront.ComputeEnergies(energyFileName, snTmp);
            if (bool == 0)
                energyFileName
                THROW('Cannot open energyFileName\n');
            end

            if (cp > 0)
                for fld = 1:obj.cpt_numFlds_zpp
                    tmp1cp.zppDat(fld) = obj.zppDatBase.summaryCriticalVals_pData(cp, fld);
                end

                for fld = 1:obj.cpt_numFlds_zpr
                    tmp1cp.zprDat(fld) = obj.zppDatBase.summaryCriticalVals_rawData(cp, fld);
                end
            else
                for fld = 1:obj.cpt_numFlds_zpp
                    utsi12u
                    p
                    dat = obj.zppDatBase.pData.data{fld}{ind}(1, 1);
                    tmp1cp.zppDat(fld) = dat;
                end
                for fld = 1:obj.cpt_numFlds_zpr
                    dat = obj.zppDatBase.rawData.data{fld}{ind}(1, 1);
                    tmp1cp.zprDat(fld) = dat;
                end
            end
        end
        function [scalarNames, scalarNamesLatex] = get_cp_Names(obj, runSeparatingNames, runSeparatingNamesLatex)
            pt = 1;
            sz = length(runSeparatingNames);
            for i = 1:sz
                scalarNames{pt} = runSeparatingNames{i};
                scalarNamesLatex{pt} = runSeparatingNamesLatex{i};
                pt = pt + 1;
            end
            
            scalarNames{pt} = 'stage';
            scalarNamesLatex{pt} = 'st';
            pt = pt + 1;
            
            scalarNames{pt} = 'cpt_valid';
            scalarNamesLatex{pt} = '\mathrm{valid}';
            pt = pt + 1;
            
            scalarNames{pt} = 'cpt_times';
            scalarNamesLatex{pt} = 't';
            pt = pt + 1;

            scalarNames{pt} = 'cpt_patch_sn';
            scalarNamesLatex{pt} = 'n_p';
            pt = pt + 1;

            scalarNames{pt} = 'cpt_sync_sn';
            scalarNamesLatex{pt} = 'n';
            pt = pt + 1;
            
            scalarNames{pt} = 'phi_t_final';
            scalarNamesLatex{pt} = '\phi_0';
            pt = pt + 1;

            scalarNames{pt} = 'tm_t0';
            scalarNamesLatex{pt} = 't^m/t^0';
            pt = pt + 1;

            scalarNames{pt} = 'epsm_eps0';
            scalarNamesLatex{pt} = '\epsilon^m/\epsilon^0';
            pt = pt + 1;

            scalarNames{pt} = 'psim_psi0';
            scalarNamesLatex{pt} = '\psi^m/\psi^0';
            pt = pt + 1;

            scalarNames{pt} = 'psirm_psitm';
            scalarNamesLatex{pt} = '\psi^m_r/\psi^m_t';
            pt = pt + 1;

            for di = 1:obj.num_ini
                nm = obj.namesDamageIni{di};
                nml = obj.namesDamageIniLatex{di};
                
                scalarNames{pt} = [nm, '_', 'ti_tms'];
                scalarNamesLatex{pt} = [nml, ' t^i/t^m'];
                pt = pt + 1;
                
                scalarNames{pt} = [nm, '_', 'epsi_epsms'];
                scalarNamesLatex{pt} = [nml, ' \epsilon^i/\epsilon^_m'];
                pt = pt + 1;
                
                scalarNames{pt} = [nm, '_', 'sigi_sigms'];
                scalarNamesLatex{pt} = [nml, ' \sigma^i/\sigma^m'];
                pt = pt + 1;

                scalarNames{pt} = [nm, '_', 'psiti_psitms'];
                scalarNamesLatex{pt} = [nml, ' \psi^i_t/\psi^m_t'];
                pt = pt + 1;

                scalarNames{pt} = [nm, '_', 'psiri_psitis'];
                scalarNamesLatex{pt} = [nml, ' \psi^i_r/\psi^i_t'];
                pt = pt + 1;
            end
            
            [scalarNamestmp, scalarNamesLatextmp] = obj.criticalPtSummaryData{1}.getNames(obj.cpt_nameFlds_zpp, obj.cpt_nameFlds_zpp_latex, obj.cpt_nameFlds_zpr, obj.cpt_nameFlds_zpr_latex);
            sz = length(scalarNamestmp);
            
            for i = 1:sz
                scalarNames{pt} = scalarNamestmp{i};
                scalarNamesLatex{pt} = scalarNamesLatextmp{i};
                pt = pt + 1;
            end
        end
        
        function [scalarValues, vld] = get_cp_Values(obj, stage, runSeparatingValues)
            if (obj.cpt_valid(stage) == 0)
                vld = 0;
                scalarValues = [];
                return;
            end
            vld = 1;
            pt = 1;
            sz = length(runSeparatingValues);
            for i = 1:sz
                scalarValues{pt} = runSeparatingValues{i};
                pt = pt + 1;
            end
            
            scalarValues{pt} = stage;
            pt = pt + 1;
            
            scalarValues{pt} = vld;
            pt = pt + 1;
            
            scalarValues{pt} = obj.cpt_times(stage);
            pt = pt + 1;

            scalarValues{pt} = obj.cpt_patch_sn(stage);
            pt = pt + 1;

            scalarValues{pt} = obj.cpt_sync_sn(stage);
            pt = pt + 1;
            
            scalarValues{pt} = obj.phi_t_final;
            pt = pt + 1;

            scalarValues{pt} = obj.tm_t0;
            pt = pt + 1;

            scalarValues{pt} = obj.epsm_eps0;
            pt = pt + 1;

            scalarValues{pt} = obj.psim_psi0;
            pt = pt + 1;

            scalarValues{pt} = obj.psirm_psitm;
            pt = pt + 1;

            for di = 1:obj.num_ini
                
                scalarValues{pt} = obj.ti_tms(di);
                pt = pt + 1;
                
                scalarValues{pt} = obj.epsi_epsms(di);
                pt = pt + 1;
                
                scalarValues{pt} = obj.sigi_sigms(di);
                pt = pt + 1;

                scalarValues{pt} = obj.psiti_psitms(di);
                pt = pt + 1;

                scalarValues{pt} = obj.psiri_psitis(di);
                pt = pt + 1;
            end
            
            valsTmp = obj.criticalPtSummaryData{stage}.getScalarValues();
            sz = length(valsTmp);
            
            for i = 1:sz
                scalarValues{pt} = valsTmp{i};
                pt = pt + 1;
            end
        end
        
        function [scalarNames, scalarNamesLatex] = get_Names_general_time(obj, runSeparatingNames, runSeparatingNamesLatex)
            pt = 1;
            sz = length(runSeparatingNames);
            for i = 1:sz
                scalarNames{pt} = runSeparatingNames{i};
                scalarNamesLatex{pt} = runSeparatingNamesLatex{i};
                pt = pt + 1;
            end
            
            scalarNames{pt} = 'psir_psit';
            scalarNamesLatex{pt} = '\psi_r/\psi_t';
            pt = pt + 1;

            cp = -1; % general time, no stage
            tm = 0;
            ind = 1;
            [tmp1cp, vld] = obj.get_aSDG_old_run_summary1R1cp(cp, ind, tm);

            [scalarNamestmp, scalarNamesLatextmp] = tmp1cp.getNames(obj.cpt_nameFlds_zpp, obj.cpt_nameFlds_zpp_latex, obj.cpt_nameFlds_zpr, obj.cpt_nameFlds_zpr_latex);
            sz = length(scalarNamestmp);
            
            for i = 1:sz
                scalarNames{pt} = scalarNamestmp{i};
                scalarNamesLatex{pt} = scalarNamesLatextmp{i};
                pt = pt + 1;
            end
        end
        function [scalarValues, tmp1cp] = get_Values_general_time(obj, ind, tm, runSeparatingValues)
            pt = 1;
            sz = length(runSeparatingValues);
            for i = 1:sz
                scalarValues{pt} = runSeparatingValues{i};
                pt = pt + 1;
            end
            cp = -1; % general time, no stage
            [tmp1cp, vld] = obj.get_aSDG_old_run_summary1R1cp(cp, ind, tm);

            psi_t_ind = 8;          % toal area under sigma eps
            psi_r_ind = 9;          % recoverable part of the energy (0.5 sigma: D sigma)
            
            psi_t = tmp1cp.zppDat(psi_t_ind);
            psi_r = tmp1cp.zppDat(psi_r_ind);
            if ((tm == 0) || (psi_t == 0))
                psir2t = nan;
            else
                psir2t = psi_r / psi_t;
            end
            
            scalarValues{pt} = psir2t;
            pt = pt + 1;
            
            valsTmp = tmp1cp.getScalarValues();
            sz = length(valsTmp);

            for i = 1:sz
                scalarValues{pt} = valsTmp{i};
                pt = pt + 1;
            end
        end
    end
end