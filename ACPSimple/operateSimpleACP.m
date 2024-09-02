function operateSimpleACP(configFileName)


conf = fopen(configFileName, 'r');
buf = fscanf(conf, '%s', 1);
startFileName = fscanf(conf, '%s', 1);
buf = fscanf(conf, '%s', 1);
printOption = fscanf(conf, '%s', 1);

buf = fscanf(conf, '%s', 1);
plotEndPt = fscanf(conf, '%d', 1);
buf = fscanf(conf, '%s', 1);
plotSV = fscanf(conf, '%d', 1);
buf = fscanf(conf, '%s', 1);
numInterval = fscanf(conf, '%d', 1);
buf = fscanf(conf, '%s', 1);
layerStart = fscanf(conf, '%d', 1);
buf = fscanf(conf, '%s', 1);
layerEnd = fscanf(conf, '%d', 1);
if (layerEnd < 0)
    layerEnd = inf;
end

tmp = fscanf(conf, '%s', 1);
outputDirectoryPreName = fscanf(conf, '%s', 1);
if (strcmp(outputDirectoryPreName, 'none') == 1)
    outputDirectoryPreName = '';
end
tmp = fscanf(conf, '%s', 1);
outputDirectoryMidName = fscanf(conf, '%s', 1);
if (strcmp(outputDirectoryMidName, 'none') == 1)
    outputDirectoryMidName = '';
end
tmp = fscanf(conf, '%s', 1);
outputDirectoryPostName = fscanf(conf, '%s', 1);
if (strcmp(outputDirectoryPostName, 'none') == 1)
    outputDirectoryPostName = '';
end

tmp = fscanf(conf, '%s', 1);
outputFolder = fscanf(conf, '%s', 1);
if (strcmp(outputFolder, 'none') == 1)
    outputFolder = '';
end



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
        cls_
        return;
    end
    [t, cntr] = plotSimpleACP(fid, plotEndPt, plotSV, numInterval, outputFolder, outputFile, printOption, cntr);
end