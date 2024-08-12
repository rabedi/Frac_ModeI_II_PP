function str = gen_fromFile_vecString(fidi)
buf = fscanf(fidi, '%s', 1);
if (strcmp(buf, 'null') == 1)
    str = cell(0);
    return;
end
if (strcmp(buf, '[') == 0)
    str = buf;
    return;
end
buf = fscanf(fidi, '%s', 1);
m = fscanf(fidi, '%d', 1);
buf = fscanf(fidi, '%s', 1);
str = cell(m, 1);
for i = 1:m
    str{i} = fscanf(fidi, '%s', 1);
end
buf = fscanf(fidi, '%s', 1);
