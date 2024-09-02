classdef aa_general_dataModifiers
    properties 
        numModifiers = 0;
        modifierInstances;

        
    end
    methods
        % reading the object from a file:
        % format for reading is
        % [ FLG VAL ]
        % where FLG VAL's are as follows:
        % numModifiers:  numberModifiers           number: followed by modifiers
        % each as      index modifier
        
        function objout = read(obj, fid)
            objout = aa_general_dataModifiers;
            buf = fscanf(fid, '%s', 1);
            if (strcmp(buf, '[') == 0)
                fprintf(1, 'reading aa_general_dataModifiers: data set does not start with [, instead %s\n', buf);
                pause;
            end
            
            buf = fscanf(fid, '%s', 1);
            while (strcmp(buf, ']') == 0)
                if (strcmp(buf, 'numberModifiers') == 1)
                    objout.numModifiers = fscanf(fid, '%d', 1);
                    for i = 1:objout.numModifiers
                        index = fscanf(fid, '%d', 1);
                        objout.modifierInstances{index} = aa_general_dataModifierInstance;
                        objout.modifierInstances{index} = objout.modifierInstances{index}.read(fid);
                    end
                elseif (strcmp(buf, ']') == 0)
                    buf
                    fprintf(1, 'invalid format in reading aa_general_dataModifiers %s \n', buf);
                    pause;
                end
                buf = fscanf(fid, '%s', 1);
            end
        end
        
        
        function dataOut = operate(obj, dataIn, modifierNumber)
            if ((obj.numModifiers == 0) || (modifierNumber <= 0))
                dataOut = dataIn;
                return;
            else
                dataOut = obj.modifierInstances{modifierNumber}.operate(dataIn);
            end
        end
        function dataOut = operateSeries(obj, dataIn, modifierNumbers)
            if nargin < 3
                dataOut = dataIn;
                return;
            end
            num = length(modifierNumbers);
            dataOut = dataIn;
            for i = 1:num
                dataOut = obj.operate(dataOut, modifierNumbers(i));
            end
        end
    end
end
