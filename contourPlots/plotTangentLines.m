function plotTangentLines(x, y, teta, delx, dely, color, maxNumDivisions, includeEndPoints, zBasePoint, zbase, xmin, xmax, ymin, ymax)


if (nargin < 6)
    color = [0 0 0];
end

if (nargin < 7)
    maxNumDivisions = 10;
end

if (nargin < 8)
    includeEndPoints = 0;
end

if (nargin < 9)
    zBasePoint = inf;
end

if (nargin < 10)
    zbase = 0;
end


if (nargin < 11)
    xmin = min(x);
end

if (nargin < 12)
    xmax = max(x);
end

if (nargin < 13)
    ymin = min(y);
end

if (nargin < 14)
    ymax = max(y);
end

if (nargin < 4)
    delx = (xmax - xmin) / numSubDivX;
end

if (nargin < 5)
    dely = (ymax - ymin) / numSubDivY;
end


zbase = zbase + max(delx, dely) * 4000;


numX = ceil((xmax - xmin) / delx);
numY = ceil((ymax - ymin) / dely);


if (maxNumDivisions > 0)
    numX = max(maxNumDivisions, numX);
    numY = max(maxNumDivisions, numY);
end

mx = 60;
numX = min(numX, mx);
numY = min(numY, floor(mx * mx / numX));


delx = (xmax - xmin) / numX;
dely = (ymax - ymin) / numY;


xVals = zeros(numX + 1, 1);
yVals = zeros(numY + 1, 1);

for i = 0:numX
    xVals(i + 1) = xmin + i * delx;
    yVals(i + 1) = ymin + i * dely;
end

[X,Y] = meshgrid(xVals, yVals);
g_x = cos(teta);
g_y = sin(teta);
option = 'nearest';
G_x = griddata(x, y,g_x, X, Y, option);
G_y = griddata(x, y,g_y, X, Y, option);

% for i = 1:(numX + 1)
%     for j = 1:(numY + 1)
%         x = xVals(i);
%         y = yVals(j);
%         r = sqrt(x^2 + y^2);
%         G_y(j, i) = x; %x/r;2 * x;
%         G_x(j, i) = -y; % -y/r;
%     end
% end


sx = length(xVals);
sy = length(yVals);
len = sx * sy;
mat = zeros(len);
F = zeros(sy, sx);
mat(1,1) = 1;
rhs = zeros(len, 1);
rhs(1) = 1.0;

for i = 1:numX
    sinx = 0.5 * (G_y(1, i) + G_y(1, i + 1));
    F(1, i + 1) = F(1, i) + sinx * delx;
end
    
for j = 1:numY
    cosy = 0.5 * (G_x(j, 1) + G_x(j + 1, 1));
    F(j + 1, 1) = F(j, 1) - cosy * dely;
end

% sx = numX + 1;
% sy = numY + 1;
% len = sx * sy;
% mat = zeros(len);



% F = zeros(sy, sx);
% rhs = zeros(len, 1);
% 
% 
% for i = 1:numX
%     sinx = 0.5 * (G_y(1, i) + G_y(1, i + 1));
%     F(1, i + 1) = F(1, i) + sinx * delx;
% end
%     
% for j = 1:numY
%     cosy = 0.5 * (G_x(j, 1) + G_x(j + 1, 1));
%     F(j + 1, 1) = F(j, 1) - cosy * dely;
% end






















% for i = 2:len
%     J = ceil(i / sx);
%     I = i - (J - 1) * sx;
%     gx2delx = G_x(J, I) / delx;
%     gy2dely = G_y(J, I) / dely;
% 
%     gx2delx = 1.0;
%     gy2dely = 1.0;
%  
%     if (J == 1)
%        ind_i_jp1 = i + sx;
%        mat(i, ind_i_jp1) = mat(i, ind_i_jp1) + gy2dely;
%        mat(i, i) = mat(i, i) - gy2dely;
% %         mat(i, i) = 1.0;
% %         rhs(i) = F(J, I);
%         
%     elseif (J == sy)
%         ind_i_jm1 = i - sx;
%         mat(i, ind_i_jm1) = mat(i, ind_i_jm1) - gy2dely;
%         mat(i, i) = mat(i, i) + gy2dely;
%     else
%         ind_i_jp1 = i + sx;
%         mat(i, ind_i_jp1) = mat(i, ind_i_jp1) + 0.5 * gy2dely;
%         ind_i_jm1 = i - sx;
%         mat(i, ind_i_jm1) = mat(i, ind_i_jm1) - 0.5 * gy2dely;
%     end
%         
%     if (I == 1)
%          ind_i_ip1 = i + 1;
%          mat(i, ind_i_ip1) = mat(i, ind_i_ip1) + gx2delx;
%          mat(i, i) = mat(i, i) - gx2delx;
% %        mat(i, i) = 1.0;
% %        rhs(i) = F(J, I);
% 
%     elseif (I == sx)
%         ind_i_im1 = i - 1;
%         mat(i, ind_i_im1) = mat(i, ind_i_im1) - gx2delx;
%         mat(i, i) = mat(i, i) + gx2delx;
%     else
%         ind_i_ip1 = i + 1;
%         mat(i, ind_i_ip1) = mat(i, ind_i_ip1) + 0.5 * gx2delx;
%         ind_i_im1 = i - 1;
%         mat(i, ind_i_im1) = mat(i, ind_i_im1) - 0.5 * gx2delx;
%     end
% end





























for i = 1:len
    J = ceil(i / sx);
    I = i - (J - 1) * sx;
    gx2delx = G_x(J + 1, I + 1) / delx;
    gy2dely = G_y(J + 1, I + 1) / dely;

%     gx2delx = 1.0;
%     gy2dely = 1.0;
 
    if (J == 1)
       mat(i, i) = mat(i, i) + gy2dely;
       rhs(i) = rhs(i) + gy2dely * F(J, I + 1);
    elseif (J == sy)
        ind_i_jm1 = i - sx;
        mat(i, ind_i_jm1) = mat(i, ind_i_jm1) - gy2dely;
        mat(i, i) = mat(i, i) + gy2dely;
    else
        ind_i_jp1 = i + sx;
        mat(i, ind_i_jp1) = mat(i, ind_i_jp1) + 0.5 * gy2dely;
        ind_i_jm1 = i - sx;
        mat(i, ind_i_jm1) = mat(i, ind_i_jm1) - 0.5 * gy2dely;
    end
        
    if (I == 1)
       mat(i, i) = mat(i, i) + gx2delx;
       rhs(i) = rhs(i) + gx2delx * F(J + 1, I);
    elseif (I == sx)
        ind_i_im1 = i - 1;
        mat(i, ind_i_im1) = mat(i, ind_i_im1) - gx2delx;
        mat(i, i) = mat(i, i) + gx2delx;
    else
        ind_i_ip1 = i + 1;
        mat(i, ind_i_ip1) = mat(i, ind_i_ip1) + 0.5 * gx2delx;
        ind_i_im1 = i - 1;
        mat(i, ind_i_im1) = mat(i, ind_i_im1) - 0.5 * gx2delx;
    end
end

[mm, nm] = size(mat)
[mr, nr] = size(rhs)

%z = null(mat)
%sol = z(:,8);
sol = mat \ rhs;

%    [mF, nF] = size(F)
for i = 1:len
    J = ceil(i / sx);
    I = i - (J - 1) * sx;
    F(J + 1, I + 1) = sol(i);
end



% for i = 1:len
%     J = ceil(i / sx);
%     I = i - (J - 1) * sx;
%     F(J, I) = sol(i);
% end


%[mF, nF] = size(F)

F = F - zbase;

FMin = min(min(F));
FMax = max(max(F));
rows = max(maxNumDivisions, 255);

colorm = zeros(rows, 3);
for i = 1: rows
    colorm(i,:) = color;
end
colormap(colorm);

if (maxNumDivisions > 0)
    points = getDividingPoints(FMin, FMax, maxNumDivisions, includeEndPoints, includeEndPoints, zBasePoint);
    
%     [mX, nX] = size(X)
%     [mY, nY] = size(Y)
%     [mF, nF] = size(F)

    [mC,hC] = contour(X, Y, F, points);
else
    [mC,hC] = contour(X, Y, F);
end