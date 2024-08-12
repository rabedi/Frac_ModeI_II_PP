function strVal = gen_ReadWEnclosing(fid, ch)

strVal = [];
chn = 'z';
while (chn ~= ch)
    chn = fscanf(fid, '%c', 1);
end

chn = fscanf(fid, '%c', 1);
while (chn ~= ch)
    strVal = [strVal, chn];
    chn = fscanf(fid, '%c', 1);
end