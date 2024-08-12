function safeMatlabDefaultRestore()
%setting defaults from setDefaults(ax,fig,defaults) in sentinel_vds_plot.m
    set(groot, 'defaultTextInterpreter', 'factory');
    set(groot, 'defaultTextFontSize', 'factory');
    set(groot, 'defaultAxesFontSize', 'factory');
    
    set(groot, 'defaultLegendInterpreter', 'factory');
    set(groot, 'defaultLegendOrientation', 'factory');
    set(groot, 'defaultLegendBox', 'factory');
    set(groot, 'defaultLegendLineWidth', 'factory');
    set(groot, 'defaultLegendFontSize', 'factory');
end