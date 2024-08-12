function [minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, counter, average, sums, sDiviation] = getStatisticForData(times, data)

[numPoints, numFlds] = size(data);

sums = sum(data, 1);
average = sums / numPoints;
sDiviation = std(data, 1, 1);
min_eID = zeros(1, numFlds);
min_id = zeros(1, numFlds);
[minV, minVind] = min(data);
minCoord = [zeros(numFlds, 2) times(minVind)];

[maxV, maxVind] = max(data);
maxCoord = [zeros(numFlds, 2) times(maxVind)];
max_eID = zeros(1, numFlds);
max_id = zeros(1, numFlds);
counter = numPoints * ones(1, numFlds);



