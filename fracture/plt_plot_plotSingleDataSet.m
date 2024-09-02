classdef plt_plot_plotSingleDataSet
    properties
        xAxisData = plt_plot_axisData;
        yAxisData = plt_plot_axisData;
    end
    methods
        % reading the object from a file:
        % format for reading is
        % [ FLG VAL ]
        % where FLG VAL's are as follows:
        % field:  FLG           VAL format
        % xAxisData             "xAxis"       plt_plot_axisData
        % yAxisData             "yAxis"       plt_plot_axisData
        
        % dataSetOrderModifiers     "mod"        numberOfModifiers followed
        % by numberOfModifiers modifiers (first modier to apply to data
        % appears first)
        
        function objout = read(obj, fid)
            objout = plt_plot_plotSingleDataSet;
            buf = fscanf(fid, '%s', 1);
            if (strcmp(buf, '[') == 0)
                fprintf(1, 'reading plt_plot_plotSingleDataSet: data set does not start with [, instead %s\n', buf);
                pause;
            end
            
            buf = fscanf(fid, '%s', 1);
            while (strcmp(buf, ']') == 0)
                if (strcmp(buf, 'xAxis') == 1)
                    objout.xAxisData = plt_plot_axisData;
                    objout.xAxisData = objout.xAxisData.read(fid);
                elseif (strcmp(buf, 'yAxis') == 1)
                    objout.yAxisData = plt_plot_axisData;
                    objout.yAxisData = objout.yAxisData.read(fid);
                elseif (strcmp(buf, ']') == 0)
                    buf
                    fprintf(1, 'invalid format in plt_plot_plotSingleDataSet %s \n', buf);
                    pause;
                end
                buf = fscanf(fid, '%s', 1);
            end
        end
    end
end
