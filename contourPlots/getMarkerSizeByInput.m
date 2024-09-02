function msize = getMarkerSizeByInput(inp)
global gMarkerSize;

if (inp > 0)
    msize = inp;
else
    msize = gMarkerSize{-inp};
end
