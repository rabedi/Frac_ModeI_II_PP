fid = fopen('req.txt', 'r');

setGlobalValuesContour();
[cnfgFldReq, NcnfgFldReq] = readRequested_CollectedConfigValues(fid, 1, 1);
[cnfgFldCol, NcnfgFldCol] = readRequested_CollectedConfigValues(fid, 0, 0);



% n  = 1000;
% w = zeros(n, n);
% tic
% for K = 1:10
%     for i = 1:n
%         for j = 1:n
%             w(i, j) = rand();
%         end
%     end
% end
% toc
% 
% tic
% for K = 1:10
%     for j = 1:n
%         for i = 1:n
%             w(i, j) = rand();
%         end
%     end
% end
% toc
% 
% contourConfName = 'contourConfig.txt';
% fidC = fopen(contourConfName, 'r');
% if (fidC < 0)
%     fprintf(1, 'could not open file %s\n', contourConfName);
% end
% [cosnfGen, confData] = readContourPlotConfigFile(fidC)
% 
% fclose(fidC);




% flg = 'b';
% fileName = ['data', flg, '.txt'];
% fid = fopen(fileName, 'r');
% 
% fileNum = ['sizes', '.txt'];
% fidnum = fopen(fileNum, 'r');
% noef = 1;
% cntr = 1;
% nums = [];
% while noef == 1
%     [tm, noef] = fscanf(fidnum, '%d', 1);
%     if (noef == 1)
%         nums(cntr) = tm
%         cntr = cntr + 1
%     end
% end
% 
% cntr = cntr - 1;
% 
% for c = 1:cntr
%     c
%     [vec, noteof] = readVector(fid, nums(c), flg)
% end
% 
% 
% xmin = 1;
% xmax = 3;
% ymin = 2;
% ymax = 4;
% sizx = xmax - xmin;
% sizy = ymax - ymin;
% number = 100;
% 
% alph = 0.4;
% xmin_ = xmin - sizx * alph
% xmax_ = xmax + sizx * alph
% sizx_ = sizx * (1 + 2 * alph)
% ymin_ = ymin - sizy * alph
% ymax_ = ymax + sizy * alph
% sizy_ = sizy * (1 + 2 * alph);
% x_ = xmin_ * ones(number, 1) + sizx_ * rand(number, 1);
% y_ = ymin_ * ones(number, 1) + sizy_ * rand(number, 1);
% delx = 1/30;
% dely = 1/60;
% 
% a0 = 12;
% a = 2.0;
% b = 3.0;
% c = 0.0;
% d = 0.0; 
% e = 0.0;
% zVec = a0 + a * x_ + b * y_ + c .* x_ .* y_ + d * x_ .* x_ + e * y_ .* y_;
% 
% xVals = xmin_:delx:xmax_;
% yVals = ymin_:dely:ymax_;
% [X,Y] = meshgrid(xVals, yVals);
% Zint = griddata(x_,y_, zVec, X, Y);
% 
% f0 = 0.21312;
% f1 = 0.131212;
% x = f0 * xmin + (1 - f0) * xmax
% y = f1 * ymin + (1 - f1) * ymax
% z = interpolate2D(x, y, xmin_, xmax_, ymin_, ymax_)
% z_ = a0 + a * x + b * y + c .* x .* y + d * x .* x + e * y .* y
% 
% 
% xmin = 0;
% xmax = 1;
% delx = 0.10;
% xvals = [];
% 
% %xvals
% for i = 1:10
%     x = rand() * 2;
%     xvals = UpdateXVectorWithNewPoint(x, xmin, xmax, xvals);
% end
% %xvals
% 
% 
% getNewPoint = 1;
% 
% while (getNewPoint == 1)
%    [getNewPoint, x, xvals] =  getNewPointInInterval(xmin, xmax, delx, xvals);
% end
% 
% %xvals
