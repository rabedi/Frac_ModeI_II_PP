function [getNewPoint, x, xvalsNew] = getNewPointInInterval(xmin, xmax, delx, xvals)

tol = 1e-7;
Delx = (1 + tol) * delx;
xsize = xmax - xmin;

xvals = sort(xvals);
siz = length(xvals);
if (siz == 0)
    x = xmin;
    xvalsNew = [xmin];
    getNewPoint = 1;
    return;
end

if (abs(xvals(1)  - xmin) > xsize * tol)
    x = xmin;
    xvalsNew = xvals;
    xvalsNew(siz + 1) = x;
    xvalsNew = sort(xvalsNew);
    getNewPoint = 1;
    return;
end



for i = 1:(siz - 1)
    diff = xvals(i + 1) - xvals(i);
    if (diff > Delx)
        if (diff > 2 * delx)
            x = xvals(i) + delx;
        else
            x = 0.5 * (xvals(i) + xvals(i + 1));
        end
        xvalsNew = xvals;
        xvalsNew(siz + 1) = x;
        xvalsNew = sort(xvalsNew);
        getNewPoint = 1;
        return;
    end
end


diff = xmax - xvals(siz);

if (diff > Delx)
    if (diff > 2 * delx)
        x = xvals(siz) + delx;
    else
        x = 0.5 * (xvals(siz) + xmax);
    end
    xvalsNew = xvals;
    xvalsNew(siz + 1) = x;
    xvalsNew = sort(xvalsNew);
    getNewPoint = 1;
    return;
elseif (diff > tol * delx)
    x = xmax;
    xvalsNew = xvals;
    xvalsNew(siz + 1) = x;
    xvalsNew = sort(xvalsNew);
    getNewPoint = 1;
    return;
else
    xvalsNew  = xvals;
    x = xmax;
    getNewPoint = 0;
    return;
end

