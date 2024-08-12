directory = '../trunk_working/physics/outputPP';
runname = 'XuN';
middlename = 'SL';
statFileName = 'StatTimeBrief';
fileSpecificName = 'TimeSlice';
ReadFlag = 'a';
flagNum = -1;
serialNum = 100;
matrixFormData = 1;
useOnlyStat = 1;

%[data, startingPts, sizeBreakPts, col, colSize, minV, minCoord, min_eID, ...
%    min_id, maxV, maxCoord, max_eID, max_id, Counter, average, sum, sDiviation, fieldName] = ...
%readSliceFile(directory, runname, middlename, statFileName, fileSpecificName, ReadFlag, flagNum, serialNum, matrixFormData, useOnlyStat);
%minV
%data

ctTimes = 4.0:0.04:4.08;
startTime = 0.0;
timeStep = 0.04;
statBriefName = 'StatTimeBrief';
sliceName = 'TimeSlice';
sliceReadFlag = 'a';
matrixTypeOutput = 0;
computeDerivatives = 1;
derMethod = 1;
maxPower = 6;
returnInfs = 1;
useOnlyStat = 0;
indexCoord2SpaceExtermums = 1;

fldRequested{1}{1} = 'flds';    fldRequested{1}{2} = 4;    fldRequested{1}{3} = 'max';
fldRequested{2}{1} = 'id';      fldRequested{2}{2} = 0;     fldRequested{2}{3} = '-12204';
fldRequested{3}{1} = 'id';      fldRequested{3}{2} = 0;     fldRequested{3}{3} = '-2204';
fldRequested{4}{1} = 'fld0';    fldRequested{4}{2} = 4;     fldRequested{4}{3} = 'min';
fldRequested{5}{1} = 'id';      fldRequested{5}{2} = 0;     fldRequested{5}{3} = '-11004';
fldRequested{6}{1} = 'id';      fldRequested{6}{2} = 0;     fldRequested{6}{3} = '-1004';
fldRequested{7}{1} = 'flds';    fldRequested{7}{2} = 3;     fldRequested{7}{3} = 'max';
fldRequested{8}{1} = 'id';    fldRequested{8}{2} = 0;     fldRequested{8}{3} = '-12203';
fldCollected{1}{1} = 'space';    fldCollected{1}{2} = 0;
fldCollected{2}{1} = 'time';    fldCollected{2}{2} = 0;
fldCollected{3}{1} = 'flds';    fldCollected{3}{2} = 10;
fldCollected{4}{1} = 'flds';    fldCollected{4}{2} = 3;
fldCollected{5}{1} = 'flds';    fldCollected{5}{2} = 4;

[spaces, values, dataCollected, dSpaces, dValues, dDataCollected] = getSelectedFldsSelectedPts(ctTimes , startTime, timeStep, ...
directory, runname, middlename, sliceName,sliceReadFlag, statBriefName, ...
fldRequested, fldCollected, matrixTypeOutput, computeDerivatives, derMethod, maxPower, ...
returnInfs, useOnlyStat, indexCoord2SpaceExtermums);


% x = 10 * [0.21 0.32 0.65 0.75 0.89];
% 
% y = sin(80 * x);
% 
% y(3) = inf;
% 
% len = length(y);
% 
% ind = find(isfinite(y))
% y2 = y(ind)
% x2 = x(ind)
% 
% X2 = 0:0.5:10
% Y2 = interp1(x2,y2,X2, 'spline')
% Y3 = sin(80 * X2);
% plot(X2, Y2 , X2, Y3);
% hold on;
% plot(x,y, 'LineStyle', 'none', 'Marker', 'x');
% 
% % Y = interp1(x,y,X2, 'spline')
% % pause
% % plot(X2, Y);
