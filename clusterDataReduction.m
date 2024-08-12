function    clusterReduced = clusterDataReduction(clusterData, ClusterReductionMethod, spaceIndex, timeIndex, maxAllowableSpaceCoordinate)

%ClusterReductionMethod:
    %1 average values is considered
    %2 min value is considered
    %3 max value is considered
    
for i = 1:length(clusterData)
    changed = 0;
    for cluster = 1:length(clusterData{i})
        dataTemp = [];
        if (ClusterReductionMethod == 1)
            if (length(clusterData{i}{cluster}) > 0)
                dataTemp = 0;
            end
            for j = 1:length(clusterData{i}{cluster})
                dataTemp = dataTemp + clusterData{i}{cluster}{j};
            end
            dataTemp = 1.0 / length(clusterData{i}{cluster}) * dataTemp;
        elseif (ClusterReductionMethod == 2)
            dataTemp = clusterData{i}{cluster}{1};
        elseif (ClusterReductionMethod == 3)
            dataTemp = clusterData{i}{cluster}{length(clusterData{i}{cluster})};
        end
        spaceCluster = dataTemp(spaceIndex);
        if (spaceCluster > maxAllowableSpaceCoordinate)
            changed = 1;
        end
        clusterReduced{i}{cluster} = dataTemp;
    end
    if (changed == 1)
        clusterReduced{i} = [];
    end
end
            
%     
% I = 1;    
% for i = 1:length(clusterData)
%     cRTemp = cell(0);
%     clusterCount = 1;
%     for cluster = 1:length(clusterData{i})
%         if (ClusterReductionMethod == 1)
%             dataTemp = 0.0;
%             for j = 1:length(clusterData{i}{cluster})
%                 dataTemp = dataTemp + clusterData{i}{cluster}{j};
%             end
%             dataTemp = 1.0 / length(clusterData{i}{cluster}) * dataTemp;
%         elseif (ClusterReductionMethod == 2)
%             dataTemp = clusterData{i}{cluster}{1};
%         elseif (ClusterReductionMethod == 3)
%             dataTemp = clusterData{i}{cluster}{length(clusterData{i}{cluster})};
%         end
%         spaceCluster = dataTemp(spaceIndex);
%         if (spaceCluster <= maxAllowableSpaceCoordinate)
%             cRTemp{clusterCount} = dataTemp;
%             clusterCount = clusterCount + 1;
%         end
%     end
%     if (length(cRTemp) == 0)
%         continue;
%     end
%     if (I == 1)
%         clusterReduced{I} = cRTemp;
%         I = I + 1;
%     else
%         similarPattern = 1;
%         len = length(cRTemp);
%         if (len ~= length(clusterReduced{I - 1}))
%             similarPattern = 0;
%         else
%             for j = 1:len
%                 delS = cRTemp{j}(spaceIndex) - clusterReduced{I - 1}{j}(spaceIndex);
%                 delT = cRTemp{j}(timeIndex) - clusterReduced{I - 1}{j}(timeIndex);
%                 dSdT = computeRatioTwoSided(delS, delT, 10^10, 1);
%                 if (abs(dSdT) > spaceDotTol)
%                     similarPattern = 0;
%                     break;
%                 end
%             end
%         end
%         if (similarPattern == 1)
%             clusterReduced{I} = cRTemp;
%             I = I + 1;
%         end
%     end
% end