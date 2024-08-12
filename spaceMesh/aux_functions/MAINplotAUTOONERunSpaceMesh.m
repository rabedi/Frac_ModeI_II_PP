function MAINplotAUTOONERunSpaceMesh(runFolder, configName,...
                                        runProfile, doCLS)
%numFiles2Operate =  0 all files
%                    -1 lastFile
%                    -3 interval specified for serial range
%                    -4 interval specified for time range
%                    -5 mesh serial range determined by sync times
%                   > 0 specific number of files
%
% runNamePost is something that follows runProfile name (e.g. SL for solid runProfile
% names)
%==========================================================================
if nargin < 1
    runFolder = '../../../old_2015_07_02';
end

if nargin < 2
    configName = 'ConfigSample.txt';
end

if nargin < 3
    runProfile = struct('numFiles2Operate',[],'intervals',[],'isList',[],'deformScale',[],'superImp',[],'flag2LineWidth',[]);
    runProfile.intervals = struct('mesh',[],'sync',[]);
    runProfile.isList = struct('mesh',0,'sync',0);
    runProfile.numFiles2Operate = struct('mesh',[],'sync',[]);
    runProfile.deformScale = struct('mesh',NaN,'sync',-1);
    runProfile.flag2LineWidth = struct('mesh',[],'sync',[]);
    runProfile.numFiles2Operate.mesh = -1;
    runProfile.numFiles2Operate.sync = -1;
    runProfile.superImp = struct('n',0,'superImpFlag','multi','lineFlag','line','lineSpecs',[],'textFlag','text','legendText',[],'uniqueClr',1,'uniqueStyle',0);
end

if nargin < 4
    doCLS = 1;
end
%=========================================================================

%outputPhysicsDirectory = 'physics/output_front';
outputPhysicsDirectory = 'physics';
runNamePost = 'SL';

%INSTEAD OF THROWING ERROR WHEN FOLDER DOESNT EXIST OR IS EMPTY JUST PRINT
%ERROR MESSAGE TO CONSOLE/FILE AND BYPASS
if length(runFolder) == 1
    hasout = hasOutput(runFolder{1},outputPhysicsDirectory);
    [~,fold,~] = fileparts(runFolder{1});
    if hasout == 0
       fprintf(1,'[%s] Does not contain output for spaceMesh operations.\n',fold);
       return;
    end
end

for rf = 1:length(runFolder)
    fldrTest = [runFolder{rf}, '/', outputPhysicsDirectory];
    exs = exist(fldrTest, 'dir');

    if (exs ~= 7)
        THROW('ERROR: Folder: (',fldrTest,') does not exist');
    %     ipc = ispc();
    %     if ipc
    %         flg = [runFolder, '/physics/*_front'];
    %         frontFolders = ls(flg);
    %         if isempty(frontFolders)
    %             return;
    %         end
    %         frontFolder = frontFolders(1, :);
    %     else
    %         flg = [runFolder, '/physics'];
    %         folders = ls(flg);
    %         folders = strsplit(folders);
    %         len = length(folders);
    %         if (len == 0)
    %             return;
    %         end
    %         fndInd = -1;
    %         for i = 1:len
    %             nm = folders{i};
    %             l2 = length(nm); 
    %             if (l2 <= 7)
    %                 continue;
    %             end
    %             tailF = nm(l2 - 5: l2);
    %             if (strcmp(tailF, '_front') == 1)
    %                 fndInd = i;
    %                 break;
    %             end
    %         end
    %         if (fndInd == -1)
    %             return;
    %         end
    %         frontFolder = folders{fndInd};
    %     end
    %     outputPhysicsDirectory = ['physics/', frontFolder];
    end
end

global superImpTmpGlobal; superImpTmpGlobal = [];
global flag2LineWMap; flag2LineWMap = [];

modifyInput = 0;
plot = gen_getFileNameRunNameSerialNumbers(runFolder, runProfile, outputPhysicsDirectory, runNamePost);

superImpTmpGlobal = runProfile.superImp;

if runProfile.numFiles2Operate.mesh ~= -2
%    if (plot.mesh.num > 0)
        flag2LineWMap = runProfile.flag2LineWidth.mesh;
        tempconfigName = ['-mesh ',configName];
        MAINFILE_operatorSpaceMesh(tempconfigName, plot.mesh.serialNumbers, plot.mesh.runNames, plot.mesh.fileNameOut, runFolder, outputPhysicsDirectory, runProfile.deformScale.mesh, doCLS);
%    end
end

if runProfile.numFiles2Operate.sync ~= -2
%    if (plot.sync.num > 0)
        flag2LineWMap = runProfile.flag2LineWidth.sync;
        tempconfigName = ['-sync ',configName];
        MAINFILE_operatorSpaceMesh(tempconfigName, plot.sync.serialNumbers, plot.sync.runNames, plot.sync.fileNameOut, runFolder, outputPhysicsDirectory, runProfile.deformScale.sync, doCLS);
%    end
end

superImpTmpGlobal = [];
flag2LineWMap = [];

end


