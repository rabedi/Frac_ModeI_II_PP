function [noteof, numpts, data] = readBlock(fid, col, AsciiFormat, startingPts, findEndPtsProcessZone)

global IplotAroundProcessZoneMinValues;
global IplotAroundProcessZoneMaxValues;
global cnfg;
idCol = getColNumberFromSymbolNumber('id', 0, startingPts);

if nargin < 5
    findEndPtsProcessZone = 0;
end

% if feof(fid)
%     noteof = 0;
%     numpts = 0;
%     data = 0;
%     return;
% end
if (AsciiFormat == 1)
    [numpts, noteof] = fscanf(fid,'%d',1);
    if (noteof == 0)
        noteof = 0;
        numpts = 0;
        data = 0;
        return;
    end
    rem_col = col - 1;
    data = zeros(numpts, rem_col);

    for i = 1:numpts
        for j = 1:rem_col
            data(i , j) = fscanf(fid, '%lg', 1);
        end
        if (i < numpts)
            temp = fscanf(fid, '%d', 1);
        end
    end
else
    numpts = fread(fid,1,'int');
    if (length(numpts) == 0)
        noteof = 0;
        numpts = 0;
        data = 0;
        return;
    end        
    n = fread(fid,1,'int');
    data = fread(fid,[n numpts],'double');
    data = data';
    data = data(:,2:n);
    

    if (idCol > 0)
        data(:, idCol) = floor(data(:, idCol) + 0.5);
    end
    eIDCol = getColNumberFromSymbolNumber('eID', 0, startingPts);
    if (eIDCol > 0)
        data(:, eIDCol) = floor(data(:, eIDCol) + 0.5);
    end
    noteof = 1;
end



if (findEndPtsProcessZone > 0)
    spaceCol = getColNumberFromSymbolNumber('space', 0, startingPts);
    for pt = 1:numpts
        ind = -data(pt, idCol);
        if ((ind <= 4) && (ind >= 1))
            space = data(pt, spaceCol);
            
            cnfg{IplotAroundProcessZoneMinValues}(ind) = min(cnfg{IplotAroundProcessZoneMinValues}(ind), space);
            cnfg{IplotAroundProcessZoneMaxValues}(ind) = max(cnfg{IplotAroundProcessZoneMaxValues}(ind), space);
        end
    end
end

%tline = fgets(fid)
