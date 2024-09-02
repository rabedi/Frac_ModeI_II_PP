function plotTangentLinesIntegrationMethodSimple(x, y, teta, delx, dely, delFactorForInterpolant, interpolantOption, color, xmin, xmax, ymin, ymax, xminData, xmaxData, yminData, ymaxData)


numSubDivX = 10;
numSubDivY = 10;
tolP = 5e-2 * pi;
maxTanValue = 50;
fac = 1.4;   % safe larger data size to due linear data fit

maxSSizeFactor = delFactorForInterpolant * 10;
if (nargin < 6)
 % make a mesh delFactorForInterpolant times finer for computing interpolant functions for sin and cos teta   
    delFactorForInterpolant = 10; 
end

if (nargin < 8)
    color = [0 0 0];
end


if (nargin < 9)
    xmin = min(x);
end

if (nargin < 10)
    xmax = max(x);
end

if (nargin < 11)
    ymin = min(y);
end

if (nargin < 12)
    ymax = max(y);
end

if (nargin < 13)
    xminData = xmin;
end

if (nargin < 14)
    xmaxData = xmax;
end

if (nargin < 15)
    yminData = ymin;
end

if (nargin < 16)
    ymaxData = ymax;
end


if (nargin < 4)
    delx = (xmax - xmin) / numSubDivX;
end

if (nargin < 5)
    dely = (ymax - ymin) / numSubDivY;
end

sizx = xmax - xmin;
sizxData = xmaxData - xminData;
sizy = ymax - ymin;
sizyData = ymaxData - yminData;

if (nargin < 7)
    interpolantOption = 'nearest';
    if ((sizxData > fac * sizx) && (sizyData > fac * sizy))
        interpolantOption = 'linear';
    end
end

global Zcos;
global Zsin;
global Ztan;



numX = ceil((sizx) / delx);
numY = ceil((sizy) / dely);


delx = sizx / numX;
dely = sizy / numY;

delxData = delx / delFactorForInterpolant;
delxData = sizxData / ceil((sizxData) / delxData);
delyData = dely / delFactorForInterpolant;
delyData = sizyData / ceil((sizyData) / delyData);

maxSSize = min(sizx, sizy) / maxSSizeFactor;



teta_ = mod(teta, pi);
for i = 1:length(teta_)
    if ((pi - teta_(i)) <  tolP)
       teta_(i) = 0.0;
    end
end
cost = cos(teta_);
sint = sin(teta_);
tant = tan(teta);
tant = min(tant, maxTanValue);
tant = max(tant, -maxTanValue);


xValsData = xminData:delxData:xmaxData;
yValsData = yminData:delyData:ymaxData;
[XData,YData] = meshgrid(xValsData, yValsData);
%Zcos = griddata(x,y, cost, XData, YData, interpolantOption);
%Zsin = griddata(x,y, sint, XData, YData, interpolantOption);
Ztan = griddata(x,y, tant, XData, YData, interpolantOption);







% normals point inward
normals = [0 -1 0 1; 1 0 -1 0];
tangents = [1 0 1 0; 0 1 0 1];
% distance to origin
edged = [ymin xmax ymax xmin];
baseCoord = [0 edged(2) 0 edged(4); edged(1) 0 edged(3) 0];
% by factor of which we move along an edge
traverseCoord = [1 0 1 0; 0 1 0 1];
startP = [xmin ymin xmin ymin];
endP = [xmax ymax xmax ymax];
delP = [delx dely delx dely];
points = cell(4,1);
for i = 1:4
    points{i} = [];
end

for edge = 1:4
    
    [getNewPoint, s, points{edge}] = getNewPointInInterval(startP(edge), endP(edge), delP(edge), points{edge});
    dir = normals(:,edge);
    while (getNewPoint == 1)
       np = s * traverseCoord(:, edge) + baseCoord(:, edge);
       xv = np(1);
       yv = np(2);
       cntr = 1;
       cont = 1;
       xvec = ones(1, 1) * xv;
       yvec = ones(1, 1) * yv;
       while (cont == 1)
           tanv = interpolate2D(xv, yv, xminData, xmaxData, yminData, ymaxData, 4);
    %	   cosv = interpolate2D(xv, yv, xminData, xmaxData, yminData, ymaxData, 2);
    %      sinv = interpolate2D(xv, yv, xminData, xmaxData, yminData, ymaxData, 3);
           dirF = 1.0;
           innterProduct = dir(1) * 1.0 + dir(2) * tanv;
           if (innterProduct < 0)
               dirF = -1.0;
           end
           magnitude = sqrt(1.0 + tanv * tanv);
           dir(1) = dirF / magnitude;
           dir(2) = dirF * tanv / magnitude;
           
           shDistEdge = -1;
           minDist = inf;

           for exedge = 1:4
               if ((cntr == 1) && (exedge == edge))
                   continue;
               end
               denom = (normals(1,exedge) * dir(1) + normals(2,exedge) * dir(2));
               dels = - (normals(1,exedge) * xv + normals(2,exedge) * yv + edged(exedge)) / denom;
               if ((dels >= 0) && (dels < minDist))
                   if ((dels > 1e-6 * maxSSize) || (denom < 0.0))
                       minDist = dels;
                       shDistEdge = exedge;
                   end
               end
           end
           
               
           
           delS = maxSSize;
           if ((shDistEdge > 0) && (minDist < maxSSize))
               cont = 0;
               delS = minDist;
           end
           cntr = cntr + 1;
%            cntr
%            dir
           xv = xv + delS * dir(1);
           yv = yv + delS * dir(2);
           xvec(cntr) = xv;
           yvec(cntr) = yv;

           if (cont == 0)
               s = tangents(1, shDistEdge) * xv + tangents(2, shDistEdge) * yv;
               points{shDistEdge} = UpdateXVectorWithNewPoint(s, startP(shDistEdge), endP(shDistEdge), points{shDistEdge});
               hold on;
               plot(xvec, yvec, 'Color', color);
 %              edge
 %              points{edge}
%                if ((edge == 2) && (length(points{edge} == 6)))
%                    pause
%                end
           end
       end
       [getNewPoint, s, points{edge}] = getNewPointInInterval(startP(edge), endP(edge), delP(edge), points{edge});
       dir = normals(:,edge);
    end
end