function plotColor2DFldValue(confGen, confData, serialNum)


    [startingPts, sizeBreakPts] = readStartingPoints(fidStat);
    colSize = fscanf(fidStat,'%d', 1);
    maxCross = fscanf(fidStat,'%d', 1);
