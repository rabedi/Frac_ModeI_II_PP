function [times, values, normalizers, numBaseFld] = readIntegratedRelatedFile(fid, timeStart, timeStep, normalizerOption)

tmp = fscanf(fid, '%s', 1);
numBaseFld = fscanf(fid, '%d', 1);
baseFlds = fscanf(fid, '%d', numBaseFld);
tmp = fscanf(fid, '%s', 1);
numTimes = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
numExpFlds = fscanf(fid, '%d', 1);

if (numExpFlds ~= 3 * numBaseFld)
    fprintf(1, 'problem in field sizes');
    pause;
end

normalizers = cell(numBaseFld, 1);

tmp = fscanf(fid, '%s', 1);
for fld = 1:numBaseFld
    normalizers{fld}(1,:) = fscanf(fid, '%lg', 3);
end
tmp = fscanf(fid, '%s', 1);
for fld = 1:numBaseFld
    normalizers{fld}(2,:) = fscanf(fid, '%lg', 3);
end
tmp = fscanf(fid, '%s', 1);
for fld = 1:numBaseFld
    normalizers{fld}(3,:) = fscanf(fid, '%lg', 3);
end


for fld = 1:numBaseFld
    values{fld} = zeros(numTimes, 3);
    cnormalizer{fld} = ones(1,3);
    if (normalizerOption > 0)
        cnormalizer{fld} = normalizerOption{fld}(3,:);
    end
end

times = zeros(numTimes, 1);

for i = 1:numTimes
    t = fscanf(fid, '%lg', 1);
    indx = round((t - timeStart) / timeStep) + 1;
    if (indx ~= i)
        fprintf(1, 'missing point\n');
    end
    times(indx) = t;
    for fld = 1:numBaseFld
        values{fld}(indx, :) = fscanf(fid, '%lg', 3);
        values{fld}(indx, :) = values{fld}(indx, :) ./ cnormalizer{fld};
    end
end    