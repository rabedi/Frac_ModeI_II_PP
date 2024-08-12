function plotSolutionBlock(xcol, ycol, linesp, data, numpts, drawPoints)


if (numpts ~= 2)
    return;
end

%if (ycol == 14)
%    ycol = 36;
%end

ycolR = ycol;
if (ycol == 13)
    ycolR = 35;
end

Y = data(:,ycolR);
if ((xcol == 9) && (ycol >= 10) && (ycol <= 13))
    Y = 1.066098 * Y ;   %1 / 0.938 
end


plot(data(:,xcol), Y, linesp);
%line(data(:,xcol), Y);

if (drawPoints == 1)
%    if (data(1,3) == 0)
    if ((data(1,3) == 0) && (xcol == 1) && (ycolR == 32))
    plot(data(1,xcol), data(1,ycolR), 'x');
    end    
end
hold on;
