function COLORBAR(cbarHandle,title,limitSchemeObj,axHandle,loc)
    %========================================================
    %Exceptions
    if nargin < 5
        loc = 'westoutside';
    end
    
    if nargin < 4
        axHandle = gca();
    end
    
    if nargin < 3
       %THROW('ERROR: Not enough input arguments') 
    end
    
    if nargin < 2
       title = '$field$';
    else
       title = ['$',title,'$']; 
    end
    
    if nargin < 1 
       cbarHandle = colorbar(axHandle); 
    end
    
    if ~ishandle(axHandle)
        %THROW('ERROR: axes handle input not a valid handle')
    end
    
    if ~ishandle(cbarHandle)
        %THROW('ERROR: colorbar handle input not a valid handle')
    end
    %========================================================
    
    pinf = limitSchemeObj.pInf;
    ninf = limitSchemeObj.nInf;
    limits = limitSchemeObj.distLevels;
    
    tickLabels = {};
    map = [];
    len = length(limits.level);
    
    tmpLevels = [];
    
    i = 1;
    while i < len + 1
        if abs(limits.level(i)) == inf
%            tickLabels{i} = ' ';
        else
            map(i,:) = RGB(limits.lClr(i));
            tickLabels{i} = ['$',num2str(limits.level(i),'%10.5e'),'$'];
            tmpLevels = [tmpLevels,limits.level(i)];
        end
        i = i + 1;
    end
    [vecSorted, sortIndex] = sort(tmpLevels);
    tmpLevels = vecSorted;
    tickLabels = tickLabels(sortIndex);
    map = map(sortIndex,:);
    %
    %
    colormap(map);
    %
    %
    %Location
    set(cbarHandle,'location',loc);
    %Font
    cbarHandle.FontSize = 5;
    cbarHandle.TickLabelInterpreter = 'latex';
    %Border box
    cbarHandle.Box = 'off';
    
    %Tick Limits set
    cbarHandle.LimitsMode = 'manual';
    cbarHandle.Limits = [min(tmpLevels),max(tmpLevels)];
    
    %Tick label set
%     cbarHandle.TickLabelsMode = 'manual';
%     cbarHandle.TickLabels = tickLabels;
%     set(cbarHandle,'YTick',tmpLevels);
%    ylabel(cbarHandle,title)
    
    %http://www.mathworks.com/help/matlab/ref/colorbar-properties.html
end