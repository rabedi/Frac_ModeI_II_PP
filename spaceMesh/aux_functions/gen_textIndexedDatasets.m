classdef gen_textIndexedDatasets
    properties
        % xaxes name and values (e.g. time in sync runs)
        nameXAxes = 'x';
        xAxesVals = [];
        
        numPts = 0;
        numDataSets = 0;
        dataNames;
        dataNameSerialLatex = 'n';
        dataNamexLatex = 't';
        dataNamesLatex;
        dataOrders; % tensor orders, scalar, vector, matrix
        data;
        treatAllAsCell = 1;
        
        % groups that are used for forming data sets, curves, and points in
        % plots
        sepDataLocs;
        sepDataVals;
    end
    methods
        function objout = Initialize(obj, numPtsIn, nameXAxesIn)
            obj.numPts = numPtsIn;
            for i = 1:obj.numDataSets
                obj.data{i} = cell(obj.numPts, 1);
            end
            if (nargin < 3)
                obj.nameXAxes = nameXAxesIn;
            end
            obj.xAxesVals = zeros(obj.numPts, 1);
            
            objout = obj;
        end
        function dataIndex = DataName2Index(obj, dataName)
            dataIndex = nan;
            dataName = lower(dataName);
            for i = 1:obj.numDataSets
                if (strcmp(obj.dataNames{i}, dataName) == 1)
                    dataIndex = i;
                    return;
                end
            end
            if (contains(dataName, 'serial'))
                dataIndex = -1; % serial number
            elseif ((contains(dataName, 'xvals')) || (contains(dataName, 'time')))
                dataIndex = 0; % xvalues
            else
                dataIndex = nan;
%                names = obj.dataNames
%                dataName
%                THROW('cannot find dataName in dataNames\n');
            end
        end
        
        % only called on first entry (pt = 1)
        % addPtData actually adds ptData to cell or vector of data
        function objout = AddDataSetFirstPt(obj, ptData, dataName, addPtData)
            [m, n] = size(ptData);
            obj.numDataSets = obj.numDataSets + 1;
            if (nargin < 3)
                dataName = num2str(obj.numDataSets);
            end
            dataName = lower(dataName);
            if (nargin < 4)
                addPtData = 1;
            end
            if (m == 1)
                if (n == 1)
                    obj.dataOrders(obj.numDataSets) = 0;
                else
                    obj.dataOrders(obj.numDataSets) = 1;
                    %                  ptData = ptData';
                end
            else
                if (n == 1)
                    obj.dataOrders(obj.numDataSets) = 1;
                else
%                     obj.dataOrders(obj.numDataSets) = 2;
                end
            end
            obj.dataNames{obj.numDataSets} = lower(dataName);
            
            if ((obj.treatAllAsCell) || (obj.dataOrders(obj.numDataSets) > 0))
                if (obj.numPts > 1)
                    obj.data{obj.numDataSets} = cell(obj.numDataSets, 1);
                end
                if (addPtData)
                    obj.data{obj.numDataSets}{1} = ptData;
                end
            else
                if (obj.numPts > 1)
                    obj.data{obj.numDataSets} = zeros(obj.numDataSets, 1);
                end
                if (addPtData)
                    obj.data{obj.numDataSets}(1) = ptData;
                end
            end
            objout = obj;
        end
        function dataPts = getDataVectorByDataIndex(obj, dataIndex, index1, index2)
            if (dataIndex <= 0)
               if (dataIndex == 0) % xvalues
                    dataPts = obj.xAxesVals;
                    return;
                elseif (dataIndex == -1) % serial number
                    dataPts = 0:obj.numPts - 1;
                    return;
               else
                   dataIndex
                   THROW('Invalid dataindex\n');
               end
            end
            % returns all pts for a dataset
            if ((~obj.treatAllAsCell) && (obj.dataOrders(dataIndex) == 0))
                dataPts = obj.data{dataIndex};
                return;
            end
            if ((nargin < 3) || (isnan(index1)))
                index1 = 1;
            end
            dataPts = zeros(obj.numPts, 1);
            
            if (obj.dataOrders(dataIndex) == 0)
                for pt = 1:obj.numPts
                    dataPts(pt) = obj.data{dataIndex}{pt};
                end
                return;
            end
            if (obj.dataOrders(dataIndex) == 1)
                for pt = 1:obj.numPts
                    dataPts(pt) = obj.data{dataIndex}{pt}(index1);
                end
                return;
            end
            if ((nargin < 4) || (isnan(index2)))
                index2 = 1;
            end
            for pt = 1:obj.numPts
                dataPts(pt) = obj.data{dataIndex}{pt}(index1, index2);
            end
        end
        function dataPts = getSpecificPtsDataVectorByDataIndex(obj, specificPtsIndices, dataIndex, index1, index2)
            if (dataIndex <= 0)
               if (dataIndex == 0) % xvalues
                    dataPts = obj.xAxesVals(specificPtsIndices);
                    return;
                elseif (dataIndex == -1) % serial number
                    dataPts = specificPtsIndices - 1;
                    return;
               else
                   dataIndex
                   THROW('Invalid dataindex\n');
               end
            end
            if ((nargin < 3) || (isnan(index1)))
                index1 = 1;
            end
            sz = length(specificPtsIndices);
            dataPts = zeros(sz, 1);
            
            if (obj.dataOrders(dataIndex) == 0)
                for i = 1:sz
                    pt = specificPtsIndices(i);
                    dataPts(i) = obj.data{dataIndex}{pt};
                end
                return;
            end
            if (obj.dataOrders(dataIndex) == 1)
                for i = 1:sz
                    pt = specificPtsIndices(i);
                    dataPts(i) = obj.data{dataIndex}{pt}(index1);
                end
                return;
            end
            if ((nargin < 4) || (isnan(index2)))
                index2 = 1;
            end
            for i = 1:sz
                pt = specificPtsIndices(i);
                dataPts(i) = obj.data{dataIndex}{pt}(index1, index2);
            end
        end
        function [dataPts, dataIndex] = getDataVectorByDataName(obj, dataName, index1, index2)
            if nargin < 3
                index1 = nan;
            end
            if nargin < 4
                index2 = nan;
            end
            if (nargin < 2)
                dataName = '1';
            else
                dataName = lower(dataName);
                dataIndex = obj.DataName2Index(dataName);
                dataPts = obj.getDataVectorByDataIndex(dataIndex, index1, index2);
            end
        end
        function [dataLatexname, dataRawName] = getDataLatexNameByDataName(obj, dataName, index1, index2)
            if nargin < 3
                index1 = nan;
            end
            if nargin < 4
                index2 = nan;
            end
            if (nargin < 2)
                dataName = '1';
            else
                dataName = lower(dataName);
                dataIndex = obj.DataName2Index(dataName);
                if (dataIndex == 0)
                    dataLatexname = '$$ t $$';
                    dataRawName = 't';
                    return;
                elseif (dataIndex == -1)
                    dataLatexname = '$$ N $$';
                    dataRawName = 'N';
                    return;
                end                    
                % 
                dataLatexname = '';
                dataRawName = obj.dataNames{dataIndex};
                if (length(obj.dataNamesLatex) > 0)
                    dataLatexname = obj.dataNamesLatex{dataIndex};
                else
                    dataLatexname = dataRawName;
                end
                if (isnan(index1))
                    dataLatexname = ['$$ ', dataLatexname, ' $$'];
                    return;
                end
                subs = num2str(index1);
                if (~isnan(index2))
                    subs = ['{', subs, num2str(index2), '}'];
                end
                dataLatexname = ['$$ ', dataLatexname, '_', subs, ' $$'];
            end
        end
        function dataPts = getDataCellByDataIndex(obj, dataIndex)
            if (dataIndex <= 0)
               if (dataIndex == 0) % xvalues
                    for i = 1:obj.numPts
                        dataPts{i} = obj.xAxesVals(i);
                    end
                    return;
                elseif (dataIndex == -1) % serial number
                    for i = 1:obj.numPts
                        dataPts{i} = i - 1;
                    end
                    return;
               else
                   dataIndex
                   THROW('Invalid dataindex\n');
               end
            end
            if ((~obj.treatAllAsCell) && (obj.dataOrders(dataIndex) == 0))
                dataPts = cell(obj.numPts, 1);
                for pt = 1:obj.numPts
                    dataPts{pt} = obj.data{dataIndex}(pt);
                end
                return;
            end
            dataPts = obj.data{dataIndex};
        end
        function dataPts = getDataCellByDataName(obj, dataName)
            dataIndex = obj.DataName2Index(dataName);
            dataPts = obj.getDataCellByDataIndex(dataIndex);
        end
        
        function toFile(obj, fileNameDat, extHeader)
            if (nargin < 3)
                extHeader = 'same';
            end
            clsFl = 1;
            if (length(fileNameDat) == 1)
                fid = fileNameDat;
                extHeader = 'same';
                clsFl = 0;
            else
                fid = fopen(fileNameDat, 'w');
            end
             %adding { so that later the file can be turned to free format
            fprintf(fid, '{\n');

            fprintf(fid, 'headerExt\t%s\n', extHeader);
            fprintf(fid, 'numAxes\t%s\n', obj.nameXAxes);
            namesOpt = 2;    % print in the header file
            fidHeader = -1;
            if (strcmp(extHeader, 'same') == 1)
                namesOpt = 1; % priting names in the same file
                fidHeader = fid;
            elseif (strcmp(extHeader, 'none') == 1)
                namesOpt = 0; % printing names before each entry
            else
                fidHeader = -1;
                [~, ~, extDat] = fileparts(fileNameDat);
                fileNameStat = strrep(fileNameDat, extDat, ['.', extHeader]);
                fidHeader = fopen(fileNameStat, 'w');
            end
            
            if (namesOpt ~= 0)
                if (length(obj.dataNamesLatex) > 0)
                    fprintf(fidHeader, 'HeaderSzLatexV\t%d\n', obj.numDataSets + 2);
                else
                    fprintf(fidHeader, 'HeaderSz\t%d\n', obj.numDataSets + 2);
                end
                fprintf(fidHeader, 'pt\t%s\t', obj.nameXAxes);
                for i = 1:length(obj.dataNames)
                    fprintf(fidHeader, '%s\t', obj.dataNames{i});
                end
                if (length(obj.dataNamesLatex) > 0)
                    fprintf(fidHeader, '\nLatexNames\t%d\n', length(obj.dataNamesLatex) + 2);
                    fprintf(fidHeader, '"%s"\t"%s"\t', obj.dataNameSerialLatex, obj.dataNamexLatex);
                    for i = 1:length(obj.dataNamesLatex)
                        fprintf(fidHeader, '"%s"\t', obj.dataNamesLatex{i});
                    end
                end                    
                fprintf(fidHeader, '\n');
                if (namesOpt == 2)
                    fclose(fidHeader); % separate file
                end
            end
            fprintf(fid, 'numDataSets\t%d\n', obj.numDataSets);
            fprintf(fid, 'numPts\t%d\n', obj.numPts);
            fprintf(fid, 'dataOrders\tsz\t%d\n', obj.numDataSets);
            for di = 1:obj.numDataSets
                fprintf(fid, '%d\t', obj.dataOrders(di));
            end
            fprintf(fid, '\nData\n');
            
            % printing data
            for pt = 1:obj.numPts
                if (namesOpt == 0)
                    fprintf(fid, 'pt\t%d\t%s\t%g\t', pt, obj.nameXAxes, obj.xAxesVals(pt));
                else
                    fprintf(fid, '%d\t%g\t', pt, obj.xAxesVals(pt));
                end
                for di = 1:obj.numDataSets
                    if (namesOpt == 0)
                        fprintf(fid, '%s\t', obj.dataNames{di});
                    end
                    if ((~obj.treatAllAsCell) && (obj.dataOrders(di) == 0))
                        fprintf(fid, '%g\t', obj.data{di}(pt));
                    else
                        gen_toFile_matrix(fid, obj.data{di}{pt});
                    end
                end
                fprintf(fid, '\n');
            end
            fprintf(fid, '\n}\n');
            if (clsFl)
%                closeHeader = ((fidHeader > 0) && (fidHeader ~= fid));
                fclose(fid);
%                 if (closeHeader)
%                     fclose(fidHeader);
%                 end
            end
        end
        
        function bl = IncludesAllFields(obj, fieldNames2Check)
            sz2Check = length(fieldNames2Check);
            if (sz2Check > obj.numDataSets)
                bl = 0;
                return;
            end
            for i = 1:sz2Check
                fld2ch = fieldNames2Check{i};
                fnd = 0;
                for j = 1:obj.numDataSets
                    if (strcmp(obj.dataNames{j}, fld2ch) == 1)
                        fnd = 1;
                        break;
                    end
                end
                if (fnd == 0)
                    bl = 0;
                    return;
                end
            end
            bl = 1;
        end

        function bl = SameDataPts(obj, minVal, maxVal, numVal)
            bl = 1;
            if (numVal ~= obj.numPts)
                bl = 0;
                return;
            end
            if (minVal ~= obj.xAxesVals(1))
                bl = 0;
                return;
            end
            if (maxVal ~= obj.xAxesVals(obj.numPts))
                bl = 0;
                return;
            end
        end

        function bl = SameFieldsAndDataPts(obj, fieldNames2Check, minVal, maxVal, numVal)
            if (obj.IncludesAllFields(fieldNames2Check) == 0)
                bl = 0;
                return;
            end
            if (obj.SameDataPts(minVal, maxVal, numVal) == 0)
                bl = 0;
                return;
            end
            bl = 1;
        end
        
        function objout = fromFile(obj, fileNameDat)
            clsFile = 1;
            if (length(fileNameDat) == 1)
                fid = fileNameDat;
                clsFile = 0;
            else
                fid = fopen(fileNameDat, 'r');
            end
            if (fid < 0)
                message = ['Cannot open file\t', fileNameDat];
                error(['ERROR: ',message]);
            end
            buf = READ(fid, 's'); % should be {
            if (strcmp(buf, '{') == 1)
                buf = fscanf(fid, '%s', 1);
            end
            extHeader = fscanf(fid, '%s', 1);
            
            buf = fscanf(fid, '%s', 1);
            obj.nameXAxes = fscanf(fid, '%s', 1);
            namesOpt = 2;    % print in the header file
            fidHeader = -1;
            if (strcmp(extHeader, 'same') == 1)
                namesOpt = 1; % priting names in the same file
                fidHeader = fid;
            elseif (strcmp(extHeader, 'none') == 1)
                namesOpt = 0; % printing names before each entry
            else
                fidHeader = -1;
                [~, ~, extDat] = fileparts(fileNameDat);
                fileNameStat = strrep(fileNameDat, extDat, ['.', extHeader]);
                fidHeader = fopen(fileNameStat, 'r');
            end
            
            if (namesOpt ~= 0)
                versionChecker = fscanf(fidHeader, '%s', 1);
                headerSz = fscanf(fidHeader, '%d', 1);
                hasLatexName = (strcmp(versionChecker, 'HeaderSzLatexV') == 1);
                
                buf = fscanf(fidHeader, '%s', 1);
                obj.nameXAxes = fscanf(fidHeader, '%s', 1);
                for i = 1:headerSz - 2
                    obj.dataNames{i} = lower(fscanf(fidHeader, '%s', 1));
                end
                if (hasLatexName)
                    buf = fscanf(fidHeader, '%s', 1);
                    buf = fscanf(fidHeader, '%s', 1);

                    obj.dataNameSerialLatex = gen_ReadWEnclosing(fidHeader, '"');
                    obj.dataNamexLatex = gen_ReadWEnclosing(fidHeader, '"');
                    for i = 1:headerSz - 2
                        obj.dataNamesLatex{i} = gen_ReadWEnclosing(fidHeader, '"');
                    end
                end
                
                if (namesOpt == 2)
                    fclose(fidHeader); % separate file
                end
            end
            buf = fscanf(fid, '%s', 1);
            obj.numDataSets = fscanf(fid, '%d', 1);

            buf = fscanf(fid, '%s', 1);
            obj.numPts = fscanf(fid, '%d', 1);

            buf = fscanf(fid, '%s', 3);
            for di = 1:obj.numDataSets
                obj.dataOrders(di) = fscanf(fid, '%d', 1);
            end
            buf = fscanf(fid, '%s', 1);
            
            % printing data
            for pt = 1:obj.numPts
                if (namesOpt == 0)
                    buf = fscanf(fid, '%s', 2);
                    obj.nameXAxes = fscanf(fid, '%s', 1);
                    obj.xAxesVals(pt) = fscanf(fid, '%g', 1);
                else
                    buf = fscanf(fid, '%s', 1);
                    obj.xAxesVals(pt) = fscanf(fid, '%g', 1);
                end
                for di = 1:obj.numDataSets
                    if (namesOpt == 0)
                        obj.dataNames{di} = fscanf(fid, '%s', 1);
                    end
                    if ((~obj.treatAllAsCell) && (obj.dataOrders(di) == 0))
                        obj.data{di}(pt) = fscanf(fid, '%g', 1);
                    else
                        obj.data{di}{pt} = gen_fromFile_matrix(fid);
                    end
                end
            end
            buf = READ(fid, 's'); % should be {
            lastRead = (strcmp(buf, '}') == 1);
            
            if (~lastRead)
                while (strcmp(buf, '}') == 0)
                    if (strcmp(buf, 'sepDataLocs') == 1)
                        numSepDataLocs = READ(fid, 'd');
                        for j = 1:numSepDataLocs
                            obj.sepDataLocs(j) = READ(fid, 'd');
                        end
                    end
                    buf = READ(fid, 's'); % should be {
                end
            end
                
            if (strcmp(buf, '}') == 0)
                buf
                THROW('End of text for gen_textIndexedDatasets must be }\n');
            end

            if (clsFile)
                fclose(fid);
            end
            
            numSepDataLocs = length(obj.sepDataLocs);
            obj.sepDataVals = cell(numSepDataLocs, 1);
            for j = 1:numSepDataLocs
                ind = obj.sepDataLocs(j);
                distInd = [];
                for i = 1:obj.numPts
                    val = obj.data{ind}{i};
                    indFnd = find(distInd == val);
                    if (length(indFnd) == 0)
                        distInd(length(distInd) + 1) = val;
                    end
                end
                distInd = sort(distInd);
                obj.sepDataVals{j} = distInd;
            end
            objout = obj;
        end
        function objout = ExtractIntegerIndices(obj, indices2Extract)
            objout = gen_textIndexedDatasets;
            objout.nameXAxes = obj.nameXAxes;
            objout.numDataSets = obj.numDataSets;
            objout.dataNames = obj.dataNames;
            objout.dataOrders = obj.dataOrders;
            objout.treatAllAsCell = obj.treatAllAsCell;
            
            objout.numPts = length(indices2Extract);
            for pt = 1:objout.numPts
                ptBase = indices2Extract(pt);
                if ((~isnan(ptBase)) && (ptBase > 0) && (ptBase <= obj.numPts))
                    objout.xAxesVals(pt) = obj.xAxesVals(ptBase);
                    for fld = 1:objout.numDataSets
                        objout.data{fld}{pt} = obj.data{fld}{ptBase};
                    end
                else
                    objout.xAxesVals(pt) = nan;
                    for fld = 1:objout.numDataSets
                        objout.data{fld}{pt} = nan * obj.data{fld}{obj.numPts};
                    end
                end
            end
        end
        function breaker1Lout = updateDataBreakerUsingInstruction(obj, breaker1Lin, break1Linstruction)
            breaker1Lout = breaker1Lin;
            if (breaker1Lout.dataIndices == -1)
                breaker1Lout.dataIndices = 1:obj.numPts;
            end
            cntr = 0;
            cntrDistinctSets = 0;
            velset = cell(0);
            validIndices = zeros();
            validOrder = zeros();
            distincSetDataPoss = cell(0);
            distincSetDataPossSz = [];
            for i = 1:length(breaker1Lout.dataIndices)
                dataPos = breaker1Lout.dataIndices(i);
                vld = 1;
                valsVec = [];
                for j = 1:break1Linstruction.numDataPoss
                    fldPos = break1Linstruction.dataPoss(j);
                    vlAtpos = obj.data{fldPos}{dataPos};
                    if (break1Linstruction.sz_dataVals2Look(j) > 0)
                        if (length(find(break1Linstruction.dataVals2Look{j} == vlAtpos)) == 0)
                            vld = 0;
                        end
                    end
                    if (vld == 0)
                        break;
                    end
                    valsVec(j) = vlAtpos;
                end
                if (vld == 0)
                    continue;
                end
                posInFoundSets = -1;
                for k = 1:cntrDistinctSets
                    if (isequal(valsVec, velset{k}))
                        posInFoundSets = k;
                        break;
                    end
                end
                if (posInFoundSets == -1)
                    cntrDistinctSets = cntrDistinctSets + 1;
                    velset{cntrDistinctSets} = valsVec;
                    posInFoundSets = cntrDistinctSets;
                    distincSetDataPoss{posInFoundSets} = [];
                    distincSetDataPossSz(posInFoundSets) = 0;
                end
                cntr = cntr + 1;
                validIndices(cntr) = dataPos;
                validOrder(cntr) = posInFoundSets;
                distincSetDataPossSz(posInFoundSets) = distincSetDataPossSz(posInFoundSets) + 1;
                distincSetDataPoss{posInFoundSets}(distincSetDataPossSz(posInFoundSets)) = dataPos;
            end
            szCntrDistinctSets = cntrDistinctSets;
            indexSet = cell(0);
            for cntrDistinctSets = 1:szCntrDistinctSets
                indices = -ones(break1Linstruction.numDataPoss, 1);
                for j = 1:break1Linstruction.numDataPoss
                    fldPos = break1Linstruction.dataPoss(j);
                    loc = find(obj.sepDataLocs == fldPos);
                    if (length(loc) == 0)
                        continue;
                    end
                    vl = velset{cntrDistinctSets}(j);
                    index = find(obj.sepDataVals{loc} == vl);
                    indices(j) = index;
                end
                indexSet{cntrDistinctSets} = indices;
            end
            
            breaker1Lout.leaves = cell(szCntrDistinctSets, 1);
            for cntrDistinctSets = 1:szCntrDistinctSets
                breaker1Lout.leaves{cntrDistinctSets} = gen_dataBreaker1L ;
                breaker1Lout.leaves{cntrDistinctSets}.numDataBreaker = break1Linstruction.numDataPoss;
                if (length(breaker1Lout.leaves{cntrDistinctSets}.numDataBreaker) == 0)
                    breaker1Lout.leaves{cntrDistinctSets}.numDataBreaker = 0;
                end
                breaker1Lout.leaves{cntrDistinctSets}.dataPoss = break1Linstruction.dataPoss';
                breaker1Lout.leaves{cntrDistinctSets}.dataVals = velset{cntrDistinctSets};
                breaker1Lout.leaves{cntrDistinctSets}.dataInds4Vals = indexSet{cntrDistinctSets}';
                breaker1Lout.leaves{cntrDistinctSets}.dataIndices = distincSetDataPoss{cntrDistinctSets};
            end
            breaker1Lout.numLeaves = szCntrDistinctSets;
        end
    
        function xOryout = FinalizeData_in_gen_dat_xOrys(obj, xOryIn)
            xOryout = xOryIn;
            for i = 1:xOryout.number
                name = xOryout.datLabel{i};
                dataIndex = obj.DataName2Index(name);
                xOryout.datPos(i) = dataIndex;

                if (dataIndex > 0)
                    orderStored = obj.dataOrders(dataIndex);
                    orderRead = xOryout.numIndices(i);
                    nameLatex = obj.dataNamesLatex{dataIndex};
                elseif (dataIndex == 0) % xvalues
                    orderStored = 1;
                    orderRead = xOryout.numIndices(i);
                    nameLatex = obj.dataNamexLatex;
                elseif (dataIndex == -1) % serial value
                    orderStored = 1;
                    orderRead = xOryout.numIndices(i);
                    nameLatex = obj.dataNameSerialLatex;
                end
                order = orderRead;
%                order = min(orderRead, orderStored);
                if (order > 0)
                    ind1 = xOryout.indices1(i);
                    str = 'x';
                    if (ind1 == 2)
                        str = 'y';
                    elseif (ind1 == 3)
                        str = 'z';
                    end
                    name = [name, '_', str];
                    nameLatex = [nameLatex, '_{',str];

                    if (order > 1)
                        ind2 = xOryout.indices2(i);
                        str = 'x';
                        if (ind2 == 2)
                            str = 'y';
                        elseif (ind2 == 3)
                            str = 'z';
                        end
                        name = [name, str];
                        nameLatex = [nameLatex, ' ', str];
                    end
                    nameLatex = [nameLatex, '}'];
                end
                
                xOryout.datLabel{i} = name;
                xOryout.datLatexLabel{i} = nameLatex;
            end
        end
        
        % sets x, y, latex names
        % finalizing break points
        function pltConfigOut = UpdatePlotConfig(obj, pltConfigIn)

           %%% A. breaking schemes 
           pltConfigOut = pltConfigIn;
           numOutMid = pltConfigOut.out_middle_num;

           pltConfigOut.breaker1Lins = cell(numOutMid, 1);
           pltConfigOut.breaker1Louts = cell(numOutMid, 1);

           for i = 1:numOutMid
                outNo = pltConfigOut.out_middle(i, 1);
                midNo = pltConfigOut.out_middle(i, 2);

                pltConfigOut.breaker1Lins{i} = gen_dataBreaker1L;
                pltConfigOut.breaker1Louts{i} = obj.updateDataBreakerUsingInstruction(pltConfigOut.breaker1Lins{i}, pltConfigOut.splitter{outNo});

                for j = 1:pltConfigOut.breaker1Louts{i}.numLeaves
                    pltConfigOut.breaker1Louts{i}.leaves{j} = obj.updateDataBreakerUsingInstruction(pltConfigOut.breaker1Louts{i}.leaves{j}, pltConfigOut.splitter{midNo});
                end
           end
        
           %%% B. latex names for fields x, y 
           numXorY = pltConfigOut.data_xys_num;
           for i = 1:numXorY
               pltConfigOut.data_xys{i} = obj.FinalizeData_in_gen_dat_xOrys(pltConfigOut.data_xys{i});
           end
           
           
           % directly copying data sets inside actual plot x and y data
           for i = 1:pltConfigOut.plotConfigurationsNumber
               for j = 1:pltConfigOut.plotConfigurations{i}.numberOfAxesDataSets
                    axisData{1} = pltConfigOut.plotConfigurations{i}.axesDataSets{j}.xAxisData;
                    axisData{2} = pltConfigOut.plotConfigurations{i}.axesDataSets{j}.yAxisData;
                    for k = 1:2
                        if (axisData{k}.dataSetNumber > 0)
                            axisData{k}.actual_xOry = pltConfigOut.data_xys{axisData{k}.dataSetNumber};
                        else
                            axisData{k}.actual_xOry = obj.FinalizeData_in_gen_dat_xOrys(axisData{k}.actual_xOry);
                        end
                    end
                    pltConfigOut.plotConfigurations{i}.axesDataSets{j}.xAxisData = axisData{1};
                    pltConfigOut.plotConfigurations{i}.axesDataSets{j}.yAxisData = axisData{2};
               end
           end
        end
        
        function makePlots(obj, pltConf)
            set(0,'DefaultLegendAutoUpdate','off');
            % for creating file names
            separator = '_'; 
            for pltSet = 1:pltConf.plotConfigurationsNumber
                if (pltConf.plotConfigurations{pltSet}.active == 0)
                    continue;
                end
                pltSet
                pltIndConf = pltConf.plotConfigurations{pltSet};
                dataRepresentationNumber = pltIndConf.dataRepresentationNumber;
                plotPropertyNumber = pltIndConf.plotPropertyNumber;

                numXDataOptions = pltIndConf.xAxisDataNumber;
                numYDataOptions = pltIndConf.yAxisDataNumber;
                numberOfAxesDataSets = pltIndConf.numberOfAxesDataSets;
                % 1 if c is out
                outerLoopCRV = pltIndConf.outerLoopCRV;
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                hasHeader_xy = (numberOfAxesDataSets == 1);
                %xypi - getting base x,y data and their names
                xDataLabelLatex = cell(0);
                yDataLabelLatex = cell(0);
                xDataLabelLatexFinal = cell(0);
                yDataLabelLatexFinal = cell(0);
                
                for xypi = 1:numberOfAxesDataSets
                    % x axis
                    xAxisData = pltIndConf.axesDataSets{xypi}.xAxisData;
                    yAxisData = pltIndConf.axesDataSets{xypi}.yAxisData;
                    xData = xAxisData.actual_xOry;
                    yData = yAxisData.actual_xOry;
                    
                    for xi = 1:numXDataOptions
                        xDatLabel{xypi}{xi} = xData.datLabel{xi};
                        xDataLabelLatex{xi}{xypi} = xData.datLatexLabel{xi};
                        xDataPos{xypi}{xi} = xData.datPos(xi);
                        xIndex1 = xData.indices1(xi);
                        xIndex2 = xData.indices2(xi);
                        xVal = obj.getDataVectorByDataIndex(xDataPos{xypi}{xi}, xIndex1, xIndex2);

                        if (xAxisData.num_dataSetOrderModifiers == 0)
                            xDataBase{xypi}{xi} = xVal;
                        else
                            xDataBase{xypi}{xi} = xAxisData.operateSeries(xVal, pltConf.general_dataModifiers);
                        end
                    end
                    for yi = 1:numYDataOptions
                       yDatLabel{xypi}{yi} = yData.datLabel{yi};
                       yDataLabelLatex{yi}{xypi} = yData.datLatexLabel{yi};
                       yDataPos{xypi}{yi} = yData.datPos(yi);
                       yIndex1 = yData.indices1(yi);
                       yIndex2 = yData.indices2(yi);
                       yVal = obj.getDataVectorByDataIndex(yDataPos{xypi}{yi}, yIndex1, yIndex2);

                        if (yAxisData.num_dataSetOrderModifiers == 0)
                            yDataBase{xypi}{yi} = yVal;
                        else
                            yDataBase{xypi}{yi} = yAxisData.operateSeries(yVal, pltConf.general_dataModifiers);
                        end
                    end
                end
                
                for xi = 1:numXDataOptions
                    xDataLabelLatexFinal{xi} = gen_concatinateStrings(',', 1, xDataLabelLatex{xi}); 
                end                
                for yi = 1:numYDataOptions
                    yDataLabelLatexFinal{yi} = gen_concatinateStrings(',', 1, yDataLabelLatex{yi}); 
                end                

                numSplits = pltIndConf.numberDataSplits;
                numPlotsInSplitSchemes = [];
                strTitleFlds = cell(0);
                strTitleFldsLatex = cell(0);
                dataPossCrs = cell(0);
                labelsLegFld = cell(0);
                numCurves = cell(0);
                      
                ptInds = cell(0);
                hasHeader_split = cell(0);
                header_split = cell(0);
                indexCrdataPossCrs = cell(0);
                for dSplit = 1:numSplits
            %        dSplit
                    dataSplitNumber = pltIndConf.dataSplitValues{dSplit};

                    %pltConf.breaker1Lins{dataSplitNumber}
                    breaker1Lout = pltConf.breaker1Louts{dataSplitNumber};
                    
                    numPlotsInSplitScheme = breaker1Lout.numLeaves;
                    numPlotsInSplitSchemes(dSplit) = numPlotsInSplitScheme;
                                        
                    for j = 1:numPlotsInSplitScheme
                        numOuterIndsBreaker = breaker1Lout.leaves{j}.numDataBreaker;
                        dataPos = breaker1Lout.leaves{j}.dataPoss;
                        dataVls = breaker1Lout.leaves{j}.dataVals;
                        dataInds4Vals = breaker1Lout.leaves{j}.dataInds4Vals;
 %                       outputPlotName = ['plt_', num2str(j, '%04d'), '_'];

                        strLatexAll = [];
                        strAll = [];
                        indexBase = [];
                        for k = 1:numOuterIndsBreaker
                            datpos = dataPos(k);
                            indexBase(datpos) = dataInds4Vals(k);
                            str = obj.dataNames{datpos};
                            str = [str, '=',  num2str(dataVls(k))];
                            strLtx = obj.dataNamesLatex{datpos};
                            strLtx = [strLtx, ' = ',  num2str(dataVls(k))];

                            if (k < numOuterIndsBreaker)
                                strAll = [strAll, str, '_'];
                                strLatexAll = [strLatexAll , strLtx, ', '];
                            else
                                strAll = [strAll, str];
                                strLatexAll = [strLatexAll , strLtx];
                            end
                        end
                        
                        numInner = breaker1Lout.leaves{j}.leaves{1}.numDataBreaker;
                        if (hasHeader_xy && (numInner == 1))
                            hasHeader_split{dSplit}{j} = 1;
                            datposHeader = breaker1Lout.leaves{j}.leaves{1}.dataPoss;
                            header_split{dSplit}{j} = obj.dataNamesLatex{datposHeader};
                        else
                            hasHeader_split{dSplit}{j} = 0;
                            header_split{dSplit}{j} = '';
                        end
                        
                        strTitleFlds{dSplit}{j} = strAll;
                        if (hasHeader_split{dSplit}{j} == 0)
                            strTitleFldsLatex{dSplit}{j} = strLatexAll;
                        else
                            strTitleFldsLatex{dSplit}{j} = num2str(dataVls(1));
                        end                            
                        %strAll = [outputPlotName, strAll];

%                        strLatexAll = ['$$ ', strLatexAll, ' $$'];
%                        title(strLatexAll, 'FontSize', tfs, 'interpreter', 'latex');
                        numCurve = breaker1Lout.leaves{j}.numLeaves;
                        
                        for c = 1:numCurve
                            numIndsBreakerCr = breaker1Lout.leaves{j}.leaves{c}.numDataBreaker;
                            dataPossCr = breaker1Lout.leaves{j}.leaves{c}.dataPoss;
                            dataVlsCr = breaker1Lout.leaves{j}.leaves{c}.dataVals;
                            dataInds4ValsCr = breaker1Lout.leaves{j}.leaves{c}.dataInds4Vals;
                            ptInds{dSplit}{j}{c} = breaker1Lout.leaves{j}.leaves{c}.dataIndices;
                            strLatexAllLeg = [];
                            indexCrdataPossCrs{dSplit}{j}{c} = indexBase;
                            for k = 1:numIndsBreakerCr
                                datposCr = dataPossCr(k);
                                indexCrdataPossCrs{dSplit}{j}{c}(datposCr) = dataInds4ValsCr(k);
                                strCr = obj.dataNames{datposCr};
                                header = obj.dataNamesLatex{datpos};
                                if (numIndsBreakerCr == 1)
                                    strLatexAllLeg = num2str(dataVlsCr(k));
                                else
                                    strLtxLeg = obj.dataNamesLatex{datposCr};
                                    strLtxLeg = [strLtxLeg, ' = ',  num2str(dataVlsCr(k))];
                                    if (k < numOuterIndsBreaker)
                                        strLatexAllLeg = [strLatexAllLeg , strLtxLeg, ', '];
                                    else
                                        strLatexAllLeg = [strLatexAllLeg, strLtxLeg];
                                    end
                                end
                            end
%                            labelsLeg{c} = ['$$ ', strLatexAllLeg, ' $$'];
                            dataPossCrs{dSplit}{j}{c} = dataPossCr;
                            labelsLegFld{dSplit}{j}{c} = strLatexAllLeg;
                        end
                        numCurves{dSplit}{j} = numCurve;
                    end
                end
                
                figName_pltNum = [pltConf.root, 'plt_', num2str(pltSet, '%03d')];

                for xi = 1:numXDataOptions
                    % xlabel
                    xlbl = ['$$ ', xDataLabelLatexFinal{xi}, ' $$'];
                    figName_xi = ['xi_', num2str(xi, '%02d'), '_', xDatLabel{xypi}{xi}];
                    % ylabel
                    for yi = 1:numYDataOptions
                        ylbl = ['$$ ', yDataLabelLatexFinal{yi}, ' $$'];
                        figName_yi = ['yi_', num2str(yi, '%02d'), '_', yDatLabel{xypi}{yi}];
                        for dSplit = 1:numSplits
                            figName_split = ['splt_', num2str(dSplit, '%d')];
                            for j = 1:numPlotsInSplitSchemes(dSplit)
                                cls_
                                h = axes;

                                % regression
                                if (length(pltIndConf.regressionNo) >= dSplit)
                                    regNo = pltIndConf.regressionNo(dSplit);
                                else
                                    regNo = -1;
                                end
                                if (pltConf.RegressionParametersOn == 0)
                                    regNo = -1;
                                end
                                if (regNo > 0)
                                    regressionV = pltConf.regressionProperty{regNo};
                                    gPlotRegClass.clean(regressionV);
                                end
                                
                                xmn = inf; xmx = -inf;
                                ymn = inf; ymx = -inf;
                                
                                % part going to figure name
                                figName_outer = strTitleFlds{dSplit}{j};
                       
                                % name base for plot
                                namePlotBase = gen_concatinateStrings(separator, 0, figName_pltNum, figName_xi, figName_yi, figName_split, figName_outer); 
                                % title for plot
                                plotLatexTitle = strTitleFldsLatex{dSplit}{j};

                                numCurveFromSplit = numCurves{dSplit}{j};
                                numCurvesTotal = numberOfAxesDataSets * numCurveFromSplit;
                                xs = cell(numCurvesTotal, 1);
                                ys = cell(numCurvesTotal, 1);
                                lineSpecs = cell(numCurvesTotal, 1);
                                curveIndices_set = cell(numCurvesTotal, 1);
    
                                if (hasHeader_split{dSplit}{j} == 0)
                                    start_c = 1;
                                    leg = cell(numCurvesTotal + start_c - 1, 1);
                                else
                                    plot(nan, nan, 'Color', 'none');
                                    hold on;
                                    start_c = 2;
                                    leg = cell(numCurvesTotal + start_c - 1, 1);
                                    leg{1} = header_split{dSplit}{j};
                                end
                                
                                if (outerLoopCRV)
                                    factor_c = numberOfAxesDataSets;
                                    factor_d = 1;
                                else
                                    factor_c = 1;
                                    factor_d = numCurveFromSplit;
                                end

                                for xypi = 1:numberOfAxesDataSets
                                    for c = 1:numCurveFromSplit
                                        ci = (xypi - 1) * factor_d + (c - 1) * factor_c + start_c;
                                        inds2Select = ptInds{dSplit}{j}{c};

                                        xs{ci} = xDataBase{xypi}{xi}(inds2Select);
                                        mn = min(xs{ci});
                                        mx = max(xs{ci});
                                        xmn = min(xmn, mn);
                                        xmx = max(xmx, mx);
                                        ys{ci} = yDataBase{xypi}{yi}(inds2Select);
                                        mn = min(ys{ci});
                                        mx = max(ys{ci});
                                        ymn = min(ymn, mn);
                                        ymx = max(ymx, mx);

                                        % need to fix this
                                        curveIndices = indexCrdataPossCrs{dSplit}{j}{c};
                                        lineSpecs{ci} = pltConf.getCurveProperty(curveIndices, xypi);
                                        curveIndices_set{ci} = curveIndices;    

                                        label_fromSplit = labelsLegFld{dSplit}{j}{c};
                                        if (numberOfAxesDataSets == 1)
                                            leg{ci} = label_fromSplit;
                                        else
                                            label_from_xySet = yDataLabelLatex{yi}{xypi};
                                            if (length(label_fromSplit) == 0)
                                                leg{ci} = label_from_xySet;
                                            else
                                                if (outerLoopCRV)
                                                    leg{ci} = [label_fromSplit, ',', label_from_xySet];
                                                else
                                                    leg{ci} = [label_from_xySet, ',', label_fromSplit];
                                                end
                                            end
                                        end
                                    end
                                end

                                for ci = start_c:length(lineSpecs)
                                    plt_plotData_plotXYbasedOnDataSpec(lineSpecs{ci}, xs{ci}, ys{ci});
                                    hold on;
                                end

                                % x and y labels, title, min max limits,
                                % etc.
                                for m = 1:length(leg)
                                    if (length(leg{m}) > 0)
                                        leg{m} = ['$$ ', leg{m}, ' $$'];
                                    end
                                end
                                legendHandle = pltConf.plotProperties{plotPropertyNumber}.setPlotLabelsAxis(h, plotLatexTitle, leg, xlbl, ylbl, ...
                                0, xmn, xmx, ymn, ymx, 1);
                            
                                % computing and plotting regressions
                                if (regNo > 0)
                                    for ci = start_c:length(lineSpecs)
                                        gPlotRegClass.setData(regressionV, xs{ci}, ys{ci}, curveIndices_set{ci});
                                    end
                                    
                                    XDirF = (strcmp(pltConf.plotProperties{plotPropertyNumber}.xAxis.dir, 'reverse') == 1);
                                    YDirF = (strcmp(pltConf.plotProperties{plotPropertyNumber}.yAxis.dir, 'reverse') == 1);
                                    gPlotRegClass.setRegTri(regressionV, YDirF); % Call to create regression symbol per plot for n data pairs
                                    gPlotRegClass.DoPlotReg(regressionV, XDirF, YDirF); % Call to plot regression info per plot for n data pairs

                                    if (regressionV.printReg == 1)
                                       fileNameReg = [namePlotBase, '.regr'];     
                                       fidReg = fopen(fileNameReg, 'w');
                                       gPlotRegClass.outputRegText(regressionV,fidReg); % Called to write regression data to text file
%                                       fclose(fidReg);
                                       gPlotRegClass.clean(pltConf.regressionProperty{regNo});
                                    end
                                end
                                
                                print('-dpng', [namePlotBase, '.png']);
                                savefig([namePlotBase, '.fig']);
                            end
                        end
                    end
                end
            end
        end
    end
end