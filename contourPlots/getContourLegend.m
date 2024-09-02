function labl = getContourLegend(zMin, zMax, maxNumDivisions, lablIn, zBasePoint, includeStartPoint, includeEndPoint, ...
    colormapInput, showLegend, zflag, quiverColor, quiverArrowHead, addMarkerData, loc, filledContour, symfs)

valZ = max(max(abs(zMin), abs(zMax)), 1.0)
if (abs(zMax - zMin) < 1e-15 * valZ)
    maxNumDivisions = 1;
    zMinT = zMin;
    zMaxT = zMax;
    zMin = zMinT - 1e-3 * valZ;
    zMax = zMaxT + 1e-3 * valZ;
end

% includeStartPoint = 0;
% includeEndPoint = 0;
% filledContour = 0;


if nargin < 3
    maxNumDivisions = 10;
end

if nargin < 4
    lablIn = [];
end


if nargin < 5
    zBasePoint = inf;
end

if nargin < 6
    includeStartPoint = 0;
end

if nargin < 7
    includeEndPoint = 0;
end

if nargin < 8
    colormap('default');
    colormapInput = colormap;
end

if nargin < 9
    showLegend = 1;
end

if nargin < 10
    zflag = 1;
end



if nargin < 11
    quiverColor = 'k';
end
    
if nargin < 12
    quiverArrowHead = 'off';
end

labl = lablIn;
cntrStart = length(labl) + 1;



zflag = abs(zflag);
zflag = mod(zflag, 100);
zflagQuiver = floor(zflag / 10);
zflagContour = zflag - 10 * zflagQuiver;

if (zflagQuiver ~= 0)
%    quiver([inf],[inf],[inf], [inf], 'Color',quiverColor,'Visible','off', 'ShowArrowHead', quiverArrowHead);
    hold on; 
    plot([inf],[inf], 'Color',quiverColor,'Visible','off');
    hold on; 
    labl{cntrStart} = 'direction';
    cntrStart = cntrStart + 1;
end

if (zflagContour == 1)

    [points, pointsLegend, includeLastPointInLegend] = getDividingPoints(zMin, zMax, maxNumDivisions, includeStartPoint, includeEndPoint, zBasePoint, filledContour);
    len = length(points);
    minV = points(1)
    maxV = points(len)
    caxis([minV maxV]);
    [cmin cmax] = caxis;
    [m, n] = size(colormapInput);
    for j = 1:len
        v = points(j);
        if (v <= cmin)
            index = 1;
        elseif (v >= cmax)
            index = m;
        else
            index = fix((v-cmin)/(cmax-cmin)*m)+1;
        end

        clr = colormapInput(index,:);
        doPlot = 1;
        if (filledContour == 0)
            labl{cntrStart} = num2str(pointsLegend(j));
        else
            if (j < len)
                labl{cntrStart} = [num2str(pointsLegend(j)),' - ', num2str(pointsLegend(j + 1))];
            else
                if (includeLastPointInLegend == 1)
                    labl{cntrStart} = ['> ', num2str(pointsLegend(j))];
                else
                    doPlot = 0;
                end
            end
        end
        if (doPlot == 1)
            plot([inf],[inf],'Color',clr,'Visible','off');
            hold on;
            cntrStart = cntrStart + 1;
        end
    end
end

if (addMarkerData ~= 0)
    labl = getContourMarkerLegend(labl, 0);
end



symfs = computeSymbolFS(symfs, labl);
if (showLegend == 1)
%    legend(labl, 'Location', loc, 'FontSize', symfs);

    leg = legend(labl, 'Location', loc);
    if (strcmp(loc, 'NorthWest') ~= 0)
        pos = get(leg, 'Position');
        pos = [0.12, 0.95 - pos(4), pos(3), pos(4)];
        set(leg, 'Position', pos);
    end
end

% cla;
%hold on;
%[mCt,hCt] = contour(x, x, zz, points);
