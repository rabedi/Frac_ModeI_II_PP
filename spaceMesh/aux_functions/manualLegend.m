function legendHandle = manualLegend(textIn, lWidth, lColor, lStyle, lMarker, lMarkerSz, legLocation)
addpath('../');
addpath('../../');

matlabVersion = version('-release');
pre2016b = 0;
if (str2num(matlabVersion(1:4)) < 2016) ||  (str2num(matlabVersion(1:4)) == 2016 && strcmpi(matlabVersion(end),'a') == 1)
    pre2016b = 1;
end

defaultTextSize = 24;
defaultMarkerSize = 6.0;
defaultMarker = 'none';
defaultLineWidth = 0.5;
defaultLineColor = RGB('b');
defaultLineStyle = '-';
defaultLegendText = 'series0';

if nargin < 7
    legLocation = 'southeast';
end
if nargin < 6
    lMarkerSz = {defaultMarkerSize};
end
if nargin < 5
    lMarker = {defaultMarker};
end
if nargin < 4
    lStyle = {defaultLineStyle};
end
if nargin < 3
    lColor = {defaultLineColor};
end
if nargin < 2
    lWidth = {defaultLineWidth};
end
if nargin < 1
    textIn = {defaultLegendText};
end

if isa(textIn,'cell') == 0
    textIn = mat2cell(textIn);
end
if isa(lWidth,'cell') == 0
    lWidth = mat2cell(lWidth);
end
if isa(lStyle,'cell') == 0
    lStyle = mat2cell(lStyle);
end
if isa(lColor,'cell') == 0
    lColor = mat2cell(lColor);
end
if isa(lMarker,'cell') == 0
    lMarker = mat2cell(lMarker);
end
if isa(lMarkerSz,'cell') == 0
    lMarkerSz = mat2cell(lMarkerSz);
end

lenText = length(textIn);
lenColor = length(lColor);
lenWidth = length(lWidth);
lenStyle = length(lStyle);
lenMarker = length(lMarker);
lenMarkSz = length(lMarkerSz);

if lenText ~= lenColor || lenWidth ~= lenStyle || lenText ~= lenWidth || lenMarker ~= lenMarkSz || lenMarkSz ~= lenText
   THROW('insufficient number of legend entries'); 
end

hold on;

h = zeros(lenText, 1);
htext = cell(lenText, 1);
for i = 1:lenText
    if isempty(lWidth{i})
        lWidth{i} = defaultLineWidth;
    end
    if isempty(lStyle{i})
        lStyle{i} = defaultLineStyle;
    end
    if isempty(lColor{i})
        lColor{i} = defaultLineColor;
    end
    if isempty(lMarker{i})
        lMarker{i} = defaultMarker;
    end
    if isempty(lMarkerSz{i})
        lMarkerSz{i} = defaultMarkerSize;
    end
    
    if pre2016b == 1
        h(i) = plot(0.0,0.0,'visible','off');
    else
        h(i) = plot(NaN,NaN);
    end
    
    set(h(i),...        
        'LineWidth',lWidth{i},...
        'Color',lColor{i},...
        'LineStyle',lStyle{i},...
        'Marker',lMarker{i},...
        'MarkerSize',lMarkerSz{i});
    
    if isempty(textIn{i})
       textIn{i} = defaultLegendText; 
    end
    htext{i} = textIn{i};
end

legendHandle = legend(h, htext);
set(legendHandle,'Box','off',...
    'Location',legLocation,...
    'FontSize',defaultTextSize,...
    'TextColor',RGB('k'),...
    'Interpreter','latex');
end