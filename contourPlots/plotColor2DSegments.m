function plotColor2DSegments(fldData, fldSizes, zCol, lim, colormapInput)

if nargin < 4
    lim = [-inf inf];
end

if (nargin < 5)
    colormap('default');
    colormapInput = colormap;
end


x = fldData(:, 1);
y = fldData(:, 2);
z = fldData(:, zCol);
zmin = min(z);
zmax = max(z);

cmin = max(zmin, lim(1));
cmax = min(zmax, lim(2));

[m, n] = size(colormapInput);
%caxis([cmin cmax]);
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

cntr = 1;
numSegments = length(fldSizes);
for s =1:numSegments
    segSz = fldSizes(s);
    colr = colormapInput(zind(cntr), :);
    hold on;
%    plot(x(cntr:cntr + segSz - 1), y(cntr:cntr + segSz - 1), 'Color', 'r');
    plot(x(cntr:cntr + segSz - 1), y(cntr:cntr + segSz - 1), 'Color', colr);
    cntr = cntr + segSz;
end

