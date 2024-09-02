

number = 3000;
px = 2;
py = 0.5;

x = zeros(number, 1);
y = zeros(number, 1);
teta = zeros(number, 1);

xmin = 0;
xmax = 1;
ymin = 0;
ymax = 1;


alph = 0.4;
sizx = xmax - xmin;
sizy = ymax - ymin;
xminData = xmin - sizx * alph;
xmaxData = xmax + sizx * alph;
sizxData = sizx * (1 + 2 * alph);
yminData = ymin - sizy * alph;
ymaxData = ymax + sizy * alph;
sizyData = sizy * (1 + 2 * alph);

x = xminData * ones(number, 1) + sizxData * rand(number, 1);
y = yminData * ones(number, 1) + sizyData * rand(number, 1);

% for i = 1:number
%     x_ = rand(1, 1);
%     x_ = power(x_, px);
%     y_ = rand(1, 1);
%     y_ = (1 - power(y_, py));
%     x(i,1) = x_;
%     y(i,1) = y_;
% 
%     
%     grad = [-2*x_, 1];
% %    teta(i) = atan2(grad(2), grad(1));
%     teta(i) = atan2(grad(1), -grad(2));
% end

[z_, zx_, zy_, teta] = testFunction(x, y);


% u = cos(teta);
% v = sin(teta);
% 
% quiver(x, y, u, v);
% hold on;
% pause;

delx = 1/10;
dely = 1/10;
maxNumDivisions = 20;
includeEndPoints = 0;
zBasePoint = inf;
color = [0 0 0];

delFactorForInterpolant = 10;
interpolantOption = 'linear';
fac = 0.4;

plotTangentLinesIntegrationMethod(x, y, teta, delx, dely, delFactorForInterpolant, interpolantOption, color, xmin, xmax, ymin, ymax, xminData, xmaxData, yminData, ymaxData);


%plotTangentLines(x, y, teta, delx, dely, color, maxNumDivisions, includeEndPoints, zBasePoint);
