function plotColor2D(x, y, z, lim, colormapInput)

if nargin < 4
    lim = [-inf inf];
end

if (nargin < 5)
    colormap('default');
    colormapInput = colormap;
end


zmin = min(z);
zmax = max(z);

cmin = max(zmin, lim(1));
cmax = min(zmax, lim(2));

[m, n] = size(colormapInput);
caxis([cmin cmax]);
num = length(x);

zind = zeros(1, num);
for cntr = 1:num
    if (z(cntr) <= cmin)
        index = 1;
    elseif (z(cntr) >= cmax)
        index = m;
    else
        index = fix((z(cntr) - cmin)/(cmax - cmin)* m)+1;
    end
    zind(cntr) = index;
end


[breakPoints, values] =  getBreakPointsAndValues(zind);
numIntervals = length(values);

for interv = 1:numIntervals
   colr = colormapInput(values(interv),:);
   hold on;
   plot(x(breakPoints(interv:interv + 1)), y(breakPoints(interv:interv + 1)), 'Color', colr);
end