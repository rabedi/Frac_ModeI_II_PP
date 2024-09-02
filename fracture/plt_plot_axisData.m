classdef plt_plot_axisData
    properties
        dataSetNumber;
        dataSetOrderModifiers = [];
        num_dataSetOrderModifiers = 0;
    end
    methods
        % reading the object from a file:
        % format for reading is
        % [ FLG VAL ]
        % where FLG VAL's are as follows:
        % field:  FLG           VAL format
        % dataSetNumber             "data"       number
        % dataSetOrderModifiers     "mod"        numberOfModifiers followed
        % by numberOfModifiers modifiers (first modier to apply to data
        % appears first)
        
        function objout = read(obj, fid)
            objout = plt_plot_axisData;
            buf = fscanf(fid, '%s', 1);
            if (strcmp(buf, '[') == 0)
                fprintf(1, 'reading plt_plot_axisData: data set does not start with [, instead %s\n', buf);
                pause;
            end
            
            buf = fscanf(fid, '%s', 1);
            while (strcmp(buf, ']') == 0)
                if (strcmp(buf, 'data') == 1)
                    objout.dataSetNumber = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'mod') == 1)
                    buf = fscanf(fid, '%s', 1);
                    num = fscanf(fid, '%d', 1);
                    buf = fscanf(fid, '%s', 1);
                    for i = 1:num
                        objout.dataSetOrderModifiers(i) = fscanf(fid, '%d', 1);
                    end
                    objout.num_dataSetOrderModifiers = num;
                elseif (strcmp(buf, ']') == 0)
                    buf
                    fprintf(1, 'invalid format in plt_plot_axisData %s \n', buf);
                    pause;
                end
                buf = fscanf(fid, '%s', 1);
            end
        end
        
        function dataOut = operateSeries(obj, dataIn, general_dataModifiers)
            dataOut = general_dataModifiers.operateSeries(dataIn, obj.dataSetOrderModifiers);
        end
    end
end
