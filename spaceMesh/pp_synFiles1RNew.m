classdef pp_synFiles1RNew % 1R: 1 run
    properties
        % particular for this run
        %%% input
        allRunsConfigs; % pp_synFilesAllR
        frontAllPath = '../../physics'; % all the way to within physics folder
        timeIndexStart = 0;
        
        % processed
        timeIndexLast;   % will be determined from frontAllPath, ... -> through fc
%        fc; % content of front_sync.all
        
        %    completeSyncData;  % cell of pp_energyDispWholeDomain
        summarySyncData;    % data set containing all summary data
        summarySyncFileName;
        
    end
    methods
        function [objout, regenBrief, E, nu, planeMode, t0, normalizationsUVSEps, voightStiffness] = ...
                ProcessAllSyncFiles(obj, frontAllPathIn, allRunsConfigs, addedParas)
            if (nargin < 4)
                addedParas = gen_map;
            end
        	cpp_timeIndexStartIn = 0;
            [serialMin, validsMin] = addedParas.AccessNumber('serialMin');
            if (validsMin)
                cpp_timeIndexStartIn = serialMin;
            end
            
            regenBase = allRunsConfigs.regenerateBaseFile;
            regenBrief = allRunsConfigs.regenerateBriefFile;
            if (regenBase)
                regenBrief = 1;
            end
            
            ignoreMinConstraints = 1;
            [fc, numfc, folder, syncDatName, syncStatName, runName, phy, midName, sn, timeMinI] = ReadAllSyncFile(frontAllPathIn, allRunsConfigs.frontFileName, addedParas, ignoreMinConstraints);
%            numfc = 3;
            obj.timeIndexStart = cpp_timeIndexStartIn + 1;
            obj.timeIndexLast = numfc;
            timeMinVal = str2num(fc{obj.timeIndexStart, timeMinI});
            timeMaxVal = str2num(fc{obj.timeIndexLast , timeMinI});

            % S stands for summary foles
            numSyncS = obj.timeIndexLast - obj.timeIndexStart + 1;
            % fi -> position of processed data (going into
            % gen_textIndexedDatasets)
            offsetS = 1 - obj.timeIndexStart;
            
            % summary file ext
            extSummaryData = allRunsConfigs.briefFileExt;
            extSummaryHeader = allRunsConfigs.briefFileExtHeader;
            extCompleteData = allRunsConfigs.extCompleteFile;
            
            summaryExists = 0;
            s = 1;
            nameSummaryData = fullfile(frontAllPathIn,...
                fc{s,folder},...
                sprintf('%s%s%s.%s',...
                fc{s,runName},...
                fc{s,phy},...
                fc{s,midName},...
                extSummaryData));
           obj.summarySyncFileName = nameSummaryData;
                        
            if (~regenBrief)
                fidSumDat = fopen(nameSummaryData, 'r');
                summaryExists = (fidSumDat > 0);
                if (summaryExists)
                    fclose(fidSumDat);
                end
            end
            ready2Return = 0;
            if (summaryExists)
                obj.summarySyncData = gen_textIndexedDatasets;
                obj.summarySyncData = obj.summarySyncData.fromFile(nameSummaryData);
                sameFields = obj.summarySyncData.SameFieldsAndDataPts(allRunsConfigs.fld2printInBriefRaw, timeMinVal, timeMaxVal, numSyncS); 
                if (sameFields)
                    objout = obj;
                    ready2Return = 1;
                else
                    summaryExists = 0;
                    regenBrief = 1;
                    obj.summarySyncData = cell(0);
                end
            end
            
            nameBB = [frontAllPathIn, '/', allRunsConfigs.bbFile];
            centroid = [0, 0];
            xmins = [];
            xmaxs = [];
            fidBB = fopen(nameBB, 'r');
            if (fidBB < 0)
                msg = ['Cannot open boundingbox file: ',nameBB,'\n'];
                THROW(msg);
            end
            buf = fscanf(fidBB, '%s', 1);
            szCrd = fscanf(fidBB, '%d', 1);
            xmins = zeros(szCrd, 1);
            xmaxs = zeros(szCrd, 1);
            for d = 1:szCrd
                buf = fscanf(fidBB, '%s', 1);
                xmins(d) = fscanf(fidBB, '%g', 1);
                buf = fscanf(fidBB, '%s', 1);
                xmaxs(d) = fscanf(fidBB, '%g', 1);
            end
            centroid(1) = 0.5 * (xmins(1) + xmaxs(1));
            centroid(2) = 0.5 * (xmins(2) + xmaxs(2));
            fclose(fidBB);
            
            % last sync file is used to set summary file (as the first one
            % may not have the cracks, ...)
            rawSyncDatLast = pp_energyDispWholeDomain;
            nameSyncData = [frontAllPathIn, '/', fc{obj.timeIndexLast, syncDatName}];
            s = obj.timeIndexLast;
            nameCompleteData = fullfile(frontAllPathIn,...
                    fc{s,folder},...
                    sprintf('%s%s%s%010d.%s',...
                    fc{s,runName},...
                    fc{s,phy},...
                    fc{s,midName},...
                    str2double(fc{s,sn}),...
                    extCompleteData));
                
            compExists = 0;
            if (~regenBase)
                fidCompDat = fopen(nameCompleteData, 'r');
                compExists = (fidCompDat> 0);
                if (compExists)
                    fclose(fidCompDat);
                end
            end
            if (~compExists)
                rawSyncDatLast = rawSyncDatLast.MainFunction(nameSyncData, centroid, allRunsConfigs.step4ScalarCDFs, ...
                    allRunsConfigs.numAngleRanges, allRunsConfigs.crackBinSize, allRunsConfigs.newNormalizationsUVSEps);
            else
                fidCompDat = fopen(nameCompleteData, 'r');
                rawSyncDatLast = rawSyncDatLast.fromFile(fidCompDat);
                fclose(fidCompDat);
            end
            
            % values needed for zpp file
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            E = rawSyncDatLast.E;
            nu = rawSyncDatLast.nu;
            
            planeMode = rawSyncDatLast.planeMode;
            t0 = rawSyncDatLast.t0;

            voightStiffness = rawSyncDatLast.voightStiffness;
            normalizationsUVSEps = rawSyncDatLast.newNormalizationsUVSEps;
            if (length(normalizationsUVSEps) < 4)
                normalizationsUVSEps(4) = rawSyncDatLast.strainScale;
            end
            
            if (ready2Return)
                objout = obj;
                return;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
            dataCell = rawSyncDatLast.GetData(allRunsConfigs.fld2printInBriefRaw);
            szData = length(dataCell);
            
            addPtData = 0; % we don't want to add the last point data to summarySyncData, and just want to update names and tensor types
            obj.summarySyncData = gen_textIndexedDatasets;
            for ds = 1:szData
                obj.summarySyncData = obj.summarySyncData.AddDataSetFirstPt(dataCell{ds}, allRunsConfigs.fld2printInBriefRaw{ds}, addPtData);
            end
            
            for s = obj.timeIndexStart:obj.timeIndexLast
                if (mod(s - 1, 100) == 0)
                    fprintf('%d ', s);
                end
                rawSyncDat = pp_energyDispWholeDomain;
                nameCompleteData = fullfile(frontAllPathIn,...
                    fc{s,folder},...
                    sprintf('%s%s%s%010d.%s',...
                    fc{s,runName},...
                    fc{s,phy},...
                    fc{s,midName},...
                    str2double(fc{s,sn}),...
                    extCompleteData));
                
                if (s == obj.timeIndexLast)
                    rawSyncDat = rawSyncDatLast;
                else
                    compExists = 0;
                    if (~regenBase)
                        fidCompDat = fopen(nameCompleteData, 'r');
                        compExists = (fidCompDat> 0);
                        if (compExists)
                            fclose(fidCompDat);
                        end
                    end
                    if (~compExists)
                        nameSyncData = [frontAllPathIn, '/', fc{s, syncDatName}];
                        rawSyncDat = rawSyncDat.MainFunction(nameSyncData, centroid, allRunsConfigs.step4ScalarCDFs, ...
                            allRunsConfigs.numAngleRanges, allRunsConfigs.crackBinSize, allRunsConfigs.newNormalizationsUVSEps);
                    else
                        fidCompDat = fopen(nameCompleteData, 'r');
                        rawSyncDat = rawSyncDat.fromFile(fidCompDat);
                        fclose(fidCompDat);
                    end
                end
                
                dataCell = rawSyncDat.GetData(allRunsConfigs.fld2printInBriefRaw);
                
                if (s == obj.timeIndexStart) % see if a zero first point should be added
                    addZero = ((obj.timeIndexStart > 1) || (~rawSyncDat.IsSlnZero()));
                    if (addZero)
                        numSyncS = numSyncS + 1;
                        offsetS = offsetS + 1;
                    end
                    obj.summarySyncData = obj.summarySyncData.Initialize(numSyncS, 'time');
                    if (addZero)
                        % creating a zero member
                        %                    rawSyncDatTimeZero = rawSyncDat; %pp_energyDispWholeDomain;
                        %                    rawSyncDatTimeZero = rawSyncDatTimeZero.MakeZero();
                        dataCell0 = dataCell;
                        pt = 1; % first point to be added to data set
                        obj.summarySyncData.xAxesVals(pt) = 0; % time zero
                        for j = 1:szData
                            dataCell0{j} = 0.0 * dataCell0{j};
%                            if (obj.summarySyncData.dataOrders(j) == 0)
%                                obj.summarySyncData.data{j}(pt) = dataCell0{j};
%                            else
                                obj.summarySyncData.data{j}{pt} = dataCell0{j};
%                            end
                        end
                        % adding this point to summary data
                    end
                    
                end
                pt = offsetS + s;
                obj.summarySyncData.xAxesVals(pt) = rawSyncDat.time; % time coordinate
                for j = 1:szData
%                    if (obj.summarySyncData.dataOrders(j) == 0)
%                        obj.summarySyncData.data{j}(pt) = dataCell{j};
%                    else
                        obj.summarySyncData.data{j}{pt} = dataCell{j};
%                    end
                end
                
                % printing comp data
                if (~compExists)
                    fidCompDat = fopen(nameCompleteData, 'w');
                    % compExists
                    rawSyncDat.toFile(fidCompDat, 0);
                    fclose(fidCompDat);
                end
            end
            obj.summarySyncData.toFile(nameSummaryData, extSummaryHeader);
            
            objout = obj;
        end
        function dataPts = getDataVectorByDataIndex(obj, dataIndex, index1, index2)
            if ((nargin < 3) || (isnan(index1)))
                index1 = 1;
            end
            if ((nargin < 4) || (isnan(index2)))
                index2 = 1;
            end
            dataPts = obj.summarySyncData.getDataVectorByDataIndex(dataIndex, index1, index2);
        end
        function dataPts = getDataVectorByDataName(obj, dataName, index1, index2)
            dataName = lower(dataName);
            if ((nargin < 3) || (isnan(index1)))
                index1 = 1;
            end
            if ((nargin < 4) || (isnan(index2)))
                index2 = 1;
            end
            dataPts = obj.summarySyncData.getDataVectorByDataName(dataName, index1, index2);
        end
    end
end