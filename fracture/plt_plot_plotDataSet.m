classdef plt_plot_plotDataSet
    properties
        axesDataSets; % a vector of plt_plot_plotSingleDataSet
        dataRepresentationNumber = 1; %refers to "data representation" line, marker properties, ... from output to [dataProps, inDataRelatedDataProps, outDataRelatedDataProps] = plt_plotDataProp_ReadDataPropStructure(fid, numIndex)

        numberDataSplits = 1; % number of data split schemes used for this plot
        dataSplitValues; % refers to data split properties (which things are split on outPlot, active in plot, inactive in plot, ...)
        plotPropertyNumber = 1;  % refers to plot, axis labels, title, legend font size, legend location, ....
        numberOfAxesDataSets = 0; % how many X-Y general data sets are included in this set
        % the following two are set based on an input [index_sets,
        % numDataSets, namesGeneral] = gen_Index_set_Read(fid) to ensure
        % xAxis (and yAxis) of all dataSets have the same number of data
        xAxisDataNumber = 0;    % number of data combinations on x axis (should be the same for all components of axesDataSets
        yAxisDataNumber = 0;    % number of data combinations on y axis (should be the same for all components of axesDataSets
        outerLoopCRV = 1;   % for plots for which numberOfAxesDataSets > 1 it matters how we plot data:
        active = 1;         % whether to plot or not the data
        % e.g. data (n number of curvesBase)
        % outerDataSet1 is D1_1, ...., D1_n
        % outerDataSet1 is D2_1, ...., D2_n
        
        % there are two options:
        % outerLoopCRV == 1:
        % D1_1 D2_1, ...,  D1_n D2_n
        % outputLoopCRV == 0
        % D1_1, ...., D1_n, D2_1, ...., D2_n
        pltProp;
    end
    methods
        % reading the object from a file:
        % format for reading is
        % [ FLG VAL ]
        % where FLG VAL's are as follows:
        % field:  FLG           VAL format
        % axesDataSets                      "dataXY"       "number" number (stored in
        % numberOfAxesDataSets) followd by numberOfAxesDataSets
        % plt_plot_plotSingleDataSet sets in the format:
        % index_1 plt_plot_plotSingleDataSet  ... index_numberOfAxesDataSets plt_plot_plotSingleDataSet
        % dataRepresentationNumber          "repNo"         number
        % active                            "active"        0, 1(default        % 1)
        % dataSplitValues, numberDataSplits
        %                                   "splitNos" "num"
        %                                   numberDataSplits "vals" dataSplitValues
        % plotPropertyNumber                "plotNo"        number
        % outerLoopCRV                      "outerLoop"     vals are:
        % c         for     outerLoopCRV==1 (curve is outerloop)
        % d         for     outerLoopCRV==0 (data  is outerloop) 
        
        
        function objout = read(obj, fid)
            objout = plt_plot_plotDataSet;
            buf = fscanf(fid, '%s', 1);
            if (strcmp(buf, '[') == 0)
                fprintf(1, 'reading plt_plot_plotDataSet: data set does not start with [, instead %s\n', buf);
                pause;
            end

            
            buf = fscanf(fid, '%s', 1);
            while (strcmp(buf, ']') == 0)
                if (strcmp(buf, 'dataXY') == 1)
                    buf = fscanf(fid, '%s', 1);
                    objout.numberOfAxesDataSets = fscanf(fid, '%d', 1);
                    for i = 1:objout.numberOfAxesDataSets
                        buf = fscanf(fid, '%d', 1);
                        if (buf ~= i)
                            buf
                            i
                            fprintf(1, 'in reading data for plt_plot_plotDataSet indices should be in order\n');
                            pause;
                        end
                        objout.axesDataSets{i} = plt_plot_plotSingleDataSet;
                        objout.axesDataSets{i} = objout.axesDataSets{i}.read(fid);
                    end
                elseif (strcmp(buf, 'repNo') == 1)
                    objout.dataRepresentationNumber = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'active') == 1)
                    objout.active = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'splitNos') == 1)
                    tmp = fscanf(fid, '%s', 1);
                    objout.numberDataSplits = fscanf(fid, '%d', 1);
                    tmp = fscanf(fid, '%s', 1);
                    for k = 1:objout.numberDataSplits
                        objout.dataSplitValues{k} = fscanf(fid, '%d', 1);
                    end
                elseif (strcmp(buf, 'outerLoop') == 1)
                    tmp = fscanf(fid, '%s', 1);
                    if (strcmp(tmp, 'c') == 1)
                        objout.outerLoopCRV  = 1;
                    elseif (strcmp(tmp, 'd') == 1)
                        objout.outerLoopCRV  = 0;
                    else
                        tmp
                        fprintf(1, 'tmp for outerLoop entry should be either c(curve) or d(data)\n');
                        pause;
                    end
                elseif (strcmp(buf, 'plotNo') == 1)
                    objout.plotPropertyNumber = fscanf(fid, '%d', 1);
                    if (objout.plotPropertyNumber < 0)
                        objout.pltProp = plt_plot_plotProperties;
                        objout.pltProp = objout.pltProp.read(fid);
                    end
                elseif (strcmp(buf, ']') == 0)
                    buf
                    fprintf(1, 'invalid format in plt_plot_plotDataSet %s \n', buf);
                    pause;
                end
                buf = fscanf(fid, '%s', 1);
            end
        end
        
        function objout = setNumberOfDataForEachAxis(obj, index_sets)
            objout = plt_plot_plotDataSet;
            if (obj.numberOfAxesDataSets == 0)
                return;
            end
            dataSetNumberX = obj.axesDataSets{1}.xAxisData.dataSetNumber;
            dataSetNumberY = obj.axesDataSets{1}.yAxisData.dataSetNumber;

            xAxisDataNumber = index_sets{dataSetNumberX}.numCombinations;
            yAxisDataNumber = index_sets{dataSetNumberY}.numCombinations;
            for i = 2:obj.numberOfAxesDataSets
                dataSetNumberXTemp = obj.axesDataSets{i}.xAxisData.dataSetNumber;
                dataSetNumberYTemp = obj.axesDataSets{i}.yAxisData.dataSetNumber;
                xAxisDataNumberTemp = index_sets{dataSetNumberXTemp}.numCombinations;
                yAxisDataNumberTemp = index_sets{dataSetNumberYTemp}.numCombinations;
                if (xAxisDataNumber ~= xAxisDataNumberTemp)
                    i
                    xAxisDataNumberTemp
                    xAxisDataNumber
                    fprintf(1, 'number of fields for different data sets are not equal (x axis)\n');
                    pause;
                end
                if (yAxisDataNumber ~= yAxisDataNumberTemp)
                    i
                    yAxisDataNumberTemp
                    yAxisDataNumber
                    fprintf(1, 'number of fields for different data sets are not equal (y axis)\n');
                    pause;
                end
            end
            objout = obj;
            objout.xAxisDataNumber = xAxisDataNumber;
            objout.yAxisDataNumber = yAxisDataNumber;
        end            
        
        function [dataX4Plot, dataY4Plot, actualLimsX, actualLimsY, dataName4PlotX, dataName4PlotY, axisLabelsX, axisLabelsY] = ...
                getDataNames4Ploting(obj, dataSplitScheme, general_dataModifiers, dataSet, names)
            
            dataX4Plot = cell(0);
            dataY4Plot = cell(0);
            dataName4Plot = cell(0);
            dataName4PlotX = cell(0);
            dataName4PlotY = cell(0);

            actualLimsX = cell(0);
            actualLimsX = cell(1, obj.xAxisDataNumber);
            for i = 1:obj.xAxisDataNumber
               actualLimsX{i} = cell(1, dataSplitScheme.numPlots);
                for plt = 1:dataSplitScheme.numPlots
                    actualLimsX{i}{plt} = [inf, -inf];
                end
            end
            
            actualLimsY = cell(0);
            actualLimsY = cell(1, obj.yAxisDataNumber);
            for i = 1:obj.yAxisDataNumber
               actualLimsY{i} = cell(1, dataSplitScheme.numPlots);
                for plt = 1:dataSplitScheme.numPlots
                    actualLimsY{i}{plt} = [inf, -inf];
                end
            end
            
            for ds = 1:obj.numberOfAxesDataSets
%                axisDataSpec = plt_plot_axisData;
                axisDataSpec = obj.axesDataSets{ds}.xAxisData;
                dataSetNumber = axisDataSpec.dataSetNumber;
                for i = 1:obj.xAxisDataNumber
                   dataTmp = cell(0);
                   dataTmp = aa_SortedMat_getActualPlotValuesFromDataAndSplitMatrixStructure(dataSet{dataSetNumber}{i}, ...
                        dataSplitScheme.fullIndicesSet, dataSplitScheme.numPlots, dataSplitScheme.indPlotNumberOfCurves, ...
                        dataSplitScheme.indPlotNumberOfDataSetPerCurve, dataSplitScheme.indPlotNumberOfPointsPerDataSet);
                    
                   
                    dataName4PlotX{1}{i}{ds} = names{1}{dataSetNumber}{i};
                    dataName4PlotX{2}{i}{ds} = names{2}{dataSetNumber}{i};
                    
                    for plt = 1:dataSplitScheme.numPlots
                        for c = 1:dataSplitScheme.indPlotNumberOfCurves{plt}
                            if (axisDataSpec.num_dataSetOrderModifiers == 0)
                                dat = dataTmp{plt}{c};
                            else
                                dat = axisDataSpec.operateSeries(dataTmp{plt}{c}, general_dataModifiers);
                            end
                            dataX4Plot{i}{ds}{plt}{c} = dat;
                            dat = dat(~isinf(dat));
                            actualLimsX{i}{plt}(1) = min(actualLimsX{i}{plt}(1), min(dat));
                            actualLimsX{i}{plt}(2) = max(actualLimsX{i}{plt}(2), max(dat));
                        end
                    end
                end
                
                axisDataSpec = obj.axesDataSets{ds}.yAxisData;
                dataSetNumber = axisDataSpec.dataSetNumber;
                for i = 1:obj.yAxisDataNumber
                   dataTmp = cell(0);
                   dataTmp = aa_SortedMat_getActualPlotValuesFromDataAndSplitMatrixStructure(dataSet{dataSetNumber}{i}, ...
                        dataSplitScheme.fullIndicesSet, dataSplitScheme.numPlots, dataSplitScheme.indPlotNumberOfCurves, ...
                        dataSplitScheme.indPlotNumberOfDataSetPerCurve, dataSplitScheme.indPlotNumberOfPointsPerDataSet);
                    
                    dataName4PlotY{1}{i}{ds} = names{1}{dataSetNumber}{i};
                    dataName4PlotY{2}{i}{ds} = names{2}{dataSetNumber}{i};

                    for plt = 1:dataSplitScheme.numPlots
                        for c = 1:dataSplitScheme.indPlotNumberOfCurves{plt}
                            if (axisDataSpec.num_dataSetOrderModifiers == 0)
                                dat = dataTmp{plt}{c};
                            else
                                dat = axisDataSpec.operateSeries(dataTmp{plt}{c}, general_dataModifiers);
                            end
                            dataY4Plot{i}{ds}{plt}{c} = dat;
                            dat = dat(~isinf(dat));
                            actualLimsY{i}{plt}(1) = min(actualLimsY{i}{plt}(1), min(dat));
                            actualLimsY{i}{plt}(2) = max(actualLimsY{i}{plt}(2), max(dat));
                        end
                    end
                end
                
            end
            
            sep = ', ';
            maxNumber2Merge = 3;
            maxSizeWord = 30;
            for i = 1:obj.xAxisDataNumber
%                    axisLabelsX{1}{i} = 'xLabel';
                    [reducedSet, num] = aa_word_process_removeRepetativeStrings(dataName4PlotX{1}{i});
                    axisLabelsX{i}{1} = aa_word_process_MergeWords(reducedSet, sep, maxNumber2Merge, maxSizeWord);
                    [reducedSet, num] = aa_word_process_removeRepetativeStrings(dataName4PlotX{2}{i});
                    axisLabelsX{i}{2} = aa_word_process_MergeWords(reducedSet, sep, maxNumber2Merge, maxSizeWord);
            end

            for i = 1:obj.yAxisDataNumber
%                    axisLabelsY{1}{i} = 'yLabel';
                    [reducedSet, num] = aa_word_process_removeRepetativeStrings(dataName4PlotY{1}{i});
                    axisLabelsY{i}{1} = aa_word_process_MergeWords(reducedSet, sep, maxNumber2Merge, maxSizeWord);
                    [reducedSet, num] = aa_word_process_removeRepetativeStrings(dataName4PlotY{2}{i});
                    axisLabelsY{i}{2} = aa_word_process_MergeWords(reducedSet, sep, maxNumber2Merge, maxSizeWord);
            end
            
        end
    end
end
