function [plotProperties, numPlotProperties] = plt_plot_plotProperties_Read(fid)

buf = fscanf(fid, '%s', 1);
buf = fscanf(fid, '%s', 1);
numPlotProperties = fscanf(fid, '%d', 1);

for i = 1:numPlotProperties
    index = fscanf(fid, '%d', 1);
    plotProperties{index} = plt_plot_plotProperties;
    plotProperties{index} = plotProperties{index}.read(fid);
end