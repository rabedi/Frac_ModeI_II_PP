function z = interpolate2D(x, y, xmin, xmax, ymin, ymax, option)

% [z_, zx_, zy_, teta] = testFunction(x, y);
% if (option == 2)
%     z = cos(teta);
% elseif (option == 3)
%     z = sin(teta);
% elseif (option == 4)
%     z = tan(teta);
% end
% return;

if (nargin < 7)
    option = 1;
end
global Zint;
global Zcos;
global Zsin;
global Ztan;

if (option == 1)
    [ysiz, xsiz] = size(Zint);
elseif (option == 2)
    [ysiz, xsiz] = size(Zcos);
elseif (option == 3)
    [ysiz, xsiz] = size(Zsin);
elseif (option == 4)
    [ysiz, xsiz] = size(Ztan);
else
    fprintf(1, 'unkown option');
end

sizX = xmax - xmin;
sizY = ymax - ymin;
delx = sizX / (xsiz - 1);
dely = sizY / (ysiz - 1);

indix = (x - xmin) / delx;
nx = floor(indix) + 1;
ax = indix - nx + 1;


indiy = (y - ymin) / dely;
ny = floor(indiy) + 1;
ay = indiy - ny + 1;


if (nx <= 0)
    nx = 1;
    ax = 0;
end

if (ny <= 0)
    ny = 1;
    ay = 0;
end

if (option == 1)
    z00 = Zint(ny, nx);
    z01 = z00;
    z11 = z00;
    z10 = z00;
    if (nx ~= xsiz)
        z10 = Zint(ny, nx + 1);
    end
    if (ny ~= ysiz)
        z01 = Zint(ny + 1, nx);
    end
    if ((nx ~= xsiz) && (ny ~= ysiz))
        z11 = Zint(ny + 1, nx + 1);
    end
elseif (option == 2)
    z00 = Zcos(ny, nx);
    z01 = z00;
    z11 = z00;
    z10 = z00;
    if (nx ~= xsiz)
        z10 = Zcos(ny, nx + 1);
    end
    if (ny ~= ysiz)
        z01 = Zcos(ny + 1, nx);
    end
    if ((nx ~= xsiz) && (ny ~= ysiz))
        z11 = Zcos(ny + 1, nx + 1);
    end
elseif (option == 3)
    z00 = Zsin(ny, nx);
    z01 = z00;
    z11 = z00;
    z10 = z00;
    if (nx ~= xsiz)
        z10 = Zsin(ny, nx + 1);
    end
    if (ny ~= ysiz)
        z01 = Zsin(ny + 1, nx);
    end
    if ((nx ~= xsiz) && (ny ~= ysiz))
        z11 = Zsin(ny + 1, nx + 1);
    end
elseif (option == 4)
    z00 = Ztan(ny, nx);
    z01 = z00;
    z11 = z00;
    z10 = z00;
    if (nx ~= xsiz)
        z10 = Ztan(ny, nx + 1);
    end
    if (ny ~= ysiz)
        z01 = Ztan(ny + 1, nx);
    end
    if ((nx ~= xsiz) && (ny ~= ysiz))
        z11 = Ztan(ny + 1, nx + 1);
    end
else
    fprintf(1, 'unkown option');
end

    


z = (z00 * (1 - ax) + z10 * ax) * (1 - ay) + ...
    (z01 * (1 - ax) + z11 * ax) * ay;

