classdef aSDG_runProperties
	properties
        rootFolderBase = '../../../';
        runFolder; % only old .... 
        runFolderComplete; % rootFolderBase , runFolder, physicsFolder 
        physicsFolder = 'physics';
        front_folder_name = 'output_front';
        runName = 'Micro';
        phyName = 'SL';
        midName = 'front';
        % -1 does not even have front.last file;
        %  0 does not have zpp
        % 1 has zpp
        zppFlag = 1;
        zppFileName;
        frontLastFileName;
        frontSyncLastFileName;
        
        runMap = gen_map;
        num_values;
        values; % values of run, e.g. xy, tau, ... values for Micro runs
        valuesOptionName = 'none'; % if Micro values will be generated from the file name
    end
    methods
        function [objout, valid] = fromFile(obj, fid)
            buf = READ(fid,'s');
            if (strcmp(buf, '}') == 1)
                valid = 0;
                objout = obj;
                return;
            end
            if (strcmp(buf, '{') == 0)
                buf
                THROW('invalid format\n');
            end
            valid = 1;
%            [buf, neof] = fscanf(fid, '%s', 1);
            buf = READ(fid,'s');
%            while ((strcmp(buf, '}') == 0) && (neof))
            while (strcmp(buf, '}') == 0)
                if (strcmp(buf, 'values') == 1)
                    buf = READ(fid,'s');
                    if (strcmp(buf, '{') == 0)
                        obj.valuesOptionName = buf;
                    else
                        buf = READ(fid,'s');
                        cntr = 0;
                        while (strcmp(buf, '}') == 0)
                            num = str2num(buf);
                            if (length(num) == 0)
                                buf
                                THROW('Cannot turn buf to number\n');
                            end
                            cntr = cntr + 1;
                            obj.values{cntr} = num;
                            buf = READ(fid,'s');
                        end
                    end
                elseif (strcmp(buf, 'folder') == 1)
                    obj.runFolder = READ(fid, 's');
                elseif (strcmp(buf, 'runMap') == 1)
                    obj.runMap.Read_gen_Map(fid)
                elseif (strcmp(buf, 'physicsFolder') == 1)
                    obj.physicsFolder = READ(fid, 's');
                elseif (strcmp(buf, 'front_folder_name') == 1)
                    obj.front_folder_name = READ(fid, 's');
                elseif (strcmp(buf, 'phyName') == 1)
                    obj.phyName = READ(fid, 's');
                elseif (strcmp(buf, 'midName') == 1)
                    obj.midName = READ(fid, 's');
                elseif (strcmp(buf, 'midName') == 1)
                    obj.midName = READ(fid, 's');
                elseif (strcmp(buf, 'midName') == 1)
                    obj.midName = READ(fid, 's');
                else
                    buf
                    THROW('Invalid key\n');
                end
                buf = READ(fid, 's');
            end
            
            if (strcmp(obj.valuesOptionName, 'none') == 0)
                if (strcmp(obj.valuesOptionName, 'Micro') == 1) % automatically generating flags
                    xy = 1;
                    random = 2;
                    tau = 3;
                    aDot = 4;
                    resolution = 5;
                    meshNo = 6;
                    adaptive = 7;
                    tolerance = 8;
                    sz = 8;
                    obj.values = cell(1, sz);
                    for i = 1:sz
                        obj.values{i} = 0;
                    end
                    fldr = obj.runFolder;
                    if (contains(fldr, 'tol'))
                        obj.values{adaptive} = 1;
                        obj.values{meshNo} = -1; % a file
                        C = strsplit(fldr,'tol');
                        c2 = C{2}(1:5);
                        tol = -1;
                        if (strcmp(c2, '1em8_'))
                            tol = 8;
                        elseif (strcmp(c2, '1em9_'))
                            tol = 9;
                        elseif (strcmp(c2, '1em10'))
                            tol = 10;
                        elseif (strcmp(c2, '1em11'))
                            tol = 11;
                        elseif (strcmp(c2, '1em12'))
                            tol = 12;
                        elseif (strcmp(c2, '1em7_'))
                            tol = 7;
                        end
                        obj.values{tolerance} = tol;
                    else
                        if (contains(fldr, '3_NPa'))
                            obj.values{meshNo} = -1; % a file
                        elseif (contains(fldr, '3_NP0'))
                            obj.values{meshNo} = 0;
                        elseif (contains(fldr, '3_NP1'))
                            obj.values{meshNo} = 1;
                        elseif (contains(fldr, '3_NP2'))
                            obj.values{meshNo} = 2;
                        end
                    end
                    x = contains(fldr, '_x_');
                    obj.values{xy} = 1 - x;
                    if (contains(fldr, '28'))
                        obj.values{resolution} = 28;
                    elseif (contains(fldr, '64'))
                        obj.values{resolution} = 64;
                    elseif (contains(fldr, '52'))
                        obj.values{resolution} = 52;
                    elseif (contains(fldr, '88'))
                        obj.values{resolution} = 88;
                    end

                    if (contains(fldr, '05x05'))
                        obj.values{random} = 0.05;
                    elseif (contains(fldr, 'infxinf'))
                        obj.values{random} = 1;
                    elseif (contains(fldr, '02x02'))
                        obj.values{random} = 0.025;
                    elseif (contains(fldr, '01x01'))
                        obj.values{random} = 0.01;
                    elseif (contains(fldr, '10x10'))
                        obj.values{random} = 0.1;
                    elseif (contains(fldr, '12x12'))
                        obj.values{random} = 0.125;
                    elseif (contains(fldr, '25x25'))
                        obj.values{random} = 0.25;
                    elseif (contains(fldr, '50x50'))
                        obj.values{random} = 0.5;
                    end

                    if (contains(fldr, '16em2'))
                        obj.values{tau} = 0.0116;
                    elseif (contains(fldr, '16em3'))
                        obj.values{tau} = 0.00116;
                    end


                    if (contains(fldr, 'a013'))
                        obj.values{aDot} = 0.013;
                    elseif (contains(fldr, 'a13'))
                        obj.values{aDot} = 0.13;
                    end
                else
                    valuesOptionName = obj.valuesOptionName
                    fprintf(1, 'obj.valuesOptionName must be Micro if it is not none (i.e. it is a specific run option provided by the user\n');
                    THROW('Invalid run option\n');
                end
            end
            obj.num_values = length(obj.values);
            objout = obj;
        end
        function objout = Finalize(obj)
            obj.runFolderComplete =  [obj.rootFolderBase, obj.runFolder, '/', obj.physicsFolder];
            obj.frontLastFileName = [obj.runFolderComplete, '/front.last'];
            obj.frontSyncLastFileName = [obj.runFolderComplete, '/frontSync.last'];

            fidfl = fopen(obj.frontLastFileName, 'r');
            if (fidfl < 0)
                obj.zppFlag = -1;
            else
                buf = fscanf(fidfl, '%s', 1);
                obj.front_folder_name = fscanf(fidfl, '%s', 1);
                buf = fscanf(fidfl, '%s', 1);
                obj.runName = fscanf(fidfl, '%s', 1);
                buf = fscanf(fidfl, '%s', 1);
                obj.phyName = fscanf(fidfl, '%s', 1);
                buf = fscanf(fidfl, '%s', 1);
                obj.midName = fscanf(fidfl, '%s', 1);
                fclose(fidfl);

                obj.zppFileName = [obj.runFolderComplete, '/', obj.front_folder_name, '/', obj.runName, obj.phyName, obj.midName, 'Sync.zppBSync'];
                fidzp = fopen(obj.zppFileName, 'r');
                if (fidzp < 0)
                    obj.zppFlag = 0;
                else
                    fclose(fidzp);
                    obj.zppFlag = 1;
                end
            end
            objout = obj;
        end
    end
end