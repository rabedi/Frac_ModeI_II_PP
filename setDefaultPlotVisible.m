function [FIG,AX] = setDefaultPlotVisible(str,clrStr)
    if nargin < 2
        clrStr = ' ';
    end

    out = [];
    
    if strcmp(str,'off') == 1
        %Plot visibility and handle sets...................
        set(0,'DefaultFigureVisible','off')
        set(0,'DefaultAxesVisible','off')
        %..................................................
    elseif strcmp(str,'on') == 1
        set(0,'DefaultFigureVisible','on')
        set(0,'DefaultAxesVisible','on')
    else
        THROW('Invalid visibility option:(',str,')');
    end
    
    if strcmp(clrStr,'reset') == 1
            clf;cla;close all;
            FIG = figure('Visible',str);
            AX = axes('Visible',str);
            %if (FIG ~= 1)
            %FIG = figure('Visible',str);
            %end
%            figure(FIG);

    else
            FIG = out;
            AX = out;
    end          
end