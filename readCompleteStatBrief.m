function [startingPts, sizeBreakPts, colSize, maxCross, minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, counter, average, sum, sDiviation, fieldName] = readCompleteStatBrief(fileNameStatCT)


fidStatR = fopen(fileNameStatCT, 'r');
[startingPts, sizeBreakPts] = readStartingPoints(fidStatR);
colSize = fscanf(fidStatR,'%d', 1);
maxCross = fscanf(fidStatR,'%d', 1);
[minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, counter, average, sum, sDiviation, fieldName] =  readBriefStat(fidStatR, colSize);
fclose(fidStatR);


