function dataSamePColGrouped = indexOnPrimaryCellSortOnSecondaryCol(data, primaryCol, startVal, endVal, incrementVal, secondaryCol, ...
    spaceIndex, maxAllowableSpaceCoordinate)

% This function is given a cell of vectors.
% it first sorts vectors based on primaryCol and groups those with same
% primary col value in one cell of vectors. This cells of vectors are also
% arranged based on their primaryCol Value value = startVal + i *
% incrementVal is indexed i and check is only for times between startVal
% and endVal with increments incrementVal (others are thrown out)
% then within that cell of vectors again sorts vectors based on
% secondaryCol

tol = 1e-5;


%dataSortFirst = sortCellofVectorsBasedOnColValue(data, primaryCol);

dataSamePColGrouped = cell(floor((endVal - startVal) / incrementVal + tol) + 1 , 1);
siz = length(data);
for i = 1:siz
    colValue = data{i}(primaryCol);
    if (colValue > endVal + tol * incrementVal)
        continue;
    end
    colIndex = floor((colValue - startVal) / incrementVal + tol) + 1;
    if (abs(colValue - (colIndex - 1) * incrementVal - startVal) > 2 * tol * incrementVal)
        continue;
    end
    spaceCluster = data{i}(spaceIndex);
    if (spaceCluster > maxAllowableSpaceCoordinate)
         continue;
    end
    dataSamePColGrouped{colIndex}{length(dataSamePColGrouped{colIndex}) + 1} = data{i};
end
    


for index = 1:length(dataSamePColGrouped)
    temp = dataSamePColGrouped{index};
    dataSamePColGrouped{index} = sortCellofVectorsBasedOnColValue(temp, secondaryCol);
end
