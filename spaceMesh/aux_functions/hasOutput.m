function hasout = hasOutput(varargin)
fldrTest = '';

if nargin < 3
    runFolder = varargin{1};
    outputPhysicsDirectory = varargin{2};
    fldrTest = fullfile(runFolder,outputPhysicsDirectory,'output_front');
else
    topLevelDir = varargin{1};
    runFolder = varargin{2};
    outputPhysicsDirectory = varargin{3};
    fldrTest = fullfile(topLevelDir, runFolder,outputPhysicsDirectory,'output_front');
end

idirEmpty = isDirEmpty(fldrTest); 
iFile0 = isFile(fullfile(fldrTest,'front.all'));
iFile1 = isFile(fullfile(fldrTest,'front.last'));
iFile2 = isFile(fullfile(fldrTest,'frontSync.all'));
iFile3 = isFile(fullfile(fldrTest,'frontSync.last'));

hasout = (idirEmpty == 0 || iFile0 == 1 || iFile1 == 1 || iFile2 == 1 || iFile3 == 1);
end