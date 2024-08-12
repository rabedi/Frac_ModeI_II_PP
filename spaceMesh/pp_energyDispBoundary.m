classdef pp_energyDispBoundary
    properties
        % x: position w.r.t. centroid
        int_xn = 0; %                           -> computig the area of domain
        int_sn = [0;0]; % int s.n dl            -> average of rho a
        int_snox = [0 0;0 0]; % int s.n o x dl      -> average of s;
        int_un = [0 0;0 0]; % int u x n dl          -> average of grad u
        int_vsn_0 = 0; %                      -> power: normal forces
        int_vsn_1 = 0; %                      -> power: tangential forces
        int_vsn = 0;   %                      -> power: sum of above
        crdMin = [inf inf];
        crdMax = [-inf -inf];
        edgeCentroid = [0 0];
        % for straight edges orientation and normal computed from last
        % segment is not changing
        orientation = [0 0];
        normal = [0 0];
        totalLength = 0;
        
        % this is set by the user
        domainCentroid = [0; 0];
    end
    methods
        function objout = SetDomainCentroid(obj, domainCentroidIn)
            objout = obj;
            objout.domainCentroid = domainCentroidIn;
        end
        function [objout, valid] = UpdateBySegment(obj, Xs, Us, Trcns, Vs, strsTracLocCrd, tractionGiven, vsLocalCrd)
            if nargin < 6
                strsTracLocCrd = 1;
            end
            if nargin < 7
                tractionGiven = 1;
            end
            if nargin < 8
                vsLocalCrd = 1;
            end
            [numPoints, crdSz] = size(Xs);
            % first deciding if X is oriented in the right direction (CCW)
            delX = Xs{numPoints} - Xs{1};
            cent2X0 = Xs{1} - obj.domainCentroid;
            cross = -delX(1) * cent2X0(2) + delX(2) * cent2X0(1);
            flipSign = (cross < 0);
            len = norm(delX);
            orientation = delX / len;
            
            if ((numPoints == 1) || (len < 1e-50) || (isnan(orientation(1))))
%                 numPoints
%                 len
%                 delX
%                 xst = Xs{1}
%                 xen = Xs{numPoints}
%                 THROW('Invalid segment in pp_energyDispBoundary\n');
                  objout = obj;
                  valid = 0;
                  return;
            end
            valid = 1;
            obj.totalLength = obj.totalLength + len;

            if (flipSign)
                orientation = -orientation;
            end
            obj.orientation = orientation;
            n = [orientation(2), -orientation(1)];
            obj.normal = n;
            
            % computing traction
            if (tractionGiven ~= 1)
                if (iscell(Trcns) == 0)
                    THROW('stress tensor in Trcns should be given as cell stress{pt}(i,j)');
                end
                if (strsTracLocCrd == 0)
                    for pt = 1:numPoints
                        ts{pt} = Trcns{pt} * n;
                    end
                else
                    for pt = 1:numPoints
                        ts{pt} = Trcns{pt}(:, 1);
                    end
                end
            else
                [r, c] = size(Trcns{1});
                if (c > 1)
                    for pt = 1:numPoints
                        ts{pt} = Trcns{pt}';
                    end
                else
                    ts = Trcns;
                end
                %                for pt = 1:numPoints
                %                    ts{pt} = Trcns{pt};
                %                end
            end
            rotateLocal2Global = [n(1) -n(2);n(2) n(1)];
            if (strsTracLocCrd) % ts is given in local coordinate system
                for pt = 1:numPoints
                    ts{pt} = rotateLocal2Global * ts{pt};
                end
            end
            rotateGlobal2Local = rotateLocal2Global';
            for pt = 1:numPoints
                tsLocal{pt} = rotateGlobal2Local * ts{pt};
            end
            
            if (vsLocalCrd)
                VsLocal = Vs;
            else
                VsLocal = cell(numPoints, 1);
                for pt = 1:numPoints
                    VsLocal{pt} = rotateGlobal2Local * Vs{pt};
                end
            end
            for pt = 1:numPoints
                for j = 1:2
                    obj.crdMin(j) = min(obj.crdMin(j), Xs{pt}(j));
                    obj.crdMax(j) = max(obj.crdMax(j), Xs{pt}(j));
                end
                x{pt} = Xs{pt} - obj.domainCentroid;
                integrand_vsn_0{pt} = tsLocal{pt}(1) * VsLocal{pt}(1);
                integrand_vsn_1{pt} = tsLocal{pt}(2) * VsLocal{pt}(2);
                integrand_xdotn{pt} = n * x{pt};
            end
            %            integrand_sn = ts;
            integrand_snox = gen_crossProduct(ts, x);
            integrand_un = gen_crossProduct(Us, n);
            
            tmp = gen_equidistant_NewtonCotes_Integral(integrand_xdotn, len);
            obj.int_xn = obj.int_xn + tmp;
            tmp = gen_equidistant_NewtonCotes_Integral(ts, len);
            obj.int_sn = obj.int_sn + tmp;
            tmp = gen_equidistant_NewtonCotes_Integral(integrand_snox, len);
            obj.int_snox = obj.int_snox + tmp;
            tmp = gen_equidistant_NewtonCotes_Integral(integrand_un, len);
            obj.int_un = obj.int_un + tmp;
            tmp = gen_equidistant_NewtonCotes_Integral(integrand_vsn_0, len);
            obj.int_vsn_0 = obj.int_vsn_0 + tmp;
            tmp = gen_equidistant_NewtonCotes_Integral(integrand_vsn_1, len);
            obj.int_vsn_1 = obj.int_vsn_1 + tmp;
            obj.int_vsn = obj.int_vsn_0 + obj.int_vsn_1;
            objout = obj;
        end
        function objout = Combine(obj, cellBCEdges)
            sz = length(cellBCEdges);
            for i = 1:sz
                if (isempty(cellBCEdges{i}))
                    continue;
                end
                objo = cellBCEdges{i};
                obj.int_xn = obj.int_xn + objo.int_xn;
                obj.int_sn = obj.int_sn + objo.int_sn;
                obj.int_snox = obj.int_snox + objo.int_snox;
                obj.int_un = obj.int_un + objo.int_un;
                obj.int_vsn_0 = obj.int_vsn_0 + abs(objo.int_vsn_0);
                obj.int_vsn_1 = obj.int_vsn_1 + abs(objo.int_vsn_1);
                obj.int_vsn = obj.int_vsn + objo.int_vsn;
                obj.totalLength = obj.totalLength + objo.totalLength;
                
                for j = 1:2
                    obj.crdMin(j) = min(obj.crdMin(j), objo.crdMin(j));
                    obj.crdMax(j) = max(obj.crdMax(j), objo.crdMax(j));
                end
                %                obj.edgeCentroid = obj.edgeCentroid + objo.edgeCentroid * totalLength;
                obj.domainCentroid = objo.domainCentroid;
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
            fprintf(fid, 'totalLength\t%g\n', obj.totalLength);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_xn\t%g\n', obj.int_xn);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_sn\t');
            gen_toFile_matrix(fid, obj.int_sn);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_snox\t');
            gen_toFile_matrix(fid, obj.int_snox);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_un\t');
            gen_toFile_matrix(fid, obj.int_un);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_vsn_0\t%g\n', obj.int_vsn_0);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_vsn_1\t%g\n', obj.int_vsn_1);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'int_vsn\t%g\n', obj.int_vsn);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crdMin\t');
            gen_toFile_matrix(fid, obj.crdMin);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crdMax\t');
            gen_toFile_matrix(fid, obj.crdMax);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'edgeCentroid\t');
            gen_toFile_matrix(fid, obj.edgeCentroid);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'orientation\t');
            gen_toFile_matrix(fid, obj.orientation);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'normal\t');
            gen_toFile_matrix(fid, obj.normal);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'domainCentroid\t');
            gen_toFile_matrix(fid, obj.domainCentroid);
            
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
                if (strcmp(buf, 'totalLength') == 1)
                    obj.totalLength = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'int_xn') == 1)
                    obj.int_xn = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'int_sn') == 1)
                    obj.int_sn = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'int_snox') == 1)
                    obj.int_snox = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'int_un') == 1)
                    obj.int_un = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'int_vsn_0') == 1)
                    obj.int_vsn_0 = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'int_vsn_1') == 1)
                    obj.int_vsn_1 = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'int_vsn') == 1)
                    obj.int_vsn = fscanf(fid, '%g', 1);
                elseif (strcmp(buf, 'crdMin') == 1)
                    obj.crdMin = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'crdMax') == 1)
                    obj.crdMax = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'edgeCentroid') == 1)
                    obj.edgeCentroid = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'orientation') == 1)
                    obj.orientation = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'normal') == 1)
                    obj.normal = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'domainCentroid') == 1)
                    obj.domainCentroid = gen_fromFile_matrix(fid);
                else
                    buf
                    THROW('Invalid key\n');
                end
                [buf, neof] = fscanf(fid, '%s', 1);
            end
            objout = obj;
        end
        function val = string2number(obj, str, ind1, ind2)
            val = nan;
            if ((contains(str, 'int_vsn')) || (contains(str, 'pow')))
                if (contains(str, 'rel'))
                    val = nan;
                    if (abs(obj.int_vsn) > 0)
                        val = obj.int_vsn_0 / obj.int_vsn;
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
            if (nargin < 3)
                ind1 = -1;
            end
            if (nargin < 4)
                ind2 = -1;
            end
            if (contains(str, 'int_snox'))
                if ((ind1 > 0) && (ind2 > 0))
                    val = obj.int_snox(ind1, ind2);
                elseif (ind1 == 0)
                    val = gen_matNorm(obj.int_snox);
                else
                    val = obj.int_snox;
                end
                return;
            end
            if (contains(str, 'int_un'))
                if ((ind1 > 0) && (ind2 > 0))
                    val = obj.int_un(ind1, ind2);
                elseif (ind1 == 0)
                    val = gen_matNorm(obj.int_un);
                else
                    val = obj.int_un;
                end
                return;
            end
            if (contains(str, 'int_sn'))
                if (ind1 > 0)
                    val = obj.int_sn(ind1);
                elseif (ind1 == 0)
                    val = norm(obj.int_sn);
                else
                    val = obj.int_sn;
                end
                return;
            end
            if (contains(str, 'int_xn'))
                val = obj.int_xn;
                return;
            end
        end
        function objout = MakeZero(obj)
            obj.int_xn = 0;
            obj.int_sn = [0;0];
            obj.int_snox = [0 0;0 0];
            obj.int_un = [0 0;0 0];
            obj.int_vsn_0 = 0;
            obj.int_vsn_1 = 0;
            obj.int_vsn = 0;
            
            objout = obj;
        end
    end
end
