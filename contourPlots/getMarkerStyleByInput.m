function style = getMarkerStyleByInput(inp)
global gMarkerStyle;
global gMarkerStyleName;

num = str2num(inp);
if (length(num) > 0)
    style = gMarkerStyle{num};
else
    style = inp;
end
