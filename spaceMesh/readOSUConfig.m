classdef readOSUConfig
    properties
        numLCs = [];
        ConfigPaths =cell(0);
    end
    methods(Static)
         function objout = ReadConfig(fid)
            buf = READ(fid,'s');
            if (strcmp(buf, '{') == 0)
                buf
                THROW('invalid format\n');
            end
            buf = READ(fid, 's');
            while (strcmp(buf, '}') == 0) %&& (neof))
                if (strcmp(buf, 'numLCs') == 1)
                    buf = READ(fid, 'd');
                    obj.numLCs = buf;
                    buf = READ(fid,'s');
                elseif (strcmp(buf, 'ConfigFiles') == 1)
                     cntr = 0;
                     for i = 1:obj.numLCs
                         cntr = cntr+1;
                         buf = READ(fid, 's');
                         obj.ConfigPaths{cntr} = buf;
                     end
                     buf = READ(fid, 's');
                 end
            end
            objout = obj;           
         end
    end
end
        