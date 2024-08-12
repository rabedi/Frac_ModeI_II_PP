classdef zpp_DamageHomogenization1RNew % damage evolution for one run
    properties
        E = 1;
        nu = 0.3;
        %        rho = 1;
        % which is the dominant stress component
        dim = 2;
        planeStrain = 1;
        scalarStrsVoigtPos = nan;  % 1D s11, 2D (s11, s22, s12), 3D (s11, s22, s33, s12, s23, s31)
        scalarStrsSign = nan; % if stress values are negative
        t0 = 0; % time of the initial stage of the simulation
        
        indexEndMode = 3;
        % modes for the value of indexEnd
        %        0 not specified: last point is chosen
        %        1 hard specified
        %        2 indexEnd is just the first point beyond which indexEnd is to be found
        %        3 indexEnd is the location of maximum point
        
        indexEnd = nan;
        % if 0, only valid points (before or at full failure are added to
        % pData, if 1 it has the size of rawData)
        pData_addDataPastFullDamage = 1;
        
        sitffnessVoigt;
        complianceVoigt;
        
        
        % includes stress and strain maps
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        rawData = gen_textIndexedDatasets;
        rawStressNameBase = 'zpr_stssh';
        rawStrainNameBase = 'zpr_stnst';
        rawDataDamageNames = {'zpr_d'};
        rawData2IntegrateInTimeNames = cell(0); %{'zpr_power'}; % time is the coordinate of xVals in rawDat (in dynamic simulations time)
        
        % Computed data
        % processed results
        % total energy dissipated
        phi_t_final;
        pData = gen_textIndexedDatasets;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % indices
        sn_ind = 1;      % serial number
        time_orsv_ind = 2;      % time (dynamic) of load number (quasi-static) problems
        eps_scalar_ind = 3;     % epsilon scalar
        sig_scalar_ind = 4;     % sigma scalar
        veps_ind = 5;           % voigt strain
        vsig_ind = 6;           % voigt stress
        Y_ind = 7;              % 0.5 eps: C eps
        psi_t_ind = 8;          % toal area under sigma eps
        psi_r_ind = 9;          % recoverable part of the energy (0.5 sigma: D sigma)
        psi_d_ind = 10;          % amount of energy loss (non-recoverable = psi_t - psi_r
        
        % same as above but normalized by final value of psi_t_ind
        psi_t_npsif_ind = 11;
        psi_r_npsif_ind = 12;
        psi_d_npsif_ind = 13;
        
        D_ind = 14;              % damage index
        Ddot_ind = 15;          % damage dot index
        
        psi_d_to_t_ind = 16;
        psi_r_to_t_ind = 17;
        
        
        % raw damage values are added here
        numFieldsBase_zpp = 17;
        numRawDamage;
        numRawData2IntegrateInTime;
        startRawData2IntegrateInTime;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % names for accessing them
        sn_name = 'zpp_sn';
        time_orsv_name = 'zpp_sv';
        eps_scalar_name = 'zpp_eps_scalar';
        sig_scalar_name = 'zpp_sig_scalar';
        veps_name = 'zpp_eps_voigt';
        vsig_name = 'zpp_sig_voigt';
        Y_name = 'zpp_Y';
        psi_t_name = 'zpp_psi_t';
        psi_r_name = 'zpp_psi_r';
        psi_d_name = 'zpp_psi_d';
        psi_t_npsif_name = 'zpp_psi_t_npsif';
        psi_r_npsif_name = 'zpp_psi_r_npsif';
        psi_d_npsif_name = 'zpp_psi_d_npsif';
        D_name = 'zpp_Din';
        Ddot_name = 'zpp_Dindot';

        psi_d_to_t_name = 'zpp_psi_d_to_t';
        psi_r_to_t_name = 'zpp_psi_r_to_t';
        
        %%%%%%%% critical points
        %% for our damage
        damageInInitiationZeroTol = 0.005;
        %% external damages -> this can become a vector if the use wants to - one entry for each external damage values
        damageInitiationZeroTol = 0.005;
        % order is from the last strain value to initiation points
        cpt_fullDamage_ind = 1;
        cpt_final_ind = 2;
        cpt_maxSts_ind = 3;
        cpt_homogDini_ind = 4;
        cpt_extDiniStart = 4;
        cpt_numPts;
        
        cpt_fullDamage_AddedName = '_cpt_fulldamage';
        cpt_final_AddedName = '_cpt_final';
        cpt_maxSts_AddedName = '_cpt_maxsts';
        cpt_homogDini_AddedName = '_cpt_homogdini';
        cpt_extDiniStart_AddedName = '_cpt_damageext';
        
        % a list of phrases added for field names, e.g. _cpt_fullDamage, ..
        cpt_fldNameAddedNames;
        
        % critical points are stored in gen_textIndexedDatasets, point
        % location corresponds to list above cpt_...
        cpt_indices; % what positions are taken for critical points
        % (a named map of critical points, but their raw data, zpr)
        cpt_rawData = gen_textIndexedDatasets;

        % (a named map of critical points, but their processed data (e.g. damage, energies, etc.), zpp)
        cpt_pData = gen_textIndexedDatasets;
        % summary of data in cpt_pData is as follow: (criticalPt, fld) -
        % these are in matrix format
        summaryCriticalVals_pData;
        summaryCriticalTimes_pData;
        
        % same summaries but formed from raw data
        summaryCriticalVals_rawData;
        summaryCriticalTimes_rawData;
        
        % normalization values
        % u, v, stress, strain
        normalizationsUVSEps = [1 1 1 1];
        normalizationAllFields;
        normalizationTime = 1;
    end
    methods
        % planeMode 0: 1D, 1: plane strain, 2: plane stress, 3: 3D
        
        function objout = Process_zpp_file(obj, allRunsConfigs, runsAddedPara, pp_syncFile1R, ...
                regenBrief, E, nu, planeMode, t0, normalizationsUVSEps, voightStiffness)
            
            %            regenBrief = allRunsConfigs.regenerateBriefFile;
            
            fileNameSync_pp = pp_syncFile1R.summarySyncFileName;
            fileNameSync_zpp = strrep(fileNameSync_pp, ['.', allRunsConfigs.briefFileExt], ['.', allRunsConfigs.zppConfig.zppExt]);
            
            summaryExists = 0;
            if (~regenBrief)
                fidSumDat = fopen(fileNameSync_zpp, 'r');
                summaryExists = (fidSumDat > 0);
                if (summaryExists)
                    fclose(fidSumDat);
                end
            end
            if (summaryExists)
                fidSumDat = fopen(fileNameSync_zpp, 'r');
                obj = obj.fromFile(fidSumDat);
                fclose(fidSumDat);
                objout = obj;
                return;
            end
            
            obj = obj.Initialize4DGRuns(allRunsConfigs.zppConfig, runsAddedPara, E, nu, planeMode, normalizationsUVSEps, t0, voightStiffness);
            obj = obj.Process(pp_syncFile1R.summarySyncData);
            
            fidzzc = fopen(fileNameSync_zpp, 'w');
            obj.toFile(fidzzc);
            fclose(fidzzc);
            
            objout = obj;
        end
        
        function objout = Initialize4DGRuns(obj, allRuns_zppConfig, runMap, E, nu, planeMode, normalizationsUVSEpsIn, t0, C)
            if nargin < 3
                runMap = gen_map;
            end
            if nargin < 4
                E = nan;
            end
            if nargin < 5
                nu = nan;
            end
            if nargin < 6
                planeMode = nan;
            end
            if nargin < 7
                normalizationsUVSEpsIn = [1 1 1 1];
            end
            if nargin < 8
                t0 = nan;
            end
            if nargin < 9
                C = [];
            end
            
            overwrite = 0;  % don't want to overwrite any value that may exist at the run level
            
            genMap = runMap;
            % first taking care of allRuns_zppConfig
            for i = 1:length(allRuns_zppConfig.rawDataDamageNames)
                key = ['rawDataDamageNames', num2str(i)];
                strVal = allRuns_zppConfig.rawDataDamageNames{i};
                genMap.AddKeyVal(key, strVal, overwrite);
            end
            for i = 1:length(allRuns_zppConfig.rawData2IntegrateInTimeNames)
                key = ['rawData2IntegrateInTimeNames', num2str(i)];
                strVal = allRuns_zppConfig.rawData2IntegrateInTimeNames{i};
                genMap.AddKeyVal(key, strVal, overwrite);
            end
            % stiffnessAllRuns is already added in gMapAllRuns
            for i = 1:length(allRuns_zppConfig.gMapAllRuns.keys)
                key = allRuns_zppConfig.gMapAllRuns.keys{i};
                strVal = allRuns_zppConfig.gMapAllRuns.valsStr{i};
                genMap.AddKeyVal(key, strVal, overwrite);
            end
            
            %%% at this stage all values of the zpp config are added to
            %%% run's map value
            
            % remaining is adding the scales, E, nu, planeMode, ...
            CcompName = ['sitffnessVoigt_', num2str(1), num2str(1)];
            [val, pos] = genMap.AccessNumber(CcompName);
            % if stiffness is provided
            hasC = (pos > 0);
            
            if (~hasC)
                % providing values for E, nu, planeMode
                if ((length(C) == 0) || (isnan(C(1, 1))))
                    if (isnan(E))
                        E = obj.E;
                        %                        THROW('E must be provided\n');
                    end
                    if (isnan(nu))
                        nu = obj.nu;
                        %                        THROW('nu must be provided\n');
                    end
                    if (isnan(planeMode))
                        planeMode = 1; % planeMode  plane strain
                        %                        THROW('planeMode must be provided\n');
                    end
                    if (planeMode == 0) % 1D
                        dim = 1;
                        planeStrain = -1;
                    elseif (planeMode == 1) % 2D plane strain
                        dim = 2;
                        planeStrain = 1;
                    elseif (planeMode == 2) % 2D plane stress
                        dim = 2;
                        planeStrain = 0;
                    elseif (planeMode == 3) % 1D
                        dim = 3;
                        planeStrain = -1;
                    end
                    pos = genMap.AddKeyVal('dim', dim, overwrite);
                    pos = genMap.AddKeyVal('planeStrain', planeStrain, overwrite);
                    pos = genMap.AddKeyVal('E', E, overwrite);
                    pos = genMap.AddKeyVal('nu', nu, overwrite);
                else
                    [m, n] = size(C);
                    if (m > 0)
                        for i = 1:m
                            for j = 1:n
                                val = C(i, j);
                                CcompName = ['sitffnessVoigt_', num2str(i), num2str(j)];
                                pos = genMap.AddKeyVal(CcompName, val, overwrite);
                            end
                        end
                    end
                end
            end
            
            % adding scales
            scaleU = normalizationsUVSEpsIn(1);
            pos = genMap.AddKeyVal('scaleU', scaleU, overwrite);
            scaleV = normalizationsUVSEpsIn(2);
            pos = genMap.AddKeyVal('scaleV', scaleV, overwrite);
            scaleS = normalizationsUVSEpsIn(3);
            pos = genMap.AddKeyVal('scaleS', scaleS, overwrite);
            scaleEps = normalizationsUVSEpsIn(4);
            pos = genMap.AddKeyVal('scaleEps', scaleEps, overwrite);
            
            % t0
            if (~isnan(t0))
                pos = genMap.AddKeyVal('t0', t0, overwrite);
            end
            
            objout = obj.Initialize(genMap);
        end
        
        function objout = Initialize(obj, genMap)
            
            % computing stiffness and compliance
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 3D stiffness
            C = nan * ones(6, 6);
            maxIJ = 0;
            for i = 1:6
                for j = 1:6
                    CcompName = ['sitffnessVoigt_', num2str(i), num2str(j)];
                    [val, pos] = genMap.AccessNumber(CcompName);
                    if (pos > 0)
                        C(i, j) = val;
                        maxIJ = max(maxIJ, i);
                        maxIJ = max(maxIJ, j);
                    end
                end
            end
            if (maxIJ == 6)
                obj.dim = 3;
            elseif (maxIJ == 3)
                obj.dim = 2;
                C = C(1:3, 1:3);
            elseif (maxIJ == 1)
                C = C(1, 1);
                obj.dim = 1;
            else
                obj.dim = -1; % not decided yet
            end
            if (obj.dim > 0)
                obj.sitffnessVoigt = C;
                obj.complianceVoigt = inv(obj.sitffnessVoigt);
                % these values not specified
                obj.E = -1;
                obj.nu = -1;
                obj.planeStrain = -1;
            else
                [val, pos] = genMap.AccessNumber('E');
                if (pos > 0)
                    obj.E = val;
                end
                [val, pos] = genMap.AccessNumber('nu');
                if (pos > 0)
                    obj.nu = val;
                end
                [val, pos] = genMap.AccessNumber('planeStrain');
                if (pos > 0)
                    obj.planeStrain = val;
                end
                [val, pos] = genMap.AccessNumber('dim');
                if (pos > 0)
                    obj.dim = val;
                end
                [obj.sitffnessVoigt, obj.complianceVoigt] = el_ComputeVoigtStiffnessCompliance(obj.E, obj.nu, obj.planeStrain, obj.dim);
            end
            % other scalars
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [val, pos] = genMap.AccessNumber('t0');
            if (pos > 0)
                obj.t0 = val;
            end
            
            % dominant stress component and its sign
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [val, pos] = genMap.AccessNumber('scalarStrsVoigtPos');
            if (pos > 0)
                obj.scalarStrsVoigtPos = val;
            end
            [val, pos] = genMap.AccessNumber('scalarStrsSign');
            if (pos > 0)
                obj.scalarStrsSign = val;
            end
            
            % conditions for end stress
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [val, pos] = genMap.AccessNumber('indexEndMode');
            if (pos > 0)
                obj.indexEndMode = val;
            end
            [val, pos] = genMap.AccessNumber('indexEnd');
            if (pos > 0)
                obj.indexEnd = val;
            end
            
            % damage initiation threshold
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.damageInInitiationZeroTol = nan;
            [val, pos] = genMap.AccessNumber('damageInitiationZeroTol');
            if (pos > 0)
                obj.damageInitiationZeroTol = val;
            end
            for i = 1:5
                [val, pos] = genMap.AccessNumber(['damageInitiationZeroTol', num2str(i)]);
                if (pos > 0)
                    obj.damageInitiationZeroTol(i) = val;
                end
            end
            [val, pos] = genMap.AccessNumber('damageInInitiationZeroTol');
            if (pos > 0)
                obj.damageInInitiationZeroTol = val;
            end
            if (isnan(obj.damageInInitiationZeroTol))
                obj.damageInInitiationZeroTol = obj.damageInitiationZeroTol(1);
            end
                        
            % normalization scales
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [val, pos] = genMap.AccessNumber('scaleU');
            if (pos > 0)
                obj.normalizationsUVSEps(1) = val;
            end
            [val, pos] = genMap.AccessNumber('scaleV');
            if (pos > 0)
                obj.normalizationsUVSEps(2) = val;
            end
            [val, pos] = genMap.AccessNumber('scaleS');
            if (pos > 0)
                obj.normalizationsUVSEps(3) = val;
            end
            [val, pos] = genMap.AccessNumber('scaleEps');
            if (pos > 0)
                obj.normalizationsUVSEps(4) = val;
            end
            
            % names of strain and stress fields
            [fldName, pos] = genMap.AccessStr('rawStressNameBase');
            if (pos > 0)
                obj.rawStressNameBase = fldName;
            end
            [fldName, pos] = genMap.AccessStr('rawStrainNameBase');
            if (pos > 0)
                obj.rawStrainNameBase = fldName;
            end
            
            % damage and time integration fields
            cntr = 0;
            index = 0;
            name = ['rawDataDamageNames', num2str(index)];
            [fldName, pos] = genMap.AccessStr(name);
            while ((pos > 0) || (index == 0))
                if (pos > 0)
                    cntr = cntr + 1;
                    obj.rawDataDamageNames{cntr} = fldName;
                end
                index = index + 1;
                name = ['rawDataDamageNames', num2str(index)];
                [fldName, pos] = genMap.AccessStr(name);
            end
            
            cntr = 0;
            index = 0;
            name = ['rawData2IntegrateInTimeNames', num2str(index)];
            [fldName, pos] = genMap.AccessStr(name);
            while ((pos > 0) || (index == 0))
                if (pos > 0)
                    cntr = cntr + 1;
                    obj.rawData2IntegrateInTimeNames{cntr} = fldName;
                end
                index = index + 1;
                name = ['rawData2IntegrateInTimeNames', num2str(index)];
                [fldName, pos] = genMap.AccessStr(name);
            end
            
            [val, pos] = genMap.AccessNumber('pData_addDataPastFullDamage');
            if (pos > 0)
                obj.pData_addDataPastFullDamage = val;
            end
            objout = obj;
        end
        function objout = Process(obj, rawDataIn, StrsVoigtPos,StrsSign)
            t0 = obj.t0; % what time does the initial time of the simulation corresponds to
            obj.rawData = rawDataIn;
            numPtsIn = obj.rawData.numPts;
            if (numPtsIn < 2)
                THROW('need at least two points in eps, sig curve\n');
            end
            
            % dimension and indices of strains
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            epsxx_i = obj.rawData.DataName2Index([obj.rawStrainNameBase, '_xx']);
            epsyy_i = obj.rawData.DataName2Index([obj.rawStrainNameBase, '_yy']);
            epsxy_i = obj.rawData.DataName2Index([obj.rawStrainNameBase, '_xy']);
            epszz_i = obj.rawData.DataName2Index([obj.rawStressNameBase, '_zz']);
            epsyz_i = obj.rawData.DataName2Index([obj.rawStressNameBase, '_yz']);
            epszx_i = obj.rawData.DataName2Index([obj.rawStressNameBase, '_zx']);
            
            if (isnan(epsxx_i))
                epsxx_i
                strainBasename = obj.rawStressNameBase
                rawDatanames = obj.rawData.dataNames
                THROW('Cannot find epsxx\n');
            end
            obj.dim = 1;
            if ((~isnan(epsyy_i)) && (~isnan(epsxy_i)))
                if ((~isnan(epszz_i)) && (~isnan(epsyz_i)) && (~isnan(epszx_i)))
                    obj.dim = 3;
                else
                    obj.dim = 2;
                end
                
                sigxx_i = obj.rawData.DataName2Index([obj.rawStressNameBase, '_xx']);
                sigyy_i = obj.rawData.DataName2Index([obj.rawStressNameBase, '_yy']);
                sigxy_i = obj.rawData.DataName2Index([obj.rawStressNameBase, '_xy']);
                sigzz_i = obj.rawData.DataName2Index([obj.rawStressNameBase, '_zz']);
                sigyz_i = obj.rawData.DataName2Index([obj.rawStressNameBase, '_yz']);
                sigzx_i = obj.rawData.DataName2Index([obj.rawStressNameBase, '_zx']);
                
                
                % extracting strain and stress voigt 'vectors'
                if (obj.dim == 1)
                    voigt_sz = 1;
                    sigs_ind = [sigxx_i];
                    epss_ind = [epsxx_i];
                elseif (obj.dim == 2)
                    epss_ind = [epsxx_i, epsyy_i, epsxy_i];
                    sigs_ind = [sigxx_i, sigyy_i, sigxy_i];
                    voigt_sz = 3;
                elseif (obj.dim == 3)
                    epss_ind = [epsxx_i, epsyy_i, epszz_i, epsxy_i, epsyz_i, epszx_i];
                    sigs_ind = [sigxx_i, sigyy_i, sigzz_i, sigxy_i, sigyz_i, sigzx_i];
                    voigt_sz = 6;
                end
            end
            
            vstrain = cell(numPtsIn, 1);
            vstress = cell(numPtsIn, 1);
            for pt = 1:numPtsIn
                vstrain{pt} = zeros(voigt_sz, 1);
                vstress{pt} = zeros(voigt_sz, 1);
                for j = 1:voigt_sz
                    ind = epss_ind(j);
                    vstrain{pt}(j) = obj.rawData.data{ind}{pt};
                    ind = sigs_ind(j);
                    vstress{pt}(j) = obj.rawData.data{ind}{pt};
                end
            end
            
            % determining which component is the dominant one, used for
            % determining certain things (max, initiation, etc.)
            
%             ptCheck = 2;
%             if (isnan(obj.scalarStrsVoigtPos)) % dominant component not chosen
%                 sig = vstress{ptCheck};
%                 [mx, obj.scalarStrsVoigtPos] = max(abs(sig));
%             end
%             if (isnan(obj.scalarStrsSign))
%                 obj.scalarStrsSign = sign(sig(obj.scalarStrsVoigtPos));
%             end

            obj.scalarStrsVoigtPos = StrsVoigtPos;
            obj.scalarStrsSign = StrsSign;
            
            % scalar strain and stress
            stn = zeros(numPtsIn, 1);
            sts = zeros(numPtsIn, 1);
            for pt = 1:numPtsIn
                stn(pt) = obj.scalarStrsSign * vstrain{pt}(obj.scalarStrsVoigtPos);
                sts(pt) = obj.scalarStrsSign * vstress{pt}(obj.scalarStrsVoigtPos);
            end
            %             for pt = 391:size(sts)
            %                 sts(pt) = -sts(pt);
            %                 vstress{pt}(1) = -vstress{pt}(1);
            %             end
            
            % determining index end
            [mxSts, indmx] = max(sts);
            stsGetsNegative = 0;
            if (obj.indexEndMode == 1)
                inden = obj.indexEnd;
            elseif (obj.indexEndMode == 0) % last point is taken
                inden = numPtsIn;
            else
                inden = numPtsIn;
                if (obj.indexEndMode == 3) % maximum start
                    st2find = indmx;
                elseif (obj.indexEndMode == 2) % maximum start
                    st2find = obj.indexEnd;
                end
                negIndex = -1;
                for pt = st2find:numPtsIn
                    if (sts(pt) < 0)
                        negIndex = pt;
                        break;
                    end
                end
                if (negIndex > 1)
                    inden = negIndex; % - 1;
                    stsGetsNegative = 1;
                end
            end
            obj.indexEnd = inden;
            
            %%% modifying the end point if the final value gets past zero
            indexEffectiveLast = obj.indexEnd;
            hasFullFailure = 0;
            if (stsGetsNegative == 1)
                stressPos = sts(inden - 1);
                stressNeg = sts(inden);
                factNext = stressPos / (stressPos - stressNeg);
                factPrev = 1 - factNext;
                indexEffectiveLast = negIndex - factPrev;
                
                % serial value
                obj.rawData.xAxesVals(negIndex) = factNext * obj.rawData.xAxesVals(negIndex) + factPrev * obj.rawData.xAxesVals(negIndex - 1);
                % field values
                for j = 1:obj.rawData.numDataSets
                    obj.rawData.data{j}{negIndex} = factNext * obj.rawData.data{j}{negIndex} + factPrev * obj.rawData.data{j}{negIndex - 1};
                end
                
                % stress and strain tensors
                vstrain{negIndex} = factNext * vstrain{negIndex} + factPrev * vstrain{negIndex - 1};
                vstress{negIndex} = factNext * vstress{negIndex} + factPrev * vstress{negIndex - 1};
                
                %scalar stress and strain
                stn(negIndex) = factNext * stn(negIndex) + factPrev * stn(negIndex - 1);
                sts(negIndex) = factNext * sts(negIndex) + factPrev * sts(negIndex - 1);
                
                hasFullFailure = 1;
            end
            if (~hasFullFailure)
                absLastSts = abs(sts(obj.indexEnd));
                hasFullFailure = (absLastSts < 1e-6 * mxSts);
            end
            
            % creating new data
            numPtsOut = obj.indexEnd;
            if (obj.pData_addDataPastFullDamage)
                numPtsOut = numPtsIn;
            end
            obj.pData = obj.pData.Initialize(numPtsOut, obj.rawData.nameXAxes);
            
            % adding names
            obj.numRawDamage = length(obj.rawDataDamageNames);
            obj.cpt_numPts = obj.cpt_extDiniStart + obj.numRawDamage;
            obj.cpt_fldNameAddedNames = cell(obj.cpt_numPts, 1);
            obj.cpt_fldNameAddedNames{obj.cpt_fullDamage_ind} = obj.cpt_fullDamage_AddedName;
            obj.cpt_fldNameAddedNames{obj.cpt_final_ind} = obj.cpt_final_AddedName;
            obj.cpt_fldNameAddedNames{obj.cpt_maxSts_ind} = obj.cpt_maxSts_AddedName;
            obj.cpt_fldNameAddedNames{obj.cpt_homogDini_ind} = obj.cpt_homogDini_AddedName;
            for i = 1:obj.numRawDamage
                obj.cpt_fldNameAddedNames{obj.cpt_extDiniStart + i} = [obj.cpt_extDiniStart_AddedName, num2str(i)];
            end
            
            obj.numRawData2IntegrateInTime = length(obj.rawData2IntegrateInTimeNames);
            obj.startRawData2IntegrateInTime = obj.numFieldsBase_zpp + obj.numRawDamage;
            numFieldsOut = obj.startRawData2IntegrateInTime + obj.numRawData2IntegrateInTime;
            namesDamage = cell(obj.numFieldsBase_zpp, 1);
            
            % setting normalization values
            obj.normalizationAllFields = ones(numFieldsOut, 1);
            UScale = obj.normalizationsUVSEps(1);
            VScale = obj.normalizationsUVSEps(2);
            SScale = obj.normalizationsUVSEps(3); % stress
            EpsScale = obj.normalizationsUVSEps(4); % strain
            obj.normalizationTime = UScale / VScale;
            energyScale = SScale * EpsScale;
            
            obj.normalizationAllFields(obj.sn_ind) = 1;
            obj.normalizationAllFields(obj.time_orsv_ind) = obj.normalizationTime;
            obj.normalizationAllFields(obj.eps_scalar_ind) = EpsScale;
            obj.normalizationAllFields(obj.sig_scalar_ind) = SScale;
            obj.normalizationAllFields(obj.veps_ind) = EpsScale;
            obj.normalizationAllFields(obj.vsig_ind) = SScale;
            obj.normalizationAllFields(obj.Y_ind) = energyScale;
            obj.normalizationAllFields(obj.psi_t_ind) = energyScale;
            obj.normalizationAllFields(obj.psi_r_ind) = energyScale;
            obj.normalizationAllFields(obj.psi_d_ind) = energyScale;
            obj.normalizationAllFields(obj.psi_t_npsif_ind) = 1;
            obj.normalizationAllFields(obj.psi_r_npsif_ind) = 1;
            obj.normalizationAllFields(obj.psi_d_npsif_ind) = 1;
            obj.normalizationAllFields(obj.D_ind) = 1;
            obj.normalizationAllFields(obj.Ddot_ind) = 1 / obj.normalizationTime;
            obj.normalizationAllFields(obj.psi_d_to_t_ind) = 1;
            obj.normalizationAllFields(obj.psi_r_to_t_ind) = 1;

            for fld = 1:obj.numRawData2IntegrateInTime
                obj.normalizationAllFields(fld + obj.numFieldsBase_zpp) = 1.0; % damages are not normalized
            end
            for fld = 1:obj.numRawData2IntegrateInTime
                obj.normalizationAllFields(fld + obj.startRawData2IntegrateInTime) = energyScale; % assume all integrated fields are power -> their integral = energy
            end
            
            
            %% names of fields
            namesDamage{obj.sn_ind} = obj.sn_name;
            namesDamage{obj.time_orsv_ind} = obj.time_orsv_name;
            namesDamage{obj.eps_scalar_ind} = obj.eps_scalar_name;
            namesDamage{obj.sig_scalar_ind} = obj.sig_scalar_name;
            namesDamage{obj.veps_ind} = obj.veps_name;
            namesDamage{obj.vsig_ind} = obj.vsig_name;
            namesDamage{obj.Y_ind} = obj.Y_name;
            namesDamage{obj.psi_t_ind} = obj.psi_t_name;
            namesDamage{obj.psi_r_ind} = obj.psi_r_name;
            namesDamage{obj.psi_d_ind} = obj.psi_d_name;
            namesDamage{obj.psi_t_npsif_ind} = obj.psi_t_npsif_name;
            namesDamage{obj.psi_r_npsif_ind} = obj.psi_r_npsif_name;
            namesDamage{obj.psi_d_npsif_ind} = obj.psi_d_npsif_name;
            namesDamage{obj.D_ind} = obj.D_name;
            namesDamage{obj.Ddot_ind} = obj.Ddot_name;

            namesDamage{obj.psi_d_to_t_ind} = obj.psi_d_to_t_name;
            namesDamage{obj.psi_r_to_t_ind} = obj.psi_r_to_t_name;
            
            % new damage fields
            for fld = 1:obj.numFieldsBase_zpp
                ptData = 0;
                if ((fld == obj.veps_ind) || (fld == obj.vsig_ind))
                    ptData = zeros(3, 1);
                end
                obj.pData = obj.pData.AddDataSetFirstPt(ptData, namesDamage{fld});
            end
            
            % adding external damage fields
            indexRawDamage = zeros(obj.numRawDamage, 1);
            for fld = 1:obj.numRawDamage
                indexRawDamage(fld) = obj.rawData.DataName2Index(obj.rawDataDamageNames{fld});
                dataCell = obj.rawData.getDataCellByDataName(obj.rawDataDamageNames{fld});
                ptData = dataCell{obj.rawData.numPts};
                nameRaw = obj.rawDataDamageNames{fld};
                nameDamage = strrep(nameRaw, 'zpr', 'zpp');
                obj.pData = obj.pData.AddDataSetFirstPt(ptData, nameDamage);
            end
            % adding time integrated values
            indexTimeIntegrated = zeros(obj.numRawData2IntegrateInTime, 1);
            for fld = 1:obj.numRawData2IntegrateInTime
                indexTimeIntegrated (fld) = obj.rawData.DataName2Index(obj.rawData2IntegrateInTimeNames{fld});
                obj.rawData2IntegrateInTimeNames{fld};
                dataCell = obj.rawData.getDataCellByDataName(obj.rawData2IntegrateInTimeNames{fld});
                ptData = dataCell{obj.rawData.numPts};
                nameRaw = obj.rawData2IntegrateInTimeNames{fld};
                nameNew = strrep(nameRaw, 'zpr', 'zpp');
                obj.pData = obj.pData.AddDataSetFirstPt(ptData, nameNew);
            end
            
            psi_t = 0.5 * vstrain{1}' * vstress{1};
            psi_d = 0.0;
            psi_r = psi_t - psi_d;
            Y = 0.5 * vstrain{1}' * obj.sitffnessVoigt * vstrain{1};
            D = 0.0;
            Ddot = 0.0;
            pt = 1;
            
            % adding values for the first point
            obj.pData.data{obj.sn_ind}{pt} = pt;
            obj.pData.data{obj.time_orsv_ind}{pt} = obj.rawData.xAxesVals(pt);
            obj.pData.data{obj.eps_scalar_ind}{pt} = stn(pt);
            obj.pData.data{obj.sig_scalar_ind}{pt} = sts(pt);
            obj.pData.data{obj.veps_ind}{pt} = vstrain{pt};
            obj.pData.data{obj.vsig_ind}{pt} = vstress{pt};
            obj.pData.data{obj.Y_ind}{pt} = Y;
            obj.pData.data{obj.psi_t_ind}{pt} = psi_t;
            obj.pData.data{obj.psi_r_ind}{pt} = psi_r;
            obj.pData.data{obj.psi_d_ind}{pt} = psi_d;
            obj.pData.data{obj.D_ind}{pt} = D;
            obj.pData.data{obj.Ddot_ind}{pt} = Ddot;
            obj.pData.data{obj.psi_d_to_t_ind}{pt} = nan;
            obj.pData.data{obj.psi_r_to_t_ind}{pt} = nan;
            
            for fld = 1:obj.numRawDamage
                obj.pData.data{obj.numFieldsBase_zpp + fld}{pt} = obj.rawData.data{indexRawDamage(fld)}{pt};
            end
            
            % assuming time integrated fields are linearly increased in
            % time
            for fld = 1:obj.numRawData2IntegrateInTime
                obj.pData.data{obj.startRawData2IntegrateInTime + fld}{pt} = 0.5 * t0 * obj.rawData.data{indexTimeIntegrated(fld)}{pt};
            end
            
            time = obj.rawData.xAxesVals(1); % or pseudo time, serial step, ...
            obj.pData.xAxesVals(1) = time;
            
            for pt = 2:obj.pData.numPts
                timeOld = time;
                time = obj.rawData.xAxesVals(pt);
                obj.pData.xAxesVals(pt) = time;
                delT = time - timeOld;
                
                % area under stress strain curve
                delEps = vstrain{pt} - vstrain{pt - 1};
                sigAverage = 0.5 * (vstress{pt} + vstress{pt - 1});
                del_psi_t = delEps' * sigAverage; % area under the curve
                psi_t = psi_t + del_psi_t;
                
                psi_r = 0.5 * vstress{pt}' * obj.complianceVoigt * vstress{pt}; % recoverable energy
                psi_d = psi_t - psi_r; % lost or dissipated energy
                
                % computing Y
                Yold = Y;
                Y = 0.5 * vstrain{pt}' * obj.sitffnessVoigt * vstrain{pt};
                delY = Y - Yold;
                
                Dold = obj.pData.data{obj.D_ind}{pt - 1};
                if (abs(delY) > 0)
                    D = 1 - del_psi_t / delY;
                else
                    D = Dold;
                end
                D = max(D, 0.0);
                D = min(D, 1.0);
                Ddot = (D - Dold) / delT;
                
                % adding values for the first point
                obj.pData.data{obj.sn_ind}{pt} = pt;
                obj.pData.data{obj.time_orsv_ind}{pt} = obj.rawData.xAxesVals(pt);
                obj.pData.data{obj.eps_scalar_ind}{pt} = stn(pt);
                obj.pData.data{obj.sig_scalar_ind}{pt} = sts(pt);
                obj.pData.data{obj.veps_ind}{pt} = vstrain{pt};
                obj.pData.data{obj.vsig_ind}{pt} = vstress{pt};
                obj.pData.data{obj.Y_ind}{pt} = Y;
                obj.pData.data{obj.psi_t_ind}{pt} = psi_t;
                obj.pData.data{obj.psi_r_ind}{pt} = psi_r;
                obj.pData.data{obj.psi_d_ind}{pt} = psi_d;
                obj.pData.data{obj.D_ind}{pt} = D;
                obj.pData.data{obj.Ddot_ind}{pt} = Ddot;

            if (abs(psi_t) > 1e-20)
%                obj.pData.data{obj.psi_d_to_t_ind}{pt} = max(min(psi_d / psi_t, 1.0), 0.0);
%                obj.pData.data{obj.psi_r_to_t_ind}{pt} = max(min(psi_r / psi_t, 1.0), 0.0);
                obj.pData.data{obj.psi_d_to_t_ind}{pt} = psi_d / psi_t;
                obj.pData.data{obj.psi_r_to_t_ind}{pt} = psi_r / psi_t;
            else
                obj.pData.data{obj.psi_d_to_t_ind}{pt} = nan;
                obj.pData.data{obj.psi_r_to_t_ind}{pt} = nan;
            end
               for fld = 1:obj.numRawDamage
                    obj.pData.data{obj.numFieldsBase_zpp + fld}{pt} = obj.rawData.data{indexRawDamage(fld)}{pt};
                end
                
                for fld = 1:obj.numRawData2IntegrateInTime
                    averageRate = 0.5 * (obj.rawData.data{indexTimeIntegrated(fld)}{pt - 1} + obj.rawData.data{indexTimeIntegrated(fld)}{pt});
                    obj.pData.data{obj.startRawData2IntegrateInTime + fld}{pt} = ...
                        obj.pData.data{obj.startRawData2IntegrateInTime + fld}{pt - 1} + delT * averageRate;
                end
            end
            
            obj.phi_t_final = obj.pData.data{obj.psi_t_ind}{obj.indexEnd};
            for pt = 1:obj.pData.numPts
                obj.pData.data{obj.psi_t_npsif_ind}{pt} = obj.pData.data{obj.psi_t_ind}{pt} / obj.phi_t_final;
                obj.pData.data{obj.psi_r_npsif_ind}{pt} = obj.pData.data{obj.psi_r_ind}{pt} / obj.phi_t_final;
                obj.pData.data{obj.psi_d_npsif_ind}{pt} = obj.pData.data{obj.psi_d_ind}{pt} / obj.phi_t_final;
            end
            
            for pt = obj.indexEnd + 1:obj.pData.numPts
                for fld = 1:obj.pData.numDataSets
                    obj.pData.data{fld}{pt} = nan * obj.pData.data{fld}{pt};
                end
            end
            
            %%%%%% critical points
            obj.cpt_indices = zeros(obj.cpt_numPts, 1);
            % first point is the last point in strain - stress
            if (hasFullFailure)
                obj.cpt_indices(obj.cpt_fullDamage_ind) = obj.indexEnd;
            else
                obj.cpt_indices(obj.cpt_fullDamage_ind) = nan;
            end
            obj.cpt_indices(obj.cpt_final_ind) = obj.indexEnd;
            % maximum stress: is it a true maximum or simply the last point
            % of the loading region (have not got to decreasing mode)
            if (indmx == obj.indexEnd)
                indMax = nan;
            else
                indMax = indmx;
            end
            obj.cpt_indices(obj.cpt_maxSts_ind) = indMax;
            % initiation ones
            
            flds_ini = zeros(obj.numRawDamage + 1, 1);
            flds_ini(1) = obj.D_ind;
            for i = 1:obj.numRawDamage
                flds_ini(i + 1) = obj.numFieldsBase_zpp + i; %indexRawDamage(i);
            end
            
            i = 1;
            offset = obj.cpt_extDiniStart - 1;
            % our damage
            tolD = obj.damageInInitiationZeroTol;
            fld = flds_ini(i);
            indIni = nan;
            for pt = 1:obj.indexEnd
                dmg = obj.pData.data{fld}{pt};
                if (dmg > tolD)
                    indIni = pt;
                    break;
                end
            end
            obj.cpt_indices(i + offset) = indIni;

        
            % external damages
            for i = 1:obj.numRawDamage
                szz = length(obj.damageInitiationZeroTol(1));
                if (i > szz)
                    obj.damageInitiationZeroTol(i) = obj.damageInitiationZeroTol(1);
                end
                tolD = obj.damageInitiationZeroTol(i);
                fld = flds_ini(i + 1);
                indIni = nan;
                for pt = 1:obj.indexEnd
                    dmg = obj.pData.data{fld}{pt};
                    if (dmg > tolD)
                        indIni = pt;
                        break;
                    end
                end
                obj.cpt_indices(i + 1 + offset) = indIni;
            end
            
            
            obj.cpt_pData = obj.pData.ExtractIntegerIndices(obj.cpt_indices);
            obj.cpt_rawData = obj.rawData.ExtractIntegerIndices(obj.cpt_indices);
            
            
            %%% summary for cpt_pData
            r = length(obj.cpt_pData.data);
            c = length(obj.cpt_pData.data{1});
            for i = 1:r
                for j = 1:c
                    obj.summaryCriticalVals_pData(i, j) = obj.cpt_pData.data{i}{j}(1);
                end
            end
            obj.summaryCriticalVals_pData = obj.summaryCriticalVals_pData';
            for pt = 1:obj.cpt_numPts
                obj.summaryCriticalTimes_pData(pt) = obj.cpt_pData.xAxesVals(pt);
            end
            
            r = length(obj.cpt_rawData.data);
            c = length(obj.cpt_rawData.data{1});
            for i = 1:r
                for j = 1:c
                    obj.summaryCriticalVals_rawData(i, j) = obj.cpt_rawData.data{i}{j}(1);
                end
            end
            obj.summaryCriticalVals_rawData = obj.summaryCriticalVals_rawData';
            for pt = 1:obj.cpt_numPts
                obj.summaryCriticalTimes_rawData(pt) = obj.cpt_rawData.xAxesVals(pt);
            end
            
            objout = obj;
        end
        function dataPts = getDataVectorByDataName(obj, dataName, index1, index2)
            dataName = lower(dataName);
            if ((nargin < 3) || (isnan(index1)))
                index1 = 1;
            end
            if ((nargin < 4) || (isnan(index2)))
                index2 = 1;
            end
            % A. first see if it's normalized
            isNormalized = contains(dataName,'_ny');
            if (isNormalized)
                dataName = strrep(dataName, '_ny', '');
            end
            
            % B. see if it belongs to raw data (starting with zppr_) or
            % processed data (starting with zpp_)
            isRaw = contains(dataName, 'zppr_');
            if (isRaw)
                dataName = strrep(dataName, 'zppr_', 'zpr_');
            end
            
            % C. see if it corresponds to a critical point data
            % includes texts
            % _cpt_all: All the points
            
            % _cpt_fulldamage (point where stress main = 0)
            % _cpt_final        (last point of the simulation)
            % _cpt_maxsts       maximum stress point
            % _cpt_homogdini    homogenized damage initiation point
            % _cpt_damageext(I) (I) = 1, 2, ... external damage values
            % provided in rawDataDamageNames
            isCPT = contains(dataName, 'cpt');
            criticalPtPos = -1; % 0 corresponds to _cpt_all, else it's one of the specific critical points
            if (isCPT)
                if (~contains(dataName, '_cpt'))
                    THROW('Critical point should be added with _cpt...\n');
                end
                if (contains(dataName, '_cpt_all'))
                    dataName = strrep(dataName, '_cpt_all', '');
                    criticalPtPos = 0; % all points
                else
                    for pt = 1:length(obj.cpt_fldNameAddedNames)
                        addedName = obj.cpt_fldNameAddedNames{pt};
                        if (contains(dataName, addedName))
                            criticalPtPos = pt;
                            dataName = strrep(dataName, addedName, '');
                            break;
                        end
                    end
                    if (criticalPtPos == -1)
                        dataName
                        THROW('Could not find critical point append in the name\n');
                    end
                end
            end
            
            % based on knowledge from A, B, C we get return the correct
            % value now
            
            % easy case: no critical point related data
            if (~isCPT)
                if (~isRaw)
                    [dataPts, dataIndex] = obj.pData.getDataVectorByDataName(dataName, index1, index2);
                else
                    [dataPts, dataIndex] = obj.rawData.getDataVectorByDataName(dataName, index1, index2);
                end
                if (isNormalized)
                    if (~isRaw)
                        dataPts = dataPts ./ obj.normalizationAllFields(dataIndex);
                    else
                        THROW('Do not know how to normlize raw data. Use original zpr_ fields to access what is needed\n');
                    end
                end
                return;
            end
            
            % next see if all fields are request or just one
            allFields = contains(dataName, 'allfields');
            if (allFields) % needs all fields
                if (isRaw)
                    dataPts = obj.summaryCriticalVals_rawData;
                else
                    dataPts = obj.summaryCriticalVals_pData;
                end
                if (criticalPtPos ~= 0) % one specific critical point
                    dataPts = dataPts(criticalPtPos, :);
                end
                % now take care of if data is normalized or not
                if (isNormalized)
                    [r, c] = size(dataPts);
                    if (~isRaw)
                        for i = 1:r
                            for j = 1:c
                                dataPts(i, j) = dataPts(i, j) / obj.normalizationAllFields(j);
                            end
                        end
                    else
                        THROW('Do not know how to normlize raw data. Use original zpr_ fields to access what is needed\n');
                    end
                end
                return;
            end
            
            if (~isRaw)
                [dataPts, dataIndex] = obj.cpt_pData.getDataVectorByDataName(dataName, index1, index2);
            else
                [dataPts, dataIndex] = obj.cpt_rawData.getDataVectorByDataName(dataName, index1, index2);
            end
            if (isNormalized)
                if (~isRaw)
                    dataPts = dataPts ./ obj.normalizationAllFields(dataIndex);
                else
                    THROW('Do not know how to normlize raw data. Use original zpr_ fields to access what is needed\n');
                end
            end
            
            % now this is data for critical point for only a specific field
            if (criticalPtPos == 0) % all critical points considered (but now one field)
                return;
            end
            
            % down to one specific critical point
            dataPts = dataPts(criticalPtPos);
        end
        function toFile(obj, fid)
            fprintf(fid, '{\n');
            
            fprintf(fid, 'sn_name\t%s\t', obj.sn_name);
            fprintf(fid, 'sn_ind\t%d\n', obj.sn_ind);
            
            fprintf(fid, 'time_orsv_name\t%s\t', obj.time_orsv_name);
            fprintf(fid, 'time_orsv_ind\t%d\n', obj.time_orsv_ind);
            
            fprintf(fid, 'eps_scalar_name\t%s\t', obj.eps_scalar_name);
            fprintf(fid, 'eps_scalar_ind\t%d\n', obj.eps_scalar_ind);
            
            fprintf(fid, 'sig_scalar_name\t%s\t', obj.sig_scalar_name);
            fprintf(fid, 'sig_scalar_ind\t%d\n', obj.sig_scalar_ind);
            
            fprintf(fid, 'veps_name\t%s\t', obj.veps_name);
            fprintf(fid, 'veps_ind\t%d\n', obj.veps_ind);
            
            fprintf(fid, 'vsig_name\t%s\t', obj.vsig_name);
            fprintf(fid, 'vsig_ind\t%d\n', obj.vsig_ind);
            
            fprintf(fid, 'Y_name\t%s\t', obj.vsig_name);
            fprintf(fid, 'Y_ind\t%d\n', obj.vsig_ind);
            
            fprintf(fid, 'psi_t_name\t%s\t', obj.psi_t_name);
            fprintf(fid, 'psi_t_ind\t%d\n', obj.psi_t_ind);
            
            fprintf(fid, 'psi_r_name\t%s\t', obj.psi_r_name);
            fprintf(fid, 'psi_r_ind\t%d\n', obj.psi_r_ind);
            
            fprintf(fid, 'psi_d_name\t%s\t', obj.psi_d_name);
            fprintf(fid, 'psi_d_ind\t%d\n', obj.psi_d_ind);
            
            fprintf(fid, 'psi_t_npsif_name\t%s\t', obj.psi_t_npsif_name);
            fprintf(fid, 'psi_t_npsif_ind\t%d\n', obj.psi_t_npsif_ind);
            
            fprintf(fid, 'psi_r_npsif_name\t%s\t', obj.psi_r_npsif_name);
            fprintf(fid, 'psi_r_npsif_ind\t%d\n', obj.psi_r_npsif_ind);
            
            fprintf(fid, 'psi_d_npsif_name\t%s\t', obj.psi_d_npsif_name);
            fprintf(fid, 'psi_d_npsif_ind\t%d\n', obj.psi_d_npsif_ind);
            
            fprintf(fid, 'D_name\t%s\t', obj.D_name);
            fprintf(fid, 'D_ind\t%d\n', obj.D_ind);
            
            fprintf(fid, 'Ddot_name\t%s\t', obj.Ddot_name);
            fprintf(fid, 'Ddot_ind\t%d\n', obj.Ddot_ind);

            fprintf(fid, 'psi_d_to_t_name\t%s\t', obj.psi_d_to_t_name);
            fprintf(fid, 'psi_d_to_t_ind\t%d\n', obj.psi_d_to_t_ind);
            
            fprintf(fid, 'psi_r_to_t_name\t%s\t', obj.psi_r_to_t_name);
            fprintf(fid, 'psi_r_to_t_ind\t%d\n', obj.psi_r_to_t_ind);

            % critical points
            fprintf(fid, 'cpt_fullDamage_AddedName\t%s\t', obj.cpt_fullDamage_AddedName);
            fprintf(fid, 'cpt_fullDamage_ind\t%d\n', obj.cpt_fullDamage_ind);
            
            fprintf(fid, 'cpt_final_AddedName\t%s\t', obj.cpt_final_AddedName);
            fprintf(fid, 'cpt_final_ind \t%d\n', obj.cpt_final_ind );
            
            fprintf(fid, 'cpt_maxSts_AddedName\t%s\t', obj.cpt_maxSts_AddedName);
            fprintf(fid, 'cpt_maxSts_ind\t%d\n', obj.cpt_maxSts_ind);
            
            fprintf(fid, 'cpt_homogDini_AddedName\t%s\t', obj.cpt_homogDini_AddedName);
            fprintf(fid, 'cpt_homogDini_ind\t%d\n', obj.cpt_homogDini_ind);
            
            fprintf(fid, 'cpt_extDiniStart_AddedName\t%s\t', obj.cpt_extDiniStart_AddedName);
            fprintf(fid, 'cpt_extDiniStart\t%d\n', obj.cpt_extDiniStart);
            fprintf(fid, 'cpt_numPts\t%d\n', obj.cpt_numPts);
            
            sz = length(obj.cpt_fldNameAddedNames);
            fprintf(fid, 'cpt_fldNameAddedNames\n# sz\n%d\n', sz);
            for i = 1:sz
                fprintf(fid, '%s\t', obj.cpt_fldNameAddedNames{i});
            end
            fprintf(fid, '\n');
            
            fprintf(fid, 'cpt_indices\n');
            gen_toFile_matrix(fid, obj.cpt_indices);
            fprintf(fid, '\n');
            
            fprintf(fid, 'numFieldsBase_zpp\t%d\n', obj.numFieldsBase_zpp);
            fprintf(fid, 'numRawDamage\t%d\n', obj.numRawDamage);
            fprintf(fid, 'numRawData2IntegrateInTime\t%d\n', obj.numRawData2IntegrateInTime);
            fprintf(fid, 'startRawData2IntegrateInTime\t%d\n', obj.startRawData2IntegrateInTime);
            
            fprintf(fid, 'rawStressNameBase\t%s\n', obj.rawStressNameBase);
            fprintf(fid, 'rawStrainNameBase\t%s\n', obj.rawStrainNameBase);
            
            sz = length(obj.rawDataDamageNames);
            fprintf(fid, 'rawDataDamageNames\n# sz\n%d\n', sz);
            for i = 1:sz
                fprintf(fid, '%s\t', obj.rawDataDamageNames{i});
            end
            fprintf(fid, '\n');
            
            sz = length(obj.rawData2IntegrateInTimeNames);
            fprintf(fid, 'rawData2IntegrateInTimeNames\n# sz\n%d\n', sz);
            for i = 1:sz
                fprintf(fid, '%s\t', obj.rawData2IntegrateInTimeNames{i});
            end
            fprintf(fid, '\n');
            
            fprintf(fid, 'E\t%g\n', obj.E);
            fprintf(fid, 'nu\t%g\n', obj.nu);
            fprintf(fid, 'dim\t%d\n', obj.dim);
            fprintf(fid, 'planeStrain\t%d\n', obj.planeStrain);
            fprintf(fid, 'scalarStrsVoigtPos\t%d\n', obj.scalarStrsVoigtPos);
            fprintf(fid, 'scalarStrsSign\t%d\n', obj.scalarStrsSign);
            fprintf(fid, 't0\t%g\n', obj.t0);
            fprintf(fid, 'indexEndMode\t%d\n', obj.indexEndMode);
            fprintf(fid, 'pData_addDataPastFullDamage\t%d\n', obj.pData_addDataPastFullDamage);
            
            fprintf(fid, 'indexEnd\t%g\n', obj.indexEnd);
            
            fprintf(fid, 'sitffnessVoigt\n');
            gen_toFile_matrix(fid, obj.sitffnessVoigt);
            fprintf(fid, '\n');
            
            fprintf(fid, 'complianceVoigt\n');
            gen_toFile_matrix(fid, obj.complianceVoigt);
            fprintf(fid, '\n');
            
            %%%%%%%% critical points
            fprintf(fid, 'damageInitiationZeroTol \t%g\n', obj.damageInitiationZeroTol );
            fprintf(fid, 'damageInInitiationZeroTol \t%g\n', obj.damageInInitiationZeroTol );
            fprintf(fid, 'phi_t_final\t%g\n', obj.phi_t_final);
            
            fprintf(fid, 'normalizationTime\t%g\n', obj.normalizationTime);
            
            fprintf(fid, 'normalizationsUVSEps\n');
            gen_toFile_matrix(fid, obj.normalizationsUVSEps);
            fprintf(fid, '\n');
            
            fprintf(fid, 'normalizationAllFields\n');
            gen_toFile_matrix(fid, obj.normalizationAllFields);
            fprintf(fid, '\n');
            
            extHeader = 'same';
            
            fprintf(fid, 'pData\n');
            obj.pData.toFile(fid, extHeader);
            fprintf(fid, '\n');
            
            fprintf(fid, 'cpt_pData\n');
            obj.cpt_pData.toFile(fid, extHeader);
            fprintf(fid, '\n');
            
            fprintf(fid, 'summaryCriticalVals_pData\n');
            gen_toFile_matrix(fid, obj.summaryCriticalVals_pData);
            fprintf(fid, '\n');
            
            fprintf(fid, 'summaryCriticalTimes_pData\n');
            gen_toFile_matrix(fid, obj.summaryCriticalTimes_pData);
            fprintf(fid, '\n');
            
            fprintf(fid, 'rawData\n');
            obj.rawData.toFile(fid, extHeader);
            fprintf(fid, '\n');
            
            fprintf(fid, 'cpt_rawData\n');
            obj.cpt_rawData.toFile(fid, extHeader);
            fprintf(fid, '\n');
            
            fprintf(fid, 'summaryCriticalVals_rawData\n');
            gen_toFile_matrix(fid, obj.summaryCriticalVals_rawData);
            fprintf(fid, '\n');
            
            fprintf(fid, 'summaryCriticalTimes_rawData\n');
            gen_toFile_matrix(fid, obj.summaryCriticalTimes_rawData);
            fprintf(fid, '\n');
            
            fprintf(fid, '\n}\n');
        end
        
        
        
        function objout = fromFile(obj, fid)
            buf = READ(fid, 's');
            if (strcmp(buf, '{') == 0)
                buf
                THROW('invalid format\n');
            end
            buf = READ(fid, 's');
            while (strcmp(buf, '}') == 0)
                if (strcmp(buf, 'sn_name') == 1)
                    obj.sn_name = READ(fid, 's');
                elseif (strcmp(buf, 'sn_ind') == 1)
                    obj.sn_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'time_orsv_name') == 1)
                    obj.time_orsv_name = READ(fid, 's');
                elseif (strcmp(buf, 'time_orsv_ind') == 1)
                    obj.time_orsv_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'eps_scalar_name') == 1)
                    obj.eps_scalar_name = READ(fid, 's');
                elseif (strcmp(buf, 'eps_scalar_ind') == 1)
                    obj.eps_scalar_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'sig_scalar_name') == 1)
                    obj.sig_scalar_name = READ(fid, 's');
                elseif (strcmp(buf, 'sig_scalar_ind') == 1)
                    obj.sig_scalar_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'veps_name') == 1)
                    obj.veps_name = READ(fid, 's');
                elseif (strcmp(buf, 'veps_ind') == 1)
                    obj.veps_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'vsig_name') == 1)
                    obj.vsig_name = READ(fid, 's');
                elseif (strcmp(buf, 'vsig_ind') == 1)
                    obj.vsig_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'Y_name') == 1)
                    obj.Y_name = READ(fid, 's');
                elseif (strcmp(buf, 'Y_ind') == 1)
                    obj.Y_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'psi_t_name') == 1)
                    obj.psi_t_name = READ(fid, 's');
                elseif (strcmp(buf, 'psi_t_ind') == 1)
                    obj.psi_t_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'psi_r_name') == 1)
                    obj.psi_r_name = READ(fid, 's');
                elseif (strcmp(buf, 'psi_r_ind') == 1)
                    obj.psi_r_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'psi_d_name') == 1)
                    obj.psi_d_name = READ(fid, 's');
                elseif (strcmp(buf, 'psi_d_ind') == 1)
                    obj.psi_d_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'psi_t_npsif_name') == 1)
                    obj.psi_t_npsif_name = READ(fid, 's');
                elseif (strcmp(buf, 'psi_t_npsif_ind') == 1)
                    obj.psi_t_npsif_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'psi_r_npsif_name') == 1)
                    obj.psi_r_npsif_name = READ(fid, 's');
                elseif (strcmp(buf, 'psi_r_npsif_ind') == 1)
                    obj.psi_r_npsif_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'psi_d_npsif_name') == 1)
                    obj.psi_d_npsif_name = READ(fid, 's');
                elseif (strcmp(buf, 'psi_d_npsif_ind') == 1)
                    obj.psi_d_npsif_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'D_name') == 1)
                    obj.D_name = READ(fid, 's');
                elseif (strcmp(buf, 'D_ind') == 1)
                    obj.D_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'Ddot_name') == 1)
                    obj.Ddot_name = READ(fid, 's');
                elseif (strcmp(buf, 'Ddot_ind') == 1)
                    obj.Ddot_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'psi_d_to_t_name') == 1)
                    obj.psi_d_to_t_name = READ(fid, 's');
                elseif (strcmp(buf, 'psi_d_to_t_ind') == 1)
                    obj.psi_d_to_t_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'psi_r_to_t_name') == 1)
                    obj.psi_r_to_t_name = READ(fid, 's');
                elseif (strcmp(buf, 'psi_r_to_t_ind') == 1)
                    obj.psi_r_to_t_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'cpt_fullDamage_AddedName') == 1)
                    obj.cpt_fullDamage_AddedName = READ(fid, 's');
                elseif (strcmp(buf, 'cpt_fullDamage_ind') == 1)
                    obj.cpt_fullDamage_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'cpt_final_AddedName') == 1)
                    obj.cpt_final_AddedName = READ(fid, 's');
                elseif (strcmp(buf, 'cpt_final_ind') == 1)
                    obj.cpt_final_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'cpt_maxSts_AddedName') == 1)
                    obj.cpt_maxSts_AddedName = READ(fid, 's');
                elseif (strcmp(buf, 'cpt_maxSts_ind') == 1)
                    obj.cpt_maxSts_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'cpt_homogDini_AddedName') == 1)
                    obj.cpt_homogDini_AddedName = READ(fid, 's');
                elseif (strcmp(buf, 'cpt_homogDini_ind') == 1)
                    obj.cpt_homogDini_ind = READ(fid, 'd');
                elseif (strcmp(buf, 'cpt_extDiniStart_AddedName') == 1)
                    obj.cpt_extDiniStart_AddedName = READ(fid, 's');
                elseif (strcmp(buf, 'cpt_extDiniStart') == 1)
                    obj.cpt_extDiniStart = READ(fid, 'd');
                elseif (strcmp(buf, 'cpt_numPts') == 1)
                    obj.cpt_numPts = READ(fid, 'd');
                elseif (strcmp(buf, 'cpt_fldNameAddedNames') == 1)
                    sz = READ(fid, 'd');
                    for i = 1:sz
                        obj.cpt_fldNameAddedNames{i} = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'cpt_indices') == 1)
                    obj.cpt_indices = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'numFieldsBase_zpp') == 1)
                    obj.numFieldsBase_zpp = READ(fid, 'd');
                elseif (strcmp(buf, 'numRawDamage') == 1)
                    obj.numRawDamage = READ(fid, 'd');
                elseif (strcmp(buf, 'numRawData2IntegrateInTime') == 1)
                    obj.numRawData2IntegrateInTime = READ(fid, 'd');
                elseif (strcmp(buf, 'startRawData2IntegrateInTime') == 1)
                    obj.startRawData2IntegrateInTime = READ(fid, 'd');
                elseif (strcmp(buf, 'rawStressNameBase') == 1)
                    obj.rawStressNameBase = READ(fid, 's');
                elseif (strcmp(buf, 'rawStrainNameBase') == 1)
                    obj.rawStrainNameBase = READ(fid, 's');
                elseif (strcmp(buf, 'rawDataDamageNames') == 1)
                    sz = READ(fid, 'd');
                    for i = 1:sz
                        obj.rawDataDamageNames{i} = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'rawData2IntegrateInTimeNames') == 1)
                    sz = READ(fid, 'd');
                    for i = 1:sz
                        obj.rawData2IntegrateInTimeNames{i} = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'E') == 1)
                    obj.E = READ(fid, 'g');
                elseif (strcmp(buf, 'nu') == 1)
                    obj.nu = READ(fid, 'g');
                elseif (strcmp(buf, 'E') == 1)
                    obj.E = READ(fid, 'g');
                elseif (strcmp(buf, 'dim') == 1)
                    obj.dim = READ(fid, 'd');
                elseif (strcmp(buf, 'planeStrain') == 1)
                    obj.planeStrain = READ(fid, 'd');
                elseif (strcmp(buf, 'scalarStrsVoigtPos') == 1)
                    obj.scalarStrsVoigtPos = READ(fid, 'd');
                elseif (strcmp(buf, 'scalarStrsSign') == 1)
                    obj.scalarStrsSign = READ(fid, 'd');
                elseif (strcmp(buf, 't0') == 1)
                    obj.t0 = READ(fid, 'g');
                elseif (strcmp(buf, 'indexEndMode') == 1)
                    obj.indexEndMode = READ(fid, 'd');
                elseif (strcmp(buf, 'pData_addDataPastFullDamage') == 1)
                    obj.pData_addDataPastFullDamage = READ(fid, 'd');
                elseif (strcmp(buf, 'indexEnd') == 1)
                    obj.indexEnd = READ(fid, 'd');
                elseif (strcmp(buf, 'sitffnessVoigt') == 1)
                    obj.sitffnessVoigt = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'complianceVoigt') == 1)
                    obj.complianceVoigt = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'damageInitiationZeroTol') == 1)
                    obj.damageInitiationZeroTol = READ(fid, 'g');
                elseif (strcmp(buf, 'damageInInitiationZeroTol') == 1)
                    obj.damageInInitiationZeroTol = READ(fid, 'g');
                elseif (strcmp(buf, 'phi_t_final') == 1)
                    obj.phi_t_final = READ(fid, 'g');
                elseif (strcmp(buf, 'normalizationTime') == 1)
                    obj.normalizationTime = READ(fid, 'g');
                elseif (strcmp(buf, 'normalizationsUVSEps') == 1)
                    obj.normalizationsUVSEps = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'normalizationAllFields') == 1)
                    obj.normalizationAllFields = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'normalizationAllFields') == 1)
                    obj.normalizationAllFields = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'pData') == 1)
                    obj.pData = obj.pData.fromFile(fid);
                elseif (strcmp(buf, 'cpt_pData') == 1)
                    obj.cpt_pData = obj.cpt_pData.fromFile(fid);
                elseif (strcmp(buf, 'summaryCriticalVals_pData') == 1)
                    obj.summaryCriticalVals_pData = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'summaryCriticalTimes_pData') == 1)
                    obj.summaryCriticalTimes_pData = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'rawData') == 1)
                    obj.rawData = obj.rawData.fromFile(fid);
                elseif (strcmp(buf, 'cpt_rawData') == 1)
                    obj.cpt_rawData = obj.cpt_rawData.fromFile(fid);
                elseif (strcmp(buf, 'summaryCriticalVals_rawData') == 1)
                    obj.summaryCriticalVals_rawData = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'summaryCriticalTimes_rawData') == 1)
                    obj.summaryCriticalTimes_rawData = gen_fromFile_matrix(fid);
                else
                    buf
                    THROW('Invalid key\n');
                end
                buf = READ(fid, 's');
            end
            objout = obj;
        end
    end
end