function changeAxisLabel(axisno, fhandle)
if (axisno == 1)

    ticklabel = get(gca,'XTickLabel');
    for i = 1:length(ticklabel)
        ticklabelnew{i} = fhandle(str2num(ticklabel(i,:)));
    end
    set(gca,'XTickLabel',ticklabelnew);

elseif (axisno == 2)

    ticklabel = get(gca,'YTickLabel');
    for i = 1:length(ticklabel)
        ticklabelnew{i} = fhandle(str2num(ticklabel(i,:)));
    end
    set(gca,'YTickLabel',ticklabelnew);
end