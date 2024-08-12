
function [timeDraw, timePrint, timeTot] = compareDifferentPlotMethods(nstart, nend,linespec)
n = nstart;
counter = 1;
while n <= nend
    x1 = rand(1, n);
    y1 = rand(1, n);
    x2 = rand(1, n);
    y2 = rand(1, n);
    for option = 0:0
%        option
        [timeDraw(counter, option + 2), timePrint(counter, option + 2), timeTot(counter, option + 2)] = plotLineSegments(x1,y1, x2, y2,linespec,option);
        timeDraw(counter, 1) = n;
        timePrint(counter, 1) = n;
        timeTot(counter, 1) = n;
    end
n = n * 10;
counter = counter + 1;
format long;

save timeDraw.txt timeDraw -ascii
save timePrint.txt timePrint -ascii
save timeTot.txt timeTot -ascii
end