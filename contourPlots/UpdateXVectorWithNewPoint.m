function xvalsNew = UpdateXVectorWithNewPoint(x, xmin, xmax, xvals)

if ((x >= xmin) && (x <= xmax))
    xvals(length(xvals) + 1) = x;
    xvalsNew = sort(xvals);
    return;
end

xvalsNew = xvals;
