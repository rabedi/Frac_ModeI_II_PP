function [plotConfigurations, plotConfigurationsNumber] = plt_plot_plotDataSet_read(fid)

buf = fscanf(fid, '%s', 1);
while (strcmp(buf, 'plots') == 0)
    buf = fscanf(fid, '%s', 1);
end

buf = fscanf(fid, '%s', 1);
plotConfigurationsNumber = fscanf(fid, '%d', 1);

for i = 1:plotConfigurationsNumber
    index = fscanf(fid, '%d', 1);
    if (index ~= i)
        fprintf(1, 'in plt_plot_plotDataSet_read index is not equal to i, a plot is missing\n');
        index
        i
    end
    plotConfigurations{i} = plt_plot_plotDataSet;
    plotConfigurations{i} = plotConfigurations{i}.read(fid);
end