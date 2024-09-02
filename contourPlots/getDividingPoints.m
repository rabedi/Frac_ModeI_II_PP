function [points, pointsLegend, includeLastPointInLegend] = ...
    getDividingPoints(xmin, xmax, maxNumDivisions, includeStartPoint, includeEndPoint, basePoint, filledContour, tolAtMinMax)
% subdivides a given interval to maxNumDivisions with n * 10^m interval
% length
tol = 1e-15;
valZ = max(max(abs(xmin), abs(xmax)), 1.0)
if (abs(xmax - xmin) < 1e-15 * valZ)
    maxNumDivisions = 1;
    zMinT = xmin;
    zMaxT = xmax;
    xmin = zMinT - 1e-3 * valZ;
    xmax = zMaxT + 1e-3 * valZ;
end



if nargin < 4
    includeStartPoint = 0;
end

if nargin < 5
    includeEndPoint = 0;
end

if nargin < 6
    basePoint = inf;
end

if nargin < 7
    filledContour = 0;
end

if nargin < 8
    tolAtMinMax = 0.03;
end

delx = xmax - xmin;
tmp_spacing = delx / maxNumDivisions;
if (tmp_spacing == 0)
    points = xmin * ones(1,1);
    pointsLegend = xmin * ones(1,1);
    includeLastPointInLegend = 0;
    return;
end

% includeStartPoint = 0;
% includeEndPoint = 0;

baseVal = power(10, floor(log10(tmp_spacing)));
n = ceil (tmp_spacing / baseVal);
spacing = n * baseVal;

if (basePoint ~= inf)
    if (includeStartPoint == 1)
        l = ceil((basePoint - xmin) / spacing);
    else
        l = floor((basePoint - xmin) / spacing);
    end
    start = basePoint - l * spacing;
else
    if (includeStartPoint == 1)
        l = floor(xmin / spacing + tol);
    else
        l = ceil(xmin / spacing);
    end
    start = l * spacing;
end

if (includeEndPoint == 1)
    num = ceil((xmax - start) / spacing);
else
    num = floor((xmax - start) / spacing + tol);
end

points = zeros(num + 1, 1);
for i = 1:num + 1
    points(i) = (i - 1) * spacing + start;
end

pointsLegend = points;

tolAtMinMaxAbs = tolAtMinMax * spacing;

includeLastPointInLegend = 1;
if ((filledContour == 1) && (abs(xmax - points(num + 1)) < tolAtMinMaxAbs))
    includeLastPointInLegend = 0;
    points(num + 1) = xmax - tolAtMinMaxAbs;
end



if ( ((points(1) - xmin) <= tolAtMinMaxAbs) && (points(1) >= xmin) && (includeStartPoint == 1))
    points(1) = xmin - tolAtMinMaxAbs;
end

if ( ((xmax - points(num + 1)) <= tolAtMinMaxAbs) && (points(num + 1) <= xmax) && (includeEndPoint == 1))
    points(num + 1) = xmax + tolAtMinMaxAbs;
end


