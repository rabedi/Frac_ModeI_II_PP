function [startPX, endPX, startPY, endPY] = computeLimitsAroundProcessZoneContourPlots(pzX, pzY)

global confGen;
global conf2DPlot;
global IplotAroundProcessZoneFactorX;
global IplotAroundProcessZoneFactorY;

global flagValueFile; 
global flagDataFile;
global CZstartIndex;
global CZendIndex; 
global CTindex;
global startCohFaceIndex;
global CZstaticSizeIndex;

global startCohFaceXIndex;
global startCohFaceYIndex;

global s_runData;

startInd = confGen{s_runData}(CZstartIndex);
endInd = confGen{s_runData}(CZendIndex);

startPX = pzX(startInd);
startPY = pzY(startInd);
endPX = pzX(endInd);
endPY = pzY(endInd);
if ((startPX > -inf) && (endPX > -inf))
    delta = sqrt((endPX - startPX)^2 + (endPY - startPY)^2); 
    
    factorX = (conf2DPlot{IplotAroundProcessZoneFactorX} - 1) / 2.0;
    factorY = (conf2DPlot{IplotAroundProcessZoneFactorY} - 1) / 2.0;
    xmax = max(startPX, endPX);
    xmin = min(startPX, endPX);
    ymax = max(startPY, endPY);
    ymin = min(startPY, endPY);
    startPX = xmin - factorX * delta;
    endPX = xmax + factorX * delta;
    startPY = ymin - factorY * delta;
    endPY = ymax + factorY * delta;
else
    ctInd = confGen{s_runData}(CTindex);
    basePtCTX = pzX(ctInd);
    basePtCTY = pzY(ctInd);

    basePt0X = confGen{s_runData}(startCohFaceXIndex);
    basePt0Y = confGen{s_runData}(startCohFaceYIndex);

    if (basePtCTX == -inf)
        basePtX = basePt0X;
        basePtY = basePt0Y;
    else
        basePtX = basePtCTX;
        basePtY = basePtCTY;
    end
    staticProcessZoneSize = confGen{s_runData}(CZstaticSizeIndex);

    factorX = conf2DPlot{IplotAroundProcessZoneFactorX};
    factorY = conf2DPlot{IplotAroundProcessZoneFactorY};
    startPX = basePtX - factorX * staticProcessZoneSize;
    startPY = basePtY - factorY * staticProcessZoneSize;
    endPX = basePtX + factorX * staticProcessZoneSize;
    endPY = basePtY + factorY * staticProcessZoneSize;
end
