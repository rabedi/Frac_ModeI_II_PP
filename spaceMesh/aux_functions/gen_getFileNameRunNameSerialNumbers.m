function plot = gen_getFileNameRunNameSerialNumbers(runFolder,...
          runProfile, outputPhysicsDirectory, runNamePost)
      
global logFileFID

%numFiles2Operate = 0 all files
%                   -1 lastFile
%                   -3 interval specified
%                   -4 interval specified for time range
%                   -5 mesh serial range determined by sync times
%                   > 0 specific number of files
%
% runNamePost is something that follows runProfile name (e.g. SL for solid runProfile
% names)
%
% Output is plot = struct('mesh',[],'sync',[]) where
% plot.* = struct('serialNumbers',[],'runNames',[],'fileNameOut',[],'num',[])
%==========================================================================
if nargin < 1
    runFolder = 'old_2015_07_02';
end

if nargin < 2
    runProfile = struct('numFiles2Operate',[],'intervals',[],'isList',[],'deformScale',[],'superImp',[],'flag2LineWidth',[]);
    runProfile.intervals = struct('mesh',[],'sync',[]);
    runProfile.isList = struct('mesh',0,'sync',0);
    runProfile.numFiles2Operate = struct('mesh',[],'sync',[]);
    runProfile.deformScale = struct('mesh',NaN,'sync',-1);
    runProfile.flag2LineWidth = struct('mesh',[],'sync',[]);
    runProfile.numFiles2Operate.mesh = -1;
    runProfile.numFiles2Operate.sync = -1;
    runProfile.superImp = struct('n',0,'superImpFlag','multi','lineFlag','line','lineSpecs',[],'uniqueClr',1,'uniqueStyle',0);
end

if nargin < 3
    outputPhysicsDirectory = 'physics';
end

if nargin < 4
    runNamePost = 'SL';
end
%==========================================================================

plot = struct('mesh',[],'sync',[]);
plot.mesh = struct('serialNumbers',[],'runNames',[],'fileNameOut',[],'num',[],'times',[]);
plot.sync = struct('serialNumbers',[],'runNames',[],'fileNameOut',[],'num',[],'times',[]);


if runProfile.numFiles2Operate.sync ~= -2
%Sync outputs..............................................................
    plot.sync.serialNumbers = cell(length(runFolder),1);
    plot.sync.runNames = cell(length(runFolder),1);
    plot.sync.fileNameOut = cell(length(runFolder),1);
    plot.sync.num = cell(length(runFolder),1);
    plot.sync.times = cell(length(runFolder),1);
    for I = 1:length(runFolder)
        plot.sync.serialNumbers{I} = [];
        plot.sync.runNames{I} = {};
        plot.sync.fileNameOut{I} = {};
        plot.sync.num{I} = 0;
        plot.sync.times{I} = [];

        frontFolder = [runFolder{I}, '/', outputPhysicsDirectory, '/'];
        fcSync = frontClass();
        if runProfile.numFiles2Operate.sync == -1
            fileSync = [frontFolder,'frontSync.last'];
            fidSync = fopen(fileSync,'r');
            fcSync.readLast(fidSync);
            fclose(fidSync);

        else
            fileSync = [frontFolder,'frontSync.all'];
            fidSync = fopen(fileSync,'r');
            fcSync.readAll(fidSync);
            fclose(fidSync);
        end
        %
        %
        if fcSync.numFiles ~= 0
            if (runProfile.numFiles2Operate.sync == 0) || (runProfile.numFiles2Operate.sync == -1) || (runProfile.numFiles2Operate.sync > 0)
                if runProfile.numFiles2Operate.sync < 1
                    maxIter = fcSync.numFiles;
                else
                    if runProfile.numFiles2Operate.sync <= fcSync.numFiles
                        maxIter = runProfile.numFiles2Operate.sync;
                    else
                        maxIter = fcSync.numFiles;
                       THROW('WARNING: numFiles2Operate[',runProfile.numFiles2Operate.sync,...
                           '] exceeds maximum number of files:[',fcSync.numFiles,...
                           '].\nOnly [',fcSync.numFiles,' of ',runProfile.numFiles2Operate.sync,'] files were processed'); 
                    end 
                end

                plot.sync.times{I} = NaN.*ones(maxIter,1);
                for i = 1:maxIter
                    plot.sync.serialNumbers{I}(i) = fcSync.fronts{i}.sn;
                    plot.sync.runNames{I}{i} = fcSync.fronts{i}.runName;
                    plot.sync.fileNameOut{I}{i} = fcSync.fronts{i}.file;
                    plot.sync.num{I} = i;

                    %syncTime update
                    plot.sync.times{I}(i) = fcSync.fronts{i}.timeMin;

                    fcSync.printFrontEntry(logFileFID, i);
                end
            else % (runProfile.numFiles2Operate.sync == -3) || (runProfile.numFiles2Operate.sync == -4)
                if ~isempty(runProfile.intervals.sync)
                    if runProfile.numFiles2Operate.sync == -3
                        i = 1;
                        for index = 1:fcSync.numFiles
                            if SerialNumberIntervalCheck(fcSync.fronts{index},runProfile.intervals.sync,runProfile.isList.sync)
                                plot.sync.serialNumbers{I}(i) = fcSync.fronts{index}.sn;
                                plot.sync.runNames{I}{i} = fcSync.fronts{index}.runName;
                                plot.sync.fileNameOut{I}{i} = fcSync.fronts{index}.file;
                                plot.sync.num{I} = i;
                                i = i + 1;

                                %syncTime update
                                plot.sync.times{I} = [plot.sync.times{I}, fcSync.fronts{index}.timeMin];

                                fcSync.printFrontEntry(logFileFID, index);
                            end
                        end
                    else %if runProfile.numFiles2Operate.sync == -4
                        i = 1;
                        Js = runProfile.intervals.sync(1);
                        Ji = runProfile.intervals.sync(2);
                        Je = runProfile.intervals.sync(3);
                        if runProfile.isList.sync == 1
                            Js = 1;
                            Ji = 1;
                            Je = length(runProfile.intervals.sync);
                        end
                        for ti = Js:Ji:Je
                            time = ti;
                            if runProfile.isList.sync == 1
                                time = runProfile.intervals.sync(ti);
                            end
                            [success,index] = RetrieveTimeInformation(time, fcSync);
                            if success
                                plot.sync.serialNumbers{I}(i) = fcSync.fronts{index}.sn;
                                plot.sync.runNames{I}{i} = fcSync.fronts{index}.runName;
                                plot.sync.fileNameOut{I}{i} = fcSync.fronts{index}.file;
                                plot.sync.num{I} = i;
                                i = i + 1;

                                %syncTime update
                                plot.sync.times{I} = [plot.sync.times{I}, fcSync.fronts{index}.timeMin];

                                fcSync.printFrontEntry(logFileFID, index);
                            else
                                THROW(['There exists no solution for Time: ',num2str(index)]);
                            end
                        end
                    end
                end
            end
        else
            %Proceed...
        end

%..........................................................................
    end
end

if runProfile.numFiles2Operate.mesh ~= -2
%spaceMesh outputs.........................................................

    plot.mesh.serialNumbers = cell(1,1);
    plot.mesh.runNames = cell(1,1);
    plot.mesh.fileNameOut = cell(1,1);
    plot.mesh.num = cell(1,1);
    plot.mesh.times = cell(1,1);
    for I = 1:1
        plot.mesh.serialNumbers{I} = [];
        plot.mesh.runNames{I} = {};
        plot.mesh.fileNameOut{I} = {};
        plot.mesh.num{I} = 0;
        plot.mesh.times{I} = [];

        fcMesh = frontClass();
        if runProfile.numFiles2Operate.mesh == -1
            fileMesh = [frontFolder,'front.last'];
            fidMesh = fopen(fileMesh,'r');
            if (fidMesh < 0)
                fprintf(1, 'cannot open %s\n', fileMesh);
            end
            fcMesh.readLast(fidMesh);
            fclose(fidMesh);
        else
            fileMesh = [frontFolder,'front.all'];
            fidMesh = fopen(fileMesh,'r');
            fcMesh.readAll(fidMesh);
            fclose(fidMesh);
        end
        %
        %
        if fcMesh.numFiles ~= 0
            if (runProfile.numFiles2Operate.mesh == 0) || (runProfile.numFiles2Operate.mesh == -1) || (runProfile.numFiles2Operate.mesh > 0)
                if runProfile.numFiles2Operate.mesh < 1
                    maxIter = fcMesh.numFiles;
                else
                    if runProfile.numFiles2Operate.mesh <= fcMesh.numFiles
                        maxIter = runProfile.numFiles2Operate.mesh;
                    else
                        maxIter = fcMesh.numFiles;
                       THROW('WARNING: numFiles2Operate[',runProfile.numFiles2Operate.mesh,...
                           '] exceeds maximum number of files:[',fcMesh.numFiles,...
                           '].\nOnly [',fcMesh.numFiles,' of ',runProfile.numFiles2Operate.mesh,'] files were processed'); 
                    end 
                end

                for i = 1:maxIter
                    plot.mesh.serialNumbers{I}(i) = fcMesh.fronts{i}.sn;
                    plot.mesh.runNames{I}{i} = fcMesh.fronts{i}.runName;
                    plot.mesh.fileNameOut{I}{i} = fcMesh.fronts{i}.file;
                    plot.mesh.num{I} = i;

                    fcMesh.printFrontEntry(logFileFID, i);
                end
            else % (runProfile.numFiles2Operate.mesh == -3) || (runProfile.numFiles2Operate.mesh == -4) || (runProfile.numFiles2Operate.mesh == -5)
                if ~isempty(runProfile.intervals.mesh) || runProfile.numFiles2Operate.mesh == -5
                    if runProfile.numFiles2Operate.mesh == -3
                        i = 1;
                        for index = 1:fcMesh.numFiles
                            if SerialNumberIntervalCheck(fcMesh.fronts{index},runProfile.intervals.mesh,runProfile.isList.mesh)
                                plot.mesh.serialNumbers{I}(i) = fcMesh.fronts{index}.sn;
                                plot.mesh.runNames{I}{i} = fcMesh.fronts{index}.runName;
                                plot.mesh.fileNameOut{I}{i} = fcMesh.fronts{index}.file;
                                plot.mesh.num{I} = i;
                                i = i + 1;

                                fcMesh.printFrontEntry(logFileFID, index);
                            end
                        end
                    elseif runProfile.numFiles2Operate.mesh == -4
                        i = 1;
                        Js = runProfile.intervals.mesh(1);
                        Ji = runProfile.intervals.mesh(2);
                        Je = runProfile.intervals.mesh(3);
                        if runProfile.isList.mesh == 1
                            Js = 1;
                            Ji = 1;
                            Je = length(runProfile.intervals.mesh);
                        end
                        for ti = Js:Ji:Je
                            time = ti;
                            if runProfile.isList.mesh == 1
                                time = runProfile.intervals.mesh(ti);
                            end
                            [success,index] = RetrieveTimeInformation(time, fcMesh);
                            if success
                                plot.mesh.serialNumbers{I}(i) = fcMesh.fronts{index}.sn;
                                plot.mesh.runNames{I}{i} = fcMesh.fronts{index}.runName;
                                plot.mesh.fileNameOut{I}{i} = fcMesh.fronts{index}.file;
                                plot.mesh.num{I} = i;
                                i = i + 1;

                                fcMesh.printFrontEntry(logFileFID, index);
                            else
                                THROW(['There exists no solution for Time: ',num2str(index)]);
                            end
                        end
                    else % runProfile.numFiles2Operate.mesh == -5
                        i = 1;
                        for t = 1:length(plot.sync.times{I})
                            [success,index] = RetrieveTimeInformation(plot.sync.times{I}(t), fcMesh);
                            if success
                                plot.mesh.serialNumbers{I}(i) = fcMesh.fronts{index}.sn;
                                plot.mesh.runNames{I}{i} = fcMesh.fronts{index}.runName;
                                plot.mesh.fileNameOut{I}{i} = fcMesh.fronts{index}.file;
                                plot.mesh.num{I} = i;
                                i = i + 1;

                                %meshTime update
                                plot.mesh.times{I} = [plot.mesh.times{I}, plot.sync.times{I}(t)];

                                fcMesh.printFrontEntry(logFileFID, index);
                            else
                                THROW(['There exists no solution for Time: ',num2str(index)]);
                            end
                        end
                    end
                end
            end
        else
            %Proceed...
        end
%..........................................................................
    end
end

return;
end

%Function to check whether each front entry of frontClassObj serial number
%is within specified runSpecs serial range
function success = SerialNumberIntervalCheck(frontClassObj, runSpecsInterval, isList)
if isList == 1
    success = any(runSpecsInterval == frontClassObj.sn);
else
    gtMin = frontClassObj.sn >= runSpecsInterval(1);
    ltMax = frontClassObj.sn <= runSpecsInterval(end);
    multInc = mod(frontClassObj.sn,runSpecsInterval(2))==0;

    success = gtMin * ltMax * multInc;
end
end

%Function to find index of frontClassObj front entry whose time is closest
%to input time
function [success,index] = RetrieveTimeInformation(time, frontClassObj)
success = 0;
indexMin = 0;
dTimeMin = Inf;

for i = 1:frontClassObj.numFiles
    dT = abs(time - frontClassObj.fronts{i}.timeMin);
    if (dT < dTimeMin)
        dTimeMin = dT;
        indexMin = i;
    end
end

if indexMin > 0
   index = indexMin;
   success = 1; 
end

end
