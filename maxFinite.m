function maxx = maxFinite(x)

ind = find(isfinite(x));
if (length(ind) > 0)
    maxx = max(x());
else
    maxx = NaN;
end