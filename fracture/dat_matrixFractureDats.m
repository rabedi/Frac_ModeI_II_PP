classdef dat_matrixFractureDats
    properties
    root;
    version;
    numRuns;
    runNames;
    runParameters;
    runsParameterName;
        
    % base data read
    % time histories
    timeHistories;
    criticalPoints;

    % data created from critical Points from runs
    criticalPointsCurves;
    numCriticalPointsNormalizations;
    
    % index as followed {j, nm, dir}
    % j dataSet number
    % nm normalization mode number (1, 2, ...)
    % dir = 1, 2
    criticalPointsNormalizedCurves;
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
        
        function objout = read(obj, versionIn, rootIn, maxDataSize)
            objout = dat_matrixFractureDats;
            if (nargin < 3)
                objout.root = 'data/';
            else
                objout.root = rootIn;
            end
            objout.version = versionIn;
            objout.numRuns = 0;
            fid = 1;
            vn = num2str(versionIn);
            while (1)
                sn = num2str(objout.numRuns);
                fprintf(1, 'reading run %s\n', sn);
                br = 0;
                for dir = 0:1
                    dn = num2str(dir);
                    nameTS =[objout.root, 'fractureComparison_v_', vn, '_s_', sn, '_dir_', dn, '.thData'];
                    fid = fopen(nameTS, 'r');

                    if (fid < 0)
                        br = 1;
                        break;
                    end
                    objout.timeHistories{objout.numRuns + 1, dir + 1} = dat_matrixDat;
                    objout.timeHistories{objout.numRuns + 1, dir + 1} = objout.timeHistories{objout.numRuns + 1, dir + 1}.read(fid, maxDataSize);
                    fclose(fid);
                end
                if (br == 1)
                    break;
                end
                for dir = 0:1
                    dn = num2str(dir);
                    nameTS =[objout.root, 'fractureComparison_v_', vn, '_s_', sn, '_dir_', dn, '.criticalPt'];
                    fid = fopen(nameTS, 'r');

                    if (fid < 0)
                        br = 1;
                        break;
                    end
                    objout.criticalPoints{objout.numRuns + 1, dir + 1} = dat_matrixDat;
                    objout.criticalPoints{objout.numRuns + 1, dir + 1} = objout.criticalPoints{objout.numRuns + 1, dir + 1}.read(fid, maxDataSize);
                    fclose(fid);
                end
                if (br == 1)
                    break;
                end
                objout.numRuns = objout.numRuns + 1;
            end
            if (objout.numRuns == 0)
                return;
            end
            numCriticalPointType = objout.criticalPoints{1, 1}.numSeries;
            objout.numCriticalPointsNormalizations = objout.criticalPoints{1, 1}.numNormalizations;
%            appendName{1} = '_c';
%             for j = 2:numCriticalPointType - 1
%                 stressRatio = objout.criticalPoints{1, 1}.dat(j, 1);
%                 appendName{j} = ['_{', num2str(stressRatio), '}'];
%             end
%          j = numCriticalPointType;
%            appendName{j} = '_f';
             appendName = objout.criticalPoints{1, 1}.appendNames;
            for dir = 0:1
                for j = 1:numCriticalPointType
                    cpcurve = dat_matrixDat;
                    cpcurve.hasRowAppendName = 0;   %objout.criticalPoints{1, dir + 1}.hasRowAppendName;
                    cpcurve.appendNames = cell(0); %objout.criticalPoints{1, dir + 1}.appendNames;
                    cpcurve.numNormalizations = objout.criticalPoints{1, dir + 1}.numNormalizations;
                    cpcurve.nameNormalizationsLong = objout.criticalPoints{1, dir + 1}.nameNormalizationsLong;
                    cpcurve.nameNormalizationsShort = objout.criticalPoints{1, dir + 1}.nameNormalizationsShort;

                    cpcurve.numDataSets = objout.criticalPoints{1, dir + 1}.numDataSets;
                    cpcurve.numSeries = objout.numRuns;
                    cpcurve.dataSetScales = objout.criticalPoints{1, dir + 1}.dataSetScales;
                    cpcurve.dataSetLabels = objout.criticalPoints{1, dir + 1}.dataSetLabels;
                    for nm = 1:(cpcurve.numNormalizations + 1)
                        for i = 1:cpcurve.numDataSets
                            cpcurve.dataSetLabels{nm, i} = ['#', cpcurve.dataSetLabels{nm, i}, '#', appendName{j}];
                        end
                    end
                    for ri = 1:cpcurve.numSeries
                        for di = 1:cpcurve.numDataSets
                            cpcurve.dat(ri, di) = objout.criticalPoints{ri, dir + 1}.dat(j, di);
                        end
                    end
                    objout.criticalPointsCurves{j, dir + 1} = cpcurve;
                    
                    for nm = 1:objout.numCriticalPointsNormalizations
                        cpcurveN = dat_matrixDat;
                        cpcurveN = cpcurve;
                        for ri = 1:cpcurve.numSeries
                            for di = 1:cpcurve.numDataSets
                                cpcurveN.dat(ri, di) = objout.criticalPoints{ri, dir + 1}.dat(j, di) / objout.criticalPoints{ri, dir + 1}.dataSetScales(nm, di);
                            end
                        end
                        objout.criticalPointsNormalizedCurves{j, nm, dir + 1} = cpcurveN;
                    end
                end
            end
            namec =['../../physics', '/config/_configFractureComparison_v_', vn, '.txt'];
            fidc = fopen(namec, 'r');
            if (fidc < 0)
                fprintf('cannot open config file %s\n', namec);
            end
            buf = 'none';
            while (strcmp(buf, 'run') == 0)
                buf = fscanf(fidc, '%s', 1);
            end
            buf = fscanf(fidc, '%s', 1);
            if (strcmp(buf, 'parameterName') == 0)
                fprintf(1, 'After run there should the keyword parameterName in the config file, now there is %s', buf);
                pause;
            end
            buf = fscanf(fidc, '%s', 1);
            objout.runsParameterName = buf;
            for i = 1:objout.numRuns
                while (strcmp(buf, 'runName') == 0)
                    buf = fscanf(fidc, '%s', 1);
                end
                objout.runNames{i} = fscanf(fidc, '%s', 1);
                buf = fscanf(fidc, '%s', 1);
                objout.runParameters(i) = fscanf(fidc, '%g', 1);
            end
        end
        % ys returns all curves
        % multiRunCurve = 1 : there is one ys and it's comprised of
        % all runs data points
        % yLabel formed by names provided in text files
        % yLabelSimple is the simple version (e.g. d1, etc.)
        
        % N below is one integer in the following format
        % 0 nonnormalized values obtained
        % > 0 normalized set N is used to normalize the value
        
        % dataIndex =  
        %     (ab)(N)dir   (ab) two digits           (ab) field
        %               dir direction
        %     (cd)(ab)(N)dir   (ab) (cd) two digits  (ab) field (cd)
        %     criticalPt type  dir direction
        
        % example   921: direction 1 data type 9  normalization 2
        % example   902: direction 2 data type 9  No normalization
        %           30902: direction 2, data type 9, critical type 3,
        %           nonormalization
        function [ys, numYs, multiRunCurve, legEntries, yLabel, ylabelSimple]  = getData(obj, dataIndex)
            if (dataIndex == 0)
                ys{1} = obj.runParameters;
                numYs = 1;
                multiRunCurve = 0;
                legEntries{1} = obj.runsParameterName;
                yLabel  = legEntries{1};
                ylabelSimple = 'RunParameter';
                return;
            end
            [criticalPtType, dataSet, nm, dir] = dat_breakDownIndex(dataIndex);
            nms = '';
            if (nm > 0)
                nms = ['n', num2str(nm)];
            end
            
            if (criticalPtType > 0) % dealing with data between multiple runs
                multiRunCurve = 0;
%                nmp = 1;
                if (nm == 0)
                    ys{1} = obj.criticalPointsCurves{criticalPtType, dir}.dat(:, dataSet);
                   legEntries{1} = obj.criticalPointsCurves{criticalPtType, dir}.dataSetLabels{nm + 1, dataSet};
                 else
%                    nmp = nm;
                    ys{1} = obj.criticalPointsNormalizedCurves{criticalPtType, nm, dir}.dat(:, dataSet);
                    legEntries{1} = obj.criticalPointsNormalizedCurves{criticalPtType, nm, dir}.dataSetLabels{nm + 1, dataSet};
                end                   
                numYs = 1;  
                yLabel = legEntries{1};
                ylabelSimple = ['cp', num2str(criticalPtType), 'ds', num2str(dataSet), nms, 'dir', num2str(dir)];
            else
                multiRunCurve = 1;
                yLabel = obj.timeHistories{1, dir}.dataSetLabels{nm + 1, dataSet};
                ylabelSimple = ['ds', num2str(dataSet), nms, 'dir', num2str(dir)];
                numYs = obj.numRuns;
                ys = cell(1, numYs);
                for run = 1:numYs
                    ys{run} = obj.timeHistories{run, dir}.getData(dataSet, nm);
                end
                legEntries = obj.runNames;
%                 if (nm > 0)
%                     for run = 1:numYs
%                         legEntries{run} = [nms, ',', legEntries{run}];
%                     end
%                end
            end
        end
    end
end
