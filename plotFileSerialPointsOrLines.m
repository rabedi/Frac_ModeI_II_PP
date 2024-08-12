function [lastIndex , lastIndexPoints, xmin, xmax, ymin, ymax] = plotFileSerialPointsOrLines(xminReq, xmaxReq, yminReq, ymaxReq, ...
    fileNo, curveNo, xcol, ycol, dataSize, ...
    startingPts, lineColor, lineStyle, lineMarker, col, drawLineSegmentes, xMaxDist, yMaxDist, flagCol, pointFlags, pointMaker, ...
    pointMarkerColor, pointMarkerSize, pointDataSize, directory, runname, middlename, flagnum, serial, name, ext, drawLines, ...
    numberOfSegments, drawPoints, numberOfPoints, xminIn, xmaxIn, yminIn, ymaxIn, doXMinMax, doYMinMax, onlyDrawSize2SolUnit)

 %drawPoints
lastIndexPoints = cell(0, 0);
global allowBinary;

global dlwidth;
global dhhlwidth;
global dhdlwidth;
global dLlwidth;


global cnfg;
global IplotAroundProcessZoneFactor;

updatePZendPts = (cnfg{IplotAroundProcessZoneFactor} > 0);

%  fileNo
%  curveNo
%  xcol
%  ycol
%  dataSize
%  lineColor
%  lineStyle
%  lineMarker
%  col
%  drawLineSegmentes
%  xMaxDist
%  yMaxDist
%  flagCol
%  pointFlags
%  pointFlags{1}{1}
%  pointFlags{1}{2}
%  pointMaker{1}{1}
%  pointMaker{1}{2}
%  pointMarkerColor{1}{1}
%  pointMarkerColor{1}{2}
%  pointMarkerSize{1}{1}
%  pointMarkerSize{1}{2}
%  pointDataSize
%  directory
%  runname
%  middlename
%  flagnum
%  serial
%  name
%  ext
%  drawLines
%  numberOfSegments
%  drawPoints
%  numberOfPoints
if (nargin < 27)
    drawLines = 1;
end

if (nargin < 28)
    numberOfSegments = -1;
end


if (nargin < 29)
    drawPoints = 1;
end

if (nargin < 30)
    numberOfPoints = -1;
end

if (nargin < 31)
    xminIn = inf;
end

if (nargin < 32)
    xmaxIn = -inf;
end


if (nargin < 33)
    yminIn = inf;
end


if (nargin < 34)
    ymaxIn = -inf;
end

if (nargin < 35)
    doXMinMax = 0;
end

if (nargin < 36)
    doYMinMax = 0;
end

if (nargin < 37)
    onlyDrawSize2SolUnit = 1;
end


 offValuel = 1234567890;
%if (doXMinMax == 1)
    xmin = xminIn;
    xmax = xmaxIn;
%end


%if (doYMinMax == 1)
    ymin = yminIn;
    ymax = ymaxIn;
%end

if (serial < 0)
    serial = -2;
end

if (allowBinary == 0) 
    ext = 'txt';
end

filename = getFileName(directory, runname, middlename, flagnum, name, serial, ext);
fid = fopen(filename, 'r');
if (fid < 0)
    if (strcmp(ext, 'txt') == 1)
        ext = 'bin';
    else
        ext = 'txt';
    end
    filename = getFileName(directory, runname, middlename, flagnum, name, serial, ext);
    fid = fopen(filename, 'r');
    if (fid < 0)
        fprintf(1, 'cannot print file %s with bin or txt extension\n', filename);
        pause;
    end
end    
len = length(xcol);

counterLines = 0;
counterPoints = 0;
numberOfSegmentsIn = numberOfSegments;
numberOfPointsIn = numberOfPoints;

if ((numberOfSegments < 0) || (drawLines == 0))
    numberOfSegmentsIn = 1;
end


if ((numberOfPoints < 0) || (drawPoints == 0))
    numberOfPointsIn = 1;
end

for i = 1:len
    x1{i} = zeros(1,dataSize(i));
    x2{i} = zeros(1,dataSize(i));
    y1{i} = zeros(1,dataSize(i));
    y2{i} = zeros(1,dataSize(i));
    lastIndex(i) = 1;
    previousx(i) = 1e150;
    previousy(i) = 1e150;
    previousDrawn(i) = 1;


    pointSize{i} = length(pointFlags{i});
    for j = 1:pointSize{i}
        pointsX{i}{j} = zeros(1,pointDataSize(i));
        pointsY{i}{j} = zeros(1,pointDataSize(i));
        lastIndexPoints{i}{j} = 1;
    end
end

AsciiFormat = strcmp(ext, 'txt');


while ((fid ~= -1) && (serial ~= -1) && (counterLines < numberOfSegmentsIn) && (counterPoints < numberOfPointsIn))
    [noteof, numpts, data] = readBlock(fid, col,AsciiFormat,  startingPts, updatePZendPts);
    while ((noteof ~= 0)  && (counterLines < numberOfSegmentsIn) && (counterPoints < numberOfPointsIn))
        
        [xval, yval, cont] = operateOnDatamatrixForXYvals(len, xcol, ycol, data, fileNo, curveNo, offValuel);
        if (cont == 0)
            [noteof, numpts, data] = readBlock(fid, col, AsciiFormat,  startingPts, updatePZendPts);
            continue;
        end
        
        if (drawLines == 1)
            lineIncrement = 0;
            if (drawLineSegmentes == 1)
                    switch numpts
                        case 2
                            for i = 1:len
                                x1{i}(lastIndex(i)) = xval{i}(1);
                                x2{i}(lastIndex(i)) = xval{i}(2);
                                y1{i}(lastIndex(i)) = yval{i}(1);
                                y2{i}(lastIndex(i)) = yval{i}(2);
                                lastIndex(i) = lastIndex(i) + 1;
                                lineIncrement = 1;
                            end
                        case 1
                            if (onlyDrawSize2SolUnit == 0)
                                for i = 1:len
        %                             i
        %                            
        %                             xval
        %                             yval
        %                             previousx
        %                             previousy
        %                             xMaxDist
        %                             yMaxDist 
        %                             xval{i}
        %                             yval{i}
        %                             previousx(i)
        %                             previousy(i)
        %                             xMaxDist(i)
        %                             yMaxDist(i)
                                    
                                    if ((abs(xval{i}(1) - previousx(i)) < xMaxDist(i)) && (abs(yval{i}(1) - previousy(i)) < yMaxDist(i)))
                                        x1{i}(lastIndex(i)) = previousx(i);
                                        x2{i}(lastIndex(i)) = xval{i}(1);
                                        y1{i}(lastIndex(i)) = previousy(i);
                                        y2{i}(lastIndex(i)) = yval{i}(1);
                                        lastIndex(i) = lastIndex(i) + 1;
                                        previousDrawn(i) = 1;
                                        lineIncrement = 1;
                                    else
                                        if  (previousDrawn(i) == 0)
                                            x1{i}(lastIndex(i)) = previousx(i);
                                            x2{i}(lastIndex(i)) = previousx(i);
                                            y1{i}(lastIndex(i)) = previousy(i);
                                            y2{i}(lastIndex(i)) = previousy(i);
                                            lastIndex(i) = lastIndex(i) + 1;
                                        end
                                        previousDrawn(i) = 0;
                                    end
                                    previousx(i) = xval{i}(1);
                                    previousy(i) = yval{i}(1);
                                end
                            end
                    end
            else
                for ptnum = 1:numpts
                    for i = 1:len
%                         
%                         i
%                         xx = xMaxDist(i)
%                         yy = yMaxDist(i)
%                         pause
%                         li = lastIndex(i)
%                         xv = xval{i}(ptnum)
%                         if (li > 1)
%                             xp = x1{i}(lastIndex(i) - 1)
%                             absx = abs(xval{i}(ptnum) - x1{i}(lastIndex(i) - 1))
%                         end
%                         yv = yval{i}(ptnum)
%                         if (li > 1)
%                             yp = y1{i}(lastIndex(i) - 1)
%                             absy = abs(yval{i}(ptnum) - y1{i}(lastIndex(i) - 1))
%                         end
%                         pause
%                        if (lastIndex(i) == 1) || (((abs(xval{i}(ptnum) - x1{i}(lastIndex(i) - 1)) ) < xMaxDist(i)) && ((abs(yval{i}(ptnum) - y1{i}(lastIndex(i) - 1)) ) < yMaxDist(i)))
                            x1{i}(lastIndex(i)) = xval{i}(ptnum);
                            y1{i}(lastIndex(i)) = yval{i}(ptnum);
                            lastIndex(i) = lastIndex(i) + 1;
 %                       end
                        lineIncrement = 1;
                    end
                end
            end
            counterLines = counterLines + lineIncrement;
            if (numberOfSegments < 0)
                numberOfSegmentsIn = numberOfSegmentsIn + 1;
            end
        end

        
        if (drawPoints == 1)
            for ptnum = 1:numpts
                flag = data(ptnum, flagCol);
                for i = 1:len
                    for j = 1:pointSize{i}
                        if (flag == pointFlags{i}{j})
                                pointsX{i}{j}(lastIndexPoints{i}{j}) = xval{i}(ptnum);
                                pointsY{i}{j}(lastIndexPoints{i}{j}) = yval{i}(ptnum);
                                lastIndexPoints{i}{j} = lastIndexPoints{i}{j} + 1;
                            break;
                        end
                    end
                end
                if (numberOfPoints < 0)
                    numberOfPointsIn = numberOfPointsIn + 1;
                end
                counterPoints = counterPoints + 1;
                if (counterPoints == numberOfPointsIn)
                    break;
                end
            end
        end

%         if (drawPoints == 1)
%             for ptnum = 1:numpts
%                 flag = data(ptnum, flagCol);
%                 for i = 1:pointSize
%                     if (flag == pointFlags(i))
%                         for j = 1:len
%                             pointsX{i}(lastIndexPoints{i}) = xval{j}(ptnum);
%                             pointsY{i}(lastIndexPoints{i}) = yval{j}(ptnum);
%                             lastIndexPoints{i} = lastIndexPoints{i} + 1;
%                         end
%                         break;
%                     end
%                 end
%             end
%         end

%        hcntr = hcntr + 1;
%        if (mod(hcntr , 100) == 0)
%            fprintf(1,data(1,9));
%        end
        [noteof, numpts, data] = readBlock(fid, col, AsciiFormat,  startingPts, updatePZendPts);
    end
    serial = serial + 1;
    filename = getFileName(directory, runname, middlename, flagnum, name, serial, ext);
    fclose(fid);
    if (serial ~= -1)
        fid = fopen(filename, 'r');
    end
end


if (drawLines == 1)
    if (drawLineSegmentes == 1)
        for i = 1:len
            
%             x1{i}
%             y1{i}
%             x2{i}
%             y2{i}
            lastIndex(i) = lastIndex(i) - 1;
            if ((doXMinMax == 1) || (doYMinMax == 1))
                x1Full = x1{i}(1:lastIndex(i));
                y1Full = y1{i}(1:lastIndex(i));
                red1Ind = find((y1Full >= yminReq) .* (y1Full <= ymaxReq) .* (x1Full >= xminReq) .* (x1Full <= xmaxReq));
                x2Full = x2{i}(1:lastIndex(i));
                y2Full = y2{i}(1:lastIndex(i));
                red2Ind = find((y2Full >= yminReq) .* (y2Full <= ymaxReq) .* (x2Full >= xminReq) .* (x2Full <= xmaxReq));
            end

            if (doXMinMax == 1)
                min1 = minFinite(x1Full(red1Ind));
                xmin = min(xmin, min1);
                min2 = minFinite(x2Full(red2Ind));
                xmin = min(xmin, min2);

                max1 = maxFinite(x1Full(red1Ind));
                xmax = max(xmax, max1);
                max2 = maxFinite(x2Full(red2Ind));
                xmax = max(xmax, max2);
            end

            if (doYMinMax == 1)
                min1 = minFinite(y1Full(red1Ind));
                ymin = min(ymin, min1);
                min2 = minFinite(y2Full(red1Ind));
                ymin = min(ymin, min2);
                
                max1 = maxFinite(y1Full(red1Ind));
                ymax = max(ymax, max1);
                max2 = maxFinite(y2Full(red1Ind));
                ymax = max(ymax, max2);
            end
    %        plotLineSegments(x1{i}, y1{i}, x2{i}, y2{i}, lineColor{i}, lineStyle{i}, lineMarker{i});
                plotLineSegments(x1{i}(1:lastIndex(i)), y1{i}(1:lastIndex(i)), x2{i}(1:lastIndex(i)), y2{i}(1:lastIndex(i)), lineColor{i}, lineStyle{i}, lineMarker{i});
        hold on;
        end
    else
        for i = 1:len
            lastIndex(i) = lastIndex(i) - 1;
            
            if ((doXMinMax == 1) || (doYMinMax == 1))
                x1Full = x1{i}(1:lastIndex(i));
                y1Full = y1{i}(1:lastIndex(i));
                red1Ind = find((y1Full >= yminReq) .* (y1Full <= ymaxReq) .* (x1Full >= xminReq) .* (x1Full <= xmaxReq));
            end

            if (doXMinMax == 1)
                min1 = minFinite(x1Full(red1Ind));
                xmin = min(xmin, min1);
                max1 = maxFinite(x1Full(red1Ind));
                xmax = max(xmax, max1);
            end

            if (doYMinMax == 1)
                min1 = minFinite(y1Full(red1Ind));
                ymin = min(ymin, min1);
                max1 = maxFinite(y1Full(red1Ind));
                ymax = max(ymax, max1);
            end

%        plot(x1{i}, y1{i}, 'Color', lineColor{i}, 'LineStyle', lineStyle{i}, 'Marker', lineMarker{i});
            if (strcmp(lineStyle{i},'-') == 1)
                linWidth = dlwidth;
            elseif (strcmp(lineStyle{i},'--') == 1)
                linWidth = dhhlwidth;
            elseif (strcmp(lineStyle{i},'-.') == 1)
                linWidth = dhdlwidth;
            elseif (strcmp(lineStyle{i},':') == 1)
                linWidth = dLlwidth;
            else
                linWidth = dlwidth;
            end

           plot(x1{i}(1:lastIndex(i)), y1{i}(1:lastIndex(i)), 'Color', lineColor{i}, 'LineStyle', lineStyle{i}, 'Marker', lineMarker{i},'LineWidth',linWidth);
        hold on;
        end
    end    
end

if (drawPoints == 1)
    for i = 1:len
        for j = 1:pointSize{i}
            color = pointMarkerColor{i}{j};

            if ((strcmp(color,'curve') == 1) || (strcmp(color,'curveBlack') == 1))
                color = lineColor{i};
            end

            colorFace = 'none';
            if ((pointFlags{i}{j} <= -1)    && (pointFlags{i}{j} >= -4))
                colorFace = color;
            end    
                
            lastIndexPoints{i}{j} = lastIndexPoints{i}{j} - 1;

            if ((drawLines == 0) || (numberOfSegments ~= -1))
                if ((doXMinMax == 1) || (doYMinMax == 1))
                    x1Full = pointsX{i}{j}(1:lastIndexPoints{i}{j});
                    y1Full = pointsY{i}{j}(1:lastIndexPoints{i}{j});
                    red1Ind = find((y1Full >= yminReq) .* (y1Full <= ymaxReq) .* (x1Full >= xminReq) .* (x1Full <= xmaxReq));
                end
                if (doXMinMax == 1)
                    min1 = minFinite(x1Full(red1Ind));
                    xmin = min(xmin, min1);
                    max1 = maxFinite(x1Full(red1Ind));
                    xmax = max(xmax, max1);
                end

                if (doYMinMax == 1)
                    min1 = minFinite(y1Full(red1Ind));
                    ymin = min(ymin, min1);
                    max1 = maxFinite(y1Full(red1Ind));
                    ymax = max(ymax, max1);
                end
            end
            
 

            plot(pointsX{i}{j}(1:lastIndexPoints{i}{j}), pointsY{i}{j}(1:lastIndexPoints{i}{j}), 'LineStyle','none', 'Marker', pointMaker{i}{j}, 'MarkerSize' ,pointMarkerSize{i}{j}, 'MarkerEdgeColor', color, 'MarkerFaceColor', colorFace) ;
            hold on;
        end
    end
end    
%fclose(fid);
