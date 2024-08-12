function minx = minFinite(x)

ind = find(isfinite(x));
if (length(ind) > 0)
    minx = min(x());
else
    minx = NaN;
end
