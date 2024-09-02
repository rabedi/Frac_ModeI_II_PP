zMin = 1.3e-15;
zMax = 0.064;
maxNumDivisions = 20;
lablIn = [];
zBasePoints = inf * ones(1, numFlds);
includeEndPoints = 0;
getContourLegend(zMin, zMax, maxNumDivisions, lablIn, zBasePoint, includeEndPoints);%, colormapInput, showLegend)

% zMax = 10;
% zMin = -1.324;
% 
% %    colorbar;
%     x = 0:0.2:1;
%     zz = zeros(6,6);
%     for i = 1:6
%         for j = 1:6
%             zz(j, i) = x(j) * zMax + (1 - x(j)) * zMin;
%         end
%     end
% %     p = points{fld}
% %     zz
%     maxNumDivisions = 12;
%     includeEndPoints = 0;
%     zBasePoint = inf;
%     points = getDividingPoints(zMin, zMax, maxNumDivisions, includeEndPoints, zBasePoint);
%     [mCt,hCt] = contour(x, x, zz, points);
%     [cmin cmax] = caxis
%     [m, n] = size(colormap)
%     cm = colormap;
%     for j = 1:length(points)
%         v = points(j);
%         if (v <= cmin)
%             index = 1;
%         elseif (v >= cmax)
%             index = m;
%         else
%             index = fix((v-cmin)/(cmax-cmin)*m)+1
%         end
%         
%         clr = cm(index,:);
%         labl{j} = num2str(points(j));
%         plot([inf],[inf],'Color',clr);
%         hold on;
%     end
%     legend(labl);
% 
%     hold on;
%     [mCt,hCt] = contour(x, x, zz, points);
