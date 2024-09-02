function plotMarkers4BulkContours(serialNumAbsolute)%, zflags, fig) 

global confGen;
global s_figContoursGen;
global p_pltFlag;
% fig = confGen{s_figContoursGen};
% zflags = confData{p_pltFlag};
% addMarkerData must be 1 entering this function

numFlds = length(confData{p_pltFlag});

for fld = 1:numFlds
    if (confData{p_pltFlag}(fld)  == 0)
        continue;
    end
    figure(confGen{s_figContoursGen}(fld));
    hold on;
    PlotContourMarkers(serialNumAbsolute);
end