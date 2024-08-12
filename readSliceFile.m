function [dataUnitSize, data, startingPts, sizeBreakPts, col, colSize, minV, ...
    minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, Counter, average, ...
    sum, sDiviation, fieldName, noteof, fidOut] ...
    = readSliceFile(directory, runname, middlename, statFileName, ...
    fileSpecificName, ReadFlag, flagNum, serialNum, matrixFormData, useOnlyStat, fid, maxNumRows2Read)

noteof = 0;
fidOut = -1;

if nargin < 11
    fid = -2;
end

if (fid == -2)
    closable = 1;
else
    closable = 0;
end
    
if nargin < 12
    maxNumRows2Read = inf;
end

removeSolSizeCol = 1;
global allowBinary;
if (allowBinary == 0)
    ReadFlag = 'a';
end

if (ReadFlag == 'a')
    ext = 'txt';
    AsciiFormat = 1;
else
    ext = 'bin';
    AsciiFormat = 0;
end


dataUnitSize = 0;


if (flagNum < 0)
    serialNumData = serialNum;
    serialNumStat = serialNum;
else
    serialNumData = serialNum;
    serialNumStat = -1;
end    
if ((useOnlyStat == 0) && (fid < 0))
    filename = getFileName(directory, runname, middlename, flagNum, fileSpecificName, serialNumData , ext);
    fid = fopen(filename, 'r');
    if (fid < 0)
        fprintf('readSliceFile unable to open %s', filename);
        pause;
    end    
end

fileNameStat = getFileName(directory, runname, middlename, flagNum, statFileName, serialNumStat, 'txt');
fidStat = fopen(fileNameStat,'r');
if (fidStat == -1)
    fprintf('unable to open %s', fileNameStat);
    pause;
end

    
[startingPts, sizeBreakPts] = readStartingPoints(fidStat);
col = startingPts(sizeBreakPts);
colSize = fscanf(fidStat,'%d', 1);
maxCross = fscanf(fidStat,'%d', 1);
    
[minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, Counter, average, sum, sDiviation, fieldName] =  readBriefStat(fidStat, colSize, removeSolSizeCol);
fclose(fidStat);
     
data = cell(0);
if (useOnlyStat == 1)
%    fclose(fid);
    return;
end

%reading each flag's data
counter = 1;
[noteof, numpt, tmp] = readBlock(fid, col,AsciiFormat,  startingPts);
if (noteof ~= 0)
    data{counter} = tmp;
end
while ((noteof ~= 0) && (counter <= maxNumRows2Read))
    counter = counter + 1;
    [noteof, numpt, tmp] = readBlock(fid, col,AsciiFormat,  startingPts);
    if (noteof ~= 0)
        data{counter} = tmp;
    end
end

if (matrixFormData == 1)
    dataTemp = data;
    clear data;
    len = length(dataTemp);
    dataUnitSize = zeros(1, len);
    if (len > 0)
        [m_, n] = size(dataTemp{1});
        if (counter < 1001)
            data = zeros(m_, n);
        else
        end
    end
    cntr = 1;
    for i = 1:len
        [m, n] = size(dataTemp{i});
        data(cntr:cntr + m - 1, :) = dataTemp{i};
        cntr  = cntr + m;
        dataUnitSize(i) = m;
    end
end


fidOut = fid;

if ((noteof == 0) || (closable == 1))
    fclose(fid);
end