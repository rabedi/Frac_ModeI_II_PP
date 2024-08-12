function data = InquireReducedClusterDataSpecificValues(reducedCluster, colNprintInt, askedColumns)

numInd = length(askedColumns);
cntr = 1;
siz = length(reducedCluster);
for i = 1:siz
    if (length(reducedCluster{i}) == 0)
        continue;
    end
    for j = 1:length(reducedCluster{i})
        for m = 1:numInd
            ind = askedColumns(m);
            data(cntr, m) = reducedCluster{i}{j}(ind);
        end
        cntr = cntr + 1;
    end
end


% siz = length(reducedCluster);
% for i = 1:siz
%     if (length(reducedCluster{i}) == 0)
%         continue;
%     end
%     for j = 1:length(reducedCluster{i})
%         fprintf(fid, '1\t');
%         for k = 1:length(reducedCluster{i}{j})
%             if (length(find(colNprintInt == k)) ~= 0)
%                 reducedCluster{i}{j}(k) = floor(reducedCluster{i}{j}(k) + 0.5);
%                 fprintf(fid, '%d\t', reducedCluster{i}{j}(k));
%             else
%                 fprintf(fid, '%25.20g\t', reducedCluster{i}{j}(k));
%             end
%         end
%         fprintf(fid, '\n');
%     end
% end
