function plotSingleSerialContourDataMultipleSegments(confGen, confData, serialNum, serialNumAbsolute, ...
    pauseTime, addMarkerData, maxNumRows2ReadBulk, maxNumRows2ReadBulkTotal)

global s_figContoursGen;
global p_pltFlag;

numFlds = length(confData{p_pltFlag});
for fld = 1:numFlds
    flg = confData{p_pltFlag}(fld);
    if (flg == 0)
        continue;
    end
    if (flg > 0)
        filledContour = 0;
    else
        filledContour = 1;
    end 
    flg = abs(flg);
    heightFlag = floor(flg / 100);
    if ((filledContour == 1) && (heightFlag ~= 0))
        figure(confGen{s_figContoursGen}(fld));
        set(gca, 'AmbientLightColor', [1 1 1]);
        light('Position',[0 0 1],'Style','infinite');
%       lighting phong
        lighting gouraud
%        lighting flat
    end
end


if (isfinite(maxNumRows2ReadBulkTotal))
    maxCntr = ceil(maxNumRows2ReadBulkTotal / maxNumRows2ReadBulk);
else
    maxCntr = inf;
end


fidDataBulk = -1;
noteof = 1;
cntr = 0;
while ((noteof ~= 0) && (cntr < maxCntr))
    make_noteofZero = (maxCntr - cntr == 1); 
    [noteof, fidDataBulk] = ...
    plotSingleSerialContourData(confGen, confData, serialNum, ...
    serialNumAbsolute, pauseTime, addMarkerData, fidDataBulk, maxNumRows2ReadBulk, make_noteofZero);
    cntr = cntr + 1;
end

