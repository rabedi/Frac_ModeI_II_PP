function    [lineHandle, symbolOut, numOut, lineWidthOut] = ...
    prepareLineSymbolsForLegend(figureHandle, location, box, num, symbol, lineColor, lineStyle, ...
    markerStyle, markerSize, markerEdgeColor, markerFaceColor, pltfs, symfs, xminT, yminT , lineWidth)
%figureHandle, location, box, num
%, symbol, lineColor, lineStyle, markerStyle
%, markerSize, markerEdgeColor%, %markerFaceColor, lineWidth



global dlwidth;
global dhhlwidth;
global dhdlwidth;
global dLlwidth;

if (nargin < 7)
    for i = 1:num
        lineStyle{i} = '-';
    end
end

if (nargin < 8)
    for i = 1:num
        markerStyle{i} = 'none';
    end
end


if (nargin < 9)
    for i = 1:num
        markerSize{i} = get(0,'DefaultLineMarkerSize');
    end
end


if (nargin < 10)
    for i = 1:num
        markerEdgeColor{i} = get(0,'DefaultLineMarkerEdgeColor');
    end
end


if (nargin < 11)
    for i = 1:num
        markerFaceColor{i} = get(0,'DefaultLineMarkerFaceColor');
    end
end


if (nargin < 12)
    pltfs = 12;
end

if (nargin < 13)
    symfs = 12;
end

if (nargin < 14)
    xminT = 1;
end

if (nargin < 15)
    yminT = 1;
end



if (num == 0)
    return;
end


if ((nargin < 16) || (length(lineWidth) == 0))
    for i = 1:num
        if (strcmp(lineStyle{i},'-') == 1)
            lineWidth{i} = dlwidth;
        elseif (strcmp(lineStyle{i},'--') == 1)
            lineWidth{i} = dhhlwidth;
        elseif (strcmp(lineStyle{i},'-.') == 1)
            lineWidth{i} = dhdlwidth;
        elseif (strcmp(lineStyle{i},':') == 1)
            lineWidth{i} = dLlwidth;
        else
            lineWidth{i} = dlwidth;
        end
    end

%        lineWidth{i} = get(0,'DefaultLineLineWidth');
end


for i = 1:num
    lineWidthOut{i} = lineWidth{i};
end

set(gca,'FontSize',pltfs);
if (xminT == 1)
    set(gca,'XMinorTick','on');
end
if (yminT == 1)
    set(gca,'YMinorTick','on');
end


%figTemp = figure(12345);
figure(figureHandle);
numOut = 0;
for i = 1:num
    if (strcmp(symbol{i} ,'none') == 0)
%    if ((i > 1) && (strcmp(symbol{i} ,'none') == 0))
         numOut = numOut + 1;
         symbolOut{numOut} = symbol{i};
%         lcol = lineColor{i}
%         lsty = lineStyle{i}
%         lw = lineWidth{i}
%         mrk = markerStyle{i}
%         mrksz = markerSize{i}
%         mrkredclr = markerEdgeColor{i}
%         mrkrfclr = markerFaceColor{i}
        lineHandle(numOut) = line(111110, 111110,'Color',lineColor{i},'LineStyle',lineStyle{i},'LineWidth',lineWidth{i},...
            'Marker',markerStyle{i},'MarkerSize',markerSize{i},'MarkerEdgeColor',markerEdgeColor{i},'MarkerFaceColor',...
            markerFaceColor{i},'Visible','off');
    end
end

%if (drawLegend == 1)
 %   figure(figureHandle);
 %   legend('wqeqweqweqweqweqweqweqwe');
    
    leg = legend(lineHandle, symbolOut,'Location',location,'FontSize', symfs);
    if (strcmp(location, 'NorthWest') ~= 0)
        pos = get(leg, 'Position');
        pos = [0.12, 0.98 - pos(4), pos(3), pos(4)];
%        pos = [0.12, 0.95 - pos(4), pos(3), pos(4)];
        set(leg, 'Position', pos);
    end
    legend(box);
%end

%delete(figTemp);
 