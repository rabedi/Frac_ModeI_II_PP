function contourPlot(x, y, z, xmin, xmax, ymin, ymax, zmin, zmax, maxNumPtsPerBox, precisionRowCounter, ...
    maxNumRowCounter, maxNumGridPtsSingleContour, maxNumGridPtsALLContour, doPlot, expansionRatio, ...
    maxNumDivisions, zBasePoints, colormapInput, fig, zflags, showLegend, lablIn, serialNumAbsolute, ...
    addMarkerData, zDataMin, zDataMax, xDataMin, xDataMax, yDataMin, yDataMax, legLoc)

global confGen;
global s_numFldsAdded;
global s_optionFldsAdded;

% global s_lfs;
% global s_tfs;
% global s_pltfs;
global s_symfs;

numAdded = confGen{s_numFldsAdded};
opt_ = confGen{s_optionFldsAdded};
symfs = confGen{s_symfs};



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

% delxTet if negative is the number of subdivision for each box if
% negative, if positive it's the absolute size distance between different
% tangent lines

% relative (this time per plot box axis)
delxTetAbs = -10;
delyTetAbs = -10;
% absolute value
% delxTetAbs = 0.03;
% delyTetAbs = 0.03;
% subdivision for interpolant in tangent line is "delFactorForInterpolant"
% times smaller than those by regular distance between lines of tangent
% curves
delFactorForInterpolant = 20;

minTol2AddPurturbation = 0.002;
purturbationMagnitude = 0.00000001;

quiverColor = [0 0 0];
quiverArrowHead = 'off';
maxNumDivisionsQuiver = 20;
rows = max(maxNumDivisionsQuiver, 255);
colormapQuiver = zeros(rows, 3);
for i = 1: rows
    colormapQuiver(i,:) = quiverColor;
end

[mc_, nc_] = size(colormapInput);
%colormapInput(mc_, :) = quiverColor;
%colormapInput(1, :) = quiverColor;

[numPts, numFlds] = size(z);

if (nargin < 10)
    maxNumPtsPerBox = 100;
end
if (nargin < 11)
    precisionRowCounter = 1000;
end
if (nargin < 12)
    maxNumRowCounter = 10000;
end
if (nargin < 13)
    maxNumGridPtsSingleContour = 40;
end
if (nargin < 14)
    maxNumGridPtsALLContour = 120;
end
if (nargin < 15)
    doPlot = 0;
end
if (nargin < 16)
    expansionRatio = 0.7;
end

if (nargin < 17)
    maxNumDivisions = 20;
end
if (nargin < 18)
    zBasePoints = inf * ones(1, numFlds);
end
if (nargin < 19)
    colormap('default');
    colormapInput = colormap;
end

if (nargin < 20)
    for fld = 1:numFlds
        fig(fld ) = figure(fld);
    end
end

if (nargin < 21)
    zflags = ones(numFlds, 1);
end

if (nargin < 22)
    showLegend = 1;
end

if (nargin < 23)
    for fld = 1:numFlds
        lablIn{fld} = [];
    end
end

if (nargin < 24)
    serialNumAbsolute = 1;
end

if (nargin < 25)
    addMarkerData = 0;
end


if (nargin < 26)
    zDataMin = [];
end

if (nargin < 27)
    zDataMax = [];
end

if (nargin < 28)
    xDataMin = [];
end

if (nargin < 29)
    xDataMax = [];
end

if (nargin < 30)
    yDataMin = [];
end

if (nargin < 31)
    yDataMax = [];
end

if (nargin < 32)
    for fld = 1:numFlds
        legLoc{fld} = 'EastOutside';
    end
end

if (length(xDataMin) == 0)
    computeMinMaxXYPlotLims = 1;
else
    computeMinMaxXYPlotLims = 0;
end    

if (length(zDataMin) == 0)
    computeMinMax = 1;
else
    computeMinMax = 0;
end  


xmin = max(xmin, min(x));
ymin = max(ymin, min(y));
xmax = min(xmax, max(x));
ymax = min(ymax, max(y));


if (computeMinMaxXYPlotLims == 1)
    xminPlot = xmin;
    xmaxPlot = xmax;
    yminPlot = ymin;
    ymaxPlot = ymax;
else
    xminPlot = min(xmin, xDataMin);
    xmaxPlot = max(xmax, xDataMax);
    yminPlot = min(ymin, yDataMin);
    ymaxPlot = max(ymax, yDataMax);
end

    
% if (xmin == -inf)
%     xmin = min(x);
% end
% if (xmax == inf)
%     xmax = max(x);
% end
% 
% if (ymin == -inf)
%     ymin = min(y);
% end
% if (ymax == inf)
%     ymax = max(y);
% end

indg = (x >= xmin) .* (x <= xmax) .* (y >= ymin) .* (y <= ymax);
indg = find(indg > 0);
x = x(indg);
y = y(indg);
z = z(indg, :);
numPts = length(x);



[splitPtsX, splitPtsY, numberOfBoxPerAxis] = subdivideRegion(x, y, xmin, xmax, ymin, ymax, maxNumPtsPerBox, precisionRowCounter, maxNumRowCounter, doPlot);

zMax = zeros(1, numFlds);
zMin = zeros(1, numFlds);

delxD = xmax - xmin;
delyD = ymax - ymin;

includeStartPoint = zeros(1, numFlds);
includeEndPoint = zeros(1, numFlds);
for fld = 1:numFlds
    if (zflags(fld)  == 0)
        continue;
    end
    if (zflags(fld) > 0)
        plotSolidContour(fld) = 0;
        filledContour = 0;
    else
        plotSolidContour(fld) = 1;
        filledContour = 1;
        includeStartPoint(fld) = 1;
    end 
    zflags(fld) = abs(zflags(fld));
    heightFlags(fld) = floor(zflags(fld) / 100);
    tmp = zflags(fld) - 100 * heightFlags(fld);
    heightFlags(fld) = abs(heightFlags(fld));
    zflagQuiver(fld) = floor(tmp / 10);
    zflagContour(fld) = tmp - 10 * zflagQuiver(fld);
    if (zflags(fld) == 0)
        continue;
    end
    figure(fig(fld));
    if (computeMinMax == 1)
        if (zmin(fld) == -inf)
            zMin(fld) = min(z(:,fld));
        else
            zMin(fld) = zmin(fld);
        end
        if (zmax(fld) == inf)
            zMax(fld) = max(z(:,fld));
        else
            zMax(fld) = zmax(fld);
        end
    else
        if (zmin(fld) == -inf)
            zMin(fld) = zDataMin(fld);
        else
            zMin(fld) = zmin(fld);
        end
        if (zmax(fld) == inf)
            zMax(fld) = zDataMax(fld);
        else
            zMax(fld) = zmax(fld);
        end
    end        
    if ((heightFlags(fld) == 0) || (heightFlags(fld) == 2))
        labl{fld} = getContourLegend(zMin(fld), zMax(fld), maxNumDivisions, lablIn{fld}, zBasePoints(fld), includeStartPoint(fld), includeEndPoint(fld), colormapInput, showLegend, zflags(fld), quiverColor, quiverArrowHead, addMarkerData, legLoc{fld}, filledContour, symfs);
    else
        colormap(colormapInput);
    end
%        view([-37.5 30]);
    if (heightFlags(fld) ~= 0) 
        view([-68.5 58]);
    end
end


maxNumGridPts = min(maxNumGridPtsSingleContour, maxNumGridPtsALLContour / numberOfBoxPerAxis);

if (numberOfBoxPerAxis == 1)
    expansionRatio = 0;
end

if (expansionRatio > 0.35)
    interpolantOption = 'linear';
else
    interpolantOption = 'nearest';
end


% if (numberOfBoxPerAxis == 1)
%     xVals = xmin:delxD / maxNumGridPts:xmax;
%     yVals = ymin:delyD / maxNumGridPts:ymax;
%     [X,Y] = meshgrid(xVals, yVals);
%     for fld = 1:numFlds
%         figure(fig(fld));
%         Z = griddata(x,y,z(:,fld),X,Y);
%         [mC,hC] = contour(X, Y, Z);
%     end
%     return;
% end

x_ = cell(numberOfBoxPerAxis, numberOfBoxPerAxis);
y_ = cell(numberOfBoxPerAxis, numberOfBoxPerAxis);
z_ = cell(numberOfBoxPerAxis, numberOfBoxPerAxis);
cntr = ones(numberOfBoxPerAxis, numberOfBoxPerAxis);
for indx = 1:numberOfBoxPerAxis
    for indy = 1:numberOfBoxPerAxis
        x_{indx, indy} = inf * ones(maxNumPtsPerBox, 1);
        y_{indx, indy} = inf * ones(maxNumPtsPerBox, 1);
        z_{indx, indy} = inf * ones(maxNumPtsPerBox, numFlds);
    end
end

XS = zeros(numberOfBoxPerAxis, numberOfBoxPerAxis);
YS = zeros(numberOfBoxPerAxis, numberOfBoxPerAxis);
XE = zeros(numberOfBoxPerAxis, numberOfBoxPerAxis);
YE = zeros(numberOfBoxPerAxis, numberOfBoxPerAxis);
delX = zeros(numberOfBoxPerAxis, numberOfBoxPerAxis);
delY = zeros(numberOfBoxPerAxis, numberOfBoxPerAxis);

XSi = zeros(numberOfBoxPerAxis, numberOfBoxPerAxis);
YSi = zeros(numberOfBoxPerAxis, numberOfBoxPerAxis);
XEi = zeros(numberOfBoxPerAxis, numberOfBoxPerAxis);
YEi = zeros(numberOfBoxPerAxis, numberOfBoxPerAxis);

for indx = 1:numberOfBoxPerAxis
    for indy = 1:numberOfBoxPerAxis
        ys = splitPtsY(indy);
        ye = splitPtsY(indy + 1);
        xs = splitPtsX{indy}(indx);
        xe = splitPtsX{indy}(indx + 1);
        delxe = xe - xs;
        delye = ye - ys;
        
        XSi(indx, indy) = xs;
        YSi(indx, indy) = ys;
        
        XEi(indx, indy) = xe;
        YEi(indx, indy) = ye;
        
        xs = xs - expansionRatio * delxe;
        xe = xe + expansionRatio * delxe;
        
        ys = ys - expansionRatio * delye;
        ye = ye + expansionRatio * delye;

        delxe = xe - xs;
        delye = ye - ys;

        XS(indx, indy) = xs;
        YS(indx, indy) = ys;
        
        XE(indx, indy) = xe;
        YE(indx, indy) = ye;
        
        delX(indx, indy) = delxe;
        delY(indx, indy) = delye;
    end
end

for i = 1:numPts
    if ((x(i) > xmax) || (x(i) < xmin) || (y(i) > ymax) || (y(i) < ymin))
        continue;
    end
    for indx = 1:numberOfBoxPerAxis
        for indy = 1:numberOfBoxPerAxis
            if ( (x(i) >= XS(indx, indy)) && (x(i) <= XE(indx, indy)) && (y(i) >= YS(indx, indy)) && (y(i) <= YE(indx, indy)) )
                x_{indx, indy}(cntr(indx, indy)) = x(i);
                y_{indx, indy}(cntr(indx, indy)) = y(i);
                z_{indx, indy}(cntr(indx, indy),:) = z(i,:);
                cntr(indx, indy) = cntr(indx, indy) + 1;
            end
        end
    end
%     indy = 1;
%     yt = min(y(i), ymax);
%     while (yt > splitPtsY(indy))
%         indy = indy + 1;
%     end
%     if (indy  > 1)
%         indy = indy - 1;
%     end
% 
%     indx = 1;
%     xt = min(x(i), xmax);
%     while (xt > splitPtsX{indy}(indx))
%         indx = indx + 1;
%     end
%     if (indx  > 1)
%         indx = indx - 1;
%     end
%     x_{indx, indy}(cntr(indx, indy)) = xt;
%     y_{indx, indy}(cntr(indx, indy)) = yt;
%     z_{indx, indy}(cntr(indx, indy),:) = z(i,:);
%     cntr(indx, indy) = cntr(indx, indy) + 1;
end    

points = cell(numFlds, 1);
pointsLegend = cell(numFlds, 1);
includeLastPointInLegend = zeros(1, numFlds);
minTol2AddPurturbationAbs = zeros(1, numFlds);
purturbationMagnitudeAbs = zeros(1, numFlds);
for fld = 1:numFlds
    if (zflags(fld)  == 0)
        continue;
    end
    [points{fld}, pointsLegend{fld}, includeLastPointInLegend(fld)] = getDividingPoints(zMin(fld), zMax(fld), maxNumDivisions, includeStartPoint(fld), includeEndPoint(fld), zBasePoints(fld), plotSolidContour(fld));
    if (length(points{fld}) > 1)
        step = points{fld}(2) - points{fld}(1);
        minTol2AddPurturbationAbs(fld) = minTol2AddPurturbation * step;
        purturbationMagnitudeAbs(fld) = purturbationMagnitude * step;
    end
end



% for indx = 1:numberOfBoxPerAxis
%     for indy = 1:numberOfBoxPerAxis
%         ys = YS(indx, indy);
%         ye = YE(indx, indy);
%         xs = XS(indx, indy);
%         xe = XE(indx, indy);
% 
%         delxe = delX(indx, indy);
%         delye = delY(indx, indy);
% 
% 
%         incX = delxe / maxNumGridPts;
%         incY = delye / maxNumGridPts;
% 
% 
%         xVals = xs:incX:xe;
%         yVals = ys:incY:ye;
%         [X,Y] = meshgrid(xVals, yVals);
%         x_{indx, indy} = x_{indx, indy}(1:cntr(indx, indy) - 1);
%         y_{indx, indy} = y_{indx, indy}(1:cntr(indx, indy) - 1);
%         z_{indx, indy} = z_{indx, indy}(1:cntr(indx, indy) - 1, :);
%         for fld = 1:numFlds
%             figure(fig(fld));
%             if (length(x_{indx, indy}) == 0)
%                 continue;
%             end
% 
%             hold on;
%             if (zflagQuiver(fld) ~= 0)
%                 teta = z_{indx, indy}(:,fld + 1);
%                 colormap(colormapQuiver);
%                 
%                 if (zflagQuiver(fld) == 1)
%                     plotTangentLines(x_{indx, indy},y_{indx, indy}, teta, delxe, delye, quiverColor, maxNumDivisionsQuiver, 0, inf, zMax(fld), xs, xe, ys, ye);
%                 else
%                     if (zflagQuiver(fld) == 2)
%                         u = cos(teta);
%                         v = sin(teta);
%                         autoScale = 'off';
%                     elseif (zflagQuiver(fld) == 3)
%                         u = z_{indx, indy}(:,fld) .* cos(teta);
%                         v = z_{indx, indy}(:,fld) .* sin(teta);
%                         autoScale = 'on';
%                     end
%     %                U = griddata(x_{indx, indy},y_{indx, indy},u, X, Y);
%     %                V = griddata(x_{indx, indy},y_{indx, indy},v, X, Y);
%     %                quiver(X, Y, U, V, 'Color', quiverColor, 'ShowArrowHead', quiverArrowHead, 'AutoScale', autoScale);
%                     quiver(x_{indx, indy},y_{indx, indy}, u, v, 'Color', quiverColor, 'ShowArrowHead', quiverArrowHead, 'AutoScale', autoScale);
%                 end
%             end
%             xlim([xmin, xmax]);
%             ylim([ymin, ymax]);
%         end
%     end
% end
% 
% 
% 
% 
% for indx = 1:numberOfBoxPerAxis
%     for indy = 1:numberOfBoxPerAxis
%         ys = YS(indx, indy);
%         ye = YE(indx, indy);
%         xs = XS(indx, indy);
%         xe = XE(indx, indy);
% 
%         delxe = delX(indx, indy);
%         delye = delY(indx, indy);
% 
%         incX = delxe / maxNumGridPts;
%         incY = delye / maxNumGridPts;
% 
%         xVals = xs:incX:xe;
%         yVals = ys:incY:ye;
%         [X,Y] = meshgrid(xVals, yVals);
%         x_{indx, indy} = x_{indx, indy}(1:cntr(indx, indy) - 1);
%         y_{indx, indy} = y_{indx, indy}(1:cntr(indx, indy) - 1);
%         z_{indx, indy} = z_{indx, indy}(1:cntr(indx, indy) - 1, :);
%         for fld = 1:numFlds
%             figure(fig(fld));
%             if (length(x_{indx, indy}) == 0)
%                 continue;
%             end
% 
%             hold on;
%             colormap(colormapInput);
%             if (zflagContour(fld) == 1)
%                 Z = griddata(x_{indx, indy},y_{indx, indy},z_{indx, indy}(:,fld),X,Y);
%                 hold on;
%                 [mC,hC] = contour(X, Y, Z, points{fld});
%             end
%             %
%             %           k =1; ind = 1;  hLines = get(hC,'Children');
%             %           while k < size(mC,2),
%             % %             legName{ind} = num2str(mC(1,k));
%             % %             legClr{ind} = num2str(mC(1,k));
%             % %
%             %              set(hLines(ind),'DisplayName',num2str(mC(1,k)))
%             %              k = k+mC(2,k)+1; ind = ind+1;
%             %           end
%             %          legend('show')
%             xlim([xmin, xmax]);
%             ylim([ymin, ymax]);
%         end
%     end
% end



for indx = 1:numberOfBoxPerAxis
    for indy = 1:numberOfBoxPerAxis
        ys = YS(indx, indy);
        ye = YE(indx, indy);
        xs = XS(indx, indy);
        xe = XE(indx, indy);

        ysi = YSi(indx, indy);
        yei = YEi(indx, indy);
        xsi = XSi(indx, indy);
        xei = XEi(indx, indy);
        
        delxe = delX(indx, indy);
        delye = delY(indx, indy);

        %         ys = splitPtsY(indy);
        %         ye = splitPtsY(indy + 1);
        %         xs = splitPtsX(indy, indx);
        %         xe = splitPtsX(indy, indx + 1);
        %         delxe = xe - xs;
        %         delye = ye - ys;
        %
        %
        %         xs = xs - expansionRatio * delxe;
        %         xe = xe + expansionRatio * delxe;
        %
        %         ys = ys - expansionRatio * delye;
        %         ye = ye + expansionRatio * delye;

        incX = delxe / maxNumGridPts;
        incY = delye / maxNumGridPts;

        %         delxe = xe - xs;
        %         delye = ye - ys;

        xVals = xs:incX:xe;
        if (length(xVals) == 0)
            xVals = xs;
        end
        yVals = ys:incY:ye;
        [X,Y] = meshgrid(xVals, yVals);
        x_{indx, indy} = x_{indx, indy}(1:cntr(indx, indy) - 1);
        y_{indx, indy} = y_{indx, indy}(1:cntr(indx, indy) - 1);
        z_{indx, indy} = z_{indx, indy}(1:cntr(indx, indy) - 1, :);
        for fld = 1:numFlds
            if (zflags(fld)  == 0)
                continue;
            end
            figure(fig(fld));
            if (length(x_{indx, indy}) < 10)
                continue;
            end

            hold on;
            if (zflagQuiver(fld) ~= 0)
                teta = z_{indx, indy}(:,fld + 1);
                colormap(colormapQuiver);
                
                if (zflagQuiver(fld) == 1)
                    if (delxTetAbs > 0)
                        delxTet = delxTetAbs;
                    else
                        delxTet = delxe/-delxTetAbs;
                    end
                    if (delyTetAbs > 0)
                        delyTet = delyTetAbs;
                    else
                        delyTet = delye/-delyTetAbs;
                    end
                    plotTangentLinesIntegrationMethod(x_{indx, indy},y_{indx, indy}, teta, delxTet, delyTet, delFactorForInterpolant, interpolantOption, quiverColor, xsi, xei, ysi, yei, xs, xe, ys, ye);
%                    plotTangentLines(x_{indx, indy},y_{indx, indy}, teta, delxe, delye, quiverColor, maxNumDivisionsQuiver, 0, inf, zMax(fld), xs, xe, ys, ye);
                else
                    if (zflagQuiver(fld) == 2)
                        u = cos(teta);
                        v = sin(teta);
                        autoScale = 'off';
                    elseif (zflagQuiver(fld) == 3)
                        u = z_{indx, indy}(:,fld) .* cos(teta);
                        v = z_{indx, indy}(:,fld) .* sin(teta);
                        autoScale = 'on';
                    end
    %                U = griddata(x_{indx, indy},y_{indx, indy},u, X, Y);
    %                V = griddata(x_{indx, indy},y_{indx, indy},v, X, Y);
    %                quiver(X, Y, U, V, 'Color', quiverColor, 'ShowArrowHead', quiverArrowHead, 'AutoScale', autoScale);
                    quiver(x_{indx, indy},y_{indx, indy}, u, v, 'Color', quiverColor, 'ShowArrowHead', quiverArrowHead, 'AutoScale', autoScale);
                end
            end
            hold on;
            colormap(colormapInput);
            len = length(points{fld});
            if (zflagContour(fld) == 1)
                Z = griddata(x_{indx, indy},y_{indx, indy},z_{indx, indy}(:,fld),X,Y);
                hold on;
                if (plotSolidContour(fld) == 1)
                    minV = min(min(Z));
                    maxV = max(max(Z));
                    if ((maxV - minV) < minTol2AddPurturbationAbs(fld))
                        [zm, zn] = size(Z);
                        Z = Z - rand(zm, zn) * purturbationMagnitudeAbs(fld);
                    end
                    if (heightFlags(fld) == 0)
                        [mC,hC] = contourf(X, Y, Z, points{fld},'LineColor', 'none');
                        caxis([points{fld}(1) points{fld}(len)]);
                    else
                        scr = 0.2;
                        ss = 0.7; %0.5;
                        as = 0.5;%0.8;
                        ds = 0.4; %0.3;
                         if (heightFlags(fld) ~= 1)
                             surf(X,Y,Z, 'EdgeColor','none', 'SpecularColorReflectance', scr, 'SpecularStrength', ss,...
                                 'AmbientStrength',as, 'DiffuseStrength', ds)
                             shading interp 
                             caxis([points{fld}(1) points{fld}(len)]);
                         else
                            surf(X,Y,Z, 'EdgeColor','none', 'FaceColor', [0.6 0.6 0.6], 'SpecularColorReflectance', scr, 'SpecularStrength', ss,...
                                'AmbientStrength',as, 'DiffuseStrength', ds)
                        end
                    end
                else
                    if (heightFlags(fld) == 0)
                        [mC,hC] = contour(X, Y, Z, points{fld});
                    else
                        [mC,hC] = contour3(X, Y, Z, points{fld});
                    end
                    caxis([points{fld}(1) points{fld}(len)]);
                end
            end
            
            %
            %           k =1; ind = 1;  hLines = get(hC,'Children');
            %           while k < size(mC,2),
            % %             legName{ind} = num2str(mC(1,k));
            % %             legClr{ind} = num2str(mC(1,k));
            % %
            %              set(hLines(ind),'DisplayName',num2str(mC(1,k)))
            %              k = k+mC(2,k)+1; ind = ind+1;
            %           end
            %          legend('show')

%             if ((addMarkerData ~= 0) && (zflags(fld) ~= 0))
%                 hold on;
%                 PlotContourMarkers(serialNumAbsolute);
%             end
            xlim([xminPlot, xmaxPlot]);
            ylim([yminPlot, ymaxPlot]);
        end
        % plotting added plot data
        if ((numAdded > 0) || (opt_ > 0))
            plotProcessedPlots(x_{indx, indy},y_{indx, indy},z_{indx, indy}, xVals, yVals);
        end
    end
end

% for fld = 1:numFlds
% 	figure(fld);
%     colorbar;
% end

