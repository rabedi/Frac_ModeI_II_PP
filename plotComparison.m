function [crossData, subdata, dataLineLegend, shapeLegend, colName] = plotComparison(fileName, outputFolder, outputOption, psfrag)
%clear subdata crossData;
subdata = 0;
crossData = 0;

if (nargin < 4)
    psfrag = 0;
end

lfs = 38;%43 27; %18;
tfs = 26;%26;
pltfs = 19;%22; %13;
symfs =  14.5; 

fid = fopen(fileName,'r');

baseLineWidth = 1.8;

shapes = { 'o', '>', 's', 'x', 'd', '*', '+', 'p', '<'};
plotBlack = 1;
changeLogData = 1;
markerSize = 10;
% This on means that the log of data is actually taken and the actual log
% is plotted instead of log log plotting
changeLogData = 1;  
%linespecs = {'-r', '-b', '-g', '-m', '-c','-y'};
if (plotBlack == 1)
        shapes = { 'ko', 'k>', 'ks', 'kx', 'kd', 'k*', 'k+', 'kp', 'k<'};
    lineStyles = {'-', '-.','--',':', '--', '-.'};
%    lineColors = {[0.6 0.6 0.6], 'k', 'k', 'k', [0.6 0.6 0.6], [0.6 0.6 0.6], 'k'};
    lineColors = {[0.6 0.6 0.6], 'k', 'k', 'k', [0.6 0.6 0.6], [0.6 0.6 0.6], 'k'};
    lineWidths = {baseLineWidth, baseLineWidth, baseLineWidth, 1.5 * baseLineWidth, baseLineWidth, baseLineWidth};
else
	shapes = { 'o', '>', 's', 'x', 'd', '*', '+', 'p', '<'};
    lineStyles = {'-', '-','-','-'};
    lineColors = {'r', 'b', 'g', 'm', 'c','y'};
    lineWidths = {baseLineWidth, baseLineWidth, baseLineWidth, baseLineWidth, baseLineWidth, baseLineWidth};
end
baselinespec = '-ok';
colSize = fscanf(fid,'%d', 1);
numXCol = fscanf(fid,'%d', 1);
xcols = fscanf(fid,'%d', numXCol);     % 8 Dissipation, 14 coh energy error, 10 no of elements
shapeCol = fscanf(fid,'%d', 1);
shapeSize = fscanf(fid,'%d', 1);


for i = 1:shapeSize 
    shapeValue(i) = fscanf(fid,'%lg', 1);
end




for i = 1:colSize
    temp = fscanf(fid,'%s', 1);
    colName{i} = readStringWithoutSpace(temp, '*', ' ');
    axisScale{i} = fscanf(fid,'%s', 1);
    axisDirection{i} = fscanf(fid,'%s', 1);
    legendLoc{i} = fscanf(fid,'%s', 1);
end



genTitle = fscanf(fid,'%s', 1);
genTitle = readStringWithoutSpace(genTitle, '*', ' ');

text = fscanf(fid,'%s', 1);
baseLegend = readStringWithoutSpace(text, '*', ' ');

text = fscanf(fid,'%s', 1);
for i = 1:shapeSize 
    temp = [text,num2str(shapeValue(i),1)];
    shapeLegend{i} = readStringWithoutSpace(temp, '*', ' ');
end




dataSize = fscanf(fid,'%d', 1);
crossDataCntr = ones(1, shapeSize);
shapeNdone = zeros(1,shapeSize);
crossData = cell(shapeSize);
subdata = cell(dataSize);
tmp = zeros(1, colSize);

for dataNum = 1:dataSize
    text = fscanf(fid,'%s', 1);
    dataLineLegend{dataNum} = readStringWithoutSpace(text, '*', ' ');
    dataStarSize = fscanf(fid,'%d', 1);
    if (dataStarSize == 1)
        dataLineLegend{dataNum} = 'none';
    end
        
    cntr = 1;
    for ds = 1:dataStarSize
        for i = 1:colSize
            tmp(i) = fscanf(fid,'%lg ', 1);
        end
        
        shapeN = -1;
        for l = 1:shapeSize
            if (abs(tmp(shapeCol) - shapeValue(l)) < 1e-40)
                shapeN = l;
                break;
            end
        end
        if (shapeN == -1)
            fprintf(1,'error');
            pause;
        else
%            crossData{shapeN}(ls, :) = tmp;
            crossData{shapeN}(crossDataCntr(shapeN), :) = tmp;
            crossDataCntr(shapeN) = crossDataCntr(shapeN) + 1;
        end
        
        if (shapeN ~= -1)
            shapeSubData(cntr, :) = tmp;
            cntr = cntr + 1;
        end
    end
    subdata{dataNum} = shapeSubData;
    clear shapeSubData;
end

pltOpt = ['-d', outputOption];


fclose(fid);

for ind =1:numXCol
    xcol =  xcols(ind);
    for col = 1:colSize
        figVec(col) = figure(col);
    %    [m, n] = size(crossData{1});
    %    for k = 1:m
    %        if crossData{1}(:,xcol);
    %    end
        XBasePts = crossData{1}(:,xcol);
        YBasePts = crossData{1}(:,col);

        XBasePtst = transferDataForPlotComparison(XBasePts, axisScale{xcol}, changeLogData);
        YBasePtst = transferDataForPlotComparison(YBasePts, axisScale{col}, changeLogData);
        plot(XBasePtst, YBasePtst, baselinespec, 'LineWidth', baseLineWidth, 'MarkerSize', markerSize);
        hold on;
        x = sum(XBasePtst) / length(XBasePtst);
        y = sum(YBasePtst) / length(YBasePtst);

        plot(x, y, 'LineStyle','none','Color', 'w');
        hold on;

        legendCtr = 0; 

        legendCtr = legendCtr + 1;
        legendVec{legendCtr} = baseLegend;

        plot(x, y, 'LineStyle','none','Color', 'w');
        hold on;
        legendCtr = legendCtr + 1;
        legendVec{legendCtr} = '';

        legendCtr = legendCtr + 1;
        legendVec{legendCtr} = 'LST';


        for dataNum = 1:dataSize

            if (strcmp(dataLineLegend{dataNum} , 'none') == 1)
                continue;
            end

            Xdata = subdata{dataNum}(:,xcol);
            Ydata = subdata{dataNum}(:,col);
            Xdatat = transferDataForPlotComparison(Xdata, axisScale{xcol}, changeLogData);
            Ydatat = transferDataForPlotComparison(Ydata, axisScale{col}, changeLogData);
            plot(Xdatat, Ydatat,'LineStyle',lineStyles{dataNum},'Color',lineColors{dataNum},'LineWidth',lineWidths{dataNum});
            hold on;
            legendCtr = legendCtr + 1;
            legendVec{legendCtr} = dataLineLegend{dataNum};
        end


        plot(x, y, 'LineStyle','none','Color', 'w');
        hold on;
        legendCtr = legendCtr + 1;
        legendVec{legendCtr} = 'SST';

        for crosCntr = 2:shapeSize
            [siz, ncol] = size(crossData{crosCntr});
            if (siz == 0)
                continue;
            end
            Xshape = crossData{crosCntr}(:,xcol);
            Yshape = crossData{crosCntr}(:,col);
            Xshapet = transferDataForPlotComparison(Xshape, axisScale{xcol}, changeLogData);
            Yshapet = transferDataForPlotComparison(Yshape, axisScale{col}, changeLogData);
            plot(Xshapet, Yshapet, shapes{crosCntr},'MarkerSize',markerSize);
            hold on;
            legendCtr = legendCtr + 1;
            legendVec{legendCtr} = shapeLegend{crosCntr};
        end



        set(gca, 'FontSize', pltfs);
        set(gca, 'XMinorTick', 'on');
        set(gca, 'YMinorTick', 'on');

        legend(legendVec);
    %   legend(gca,'Location','Best');
        legh = legend(gca,'Location',legendLoc{col});
        set(legh, 'FontSize', symfs);
        legend('boxoff');

        if (psfrag == 0)
            xlabel(colName{xcol},'FontSize', lfs,'VerticalAlignment','Top');
            ylabel(colName{col},'FontSize', lfs,'VerticalAlignment','Bottom');
        else
            xlabel('xlabel','FontSize', lfs,'VerticalAlignment','Top');
            ylabel('ylabel','FontSize', lfs,'VerticalAlignment','Bottom');
        end

        if (changeLogData == 0)
            set(gca,'XScale', axisScale{xcol});
            set(gca,'YScale', axisScale{col});
        end
        set(gca,'XDir', axisDirection{xcol});
        set(gca,'YDir', axisDirection{col});

        titName = [colName{xcol}, ' vs. ', colName{col}];

        if (psfrag == 0)

            if (strcmp(genTitle, 'none') == 1)
                title(titName,'FontSize', tfs);
            else
                title(genTitle,'FontSize', tfs);
            end
        end    
        if ((xcol == 9)  && (col == 10))
            xlm = get(gca,'xlim');
            xlm(2) = xlm(2) + 2.0;
            set(gca,'xlim', xlm);
            ylm = get(gca,'ylim');
            ylm(2) = ylm(2) + 0.0;
            set(gca,'ylim', ylm);
        end
        if ((xcol == 39)  && (col == 10))
            xlm = get(gca,'xlim');
            xlm(2) = xlm(2) + 2.5;
            set(gca,'xlim', xlm);
            ylm = get(gca,'ylim');
            ylm(2) = ylm(2) + 0.2;
            set(gca,'ylim', ylm);
        end
        if ((xcol == 14) && (col == 10))
            xlm = get(gca,'xlim');
            xlm(1) = xlm(1) - 0.9;
            xlm(2) = -5.4;
            set(gca,'xlim', xlm);
            ylm = get(gca,'ylim');
            ylm(2) = ylm(2) + 0.1;
            set(gca,'ylim', ylm);
        end

        if ((xcol == 16) && (col == 10))
            xlm = get(gca,'xlim');
            xlm(1) = xlm(1) - 0.2;
            xlm(2) = - 1.7;
            set(gca,'xlim', xlm);
            ylm = get(gca,'ylim');
            ylm(2) = ylm(2) + 0.1;
            set(gca,'ylim', ylm);
        end
    %   end

        plotName = [colName{xcol}, '_VS_', colName{col}];
        plotName = readStringWithoutSpace(plotName, ' ', '_');
        plotName = readStringWithoutSpace(plotName, '\', '_');
        plotName = readStringWithoutSpace(plotName, '{', '_');
        plotName = readStringWithoutSpace(plotName, '}', '_');
        plotName = readStringWithoutSpace(plotName, '*', '_');
        if (strcmp(outputFolder, '') == 0)
            plotName = [outputFolder, '/',plotName]; 
        end

        print(pltOpt, plotName);
        delete(figVec(col));

    end
end  