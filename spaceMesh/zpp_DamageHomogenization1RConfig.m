classdef zpp_DamageHomogenization1RConfig
    properties
        gMapAllRuns = gen_map;
        stiffnessAllRuns = [];
        rawDataDamageNames = cell(0);
        rawData2IntegrateInTimeNames = cell(0);
        zppExt = 'zppBSync';
    end
    methods
        function objout = Read(obj, fid)
            [buf, neof] = fscanf(fid, '%s', 1);
            if (strcmp(buf, '{') == 0)
                buf
                THROW('invalid format\n');
            end
            buf = READ(fid, 's');
            while (strcmp(buf, '}') == 0) %&& (neof))
                if (strcmp(buf, 'gMapAllRuns') == 1)
                    [buf, success, obj.gMapAllRuns] = obj.gMapAllRuns.Read_gen_Map(fid);
                elseif (strcmp(buf, 'stiffnessAllRuns') == 1)
                    obj.stiffnessAllRuns = gen_fromFile_matrix(fid);
                elseif (strcmp(buf, 'rawDataDamageNames') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.rawDataDamageNames{cntr} = buf;
                        buf = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'rawData2IntegrateInTimeNames') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.rawData2IntegrateInTimeNames{cntr} = buf;
                        buf = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'zppExt') == 1)
                    obj.zppExt = READ(fid, 's');
                else
                    buf
                    THROW('Invalid key\n');
                end
                buf = READ(fid, 's');
            end
            [m, n] = size(obj.stiffnessAllRuns);
            if (m > 0)
                for i = 1:m
                    for j = 1:n
                        val = obj.stiffnessAllRuns(i, j);
                        CcompName = ['sitffnessVoigt_', num2str(i), num2str(j)];
                        pos = obj.gMapAllRuns.AddKeyVal(CcompName, val);
                    end
                end
            end
            objout = obj;
        end
    end
end

