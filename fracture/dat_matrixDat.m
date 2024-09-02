classdef dat_matrixDat
    properties
    % numSeries is for example number of time steps taken
    numSeries = 0;
    % number of data sets is how many data sets (e.g. displacement,
    % velocity, ..., are there)
    numDataSets = 0;
    % names for data set used in legends
    % indexed as (nm + 1, dt) % nm normalizationMode (starting from 0) and
    % dt is field index
    dataSetLabels;
     
    % the first column of data being the name of the given row
    hasRowAppendName;
    appendNames;
    
    % there can be more than one row of normalization
    numNormalizations;
    nameNormalizationsLong;
    nameNormalizationsShort;
    % normalization values for data sets
    dataSetScales;
    % actual data (numSeries rows, numDataSets columns)
    dat;
    end
    methods
        % reading the object from a file:
        % format for reading is
        % [ FLG VAL ]
        % where FLG VAL's are as follows:
        % field:  FLG           VAL format
        % box             "box"       'off'(0) or 'on'(1)
        % location        "loc"       text
        % legendFontSize  "lfs"       number
        
        function objout = read(obj, fid, maxDataSize)
            objout = dat_matrixDat;
            buf = fscanf(fid, '%s', 1);
            objout.hasRowAppendName = fscanf(fid, '%d', 1);
            buf = fscanf(fid, '%s', 1);
            objout.numSeries = fscanf(fid, '%d', 1);
            buf = fscanf(fid, '%s', 1);
            objout.numDataSets = fscanf(fid, '%d', 1);
            buf = fscanf(fid, '%s', 1);
            nm = 1; % nonnormalized names
            if (objout.hasRowAppendName == 1)
                buf = fscanf(fid, '%s', 1);
            end            
            for i = 1:objout.numDataSets
                objout.dataSetLabels{nm, i} = fscanf(fid, '%s', 1);
            end
            buf = fscanf(fid, '%s', 1);
            objout.numNormalizations = fscanf(fid, '%d', 1);
            for nm = 1:objout.numNormalizations
                buf = fscanf(fid, '%s', 4);
                objout.nameNormalizationsLong{nm} = fscanf(fid, '%s', 1);
                buf = fscanf(fid, '%s', 1);
                objout.nameNormalizationsShort{nm} = fscanf(fid, '%s', 1);
                buf = fscanf(fid, '%s', 1);
            
                buf = fscanf(fid, '%s', 1); % should be fieldNames
                
                if (objout.hasRowAppendName == 1)
                    buf = fscanf(fid, '%s', 1);
                end            
                for i = 1:objout.numDataSets
                    objout.dataSetLabels{nm + 1, i} = fscanf(fid, '%s', 1);
                end
                if (objout.hasRowAppendName == 1)
                    buf = fscanf(fid, '%s', 1);
                end            
                for i = 1:objout.numDataSets
                    objout.dataSetScales(nm, i) = fscanf(fid, '%g', 1);
                end
            end
            objout.dat = zeros(objout.numSeries, objout.numDataSets);
            for j = 1:objout.numSeries
                if (objout.hasRowAppendName == 1)
                    objout.appendNames{j} = fscanf(fid, '%s', 1);
                end            
                for i = 1:objout.numDataSets
                    objout.dat(j, i) = fscanf(fid, '%g', 1);
                end
            end
            if (objout.numSeries > maxDataSize)
                db = objout.dat;
                rat = ceil(objout.numSeries / maxDataSize);
                db1 = downsample(db(:, 1), rat);
                objout.numSeries = length(db1);
                objout.dat = zeros(objout.numSeries, objout.numDataSets);
                for i = 1:objout.numDataSets
                    objout.dat(:, i) = downsample(db(:, i), rat);
                end
            end
        end
        % normalizationNumber > 0, value is normalized by the corresponding
        % normalization value
        function y = getData(obj, dataCol, normalizationNumber) 
            if (normalizationNumber == 0)
                y = obj.dat(:, dataCol);
            else
                y = obj.dat(:, dataCol) / obj.dataSetScales(normalizationNumber, dataCol);
            end
        end
    end
end