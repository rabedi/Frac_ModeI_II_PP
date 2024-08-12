function [vec, size] = readStartingPoints(fid)
firstRead = fscanf(fid, '%s', 1);
numVal = str2num(firstRead);
if (length(numVal) == 0)
    numPrimFlds = fscanf(fid, '%d', 1);
    temp = fscanf(fid, '%s', 1);
    numExtFlds = fscanf(fid, '%d', 1);
    temp = fscanf(fid, '%s', 1);
    numIndIntFlds = fscanf(fid, '%d', 1);
    oldFormat = 0;
    
    if (strcmp(firstRead, 'numPrimFlds1') == 1)
        tmp = fscanf(fid, '%s', 1);
        vec(33) = fscanf(fid, '%d', 1);
        tmp = fscanf(fid, '%s', 1);
        vec(34) = fscanf(fid, '%d', 1);
        tmp = fscanf(fid, '%s', 1);
        vec(35) = fscanf(fid, '%d', 1);
    end
    size = fscanf(fid,'%d',1);
    
else
    size = numVal;
    oldFormal = 1;
end
for i = 1:size
    vec(i) = fscanf(fid,'%d',1);
end


if (oldFormat == 1)
    numExtFlds = 4;
    numPrimFlds = (vec(12) - vec(11) - numExtFlds) / 3;
    numIndIntFlds = 2;
end

if (size >= 30)
    fprintf(1, 'adjustment needed to the function\n');
end

vec(30) = numPrimFlds;
vec(31) = numExtFlds;
vec(32) = numIndIntFlds;
