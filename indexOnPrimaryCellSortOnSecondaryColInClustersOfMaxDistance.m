function dataSamePColGrouped = indexOnPrimaryCellSortOnSecondaryColInClustersOfMaxDistance(data, primaryCol, startVal, endVal, ...
    incrementVal, secondaryCol, maxDistInSecondaryCol, spaceIndex, maxAllowableSpaceCoordinate)
% This is similar to indexOnPrimaryCellSortOnSecondaryCol except
% for each dataSamePColGrouped{i} (primaryCol values are the same for all)
% we first sort the values based on secondaryCol then looks at the values
% sorted and cluster those values based on the maximum distance allowed. It
% clusters all within "maxDistInSecondaryCol" in one cluster

%dataSamePColGrouped{primaryIndex}{secondary clusterIndex}{index
%withincluser}(data component)
dataSamePColGroupedTemp = indexOnPrimaryCellSortOnSecondaryCol(data, primaryCol, startVal, endVal, incrementVal, secondaryCol, ...
spaceIndex, maxAllowableSpaceCoordinate);




for i = 1:length(dataSamePColGroupedTemp)
    if (length(dataSamePColGroupedTemp{i}) == 0)
        continue;
    end
    previousSecondary = dataSamePColGroupedTemp{i}{1}(secondaryCol);
    indexCluster = 1;
    subGroupIndex = 0;
    for j = 1:length(dataSamePColGroupedTemp{i})
        if (abs(previousSecondary - dataSamePColGroupedTemp{i}{j}(secondaryCol)) <= maxDistInSecondaryCol)
            subGroupIndex = subGroupIndex + 1;
        else
            subGroupIndex = 1;
            indexCluster = indexCluster + 1;
        end
        previousSecondary = dataSamePColGroupedTemp{i}{j}(secondaryCol);
        dataSamePColGrouped{i}{indexCluster}{subGroupIndex} = dataSamePColGroupedTemp{i}{j};
    end
end