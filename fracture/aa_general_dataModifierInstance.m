classdef aa_general_dataModifierInstance
    properties
        logBase = 0;
        takeAbsValue = 0;
    end
    methods
        % reading the object from a file:
        % format for reading is
        % [ FLG VAL ]
        % where FLG VAL's are as follows:
        % field:  FLG           VAL format
        % logBase             "log"       2, e (Neperian), 10, ....
        
        function objout = read(obj, fid)
            objout = aa_general_dataModifierInstance;
            buf = fscanf(fid, '%s', 1);
            if (strcmp(buf, '[') == 0)
                fprintf(1, 'reading aa_general_dataModifierInstance: data set does not start with [, instead %s\n', buf);
                pause;
            end
            
            buf = fscanf(fid, '%s', 1);
            while (strcmp(buf, ']') == 0)
                if (strcmp(buf, 'log') == 1)
                    sym = fscanf(fid, '%s', 1);
                    if (strcmp(sym, 'e') == 1)
                        objout.logBase = -1; % ,means  it's Neperian
                    else
                        objout.logBase = str2num(sym);
                        if (objout.logBase < 0)
                            objout.takeAbsValue = 1;
                            objout.logBase = -objout.logBase;
                        end
                    end
                elseif (strcmp(buf, ']') == 0)
                    buf
                    fprintf(1, 'invalid format in reading aa_general_dataModifierInstance %s \n', buf);
                    pause;
                end
                buf = fscanf(fid, '%s', 1);
            end
        end
        
        
        function dataOut = operate(obj, dataIn)
            if (obj.takeAbsValue == 1)
                dataIn = abs(dataIn);
            end
            if (obj.logBase == 0)
                dataOut = datIn;
            elseif (obj.logBase > 0)
                 dataIn(find(dataIn <= 0)) = NaN;
                dataOut = log(dataIn) / log(obj.logBase);
            elseif (obj.logBase == -1)
                dataIn(find(dataIn <= 0)) = NaN;
                dataOut = log(dataIn);
            end
        end
    end
end