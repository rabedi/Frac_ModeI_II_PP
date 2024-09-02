function annotation_property_line
dat = rand(50,1);
hLine = plot(dat);
plotMean % Nested function draws a line at mean value
set(get(get(hLine,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','off'); % Exclude line from legend
legend('mean')
    function plotMean
    xlimits = get(gca,'XLim');
    meanValue = mean(dat);
    meanLine = line([xlimits(1) xlimits(2)],...
		 [meanValue meanValue],'Color','k','LineStyle','-.');
    end
end