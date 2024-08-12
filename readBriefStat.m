function [minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, counter, average, sum, sDiviation, name] =  ...
    readBriefStat(fid, maxLine, removeSolSizeCol)

if (nargin < 3)
    removeSolSizeCol = 0;
end
if (nargin == 1)
    maxLine = 10000;
end
i = 1;
while ((feof(fid) == 0) && (i <= maxLine))
    [temp, noteof] = fscanf(fid,'%lg',1);
    if (noteof == 0)
        break;
    else
        minV(i) = temp;
    end
    min_eID(i) = fscanf(fid,'%ld',1);
    minCoord(i, :) = fscanf(fid, '%lg', 3);
    min_id(i) = fscanf(fid,'%ld',1);
    
    maxV(i) = fscanf(fid,'%lg',1);
    max_eID(i) = fscanf(fid,'%ld',1);
    maxCoord(i, :) = fscanf(fid, '%lg', 3);
    max_id(i) = fscanf(fid,'%ld',1);

    counter(i) = fscanf(fid,'%d',1);
    average(i) = fscanf(fid,'%lg',1);
    sum(i) = fscanf(fid,'%lg',1);
    sDiviation(i) = fscanf(fid,'%lg',1);
    name{i} = fscanf(fid,'%s', 1);
    i = i + 1;
end

siz = length(min_eID);
if (removeSolSizeCol == 1)
    minV = minV(2:siz);
    min_eID = min_eID(2:siz);
    minCoord = minCoord(2:siz, :);
    min_id = min_id(2:siz);
    maxV = maxV(2:siz);
    maxCoord = maxCoord(2:siz, :);
    max_id = max_id(2:siz);
    counter = counter(2:siz);
    average = average(2:siz);
    sum = sum(2:siz);
    sDiviation = sDiviation(2:siz);
    nameTmp = name;
    for i = 1: siz - 1
        name{i} = nameTmp{i + 1};
    end
end


% maxV
% pause
