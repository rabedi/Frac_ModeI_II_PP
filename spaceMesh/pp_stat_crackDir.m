classdef pp_stat_crackDir
    properties
        % search for document Lec 16 - Directional Statistics.pdf
        %%%%%%%%%
        % for oriented cracks number of segments is 1 [0 360]
        % for normal cracks number of segments is 2 [0 180], [180 360]
        % for XY symmetric cracks number of segments is 4 [0 90], ...,
        % example: angle 25, 25 + 90, 25 + 180, 25 + 270 are the same
        
        % -4: symmetrix w.r.t. x,y axis for example crack of angle 30 ->
        % corresponds to +/- 30, +/- 120 (e.g. c, s -> +/- c, +/-s)
        optm4 = 1; % 4 multiplies the angles by 4 (fr -4 option above), otherwise, takes the average of cos(theta), sin(theta)
        % if 4 is used (angles are 4x and then divided by 4 later, it
        % returns 0 for angles exactly at 90 degrees)
        
        numSegments = 2; 
        sumSin = 0;
        sumCos = 0;
        wieghtEqCracklength = 1;
        sumWeight = 0; % weight can be either crack length (or number = 1)
        
        averageSin = 0; 
        averageCos = 0;
        r = 1;  % dispersion
        sdiv = 0; % = -log(r^2)
        thetaMeanRadBase; % before taking into account number of segments
        thetaMeanRad;
        thetaMeanDegree;
    end
    methods
        function objout = Initialize(obj, numSegmentsIn, wieghtEqCracklengthIn)
            if nargin < 2
                numSegmentsIn = 2;
            end
            if nargin < 3
                wieghtEqCracklengthIn = 1;
            end
            obj.numSegments = numSegmentsIn;
            obj.wieghtEqCracklength = wieghtEqCracklengthIn;
            objout = obj;
        end
        function objout = Update(obj, crackOrientation, crackLength)
            % orientation = [cos(angle), sin(angle)]
            weight = crackLength;
            if (obj.wieghtEqCracklength == 0)
                weight = 1;
            end
            obj.sumWeight = obj.sumWeight + weight;
            c0 = crackOrientation(1);
            s0 = crackOrientation(2);
            if (obj.numSegments == 2)
                c = c0 * c0 - s0 * s0;
                s = 2 * c0 * s0;
            elseif (obj.numSegments == -4) % symmetric w.r.t. XY axes
                if (obj.optm4 == 4)
                    c0 = abs(c0);
                    s0 = abs(s0);
                    z = c0 + sqrt(-1) * s0;
                    z = power(z, 4);
                    c = real(z);
                    s = imag(z);
                else
                    c = abs(c0);
                    s = abs(s0);
                end
            elseif (obj.numSegments == 1)
                c = c0;
                s = s0;
            elseif (obj.numSegments == 4)
                z = c0 + sqrt(-1) * s0;
                z = power(z, obj.numSegments);
                c = real(z);
                s = imag(z);
            end
            obj.sumCos = obj.sumCos + c * weight;
            obj.sumSin = obj.sumSin + s * weight;
            objout = obj;
        end
        function objout = Finalize(obj)
            obj.averageSin = obj.sumSin / obj.sumWeight; 
            obj.averageCos = obj.sumCos / obj.sumWeight; 
            r = obj.averageSin * obj.averageSin + obj.averageCos * obj.averageCos;
            obj.sdiv = -log(r);
            r = sqrt(r);
            if (r > 1e-12)
                c = obj.averageCos / r;
                s = obj.averageSin / r;
                obj.thetaMeanRadBase = atan2(s, c);
            else
                obj.thetaMeanRadBase = 0.0;
            end
            if ((obj.optm4 == 4) || (obj.numSegments ~= -4))
                obj.thetaMeanRad = obj.thetaMeanRadBase / abs(obj.numSegments);
            else
                obj.thetaMeanRad = obj.thetaMeanRadBase;
            end
            if (obj.numSegments ~= 1)
                obj.thetaMeanRad = mod(obj.thetaMeanRad, 2 * pi);
                if (obj.numSegments == -4)
                    if (obj.optm4 == 4)
                        obj.thetaMeanRad = mod(obj.thetaMeanRad, 2 * pi /abs(obj.numSegments));
                    else
                        cnew = abs(cos(obj.thetaMeanRad));
                        snew = abs(sin(obj.thetaMeanRad));
                        obj.thetaMeanRad = atan2(snew, cnew);
                    end
                else
                    obj.thetaMeanRad = mod(obj.thetaMeanRad, 2 * pi / obj.numSegments);
                end
            end
            obj.thetaMeanDegree = obj.thetaMeanRad * 180 / pi;
            obj.r = r;
            objout = obj;
        end
        function objout = Combine(obj, cell_crackStats)
            sz = length(cell_crackStats);
            for i = 1:sz
                if (isempty(cell_crackStats{i}))
                    continue;
                end
                objo = cell_crackStats{i};
                obj.optm4 = objo.optm4;
                obj.numSegments = objo.numSegments;
                obj.wieghtEqCracklength = objo.wieghtEqCracklength;
                obj.sumSin =  obj.sumSin + objo.sumSin;
                obj.sumCos =  obj.sumCos + objo.sumCos;
                obj.sumWeight = obj.sumWeight + objo.sumWeight;
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
            fprintf(fid, 'thetaMeanDegree\t%g\n', obj.thetaMeanDegree);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'r\t%g\n', obj.r);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'sdiv\t%g\n', obj.sdiv);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'thetaMeanRad\t%g\n', obj.thetaMeanRad);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'thetaMeanRadBase\t%g\n', obj.thetaMeanRadBase);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'averageSin\t%g\n', obj.averageSin);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'averageCos\t%g\n', obj.averageCos);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'sumSin\t%g\n', obj.sumSin);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'sumCos\t%g\n', obj.sumCos);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'optm4\t%d\n', obj.optm4);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'numSegments\t%d\n', obj.numSegments);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'wieghtEqCracklength\t%g\n', obj.wieghtEqCracklength);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'sumWeight\t%g\n', obj.sumWeight);
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
                if (strcmp(buf, 'thetaMeanDegree') == 1)
                    tmp = fscanf(fid, '%g', 1);
                    obj.thetaMeanDegree = tmp;
                elseif (strcmp(buf, 'r') == 1)
                    tmp = fscanf(fid, '%g', 1);
                    obj.r = tmp;
                elseif (strcmp(buf, 'sdiv') == 1)
                    tmp = fscanf(fid, '%g', 1);
                    obj.sdiv = tmp;
                elseif (strcmp(buf, 'thetaMeanRad') == 1)
                    tmp = fscanf(fid, '%g', 1);
                    obj.thetaMeanRad = tmp;
                elseif (strcmp(buf, 'thetaMeanRadBase') == 1)
                    tmp = fscanf(fid, '%g', 1);
                    obj.thetaMeanRadBase = tmp;
                elseif (strcmp(buf, 'averageSin') == 1)
                    tmp = fscanf(fid, '%g', 1);
                    obj.averageSin = tmp;
                elseif (strcmp(buf, 'averageCos') == 1)
                    tmp = fscanf(fid, '%g', 1);
                    obj.averageCos = tmp;
                elseif (strcmp(buf, 'sumSin') == 1)
                    tmp = fscanf(fid, '%g', 1);
                    obj.sumSin = tmp;
                elseif (strcmp(buf, 'sumCos') == 1)
                    tmp = fscanf(fid, '%g', 1);
                    obj.sumCos = tmp;
                elseif (strcmp(buf, 'optm4') == 1)
                    tmp = fscanf(fid, '%d', 1);
                    obj.optm4 = tmp;
                elseif (strcmp(buf, 'optm4') == 1)
                    tmp = fscanf(fid, '%d', 1);
                    obj.optm4 = tmp;
                elseif (strcmp(buf, 'numSegments') == 1)
                    tmp = fscanf(fid, '%d', 1);
                    obj.numSegments = tmp;
                elseif (strcmp(buf, 'wieghtEqCracklength') == 1)
                    tmp = fscanf(fid, '%g', 1);
                    obj.wieghtEqCracklength = tmp;
                elseif (strcmp(buf, 'sumWeight') == 1)
                    tmp = fscanf(fid, '%g', 1);
                    obj.sumWeight = tmp;
                else
                    buf
                    THROW('Invalid key\n');
                end
                [buf, neof] = fscanf(fid, '%s', 1);
            end                
            objout = obj;
        end
        function val = string2number(obj, str)
            if (contains(str, 'mean'))
                val = obj.thetaMeanDegree;
                return;
            end
            if (contains(str, '_r'))
                val = obj.r;
                return;
            end
            if (contains(str, 'sdiv'))
                val = obj.sdiv;
                return;
            end
            if (contains(str, 'meanrad'))
                val = obj.thetaMeanRad;
                return;
            end
            val = obk.thetaMeanDegree;
        end
    end
end