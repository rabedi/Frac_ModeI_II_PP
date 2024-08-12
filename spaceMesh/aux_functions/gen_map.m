classdef gen_map < handle
    properties(Access = public)
        keys = cell(0);
        valsStr = cell(0);
    end
    
    methods(Access = public)
        
%        function obj = Read_gen_Map(fid)
        function [buf, success, objout] = Read_gen_Map(obj, fid)
            buf = READ(fid,'s');
            if (strcmp(buf, '{') == 0)
                success = 0;
%                buf
%                THROW('invalid format\n');
            	objout = obj;
                return;
            end
            success = 1;
            buf = READ(fid,'s');
            cntr = 0;
            while (strcmp(buf, '}') == 0)
                if (strcmp(buf, '(') == 0)
                    buf
                    THROW('(pairs of key value in gen_Map must be enclodes in ( ), e.g. ( key value )\n');
                end
                cntr = cntr + 1;
                key = READ(fid,'s');
                val = READ(fid,'s');
                
                buf = READ(fid,'s');
                if (strcmp(buf, ')') == 0)
                    buf
                    THROW(')pairs of key value in gen_Map must be enclodes in ( ), e.g. ( key value )\n');
                end

                obj.keys{cntr} = key;
                obj.valsStr{cntr} = val;

                buf = READ(fid,'s');
            end
            buf = '';
            objout = obj;
%            objout = obj;
        end

        function pos = AddKeyVal(obj, key, val, overwrite)
            if nargin < 4
                overwrite = 1;
            end
            [valOld, pos] = obj.AccessStr(key);
            if (pos < 0)
                len = length(obj.keys);
                pos = len + 1;
                obj.keys{pos} = key;
            elseif (overwrite ~= 1) % value exist and we cannot overwrite
                return;
            end
            val = num2str(val);
            obj.valsStr{pos} = val;
        end
        function AppendOtherMap(obj, otherMap)
            len = length(otherMap.keys);
            for i = 1:len
                obj.AddKeyVal(otherMap.keys{i}, otherMap.valsStr{i});
            end
        end
        
        function [val, pos] = AccessStr(obj, key)
            val = cell(0);
            pos = -1;
            for i = 1:length(obj.keys)
                if (strcmp(key, obj.keys{i}) == 1)
                    val = obj.valsStr{i};
                    pos = i;
                    return;
                end
            end
        end
        
        function [val, valid] = AccessNumber(obj, key)
            valStr = obj.AccessStr(key);
            val = [];
            if (~isempty(valStr))
                val = str2num(valStr);
            end
            valid = (length(val) > 0);
        end
    end
end