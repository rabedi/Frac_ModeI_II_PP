function outputFolderACP(outputDirectoryMidName, startFileName, numInterval)

if nargin < 2
    startFileName = 'SF';
end

if nargin < 3
    numInterval = 50;
end

%conf = fopen(configFileName, 'r');
%buf = fscanf(conf, '%s', 1);
%startFileName = fscanf(conf, '%s', 1);
%buf = fscanf(conf, '%s', 1);
printOption = 'png';%fscanf(conf, '%s', 1);

%buf = fscanf(conf, '%s', 1);
plotEndPt = 0;%fscanf(conf, '%d', 1);
%buf = fscanf(conf, '%s', 1);
plotSV = 0;%fscanf(conf, '%d', 1);
%buf = fscanf(conf, '%s', 1);
%numInterval = fscanf(conf, '%d', 1);
%buf = fscanf(conf, '%s', 1);
layerStart = 1;%fscanf(conf, '%d', 1);
%buf = fscanf(conf, '%s', 1);
layerEnd = -1;%fscanf(conf, '%d', 1);
if (layerEnd < 0)
    layerEnd = inf;
end

%tmp = fscanf(conf, '%s', 1);
outputDirectoryPreName = '../../';%fscanf(conf, '%s', 1);
%if (strcmp(outputDirectoryPreName, 'none') == 1)
%    outputDirectoryPreName = '';
%end
%tmp = fscanf(conf, '%s', 1);
%outputDirectoryMidName = fscanf(conf, '%s', 1);
%if (strcmp(outputDirectoryMidName, 'none') == 1)
%    outputDirectoryMidName = '';
%end
%tmp = fscanf(conf, '%s', 1);
outputDirectoryPostName = '/output/';%fscanf(conf, '%s', 1);
%if (strcmp(outputDirectoryPostName, 'none') == 1)
%    outputDirectoryPostName = '';
%end

%tmp = fscanf(conf, '%s', 1);
outputFolder = 'images/';%fscanf(conf, '%s', 1);
%if (strcmp(outputFolder, 'none') == 1)
%    outputFolder = '';
%end




outputFile = 'crackPath';

outputFolder = [outputFolder, outputDirectoryMidName];
if (isdir(outputFolder) == 0)
    mkdir(outputFolder);
end
outputFolder = [outputFolder, '/'];

cntr = 0;
for layer = layerStart:layerEnd
    inputFileName = [outputDirectoryPreName, outputDirectoryMidName, outputDirectoryPostName, ...
        startFileName, 'SLcrackPath', num2str(layer, '%04d'), '.txt'];
    fid = fopen(inputFileName, 'r');
    if (fid < 0)
        
        plotTheLastImage_front(printOption, cntr, t, outputDirectoryMidName, startFileName);
        cls_
        return;
    end
    [t, cntr] = plotSimpleACP(fid, plotEndPt, plotSV, numInterval, outputFolder, outputFile, printOption, cntr);
end