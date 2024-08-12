function [startP, endP, step] = subdivide(point1, point2, num, expandFactor, option)

if (nargin < 4)
    expandFactor(1) = 0.0;
    expandFactor(2) = 1.0;
end


if (nargin < 5)
    option = 1;
end

if (num == 0)
    option = 1;
end

dist = point2 - point1;
startP = dist * expandFactor(1) + point1;
endP = dist * expandFactor(2) + point1;
if (dist == 0)
    if (abs(startP) > 1e-15)
        absV = abs(startP) / 2;
        startP = startP - absV;
        endP = endP + absV;
    else
        startP = 0;
        endP = 1;
    end
end
step = num;
if (option == 1)
    return
end

d = (endP - startP) / num;
if ((d == 0) || (num == 0))
    endP = endP + 1;
    step = 1;
    return;
end
    
logd = log10(d);
d1 = floor(logd);
d2 = logd - d1;
step = floor(10^d2) * 10^d1;
startP = floor(startP / step) * step;
endP = ceil(endP / step) * step;
