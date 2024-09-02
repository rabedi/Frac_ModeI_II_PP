function [splitPtsX, splitPtsY, numberOfBoxPerAxis] = subdivideRegion(x, y, xmin, xmax, ymin, ymax, maxNumPtsPerBox, precisionRowCounter, maxNumRowCounter, doPlot)
% maxNumPtsPerBox each "subplot" operation can plot this number for subplot
% operation
% maxNumRowCounter, when trying to subdivide the area we don't let the
% counter matrix become larger than this size
% precisionRowCounter we subdivide axes x and y by this number *
% numberOfBoxPerAxis in each axes to decide axes break points
% maxNumGridPtsSingleContour is the maximum number of grid points that a
% single subplot can have on one axis
% maxNumGridPtsALLContour: same as previous but the entire figure should
% not have more than this number squared


numPts = length(x);

if (numPts == 0)
    splitPtsX = cell(0);
    splitPtsY = cell(0);
    numberOfBoxPerAxis = 0;
    return;
end

delxD = xmax - xmin;
delyD = ymax - ymin;




numberOfBoxPerAxis = ceil(sqrt(numPts / maxNumPtsPerBox));

if (numberOfBoxPerAxis == 1)
    splitPtsY = [ymin ymax];
    for i = 1:2
        splitPtsX{i} = [xmin xmax];
    end
    return;
end


% number of subdivision in each axis
numRowCntr = min(precisionRowCounter * numberOfBoxPerAxis, maxNumRowCounter);
numRowCntr = max(numRowCntr, 20 * numberOfBoxPerAxis);

cntrY = zeros(numRowCntr, 1);
delxT = delxD / numRowCntr;
delyT = delyD / numRowCntr;

for i = 1:numPts
%    indx = ceil((x(i) - xmin) / delxT);
    indy = ceil((y(i) - ymin) / delyT);
    if (indy == 0)
        indy = 1;
    end
    if (indy > numRowCntr)
        indy = numRowCntr;
    end
    cntrY(indy) = cntrY(indy) + 1;
end

splitPtsY = getSplitPts(cntrY, numberOfBoxPerAxis, ymin, ymax, numRowCntr, numPts);
splitPtsY_size = length(splitPtsY);
if (doPlot == 1)
    for indy = 1:numberOfBoxPerAxis + 1
        plot([xmin xmax], [splitPtsY(indy) splitPtsY(indy)],'r');
        hold on;
    end
end

cntr = zeros(numRowCntr, numberOfBoxPerAxis);
for i = 1:numPts
    indx = ceil((x(i) - xmin) / delxT);
    if (indx == 0)
        indx = 1;
    elseif (indx == numRowCntr + 1)
        indx = numRowCntr;
    end
    y_ = min(y(i), ymax);
    ind = find(y_ <= splitPtsY);
    if (length(ind) == 0)
        indy = splitPtsY_size;
    else
        indy = ind(1);
    end
    if (indy  > 1)
        indy = indy - 1;
    elseif (indy == numRowCntr + 1)
        indy = numRowCntr;
    end
    if ((indx > 0) && (indx <= numRowCntr) && (indy > 0) && (indy <= numberOfBoxPerAxis))
        cntr(indx, indy) = cntr(indx, indy) + 1;
    end
end    

splitPtsX = cell(numberOfBoxPerAxis, 1);
for indy = 1:numberOfBoxPerAxis
%     indy
%     xmin 
%     xmax
%     numberOfBoxPerAxis
% %    splitPtsX
%     cntr
%     e = getSplitPts(cntr(:, indy), numberOfBoxPerAxis, xmin, xmax)
%     12
    splitPtsX{indy} = getSplitPts(cntr(:, indy), numberOfBoxPerAxis, xmin, xmax);
end


if (doPlot == 1)
    for indy = 1:numberOfBoxPerAxis
        for indx = 1:numberOfBoxPerAxis + 1
        plot([splitPtsX{indy}(indx) splitPtsX{indy}(indx)], [splitPtsY(indy) splitPtsY(indy + 1)],'k');
        hold on;
        end
    end
end
