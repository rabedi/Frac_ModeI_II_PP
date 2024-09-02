function plotTheLastImage_front(printOption, cntr, t, outputDirectoryMidName, startFileName)


outputFolder = startFileName;
if (isdir(outputFolder) == 0)
    mkdir(outputFolder);
end
outputFolder = [outputFolder, '/'];

fileName = [outputFolder, outputDirectoryMidName, '_', num2str(cntr, '%08d'), '_t_', num2str(t, '%08d'), '.', printOption];

xlimV = get(gca, 'xlim');


% the part of SF (Sharon Fineberg examples) no xlimV Smaller than 2%
if (xlimV(1) < 2)
    xlimV
    pause
    xlimV(1) = 2.0;
end

ylimV = get(gca, 'ylim');

axis equal;

set(gca, 'xlim', xlimV);
set(gca, 'ylim', ylimV);

print(['-d', printOption], fileName);

cls_

modifyInput = 1;
operateSpaceMesh('spaceMeshConfigBase.txt', modifyInput, xlimV, ylimV, printOption, outputDirectoryMidName, startFileName)

