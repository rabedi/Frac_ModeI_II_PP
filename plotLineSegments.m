function plotLineSegments(x1,y1, x2, y2,lineColor, lineStyle, lineMarker)
%[timeDraw, timePlot, timeTot] = , option
%tic;
%m = length(x1);
%switch option
%    case 0

global dlwidth;
global dLlwidth;

    u = x2 - x1;
    v = y2 - y1;


linWidth = dlwidth;
if (lineStyle == ':')
    linWidth = dLlwidth;
end   
    
    
    quiver(x1,y1,u,v,0,'ShowArrowHead','off','Color',lineColor, 'LineStyle',lineStyle, 'Marker',lineMarker,'LineWidth', linWidth);
%     case 1
%     for i = 1:m
%         X = [x1(i) x2(i)];
%         Y = [y1(i) y2(i)];
%         plot(X,Y,'Color',lineColor, 'LineStyle',lineStyle, 'Marker',lineMarker);
%         hold on;
%     end
%     case 2
%     for i = 1:m
%         X = [x1(i) x2(i)];
%         Y = [y1(i) y2(i)];
%         line(X,Y,'Color',lineColor, 'LineStyle',lineStyle, 'Marker',lineMarker);
% %       line(X,Y);
%         hold on;
%     end
% end
%timeDraw = toc;
%FigureName = ['plot',num2str(m),'__',num2str(option),'.pdf'];
%print('-dpdf',FigureName);
%delete(gca);
%delete(gcf);
%timeTot = toc;
%timePlot = timeTot - timeDraw;
