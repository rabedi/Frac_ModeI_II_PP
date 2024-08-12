function printReducedClusterData(fid, reducedCluster, colNprintInt, data)

if (nargin < 4)
    data = [];
end

siz = length(reducedCluster);
[m_, n_] = size(data);


if ((nargin < 4) || (m_ == 0))
    for i = 1:siz
        if (length(reducedCluster{i}) == 0)
            continue;
        end
        for j = 1:length(reducedCluster{i})
            fprintf(fid, '1\t');
            for k = 1:length(reducedCluster{i}{j})
                if (length(find(colNprintInt == k)) ~= 0)
                    reducedCluster{i}{j}(k) = floor(reducedCluster{i}{j}(k) + 0.5);
                    fprintf(fid, '%d\t', reducedCluster{i}{j}(k));
                else
                    fprintf(fid, '%25.20g\t', reducedCluster{i}{j}(k));
                end
            end
            fprintf(fid, '\n');
        end
    end
else
    cntr = 1;
    for i = 1:siz
        if (length(reducedCluster{i}) == 0)
            continue;
        end
        for j = 1:length(reducedCluster{i})
            fprintf(fid, '1\t');
            for k = 1:length(reducedCluster{i}{j})
                if (length(find(colNprintInt == k)) ~= 0)
                    reducedCluster{i}{j}(k) = floor(reducedCluster{i}{j}(k) + 0.5);
                    fprintf(fid, '%d\t', reducedCluster{i}{j}(k));
                else
                    fprintf(fid, '%25.20g\t', reducedCluster{i}{j}(k));
                end
            end
            for ind = 1:n_
                fprintf(fid, '%25.20g\t', data(cntr, ind));
            end
            cntr = cntr + 1;
            fprintf(fid, '\n');
        end
    end
end