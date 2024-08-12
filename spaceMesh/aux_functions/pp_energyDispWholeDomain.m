classdef pp_energyDispWholeDomain
    properties
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % new normalization if any for which values will be normalized
        newNormalizationsUVSEps = [];
        folder;
        % vectors indexed by face flag
        
        E = 1.0;
        rho = 1.0;
        nu = 0.3;
        planeMode = 1;
        t0 = 0.0;
        % voight stiffness
        voightStiffness = [];
        cd = 1.16024;
        cs = 0.620174;
        taus = [];
        factorDelU = [];
        factorS = [];
        factorDelV = [];
        factorU = [];
        factorV = [];
        % scalar
        strainScale = nan;
        
        % value assumed for a given field to be considered complete (e.g.
        % complete damage)
        step4ScalarCDFs = 0.25;
        
        %%file and index related
        fileNameDat = '';
        fileNameStat = '';
        fid; % file id for data
        pos = pp_stat_pos;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % BC
        maxBCFlag = 0;
        numBCSegments = [];
        domainBCEdges = cell(0);  % will be a cell of domainBCEdges
        domainBCEdgesCombined;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % interior
        maxInteriorFlag = 0;
        numInteriorSegmentsByFlagByFlag = [];
        domainInteriorEdgesByFlagByFlag = cell(0);  % will be a cell of domainInteriorEdgesByFlagByFlag
        domainInteriorEdgesByFlagCombined;
        domainInteriorEdgesByAngle = cell(0);
        % split angles between [0 180] (with a shift to negative values so
        % zero is not the min value) to numAngleRanges angle ranges, stored
        % in domainInteriorEdgesByAngle
        numAngleRanges = 18;
        delAngleRanges = 10; %180 / numAngleRanges;
        minAngleRanges; % - 180 / numAngleRanges / 2
        numInteriorSegmentsByFlagByAngle = [];
        
        domainCentroid = [0 0];
        circumference = 0.0;
        boundingBox = [0 0 0 0]; % [xmin, xmax, ymin, ymax]
        time = 0.0;
        % number of segments
        countSegment = 0;
        countPt = 0;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % strain, stress values homogenized
        %%% for both strain and stress values are either raw
        %%% (nonsymmetric: for strain grad U, for stress formula used,
        %%% not necessarily symmetric)
        % sym is the symmetric version of it
        sym = 1;
        raw = 2;
        
        % [1] Ren_2011_Chen_JS_10_Micro-cracks informed damage models for brittle solids.pdf
        % B stands for value computed from domain boundary
        % indices on stress types
        sts_Bhomog = 1;  % [1] eqn 7
        sts_Bsimple = 2; % this is the simple way Philip and I homogenized before, not fully correct but simple ...
        
        % indices on strain
        
        stn_Bhomog = 1;  % stnBar = \int_partialDomain u o n dS, [1] eqn (8)
        stn_Ihomog = 2;  % stnAve = \int_Domain eps dV  [1] eqn (15)
        stn_Chomog = 3;  % stnCracks = \int_Gamma Delu * n dS,    Gamma is crack manifold
        % we have Bhomog (real homogenized strain) = Ihomog + Chomog
        
        stress_homogenized = cell(0);
        strain_homogenized = cell(0);
        % 1/A \int_partial Domain s.n dS = 1/A \int (div s) dV  = 1/A
        % (\int (rho(a - b)) dV = Dynamic and source term effects
        ave_Deviation_Rhoab = [0; 0];
        ratio_Rhoab_2_stress = 0;  % = ave_Deviation_Rhoab / norm(stress) / length
        ratio_crackStrain2totalStrain = 0; % = norm(crackStrain) / norm(totalStrain)
        
        area = 0;
        fractureDissPower = 0;
        fractureDissPower_0 = 0;
        fractureDissPower_1 = 0;
        fractureDissPower_1toTotal = 0;
        
        bcPower_0 = 0;
        bcPower_1 = 0;
        bcPower = 0;
        simpleBC = 0;
    end
    methods
        function objout = Initialize(obj, fileNameDatIn, domainCentroidIn, step4ScalarCDFsIn, numAngleRangesIn, crackBinSizeIn, newNormalizationsUVSEpsIn)
            if (nargin < 4)
                step4ScalarCDFsIn = nan;
            end
            if (nargin < 5)
                numAngleRangesIn = nan;
            end
            if (nargin < 6)
                crackBinSizeIn = nan;
            end
            if (nargin < 7)
                newNormalizationsUVSEpsIn = [];
            end
            if (~isnan(numAngleRangesIn))
                obj.numAngleRanges = numAngleRangesIn;
            end
            [obj.folder, b, c] = fileparts(fileNameDatIn);
            if (~isnan(step4ScalarCDFsIn))
                obj.step4ScalarCDFs = step4ScalarCDFsIn;
            end
            if (obj.numAngleRanges > 0)
                obj.delAngleRanges = 180 / obj.numAngleRanges;
                obj.numInteriorSegmentsByFlagByAngle = zeros(obj.numAngleRanges, 1);
                obj.minAngleRanges = -180 / obj.numAngleRanges / 2;
                obj.domainInteriorEdgesByAngle = cell(obj.numAngleRanges, 1);
                crackBinSizeIn4AngleSpans = 0;
                for anglei = 1:obj.numAngleRanges
                    obj.domainInteriorEdgesByAngle{anglei} = pp_energyDispInterior;
                    crackBinMinAngle = obj.minAngleRanges + (anglei - 1) * obj.delAngleRanges;
                    crackBinMaxAngle = crackBinMinAngle + obj.delAngleRanges;
                    obj.domainInteriorEdgesByAngle{anglei} = obj.domainInteriorEdgesByAngle{anglei}.Initiallize(obj.step4ScalarCDFs, crackBinSizeIn4AngleSpans, crackBinMaxAngle, crackBinMinAngle);
                end
            end
            if (~isnan(step4ScalarCDFsIn))
                obj.step4ScalarCDFs = step4ScalarCDFsIn;
            end
            obj.domainCentroid = domainCentroidIn;
            fid = fopen(fileNameDatIn, 'r');
            if (fid < 0)
                msg = ['Cannot open', fileNameDatIn, '\n'];
                obj.fid = -1;
                THROW(msg);
            else
                obj.fid = fid;
            end
            obj.fileNameDat = fileNameDatIn;
            obj.fileNameStat = strrep(obj.fileNameDat, '.txt', '.stat');
            obj.pos = obj.pos.Initialize(obj.fileNameStat);
            obj.domainBCEdgesCombined = pp_energyDispBoundary;
            obj.domainInteriorEdgesByFlagCombined = pp_energyDispInterior;
            
            obj.newNormalizationsUVSEps = newNormalizationsUVSEpsIn;
            sz = length(obj.newNormalizationsUVSEps);
            if (sz > 3)
                obj.strainScale = obj.newNormalizationsUVSEps(4);
            end
            objout = obj;
        end
        function objout = ReadFromDataFile(obj)
            strsTracLocCrd = 1;
            tractionGiven = 1;
            %zzz assuming velocities for boundaries are printed in delV
            %field (not done now) and this is v in local coordinate
            vsLocalCrd = 1;
            obj.countSegment = 0;
            obj.countPt = 0;
            
            fid = obj.fid;
            [buf, neof] = fscanf(fid, '%s', 1);
            while (neof)
                [numPoints, eof] = fscanf(fid, '%d', 1);
                obj.countSegment = obj.countSegment  + 1;
                Xs = cell(numPoints, 1);
                Us = cell(numPoints, 1);
                TrcnLocCrds = cell(numPoints, 1);
                VsLocalCrd = cell(numPoints, 1);
                delVsLocalCrd = cell(numPoints, 1);
                
                interiorFracScalars = cell(numPoints, 1);
                delUsLocalCrd = cell(numPoints, 1);
                
                for pt = 1:numPoints
                    farg = FGETL(fid);
                    args = strsplit(farg);
                    flag = str2num(args{obj.pos.flgindex});
                    isBoundary = str2num(args{obj.pos.bindex});
                    ptTime = str2num(args{obj.pos.tindex});
                    obj.countPt = obj.countPt + 1;
                    obj.time = obj.time + ptTime;
                    
                    
                    if ((length(obj.factorDelU) < flag) || (abs(obj.factorDelU(flag)) < 1e-190))
                        fileNameSc = [obj.folder, '/cohesiveScales', num2str(flag), '.txt'];
                        fidSc = fopen(fileNameSc, 'r');
                        if (fidSc < 0)
                            tau1ep16em2 = contains(obj.folder, 'tau1ep16em2');
                            tau1ep16em3 = contains(obj.folder, 'tau1ep16em3');
                            if (tau1ep16em3 || tau1ep16em2)
                                factDelU = 0.0001;
                                factS = 0.1;
                                factDelV = 2; % set by mistake
                                factU = 1;
                                factV = factDelV;
                                tau = 0.00116024;
                                
                                obj.rho = 1;
                                obj.E = 1;
                                obj.nu = 0.3;
                                obj.planeMode = 1;
                                obj.cd = 1.16024;
                                obj.cs = 0.620174;

                                obj.t0 = 0;
                                obj.voightStiffness = [];
                                
                                if (tau1ep16em2)
                                    factDelU = factDelU * 10;
                                    tau = tau * 10;
                                end
                            else
                                msg = ['Cannot open file with scales ', fileNameSc, ' for face flag ', num2str(flag)];
                                THROW('msg');
                            end
                        else
                            buf = fscanf(fidSc, '%s', 4);
                            factDelU = fscanf(fidSc, '%g', 1);
                            buf = fscanf(fidSc, '%s', 1);
                            factS = fscanf(fidSc, '%g', 1);
                            buf = fscanf(fidSc, '%s', 1);
                            factDelV = fscanf(fidSc, '%g', 1);
                            buf = fscanf(fidSc, '%s', 1);
                            factU = fscanf(fidSc, '%g', 1);
                            factV = factDelV;
                            tau = nan;

                            [buf, neof] = fscanf(fidSc, '%s', 1);
                            if (neof)
                                tau = fscanf(fidSc, '%g', 1);
                                buf = fscanf(fidSc, '%s', 1);
                                obj.rho = fscanf(fidSc, '%g', 1);
                                buf = fscanf(fidSc, '%s', 1);
                                obj.E = fscanf(fidSc, '%g', 1);
                                buf = fscanf(fidSc, '%s', 1);
                                obj.nu = fscanf(fidSc, '%g', 1);
                                buf = fscanf(fidSc, '%s', 1);
                                obj.planeMode = fscanf(fidSc, '%d', 1);
                                buf = fscanf(fidSc, '%s', 1);
                                obj.cd = fscanf(fidSc, '%g', 1);
                                buf = fscanf(fidSc, '%s', 1);
                                obj.cs = fscanf(fidSc, '%g', 1);
                            end
                            [buf, neof] = fscanf(fidSc, '%s', 1);
                            if (neof)
                                if (strcmp(buf, 't0') ~= 1)
                                    msg = ['In file ', fileNameSc ' key must be t0, but it is ', buf];
                                    THROW(msg);
                                end
                                obj.t0 = fscanf(fidSc, '%g', 1);
                            end
                            fclose(fidSc);
                        end
                        sz = length(obj.newNormalizationsUVSEps);
                        if (sz < 3)
                            obj.newNormalizationsUVSEps(3) = factS;
                        end
                        if (sz < 2)
                            obj.newNormalizationsUVSEps(2) = factDelV;
                        end
                        if (sz < 1)
                            obj.newNormalizationsUVSEps(1) = factDelU;
                        end
                        %                         if (~isnan(obj.newNormalizationsUVSEps))
                        %                             sz = length(obj.newNormalizationsUVSEps);
                        %                             if (sz > 0)
                        %                                 factDelU = factDelU / obj.newNormalizationsUVSEps(1);
                        %                                 factU = factU / obj.newNormalizationsUVSEps(1);
                        %                                 if (sz > 1)
                        %                                     factDelV = factDelV / obj.newNormalizationsUVSEps(2);
                        %                                     factV = factV / obj.newNormalizationsUVSEps(2);
                        %                                     if (sz > 2)
                        %                                         factS = factS / obj.newNormalizationsUVSEps(3);
                        %                                     end
                        %                                 end
                        %                             end
                        %                         end
                        if (isnan(tau))
                            tau = factDelU / factDelV;
                        end
                        obj.taus(flag) = tau;
                        obj.factorS(flag) = factS;
                        obj.factorU(flag) = factU;
                        obj.factorDelU(flag) = factDelU;
                        obj.factorV(flag) = factV;
                        obj.factorDelV(flag) = factDelV;
                    else
                        factS = obj.factorS(flag);
                        factU = obj.factorU(flag);
                        factDelU = obj.factorDelU(flag);
                        factV = obj.factorV(flag);
                        factDelV = obj.factorDelV(flag);
                    end
                    if (isnan(obj.strainScale) || (obj.strainScale < 0))
                        obj.strainScale = factS / obj.E;
                    end
                    
                    Xs{pt} = [str2double(args{obj.pos.xindex}); str2double(args{obj.pos.xindex + 1})];
                    % in local coordinate
                    TrcnLocCrds{pt} = factS * [str2double(args{obj.pos.s0indabs}); str2double(args{obj.pos.s0indabs + 1})];
                    Us{pt} = factU * [str2double(args{obj.pos.u0indabs}); str2double(args{obj.pos.u0indabs + 1})];
                    VsLocalCrd{pt} = factV * [str2double(args{obj.pos.v0indabs}); str2double(args{obj.pos.v0indabs + 1})];
                    delVsLocalCrd{pt} = factDelV * [str2double(args{obj.pos.delv0indabs}); str2double(args{obj.pos.delv0indabs + 1})];
                    if (~isBoundary)
                        st = obj.pos.interiorFracPosSt;
                        en = obj.pos.interiorFracPosEn;
                        for i = st:en
                            interiorFracScalars{pt}(i - st + 1) = str2double(args{i});
                        end
                        delUsLocalCrd{pt} = factDelU * [str2double(args{obj.pos.delu0indabs}); str2double(args{obj.pos.delu0indabs + 1})];
                    end
                end
                if (isBoundary)
                    if ((flag > obj.maxBCFlag) || (isempty(obj.domainBCEdges{flag})))
                        obj.domainBCEdges{flag} = pp_energyDispBoundary;
                        obj.maxBCFlag = length(obj.domainBCEdges);
                        obj.numBCSegments(flag) = 1;
                    else
                        obj.numBCSegments(flag) = obj.numBCSegments(flag) + 1;
                    end
                    obj.domainBCEdges{flag} = obj.domainBCEdges{flag}.UpdateBySegment(Xs, Us, TrcnLocCrds, VsLocalCrd, strsTracLocCrd, tractionGiven, vsLocalCrd);
                else
                    if ((flag > obj.maxInteriorFlag) || (isempty(obj.domainInteriorEdgesByFlagByFlag{flag})))
                        obj.domainInteriorEdgesByFlagByFlag{flag} = pp_energyDispInterior;
                        obj.domainInteriorEdgesByFlagByFlag{flag} = obj.domainInteriorEdgesByFlagByFlag{flag}.Initiallize(obj.step4ScalarCDFs);
                        obj.maxInteriorFlag = length(obj.domainInteriorEdgesByFlagByFlag);
                        obj.numInteriorSegmentsByFlagByFlag(flag) = 1;
                    else
                        obj.numInteriorSegmentsByFlagByFlag(flag) = obj.numInteriorSegmentsByFlagByFlag(flag) + 1;
                    end
                    [obj.domainInteriorEdgesByFlagByFlag{flag}, crackAngleDeg] = obj.domainInteriorEdgesByFlagByFlag{flag}.UpdateBySegment(Xs, delUsLocalCrd, TrcnLocCrds, delVsLocalCrd, interiorFracScalars);
                    if (obj.numAngleRanges > 0)
                        angleDiff = mod(crackAngleDeg - obj.minAngleRanges, 180);
                        anglei = floor(angleDiff / obj.delAngleRanges) + 1;
                        if (anglei > obj.numAngleRanges)
                            anglei = obj.numAngleRanges;
                        end
                        obj.numInteriorSegmentsByFlagByAngle(anglei) = obj.numInteriorSegmentsByFlagByAngle(anglei) + 1;
                        [obj.domainInteriorEdgesByAngle{anglei}, crackAngleDeg] = obj.domainInteriorEdgesByAngle{anglei}.UpdateBySegment(Xs, delUsLocalCrd, TrcnLocCrds, delVsLocalCrd, interiorFracScalars);
                    end
                end
                [buf, neof] = fscanf(fid, '%s', 1);
            end
            fclose(obj.fid);
            objout = obj;
        end
        function objout = Finalize(obj)
            if (obj.countPt > 0)
                obj.time = obj.time / obj.countPt;
            end
            if (obj.maxInteriorFlag > 0)
                obj.domainInteriorEdgesByFlagCombined = obj.domainInteriorEdgesByFlagCombined.Combine(obj.domainInteriorEdgesByFlagByFlag);
                for flag = 1:obj.maxInteriorFlag
                    if (obj.numInteriorSegmentsByFlagByFlag(flag) == 0)
                        continue;
                    end
                    obj.domainInteriorEdgesByFlagByFlag{flag} = obj.domainInteriorEdgesByFlagByFlag{flag}.Finalize();
                end
            end
            if (obj.countSegment > 0)
                obj.domainInteriorEdgesByFlagCombined = obj.domainInteriorEdgesByFlagCombined.Finalize();
                if (obj.numAngleRanges > 0)
                    for anglei = 1:obj.numAngleRanges
                        if (obj.numInteriorSegmentsByFlagByAngle(anglei) == 0)
                            continue;
                        end
                        obj.domainInteriorEdgesByAngle{anglei} = obj.domainInteriorEdgesByAngle{anglei}.Finalize();
                    end
                end
            end
            
            %%%%%%%%%%%%%%% Interior part
            obj.domainBCEdgesCombined = obj.domainBCEdgesCombined.Combine(obj.domainBCEdges);
            obj.boundingBox = [obj.domainBCEdgesCombined.crdMin, obj.domainBCEdgesCombined.crdMax];
            
            %%%%%%%%%%%%%%% Stress, strain
            dim = 2;
            A = obj.domainBCEdgesCombined.int_xn / dim;
            obj.area = A;
            obj.circumference = obj.domainBCEdgesCombined.totalLength;
            
            stsn_mode = 2;
            stn_num = obj.stn_Chomog;
            sts_num = obj.sts_Bsimple;
            obj.stress_homogenized = cell(stsn_mode, sts_num);
            obj.strain_homogenized = cell(stsn_mode, stn_num);
            for mode = 1:stsn_mode
                for stsi = 1:sts_num
                    obj.stress_homogenized{mode, stsi} = zeros(dim, dim);
                end
                for stni = 1:stn_num
                    obj.strain_homogenized{mode, stni} = zeros(dim, dim);
                end
            end
            %           % taking care of stresses
            simpBC = ((obj.maxBCFlag == 5) && (obj.numBCSegments(1) == 0) && ...
                (obj.numBCSegments(2) > 0) && (obj.numBCSegments(3) > 0)  && (obj.numBCSegments(4) > 0) && (obj.numBCSegments(5) > 0));
            obj.simpleBC = simpBC;
            % computing simple stress BC
            if (simpBC)
                stressB = obj.domainBCEdges{2}.int_snox / A;
                stressR = obj.domainBCEdges{3}.int_snox / A;
                stressT = obj.domainBCEdges{4}.int_snox / A;
                stressL = obj.domainBCEdges{5}.int_snox / A;
                simpleS = zeros(dim, dim);
                tmp = stressR + stressL;
                simpleS(1, :) = tmp(1, :);
                tmp = stressB + stressT;
                simpleS(2, :) = tmp(2, :);
                obj.stress_homogenized{obj.raw, obj.sts_Bsimple} = simpleS;
            end
            obj.stress_homogenized{obj.raw, obj.sts_Bhomog} = obj.domainBCEdgesCombined.int_snox / A;
            
            % strains
            obj.strain_homogenized{obj.raw, obj.stn_Bhomog} = obj.domainBCEdgesCombined.int_un / A;
            if (obj.maxInteriorFlag > 0)
                obj.strain_homogenized{obj.raw, obj.stn_Chomog} = obj.domainInteriorEdgesByFlagCombined.int_un / A;
                obj.strain_homogenized{obj.raw, obj.stn_Ihomog} = obj.strain_homogenized{obj.raw, obj.stn_Bhomog} - obj.strain_homogenized{obj.raw, obj.stn_Chomog};
                obj.fractureDissPower = obj.domainInteriorEdgesByFlagCombined.int_vsn;
                obj.fractureDissPower_0 = obj.domainInteriorEdgesByFlagCombined.int_vsn_0;
                obj.fractureDissPower_1 = obj.domainInteriorEdgesByFlagCombined.int_vsn_1;
                obj.fractureDissPower_1toTotal = obj.domainInteriorEdgesByFlagCombined.int_vsn_1toTotal;
                
            else
                obj.strain_homogenized{obj.raw, obj.stn_Ihomog} = obj.strain_homogenized{obj.raw, obj.stn_Bhomog};
            end
            for stsi = 1:sts_num
                obj.stress_homogenized{obj.sym, stsi} = 0.5 * (obj.stress_homogenized{obj.raw, stsi} + obj.stress_homogenized{obj.raw, stsi}');
            end
            for stni = 1:stn_num
                obj.strain_homogenized{obj.sym, stni} = 0.5 * (obj.strain_homogenized{obj.raw, stni} + obj.strain_homogenized{obj.raw, stni}');
            end
            
            obj.ave_Deviation_Rhoab = obj.domainBCEdgesCombined.int_sn / A;
            normStress = gen_matNorm(obj.stress_homogenized{obj.sym, obj.sts_Bhomog});
            if (normStress ~= 0)
                obj.ratio_Rhoab_2_stress = norm(obj.ave_Deviation_Rhoab) / (normStress / sqrt(A)); % = norm(crackStrain) / norm(totalStrain)
            else
                obj.ratio_Rhoab_2_stress = nan;
            end
            normTotalStrain = gen_matNorm(obj.strain_homogenized{obj.sym, obj.stn_Bhomog});
            normCrackStrain = gen_matNorm(obj.strain_homogenized{obj.sym, obj.stn_Chomog});
            if (normCrackStrain ~= 0)
                obj.ratio_crackStrain2totalStrain = normCrackStrain / normTotalStrain;
            else
                obj.ratio_crackStrain2totalStrain = nan;
            end
            
            %             if (obj.strainScale ~= 1)
            %                 fact = obj.strainScale;
            %                 for mode = 1:stsn_mode
            %                     for stni = 1:stn_num
            %                         obj.strain_homogenized{mode, stni} = fact * obj.strain_homogenized{mode, stni};
            %                     end
            %                 end
            %             end
            
            obj.bcPower_0 = obj.domainBCEdgesCombined.int_vsn_0;
            obj.bcPower_1 = obj.domainBCEdgesCombined.int_vsn_1;
            obj.bcPower = obj.domainBCEdgesCombined.int_vsn;
            
            objout = obj;
        end
        function objout = MainFunction(obj, fileNameDatIn, domainCentroidIn, step4ScalarCDFsIn, numAngleRangesIn, crackBinSizeIn, newNormalizationsUVSEpsIn)
            if (nargin < 4)
                step4ScalarCDFsin = nan;
            end
            if (nargin < 5)
                numAngleRangesIn = nan;
            end
            if (nargin < 6)
                crackBinSizeIn = nan;
            end
            if (nargin < 7)
                newNormalizationsUVSEpsIn = nan;
            end
            [r, c] = size(domainCentroidIn);
            if (r == 1)
                domainCentroidIn = domainCentroidIn';
            end
            
            obj = obj.Initialize(fileNameDatIn, domainCentroidIn, step4ScalarCDFsIn, numAngleRangesIn, crackBinSizeIn, newNormalizationsUVSEpsIn);
            obj = obj.ReadFromDataFile();
            obj = obj.Finalize();
            objout = obj;
        end
        function toFile(obj, fid, nbegline)
            if nargin < 2
                nbegline = 0;
            end
            gen_printTab(fid, nbegline);
            fprintf(fid, '{\n');
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'time\t%g\n', obj.time);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'folder\t%s\n', obj.folder);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'fileNameDat\t%s\n', obj.fileNameDat);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'fileNameStat\t%s\n', obj.fileNameStat);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'countSegment\t%d\n', obj.countSegment);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'countPt\t%d\n', obj.countPt);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'domainCentroid\t');
            gen_toFile_matrix(fid, obj.domainCentroid);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'area\t%g\n', obj.area);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'circumference\t%g\n', obj.circumference);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'boundingBox\t');
            gen_toFile_matrix(fid, obj.boundingBox);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'ratio_Rhoab_2_stress\t%g\n', obj.ratio_Rhoab_2_stress);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'ratio_crackStrain2totalStrain\t%g\n', obj.ratio_crackStrain2totalStrain);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'ave_Deviation_Rhoab\t');
            gen_toFile_matrix(fid, obj.ave_Deviation_Rhoab);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'fractureDissPower\t%g\n', obj.fractureDissPower);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'fractureDissPower_0\t%g\n', obj.fractureDissPower_0);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'fractureDissPower_1\t%g\n', obj.fractureDissPower_1);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'fractureDissPower_1toTotal\t%g\n', obj.fractureDissPower_1toTotal);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'bcPower_0\t%g\n', obj.bcPower_0);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'bcPower_1\t%g\n', obj.bcPower_1);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'bcPower\t%g\n', obj.bcPower);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'sym\t%d\n', obj.sym);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'raw\t%d\n', obj.raw);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'sts_Bhomog\t%d\n', obj.sts_Bhomog);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'sts_Bsimple\t%d\n', obj.sts_Bsimple);
            
            [r, c] = size(obj.stress_homogenized);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'stress_homogenized\trows\t%d\tcols\t%d\n', r, c);
            for i = 1:r
                for j = 1:c
                    gen_printTab(fid, nbegline + 1);
                    fprintf(fid, '[ %d , %d ]\t', i, j);
                    gen_toFile_matrix(fid, obj.stress_homogenized{i, j});
                end
            end
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'stn_Bhomog\t%d\n', obj.stn_Bhomog);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'stn_Ihomog\t%d\n', obj.stn_Ihomog);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'stn_Chomog\t%d\n', obj.stn_Chomog);
            
            [r, c] = size(obj.strain_homogenized);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'strain_homogenized\trows\t%d\tcols\t%d\n', r, c);
            for i = 1:r
                for j = 1:c
                    gen_printTab(fid, nbegline + 1);
                    fprintf(fid, '[ %d , %d ]\t', i, j);
                    gen_toFile_matrix(fid, obj.strain_homogenized{i, j});
                end
            end
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'newNormalizationsUVSEps\t');
            gen_toFile_matrix(fid, obj.newNormalizationsUVSEps);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'factorDelU\t');
            gen_toFile_matrix(fid, obj.factorDelU);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'factorS\t');
            gen_toFile_matrix(fid, obj.factorS);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'factorDelV\t');
            gen_toFile_matrix(fid, obj.factorDelV);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'factorU\t');
            gen_toFile_matrix(fid, obj.factorU);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'factorV\t');
            gen_toFile_matrix(fid, obj.factorV);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'strainScale\t%g\n', obj.strainScale);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'E\t%g\n', obj.E);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'rho\t%g\n', obj.rho);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'nu\t%g\n', obj.nu);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'planeMode\t%d\n', obj.planeMode);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'cd\t%g\n', obj.cd);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'cs\t%g\n', obj.cs);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'taus\t');
            gen_toFile_matrix(fid, obj.taus);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'step4ScalarCDFs\t%g\n', obj.step4ScalarCDFs);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'simpleBC\t%d\n', obj.simpleBC);
            gen_printTab(fid, nbegline);
            fprintf(fid, '\nmaxBCFlag\t%d\n', obj.maxBCFlag);
            if (obj.maxBCFlag > 0)
                gen_printTab(fid, nbegline);
                fprintf(fid, 'domainBCEdgesCombined\n');
                obj.domainBCEdgesCombined.toFile(fid, nbegline + 1);
            end
            
            gen_printTab(fid, nbegline);
            fprintf(fid, '\nmaxInteriorFlag\t%d\n', obj.maxInteriorFlag);
            if (obj.maxInteriorFlag > 0)
                gen_printTab(fid, nbegline);
                fprintf(fid, 'domainInteriorEdgesByFlagCombined\n');
                obj.domainInteriorEdgesByFlagCombined.toFile(fid, nbegline + 1);
            end
            gen_printTab(fid, nbegline);
            fprintf(fid, '\nnumBCSegments\t');
            gen_toFile_matrix(fid, obj.numBCSegments);
            sz = length(obj.domainBCEdges);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'domainBCEdges\tsz\t%d\n', sz);
            for i = 1:sz
                gen_printTab(fid, nbegline + 1);
                fprintf(fid, '[ %d ]\n', i);
                if (obj.numBCSegments(i) == 0)
                    gen_printTab(fid, nbegline + 1);
                    fprintf(fid, 'null\n');
                else
                    obj.domainBCEdges{i}.toFile(fid, nbegline + 1);
                end
            end
            
            gen_printTab(fid, nbegline);
            fprintf(fid, '\nnumInteriorSegmentsByFlagByFlag\t');
            gen_toFile_matrix(fid, obj.numInteriorSegmentsByFlagByFlag);
            sz = length(obj.domainInteriorEdgesByFlagByFlag);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'domainInteriorEdgesByFlagByFlag\tsz\t%d\n', sz);
            for i = 1:sz
                gen_printTab(fid, nbegline + 1);
                fprintf(fid, '[ %d ]\n', i);
                if (obj.numInteriorSegmentsByFlagByFlag(i) == 0)
                    gen_printTab(fid, nbegline + 1);
                    fprintf(fid, 'null\n');
                else
                    obj.domainInteriorEdgesByFlagByFlag{i}.toFile(fid, nbegline + 1);
                end
            end
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'numAngleRanges\t%d\n', obj.numAngleRanges);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'delAngleRanges\t%g\n', obj.delAngleRanges);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'minAngleRanges\t%g\n', obj.minAngleRanges);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, '\nnumInteriorSegmentsByFlagByAngle\t');
            gen_toFile_matrix(fid, obj.numInteriorSegmentsByFlagByAngle);
            sz = length(obj.domainInteriorEdgesByAngle);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'domainInteriorEdgesByAngle\tsz\t%d\n', sz);
            for i = 1:sz
                gen_printTab(fid, nbegline + 1);
                fprintf(fid, '[ %d ]\n', i);
                if (obj.numInteriorSegmentsByFlagByAngle(i) == 0)
                    gen_printTab(fid, nbegline + 1);
                    fprintf(fid, 'null\n');
                else
                    obj.domainInteriorEdgesByAngle{i}.toFile(fid, nbegline + 1);
                end
            end
            
            gen_printTab(fid, nbegline);
            fprintf(fid, '\npos\t');
            obj.pos.toFile(fid, nbegline + 1);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, '}\n');
        end
        function objout = fromFile(obj, fid)
            [buf, neof] = fscanf(fid, '%s', 1);
            if (strcmp(buf, '{') == 0)
                buf
                THROW('invalid format\n');
            end
            [buf, neof] = fscanf(fid, '%s', 1);
            while ((strcmp(buf, '}') == 0) && (neof))
                if (strcmp(buf, 'time') == 1)
                    obj.time = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'folder') == 1)
                    obj.folder = fscanf(fid, '%s', 1);
                elseif (strcmp(buf, 'fileNameDat') == 1)
                    obj.fileNameDat = fscanf(fid, '%s', 1);
                elseif (strcmp(buf, 'fileNameStat') == 1)
                    obj.fileNameStat = fscanf(fid, '%s', 1);
                elseif (strcmp(buf, 'countSegment') == 1)
                    obj.countSegment = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'countPt') == 1)
                    obj.countPt = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'domainCentroid') == 1)
                    obj.domainCentroid = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'area') == 1)
                    obj.area = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'circumference') == 1)
                    obj.circumference = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'boundingBox') == 1)
                    obj.boundingBox = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'ratio_Rhoab_2_stress') == 1)
                    obj.ratio_Rhoab_2_stress = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'ratio_crackStrain2totalStrain') == 1)
                    obj.ratio_crackStrain2totalStrain = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'ave_Deviation_Rhoab') == 1)
                    obj.ave_Deviation_Rhoab = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'fractureDissPower') == 1)
                    obj.fractureDissPower = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'fractureDissPower_0') == 1)
                    obj.fractureDissPower_0 = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'fractureDissPower_1') == 1)
                    obj.fractureDissPower_1 = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'fractureDissPower_1toTotal') == 1)
                    obj.fractureDissPower_1toTotal = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'bcPower_0') == 1)
                    obj.bcPower_0 = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'bcPower_1') == 1)
                    obj.bcPower_1 = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'bcPower') == 1)
                    obj.bcPower = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'sym') == 1)
                    obj.sym = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'raw') == 1)
                    obj.raw = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'sts_Bhomog') == 1)
                    obj.sts_Bhomog = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'sts_Bsimple') == 1)
                    obj.sts_Bsimple = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'stress_homogenized') == 1)
                    buf = fscanf(fid, '%s', 1);
                    r = fscanf(fid, '%d', 1);
                    buf = fscanf(fid, '%s', 1);
                    c = fscanf(fid, '%d', 1);
                    obj.stress_homogenized = cell(r, c);
                    for i = 1:r
                        for j = 1:c
                            buf = fscanf(fid, '%s', 5);
                            obj.stress_homogenized{i, j} =  gen_fromFile_matrix(fid);
                        end
                    end
                elseif (strcmp(buf, 'stn_Bhomog') == 1)
                    obj.stn_Bhomog = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'stn_Ihomog') == 1)
                    obj.stn_Ihomog = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'stn_Chomog') == 1)
                    obj.stn_Chomog = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'strain_homogenized') == 1)
                    buf = fscanf(fid, '%s', 1);
                    r = fscanf(fid, '%d', 1);
                    buf = fscanf(fid, '%s', 1);
                    c = fscanf(fid, '%d', 1);
                    obj.strain_homogenized = cell(r, c);
                    for i = 1:r
                        for j = 1:c
                            buf = fscanf(fid, '%s', 5);
                            obj.strain_homogenized{i, j} =  gen_fromFile_matrix(fid);
                        end
                    end
                elseif (strcmp(buf, 'newNormalizationsUVSEps') == 1)
                    obj.newNormalizationsUVSEps = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'factorDelU') == 1)
                    obj.factorDelU = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'factorS') == 1)
                    obj.factorS = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'factorDelV') == 1)
                    obj.factorDelV = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'factorU') == 1)
                    obj.factorU = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'factorV') == 1)
                    obj.factorV = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'strainScale') == 1)
                    obj.strainScale = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'E') == 1)
                    obj.E = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'rho') == 1)
                    obj.rho = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'nu') == 1)
                    obj.nu = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'planeMode') == 1)
                    obj.planeMode = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'cd') == 1)
                    obj.cd = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'cs') == 1)
                    obj.cs = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'taus') == 1)
                    obj.taus = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'step4ScalarCDFs') == 1)
                    obj.step4ScalarCDFs = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'simpleBC') == 1)
                    obj.simpleBC = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'maxBCFlag') == 1)
                    obj.maxBCFlag = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'domainBCEdgesCombined') == 1)
                    obj.domainBCEdgesCombined = pp_energyDispBoundary;
                    obj.domainBCEdgesCombined = obj.domainBCEdgesCombined.fromFile(fid);
                    
                elseif (strcmp(buf, 'maxInteriorFlag') == 1)
                    obj.maxInteriorFlag = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'domainInteriorEdgesByFlagCombined') == 1)
                    obj.domainInteriorEdgesByFlagCombined = pp_energyDispInterior;
                    obj.domainInteriorEdgesByFlagCombined = obj.domainInteriorEdgesByFlagCombined.fromFile(fid);
                    
                elseif (strcmp(buf, 'numBCSegments') == 1)
                    obj.numBCSegments = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'domainBCEdges') == 1)
                    buf = fscanf(fid, '%s', 1);
                    sz = fscanf(fid, '%d', 1);
                    obj.domainBCEdges = cell(sz, 1);
                    for i = 1:sz
                        buf = fscanf(fid, '%s', 3);
                        if (obj.numBCSegments(i) == 0)
                            buf = fscanf(fid, '%s', 1);
                        else
                            obj.domainBCEdges{i} = pp_energyDispBoundary;
                            obj.domainBCEdges{i} = obj.domainBCEdges{i}.fromFile(fid);
                        end
                    end
                    
                elseif (strcmp(buf, 'numInteriorSegmentsByFlagByFlag') == 1)
                    obj.numInteriorSegmentsByFlagByFlag = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'domainInteriorEdgesByFlagByFlag') == 1)
                    buf = fscanf(fid, '%s', 1);
                    sz = fscanf(fid, '%d', 1);
                    obj.domainInteriorEdgesByFlagByFlag = cell(sz, 1);
                    for i = 1:sz
                        buf = fscanf(fid, '%s', 3);
                        if (obj.numInteriorSegmentsByFlagByFlag(i) == 0)
                            buf = fscanf(fid, '%s', 1);
                        else
                            obj.domainInteriorEdgesByFlagByFlag{i} = pp_energyDispInterior;
                            obj.domainInteriorEdgesByFlagByFlag{i} = obj.domainInteriorEdgesByFlagByFlag{i}.fromFile(fid);
                        end
                    end
                    
                elseif (strcmp(buf, 'numAngleRanges') == 1)
                    obj.numAngleRanges = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'delAngleRanges') == 1)
                    obj.delAngleRanges = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'delAngleRanges') == 1)
                    obj.delAngleRanges = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'minAngleRanges') == 1)
                    obj.minAngleRanges = fscanf(fid, '%g', 1);
                    
                elseif (strcmp(buf, 'numInteriorSegmentsByFlagByAngle') == 1)
                    obj.numInteriorSegmentsByFlagByAngle = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'domainInteriorEdgesByAngle') == 1)
                    buf = fscanf(fid, '%s', 1);
                    sz = fscanf(fid, '%d', 1);
                    obj.domainInteriorEdgesByAngle = cell(sz, 1);
                    for i = 1:sz
                        buf = fscanf(fid, '%s', 3);
                        if (obj.numInteriorSegmentsByFlagByAngle(i) == 0)
                            buf = fscanf(fid, '%s', 1);
                        else
                            obj.domainInteriorEdgesByAngle{i} = pp_energyDispInterior;
                            obj.domainInteriorEdgesByAngle{i} = obj.domainInteriorEdgesByAngle{i}.fromFile(fid);
                        end
                    end
                    
                elseif (strcmp(buf, 'pos') == 1)
                    obj.pos = obj.pos.fromFile(fid);
                else
                    buf
                    THROW('Invalid key\n');
                end
                [buf, neof] = fscanf(fid, '%s', 1);
            end
            objout = obj;
        end
        
        
        function val = string2number(obj, str)
            str = lower(str);
            val = nan;
            sz = length(str);
            ind1 = nan;
            ind2 = nan;
            indFld = nan;
            if ((contains(str, 'xx')) || (contains(str, '11')))
                ind1 = 1;
                ind2 = 1;
            elseif ((contains(str, 'yy')) || (contains(str, '22')))
                ind1 = 2;
                ind2 = 2;
            elseif ((contains(str, 'xy')) || (contains(str, '12')))
                ind1 = 1;
                ind2 = 2;
            elseif ((contains(str, 'yx')) || (contains(str, '21')))
                ind1 = 2;
                ind2 = 1;
            elseif (contains(str, 'ind'))
                ind1 = gen_extractNumberAfterWord(str, 'ind');
            end
            if (contains(str, 'scalar'))
                [indFld, wordAfterSpecifier] = gen_extractNumberAfterWord(str, 'scalar');
                if (isnan(indFld))
                    indFld = obj.pos.getIndexFromWord(wordAfterSpecifier);
                    if (isnan(indFld))
                        str
                        THROW('cannot find field number from str for scalar field\n');
                    end
                end
            end
            
            % stress
            psv = strfind(str, 'sts');
            if (length(psv) > 0)
                md = obj.sym;
                ty = obj.sts_Bhomog;
                wordAfterSpecifier = str(psv(1) + 3:sz);
                sz2 = length(wordAfterSpecifier);
                if (sz2 >= 2)
                    c1 = wordAfterSpecifier(1);
                    c2 = wordAfterSpecifier(2);
                    if (c1 == 'r')
                        md = obj.raw;
                    elseif (c1 ~= 's')
                        str
                        THROW('stress format sts(r/s)(h/s)\n');
                    end
                    if (c2 == 's')
                        md = obj.sts_Bsimple;
                    elseif (c2 ~= 'h')
                        str
                        THROW('stress format sts(r/s)(h/s)\n');
                    end
                end
                val = obj.stress_homogenized{ty, md};
                if ((ind1 > 0) && (ind2 > 0))
                    val = val(ind1, ind2);
                end
                if (contains(str, 'ny'))
                    val = val / obj.newNormalizationsUVSEps(3);
                elseif (contains(str, 'pu'))
                    val = val * obj.area;
                end
                return;
            end
            
            %%% strain
            psv = strfind(str, 'stn');
            if (length(psv) > 0)
                if (contains(str, 'rel'))
                    val = obj.ratio_crackStrain2totalStrain;
                    return;
                end
                md = obj.sym;
                ty = obj.stn_Bhomog;
                wordAfterSpecifier = str(psv(1) + 3:sz);
                sz2 = length(wordAfterSpecifier);
                if (sz2 >= 2)
                    c1 = wordAfterSpecifier(1);
                    c2 = wordAfterSpecifier(2);
                    if (c1 == 'r')
                        md = obj.raw;
                    elseif (c1 ~= 's')
                        str
                        THROW('strain format stn(r/s)(t/c/b)\n');
                    end
                    if ((c2 == 't') || (c2 == 'h'))
                        md = obj.stn_Bhomog;
                    elseif ((c2 == 'c') || (c2 == 'i'))
                        md = obj.stn_Chomog;
                    elseif (c2 == 'b')
                        md = obj.stn_Ihomog;
                    else
                        str
                        THROW('strain format stn(r/s)(t/c/b)\n');
                    end
                end
                val = obj.strain_homogenized{ty, md};
                if ((ind1 > 0) && (ind2 > 0))
                    val = val(ind1, ind2);
                end
                if (contains(str, 'ny'))
                    val = val / obj.strainScale;
                elseif (contains(str, 'pu'))
                    if (isnan(ind1) || isnan(ind2))
                        val = val * obj.area;
                        return;
                    end
                    if (~obj.simpleBC)
                        THROW('displacement cannot be obtained for non-simple geometry\n');
                    end
                    lx = obj.domainBCEdges{2}.totalLength;
                    ly = obj.domainBCEdges{3}.totalLength;
                    tmp = val;
                    val = nan;
                    if (ind1 == 1)
                        if (ind2 == 1)
                            val = tmp * ly;
                        elseif (ind2 == 2)
                            val = tmp * max(lx, ly);
                        end
                    elseif (ind1 == 2)
                        if (ind2 == 1)
                            val = tmp * max(lx, ly);
                        elseif (ind2 == 2)
                            val = tmp * lx;
                        end
                    end
                end
                return;
            end
            
            if (contains(str, 'bcpow'))
                if (contains(str, 'rel'))
                    val = nan;
                    if (abs(obj.bcPower) > 0)
                        val = obj.bcPower_0 / obj.bcPower;
                    end
                elseif (isnan(ind1))
                    val = obj.bcPower;
                elseif (ind1 == 1)
                    val = obj.bcPower_0;
                elseif (ind1 == 2)
                    val = obj.bcPower_1;
                else
                    str
                    THROW('Invalid str for bc power\n');
                end
                if (contains(str, 'ny'))
                    val = val / (obj.newNormalizationsUVSEps(2) * obj.newNormalizationsUVSEps(3));
                end
                return;
            end
            
            if (contains(str, 'fpow'))
                if (contains(str, 'rel'))
                    val = nan;
                    if (abs(obj.fractureDissPower) > 0)
                        val = obj.fractureDissPower_1toTotal;
                    end
                elseif (isnan(ind1))
                    val = obj.fractureDissPower;
                elseif (ind1 == 1)
                    val = obj.fractureDissPower_0;
                elseif (ind1 == 2)
                    val = obj.fractureDissPower_1;
                else
                    str
                    THROW('Invalid str for fracture power\n');
                end
                if (contains(str, 'ny'))
                    val = val / (obj.newNormalizationsUVSEps(2) * obj.newNormalizationsUVSEps(3));
                end
                return;
            end
            
            if (contains(str, 'dynerr'))
                if (contains(str, 'rel'))
                    val = obj.ratio_Rhoab_2_stress;
                    return;
                end
                val = obj.ave_Deviation_Rhoab;
                if (isnan(ind1))
                elseif (ind1 == 0)
                    val = norm(val);
                else
                    val = val(ind1);
                end
                return;
            elseif (contains(str, 'dcracklength'))
                if (obj.maxInteriorFlag > 0)
                    val = obj.domainInteriorEdgesByFlagCombined.totalLength;
                end
                return;
            elseif (contains(str, 'dcount'))
                val = obj.countSegment;
                return;
            elseif (contains(str, 'dcntpt'))
                val = obj.countPt;
                return;
            elseif (contains(str, 'time'))
                val = obj.time;
                return;
            end
            
            %%%%        interior of the domain
            if (contains(str, 'bc'))
                if (contains(str, 'bca'))
                    val = obj.domainBCEdgesCombined.string2number(str, ind1, ind2);
                    return;
                end
                [indFld, wordAfterSpecifier] = gen_extractNumberAfterWord(str, 'bc');
                if (isnan(indFld))
                    str
                    THROW('cannot read bc number to be processed\n');
                    return;
                end
                if ((indFld > obj.maxBCFlag) || (obj.numBCSegments(indFld) == 0))
                    val = nan;
                else
                    val = obj.domainBCEdges{indFld}.string2number(str, ind1, ind2);
                    return;
                end
            end
            
            if (contains(str, 'frac'))
                val = nan;
                if (contains(str, 'fraca')) % all OR angle
                    [indAngle, wordAfterSpecifier] = gen_extractNumberAfterWord(str, 'fraca');
                    if (isnan(indAngle))
                        if (obj.maxInteriorFlag > 0)
                            val = obj.domainInteriorEdgesByFlagCombined.string2number(str, ind1, ind2, indFld);
                        end
                    else
                        if ((indAngle <= obj.numAngleRanges) && (obj.numInteriorSegmentsByFlagByAngle(indAngle) > 0))
                            val = obj.domainInteriorEdgesByAngle{indAngle}.string2number(str, ind1, ind2, indFld);
                        end
                    end
                else
                    [indFace, wordAfterSpecifier] = gen_extractNumberAfterWord(str, 'frac');
                    if (~isnan(indFace))
                        if ((indFace <= obj.maxInteriorFlag) && (obj.numInteriorSegmentsByFlagByFlag(indFace) > 0))
                            val = obj.domainInteriorEdgesByFlagByFlag{indFace}.string2number(str, ind1, ind2, indFld);
                        else
                            val = 0.0;
                        end
                    end
                end
            end
        end
        function zeroSln = IsSlnZero(obj)
            tmp = gen_matNorm(obj.stress_homogenized{obj.sym, obj.sts_Bhomog});
            if (tmp > 1e-7)
                zeroSln = 0;
                return;
            end
            tmp = gen_matNorm(obj.strain_homogenized{obj.sym, obj.stn_Bhomog});
            if (tmp > 1e-7)
                zeroSln = 0;
                return;
            end
            zeroSln = 1;
        end
        function objout = MakeZero(obj)
            [r, c] = size(obj.stress_homogenized);
            for i = 1:r
                for j = 1:c
                    obj.stress_homogenized{i, j} = 0.0;
                end
            end
            
            [r, c] = size(obj.strain_homogenized);
            for i = 1:r
                for j = 1:c
                    obj.strain_homogenized{i, j} = 0.0;
                end
            end
            obj.strain_homogenized = 0 * obj.strain_homogenized;
            obj.ave_Deviation_Rhoab = [0; 0];
            obj.ratio_Rhoab_2_stress = 0;
            obj.ratio_crackStrain2totalStrain = 0;
            obj.fractureDissPower = 0;
            obj.fractureDissPower_0 = 0;
            obj.fractureDissPower_1 = 0;
            obj.fractureDissPower_1toTotal = 0;
            
            obj.bcPower_0 = 0;
            obj.bcPower_1 = 0;
            obj.bcPower = 0;
            
            obj.domainBCEdgesCombined = obj.domainBCEdgesCombined.MakeZero();
            for i = 1:obj.numBCSegments
                obj.domainBCEdges{i} = obj.domainBCEdges{i}.MakeZero();
            end
            obj.maxInteriorFlag = 0;
            obj.numInteriorSegmentsByFlagByFlag = [];
            obj.domainInteriorEdgesByFlagByFlag = cell(0);  % will be a cell of domainInteriorEdgesByFlagByFlag
            obj.domainInteriorEdgesByFlagCombined = pp_energyDispInterior;
            
            objout = obj;
        end
        function dataCell = GetData(obj, dataNames)
            sz = length(dataNames);
            dataCell = cell(sz, 1);
            for di = 1:sz
                dataCell{di} = obj.string2number(dataNames{di});
            end
        end
    end
end

function out = FGETL(fid)
out = fgetl(fid);
while isempty(out)
    out = fgetl(fid);
end
end
