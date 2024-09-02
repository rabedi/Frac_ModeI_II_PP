function colr = getColorByInput(inp)
global gColor;
global gLinename;

num = str2num(inp);
if (length(num) > 0)
    colr = gColor{num};
else
    colr = inp;
end
