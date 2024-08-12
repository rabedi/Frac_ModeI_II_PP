function clr = readClr(fid)
tmp = fscanf(fid, '%s', 1);
if (strcmp(tmp, 'sym') == 1)
    clr = fscanf(fid, '%s', 1);
elseif (strcmp(tmp, 'val') == 1)
    tmp = fscanf(fid, '%lg', 3);
    clr = tmp';
elseif (strcmp(tmp, 'num') == 1)
    num = fscanf(fid, '%d', 1);
    [colorCode, colorName] = getColorMap();
    clr = colorCode{num};
else
    printf(1, 'invalid option %s!\n', tmp);
    pause;
end
