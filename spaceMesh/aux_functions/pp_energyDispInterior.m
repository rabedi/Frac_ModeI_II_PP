classdef pp_energyDispInterior
    properties
        int_scalars = [];
        min_scalars = [];
        max_scalars = [];
        ave_scalars = [];
        step4ScalarCDFs = 0.1;
        numBins4ScalarCDFs = 9;
        step4ScalarCDFsVals = [];
        % row i col j: length of cracks for which scalar j takes a value
        % larger than i * step4ScalarCDFs
        hlengths = [];
        % row i col j: relative length of cracks (CDF) for which scalar j takes a value
        % larger than i * step4ScalarCDFs
        hlengthsRel = [];
        
        %%%%%%%%%%%%%%%%%%%       Crack angle distribution
        R2D = 180 / pi;
        % cracks are put in bins that store lengths and number of cracks in
        % this group
        % WNumber -> stat of crack angle is computed based crack number
        % WLength -> better (stat computed by crack length weights)
        
        % no decoration -> crack angle between [0, 180]
        % XYSym: symmetry w.r. to X, Y axes (e.g. compressive runs)
        % mean of crack lengths
        crackAngleStatWNumber;
        crackAngleStatWLength;
        crackAngleStatXYSymWNumber;
        crackAngleStatXYSymWLength;
        % PDF of crack lengths
        crackAngleBin_size = 180;
        crackAngleBin_minAngleDeg = 0;
        crackAngleBin_maxAngleDeg = 180;
        crackAngleBin_DelAngleDeg;
        crackAngleBin_totCrackLengths; %% total length in a bin
        crackAngleBin_totCounts;        %% total number in a bin
        crackAngleBin_perCrackLengths; %% percentage in a bin
        crackAngleBin_perCounts;        %% percentage count in a bin
        
        int_un = [0 0;0 0]; % int u x n dl          -> average of grad u (this will contribute to last term in equation (16) of Ren_2011_Chen_JS_10_Micro-cracks informed damage models for brittle solids.pdf
        int_vsn_0 = 0; %                      -> power: normal forces
        int_vsn_1 = 0; %                      -> power: tangential forces
        int_vsn = 0;   %                      -> power: sum of above
        int_vsn_1toTotal = 0; %                      -> power: relative power of shear to total
        crdMin = [inf inf];
        crdMax = [-inf -inf];
        totalLength = 0;
        count = 0;
        
        % this is set by the user
        %        domainCentroid = [0 0];
    end
    methods
        function objout = Initiallize(obj, step4ScalarCDFsIn, crackBinSize, crackBinMaxAngle, crackBinMinAngle)
            if nargin < 2
                step4ScalarCDFsIn = nan;
            end
            if nargin < 3
                crackBinSize = nan;
                crackBinMaxAngle = nan;
                crackBinMinAngle = nan;
            end
            if (~isnan(crackBinSize))
                obj.crackAngleBin_size = crackBinSize;
            end
            if (~isnan(crackBinMaxAngle))
                obj.crackAngleBin_maxAngleDeg = crackBinMaxAngle;
            end
            if (~isnan(crackBinMinAngle))
                obj.crackAngleBin_minAngleDeg = crackBinMinAngle;
            end
            obj.crackAngleBin_DelAngleDeg = obj.crackAngleBin_maxAngleDeg - obj.crackAngleBin_minAngleDeg;
            obj.crackAngleBin_totCrackLengths = zeros(obj.crackAngleBin_size, 1);
            obj.crackAngleBin_totCounts = zeros(obj.crackAngleBin_size, 1);
            
            if (~isnan(step4ScalarCDFsIn))
                obj.step4ScalarCDFs = step4ScalarCDFsIn;
            end
            sz = length(obj.step4ScalarCDFs);
            if ((sz == 0) || (obj.step4ScalarCDFs(1) >= 1))
                obj.step4ScalarCDFs = 0.5;
            end
            if ((sz > 1) || (obj.step4ScalarCDFs(1) < 0))
                if (sz == 1)
                    obj.step4ScalarCDFs(1) = -obj.step4ScalarCDFs(1);
                end
                obj.step4ScalarCDFsVals = obj.step4ScalarCDFs;
                obj.numBins4ScalarCDFs = length(obj.step4ScalarCDFsVals);
            else
                cntr = 0;
                obj.step4ScalarCDFsVals = [];
                vl = obj.step4ScalarCDFs;
                while (vl < 0.999)
                    cntr = cntr + 1;
                    obj.step4ScalarCDFsVals(cntr) = vl;
                    vl = vl + obj.step4ScalarCDFs;
                end
                obj.numBins4ScalarCDFs = cntr;
            end
            objout = obj;
        end
        function [objout, crackAngleDeg] = UpdateBySegment(obj, Xs, delUsLocalCrd, TrcnsLocalCrd, delVsLocalCrd, scalars)
            obj.crackAngleStatWNumber = pp_stat_crackDir;
            obj.crackAngleStatWNumber = obj.crackAngleStatWNumber.Initialize(2, 0);
            obj.crackAngleStatWLength = pp_stat_crackDir;
            obj.crackAngleStatWLength = obj.crackAngleStatWLength.Initialize(2, 1);
            obj.crackAngleStatXYSymWNumber = pp_stat_crackDir;
            obj.crackAngleStatXYSymWNumber = obj.crackAngleStatXYSymWNumber.Initialize(-4, 0);
            obj.crackAngleStatXYSymWLength = pp_stat_crackDir;
            obj.crackAngleStatXYSymWLength = obj.crackAngleStatXYSymWLength.Initialize(-4, 1);
            
            [numPoints, crdSz] = size(Xs);
            % first deciding if X is oriented in the right direction (CCW)
            delX = Xs{numPoints} - Xs{1};
            %            cent2X0 = Xs{1} - obj.domainCentroid;
            %            cross = -delX(1) * cent2X0(2) + delX(2) * cent2X0(1);
            %            flipSign = (cross < 0);
            len = norm(delX);
            obj.totalLength = obj.totalLength + len;
            obj.count = obj.count + 1;
            orientation = delX / len;
            
            %%%%%%%%%%% Crack angle stat
            obj.crackAngleStatWNumber = obj.crackAngleStatWNumber.Update(orientation, len);
            obj.crackAngleStatWLength = obj.crackAngleStatWLength.Update(orientation, len);
            obj.crackAngleStatXYSymWNumber = obj.crackAngleStatXYSymWNumber.Update(orientation, len);
            obj.crackAngleStatXYSymWLength = obj.crackAngleStatXYSymWLength.Update(orientation, len);
            
            angleDeg = atan2(orientation(2), orientation(1)) * obj.R2D;
            crackAngleDeg = mod(angleDeg, 180);
            if (obj.crackAngleBin_size > 0)
                delAngle = mod(angleDeg - obj.crackAngleBin_minAngleDeg, obj.crackAngleBin_DelAngleDeg);
                index = floor(delAngle / obj.crackAngleBin_DelAngleDeg * obj.crackAngleBin_size) + 1;
                if (index > obj.crackAngleBin_size)
                    index = obj.crackAngleBin_size;
                end
%                if (index > 0)
                obj.crackAngleBin_totCrackLengths(index) = obj.crackAngleBin_totCrackLengths(index) + len;
                obj.crackAngleBin_totCounts(index) = obj.crackAngleBin_totCounts(index) + 1;
%                end
            end
            %%%% integration stat
            %           if (flipSign)
            %               orientation = -orientation;
            %           end
            %            obj.orientation = orientation;
            n = [orientation(2), -orientation(1)];
            %            obj.normal = n;
            rotateLocal2Global = [n(1) -n(2);n(2) n(1)];
            rotateGlobal2Local = [n(1) n(2);-n(2) n(1)];
            
            integrand_unGlobal = cell(numPoints, 1);
            
            for pt = 1:numPoints
                for j = 1:2
                    obj.crdMin(j) = min(obj.crdMin(j), Xs{pt}(j));
                    obj.crdMax(j) = max(obj.crdMax(j), Xs{pt}(j));
                end
                %                x{pt} = Xs{pt} - obj.domainCentroid;
                integrand_vsn_0{pt} = TrcnsLocalCrd{pt}(1) * delVsLocalCrd{pt}(1);
                integrand_vsn_1{pt} = TrcnsLocalCrd{pt}(2) * delVsLocalCrd{pt}(2);
                
                % Us x n in local coord = delUsLocalCrd x [1 0]
                integrand_unLocal = [delUsLocalCrd{pt}(1) 0; delUsLocalCrd{pt}(2) 0];
                integrand_unGlobal{pt} = rotateLocal2Global * integrand_unLocal * rotateLocal2Global';
            end
            
            tmp = gen_equidistant_NewtonCotes_Integral(integrand_unGlobal, len);
            obj.int_un = obj.int_un + tmp;
            tmp = gen_equidistant_NewtonCotes_Integral(integrand_vsn_0, len);
            obj.int_vsn_0 = obj.int_vsn_0 + tmp;
            tmp = gen_equidistant_NewtonCotes_Integral(integrand_vsn_1, len);
            obj.int_vsn_1 = obj.int_vsn_1 + tmp;
            obj.int_vsn = obj.int_vsn_0 + obj.int_vsn_1;
            
            numScalars = 0;
            if (length(scalars) > 0)
                numScalars = length(scalars{1});
            end
            if (numScalars > 0)
                if (length(obj.min_scalars) == 0)
                    obj.min_scalars = inf * ones(1, numScalars);
                    obj.max_scalars = -inf * ones(1, numScalars);
                end
                integrand_hBooleans = cell(numPoints, 1);
                mnSclr = min(numScalars, 8);
                for pt = 1:numPoints
                    integrand_hBooleans{pt} = zeros(obj.numBins4ScalarCDFs, mnSclr);
                    for i = 1:numScalars
                        vl = scalars{pt}(i);
                        obj.min_scalars(i) = min(obj.min_scalars(i), vl);
                        obj.max_scalars(i) = max(obj.max_scalars(i), vl);
                        if (i <= mnSclr)
                            for k = 1:obj.numBins4ScalarCDFs
                                if (vl > obj.step4ScalarCDFsVals(k))
                                    integrand_hBooleans{pt}(k, i) = 1;
                                else
                                    break;
                                end
                            end
                        end
                    end
                end
                tmp = gen_equidistant_NewtonCotes_Integral(scalars, len);
                if (length(obj.int_scalars) > 0)
                    obj.int_scalars = obj.int_scalars + tmp;
                else
                    obj.int_scalars = tmp;
                end
                tmp = gen_equidistant_NewtonCotes_Integral(integrand_hBooleans, len);
                if (length(obj.hlengths) > 0)
                    obj.hlengths = obj.hlengths + tmp;
                else
                    obj.hlengths = tmp;
                end
            end
            objout = obj;
        end
        function objout = Finalize(obj)
            if (abs(obj.int_vsn) > 0)
                obj.int_vsn_1toTotal = abs(obj.int_vsn_1 / obj.int_vsn);
            else
                obj.int_vsn_1toTotal = 0.0;
            end
            if (obj.count > 0)
                obj.crackAngleStatWNumber = obj.crackAngleStatWNumber.Finalize();
                obj.crackAngleStatWLength = obj.crackAngleStatWLength.Finalize();
                obj.crackAngleStatXYSymWNumber = obj.crackAngleStatXYSymWNumber.Finalize();
                obj.crackAngleStatXYSymWLength = obj.crackAngleStatXYSymWLength.Finalize();
            
                obj.crackAngleBin_perCrackLengths = obj.crackAngleBin_totCrackLengths / obj.totalLength;
                obj.crackAngleBin_perCounts = obj.crackAngleBin_totCounts / obj.count;

                obj.hlengthsRel = obj.hlengths / obj.totalLength;
                obj.ave_scalars = obj.int_scalars / obj.totalLength;
            end
            
            objout = obj;
        end
        function objout = Combine(obj, cellInteriorEdges)
            sz = length(cellInteriorEdges);
            cntr = 1;
            for i = 1:sz
                if (isempty(cellInteriorEdges{i}))
                    continue;
                end
                objo = cellInteriorEdges{i};
                
                obj.step4ScalarCDFs = objo.step4ScalarCDFs;
                obj.numBins4ScalarCDFs = objo.numBins4ScalarCDFs;
                obj.step4ScalarCDFsVals = objo.step4ScalarCDFsVals;
                
                obj.crackAngleBin_size = objo.crackAngleBin_size;
                obj.crackAngleBin_minAngleDeg = objo.crackAngleBin_minAngleDeg;
                obj.crackAngleBin_maxAngleDeg = objo.crackAngleBin_maxAngleDeg;
                obj.crackAngleBin_DelAngleDeg = objo.crackAngleBin_DelAngleDeg;
                
                if (length(obj.int_scalars) == 0)
                    obj.int_scalars = objo.int_scalars;
                    obj.hlengths = objo.hlengths;
                    obj.crackAngleBin_totCrackLengths = objo.crackAngleBin_totCrackLengths;
                    obj.crackAngleBin_totCounts = objo.crackAngleBin_totCounts;
                else
                    obj.int_scalars = obj.int_scalars + objo.int_scalars;
                    obj.hlengths = obj.hlengths + objo.hlengths;
                    obj.crackAngleBin_totCrackLengths = obj.crackAngleBin_totCrackLengths + objo.crackAngleBin_totCrackLengths;
                    obj.crackAngleBin_totCounts = obj.crackAngleBin_totCounts + objo.crackAngleBin_totCounts;
                end
                obj.int_un = obj.int_un + objo.int_un;
                obj.int_vsn_0 = obj.int_vsn_0 + objo.int_vsn_0;
                obj.int_vsn_1 = obj.int_vsn_1 + objo.int_vsn_1;
                obj.int_vsn = obj.int_vsn + objo.int_vsn;
                obj.totalLength = obj.totalLength + objo.totalLength;
                obj.count = obj.count + objo.count;
                
                tmp_crackAngleStatWNumber{cntr} = objo.crackAngleStatWNumber;
                tmp_crackAngleStatWLength{cntr} = objo.crackAngleStatWLength;
                tmp_crackAngleStatXYSymWNumber{cntr}= objo.crackAngleStatXYSymWNumber;
                tmp_crackAngleStatXYSymWLength{cntr} = objo.crackAngleStatXYSymWLength;
                cntr = cntr + 1;
                
                for j = 1:2
                    obj.crdMin(j) = min(obj.crdMin(j), objo.crdMin(j));
                    obj.crdMax(j) = max(obj.crdMax(j), objo.crdMax(j));
                end
                if (length(obj.min_scalars) == 0)
                    obj.min_scalars = objo.min_scalars;
                    obj.max_scalars = objo.max_scalars;
                else
                    obj.min_scalars = min(obj.min_scalars, objo.min_scalars);
                    obj.max_scalars = max(obj.max_scalars, objo.max_scalars);
                end
                obj.crackAngleStatWNumber = pp_stat_crackDir;
                obj.crackAngleStatWNumber = obj.crackAngleStatWNumber.Combine(tmp_crackAngleStatWNumber);
                obj.crackAngleStatWLength = pp_stat_crackDir;
                obj.crackAngleStatWLength = obj.crackAngleStatWLength.Combine(tmp_crackAngleStatWLength);
                obj.crackAngleStatXYSymWNumber = pp_stat_crackDir;
                obj.crackAngleStatXYSymWNumber = obj.crackAngleStatXYSymWNumber.Combine(tmp_crackAngleStatXYSymWNumber);
                obj.crackAngleStatXYSymWLength = pp_stat_crackDir;
                obj.crackAngleStatXYSymWLength = obj.crackAngleStatXYSymWLength.Combine(tmp_crackAngleStatXYSymWLength);
                objout = obj;
            end
        end
        function toFile(obj, fid, nbegline)
            if nargin < 2
                nbegline = 0;
            end
            gen_printTab(fid, nbegline);
            fprintf(fid, '{\n');
            gen_printTab(fid, nbegline);
            fprintf(fid, 'count\t%d\n', obj.count);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'totalLength\t%g\n', obj.totalLength);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_vsn_0\t%g\n', obj.int_vsn_0);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_vsn_1\t%g\n', obj.int_vsn_1);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_vsn\t%g\n', obj.int_vsn);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_vsn_1toTotal\t%g\n', obj.int_vsn_1toTotal);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_un\t');
            gen_toFile_matrix(fid, obj.int_un);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crdMin\t');
            gen_toFile_matrix(fid, obj.crdMin);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crdMax\t');
            gen_toFile_matrix(fid, obj.crdMax);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'hlengths\t');
            gen_toFile_matrix(fid, obj.hlengths);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'hlengthsRel\t');
            gen_toFile_matrix(fid, obj.hlengthsRel);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'ave_scalars\t');
            gen_toFile_matrix(fid, obj.ave_scalars);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_scalars\t');
            gen_toFile_matrix(fid, obj.int_scalars);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'min_scalars\t');
            gen_toFile_matrix(fid, obj.min_scalars);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'max_scalars\t');
            gen_toFile_matrix(fid, obj.max_scalars);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleBin_size\t%d\n', obj.crackAngleBin_size);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleBin_minAngleDeg\t%d\n', obj.crackAngleBin_minAngleDeg);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleBin_maxAngleDeg\t%d\n', obj.crackAngleBin_maxAngleDeg);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleBin_DelAngleDeg\t%d\n', obj.crackAngleBin_DelAngleDeg);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleBin_DelAngleDeg\t%d\n', obj.crackAngleBin_DelAngleDeg);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleBin_totCrackLengths\t');
            gen_toFile_matrix(fid, obj.crackAngleBin_totCrackLengths);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleBin_totCounts\t');
            gen_toFile_matrix(fid, obj.crackAngleBin_totCounts);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleBin_perCrackLengths\t');
            gen_toFile_matrix(fid, obj.crackAngleBin_perCrackLengths);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleBin_perCounts\t');
            gen_toFile_matrix(fid, obj.crackAngleBin_perCounts);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleStatWNumber\n');
            obj.crackAngleStatWNumber.toFile(fid, nbegline + 1);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleStatWLength\n');
            obj.crackAngleStatWLength.toFile(fid, nbegline + 1);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleStatXYSymWNumber\n');
            obj.crackAngleStatXYSymWNumber.toFile(fid, nbegline + 1);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crackAngleStatXYSymWLength\n');
            obj.crackAngleStatXYSymWLength.toFile(fid, nbegline + 1);
            
            fprintf(fid, 'step4ScalarCDFs\t');
            gen_toFile_matrix(fid, obj.step4ScalarCDFs);
            fprintf(fid, 'numBins4ScalarCDFs\t');
            gen_toFile_matrix(fid, obj.numBins4ScalarCDFs);
            fprintf(fid, 'step4ScalarCDFsVals\t');
            gen_toFile_matrix(fid, obj.step4ScalarCDFsVals);
            
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
                if (strcmp(buf, 'count') == 1)
                    obj.count = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'totalLength') == 1)
                    obj.totalLength = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'int_vsn_0') == 1)
                    obj.int_vsn_0 = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'int_vsn_1') == 1)
                    obj.int_vsn_1 = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'int_vsn') == 1)
                    obj.int_vsn = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'int_vsn_1toTotal') == 1)
                    obj.int_vsn_1toTotal = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'int_un') == 1)
                    obj.int_un = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'crdMin') == 1)
                    obj.crdMin = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'crdMax') == 1)
                    obj.crdMax = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'hlengths') == 1)
                    obj.hlengths = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'hlengthsRel') == 1)
                    obj.hlengthsRel = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'ave_scalars') == 1)
                    obj.ave_scalars = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'int_scalars') == 1)
                    obj.int_scalars = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'min_scalars') == 1)
                    obj.min_scalars = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'max_scalars') == 1)
                    obj.max_scalars = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'crackAngleBin_size') == 1)
                    obj.crackAngleBin_size = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'crackAngleBin_minAngleDeg') == 1)
                    obj.crackAngleBin_minAngleDeg = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'crackAngleBin_maxAngleDeg') == 1)
                    obj.crackAngleBin_maxAngleDeg = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'crackAngleBin_DelAngleDeg') == 1)
                    obj.crackAngleBin_DelAngleDeg = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'crackAngleBin_DelAngleDeg') == 1)
                    obj.crackAngleBin_DelAngleDeg = fscanf(fid, '%g', 1);
                    
                elseif (strcmp(buf, 'crackAngleBin_totCrackLengths') == 1)
                    obj.crackAngleBin_totCrackLengths = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'crackAngleBin_totCounts') == 1)
                    obj.crackAngleBin_totCounts = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'crackAngleBin_perCrackLengths') == 1)
                    obj.crackAngleBin_perCrackLengths = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'crackAngleBin_perCounts') == 1)
                    obj.crackAngleBin_perCounts = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'crackAngleBin_perCounts') == 1)
                    obj.crackAngleBin_perCounts = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'crackAngleStatWNumber') == 1)
                    obj.crackAngleStatWNumber = pp_stat_crackDir;
                    obj.crackAngleStatWNumber = obj.crackAngleStatWNumber.fromFile(fid);
                elseif (strcmp(buf, 'crackAngleStatWLength') == 1)
                    obj.crackAngleStatWLength = pp_stat_crackDir;
                    obj.crackAngleStatWLength = obj.crackAngleStatWNumber.fromFile(fid);
                elseif (strcmp(buf, 'crackAngleStatXYSymWNumber') == 1)
                    obj.crackAngleStatXYSymWNumber = pp_stat_crackDir;
                    obj.crackAngleStatXYSymWNumber = obj.crackAngleStatWNumber.fromFile(fid);
                elseif (strcmp(buf, 'crackAngleStatXYSymWLength') == 1)
                    obj.crackAngleStatXYSymWLength = pp_stat_crackDir;
                    obj.crackAngleStatXYSymWLength = obj.crackAngleStatWNumber.fromFile(fid);
                elseif (strcmp(buf, 'step4ScalarCDFs') == 1)
                    obj.step4ScalarCDFs = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'numBins4ScalarCDFs') == 1)
                    obj.numBins4ScalarCDFs = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'step4ScalarCDFsVals') == 1)
                    obj.step4ScalarCDFsVals = gen_fromFile_matrix(fid);
                else
                    buf
                    THROW('Invalid key\n');
                end
                [buf, neof] = fscanf(fid, '%s', 1);
            end
            objout = obj;
        end
        function val = string2number(obj, str, ind1, ind2, indFld)
            val = nan;
            if (nargin < 5)
                indFld = -1;
            end
            % group I: scalar value statistics
            %            if (length(strfind(str, 'scalar')) > 0)
            if (indFld > 0)
                if (nargin < 3)
                    ind1 = 1;
                end
                if (contains(str, 'int'))
                    val = obj.int_scalars(indFld);
                    return;
                elseif (contains(str, 'min'))
                    val = obj.min_scalars(indFld);
                    return;
                elseif (contains(str, 'max'))
                    val = obj.max_scalars(indFld);
                    return;
                elseif ((contains(str, 'mean')) || (contains(str, 'ave')))
                    val = obj.ave_scalars(indFld);
                    return;
                else
                    if (ind1 <= 0)
                        ind1 = obj.numBins4ScalarCDFs - ind1;
                    end
                    if ((contains(str, 'rel')) || (contains(str, 'per')) || (contains(str, 'pdf')))
                        val = obj.hlengthsRel(ind1, indFld);
                    else
                        val = obj.hlengths(ind1, indFld);
                    end
                    return;
                end
            end
            % group II: crack angles
            if (contains(str, 'angle'))
                if (nargin < 3)
                    ind1 = -1;
                end
                lengthStat = 1;
                if (contains(str, 'count'))
                    lengthStat = 0;
                end
                if (~contains(str, 'stat'))
                    relStat = 0;
                    if ((contains(str, 'rel')) || (contains(str, 'per')) || (contains(str, 'pdf')))
                        relStat = 1;
                    end
                    if (ind1 > 0) % single value
                        if (relStat)
                            if (lengthStat)
                                val = obj.crackAngleBin_perCrackLengths(ind1);
                            else
                                val = obj.crackAngleBin_perCounts(ind1);
                            end
                        else
                            if (lengthStat)
                                val = obj.crackAngleBin_totCrackLengths(ind1);
                            else
                                val = obj.crackAngleBin_totCounts(ind1);
                            end
                        end
                    else % entire population
                        if (relStat)
                            if (lengthStat)
                                val = obj.crackAngleBin_perCrackLengths;
                            else
                                val = obj.crackAngleBin_perCounts;
                            end
                        else
                            if (lengthStat)
                                val = obj.crackAngleBin_totCrackLengths;
                            else
                                val = obj.crackAngleBin_totCounts;
                            end
                        end
                    end
                    return;
                else % mean, r, stdiv of crack length
                    symXYStat = 0;
                    if (contains(str, 'sym'))
                        symXYStat = 1;
                    end
                    if (symXYStat)
                        if (lengthStat)
                            val = obj.crackAngleStatXYSymWLength.string2number(str);
                        else
                            val = obj.crackAngleStatXYSymWNumber.string2number(str);
                        end
                    else
                        if (lengthStat)
                            val = obj.crackAngleStatWLength.string2number(str);
                        else
                            val = obj.crackAngleStatWNumber.string2number(str);
                        end
                    end
                    return;
                end
            end
            
            % group III: miscelaneous
            if (contains(str, 'cracklength'))
                val = obj.totalLength;
                return;
            elseif (contains(str, 'count'))
                val = obj.count;
                return;
            end
            
            % group IV: integrals
            if (nargin < 3)
                ind1 = -1;
            end
            if (nargin < 4)
                ind2 = -1;
            end
            if ((contains(str, 'int_vsn')) || (contains(str, 'pow')))
                if (contains(str, 'rel'))
                    val = obj.int_vsn_1toTotal;
                    if (abs(obj.int_vsn) == 0)
                        val = nan;
                    end
                    return;
                elseif ((nargin < 3) || (ind1 <= 0))
                    val = obj.int_vsn;
                    return;
                elseif (ind1 == 1)
                    val = obj.int_vsn_0;
                    return;
                elseif (ind1 == 2)
                    val = obj.int_vsn_1;
                    return;
                end
            end
            
            
            if (contains(str, 'int_snox'))
                if ((ind1 > 0) && (ind2 > 0))
                    val = obj.int_snox(ind1, ind2);
                    return;
                end
                val = obj.int_snox;
                return;
            end
            if (contains(str, 'int_un'))
                if ((ind1 > 0) && (ind2 > 0))
                    val = obj.int_un(ind1, ind2);
                    return;
                end
                val = obj.int_un;
                return;
            end
            if (contains(str, 'int_sn'))
                if (ind1 > 0)
                    val = obj.int_sn(ind1);
                    return;
                end
                val = obj.int_sn;
                return;
            end
            if (contains(str, 'int_xn'))
                val = obj.int_xn;
                return;
            end
        end
    end
end