function plot_Dsu_Dv(version, runNumber, xMode, fieldXIndex, forceDroppingDir)

usePrime4normalized = 0;
forceScaleOpt = -1;
if xMode == 1
    xsym = 'du0n';
    fileNameBase = ['dataDs/fractureComparison_v_', num2str(version), '_s_', num2str(runNumber), '_', num2str(fieldXIndex)];
else
    xsym = 'du0k';
    fileNameBase = ['dataDv/fractureComparison_v_', num2str(version), '_s_', num2str(runNumber), '_', num2str(fieldXIndex)];
end
xlatex = getLatexName(xsym, usePrime4normalized, forceDroppingDir, forceScaleOpt);



%fileNameDat = [fileNameBase, '.Dst_Dv'];
fileNameDat = [fileNameBase, '.tsv'];
fileNameInfo = [fileNameBase, '.Dst_DvPara'];

fidi = fopen(fileNameInfo, 'r');
if (fidi < 0)
    return;
end

buf = fscanf(fidi, '%s', 1);
numTimeSteps = fscanf(fidi, '%d', 1);

buf = fscanf(fidi, '%s', 1);
numFields = fscanf(fidi, '%d', 1);

for i = 1:numFields
    fieldNamesBase{i} = fscanf(fidi, '%d', 1);
    base = 'none';
    if (strcmp(fieldNamesBase{i}, 'du') == 1)
        base = xsym;
    elseif (strcmp(fieldNamesBase{i}, 'Dsu') == 1)
        base = 'Dsu0n';
    elseif (strcmp(fieldNamesBase{i}, 'Dv') == 1)
        base = 'Dv0n';
    end
%    base = test_getLatexName(base, usePrime4normalized, forceDroppingDir, usePrime4normalized);
    fieldNamesBase{i} = base;
end


fclose(fidi);
fid = fopen(fileNameDat, 'r');
dat = fscanf(fid, '%g', [numFields inf]);
dat = dat';
fclose(fid);

if (numFields ~= 3)
    fprintf(1, 'invalid numFields\n');
end

dat = dat';
x = dat(1, :);
y = dat(2:3, :);
%y(2,:) = y(2,:) + y(1, :);
%y(1,:) = y(2,:);

figure(1);
set(gca, 'FontSize', 18);
h = area(x, y', 'lineStyle', 'none');
%set(gca, 'YGrid', 'on');
h(1).FaceColor = [0.5 0.5 0.5];
h(2).FaceColor = [0.75 0.75 0.75];
legEntries{1} = 'Dsu0n';
legEntries{2} = 'Dv0n';
set(gca, 'FontSize', 17);
for i = 1:2
    leg{i} = getLatexName(legEntries{i}, usePrime4normalized, forceDroppingDir, forceScaleOpt);
end
legend(leg, 'Location', 'NorthOutside', 'FontSize', 24, 'Orientation', 'horizontal', 'Interpreter', 'latex');
legend('boxoff');

xh = get(gca, 'XLabel');
set(xh, 'String', xlatex, 'FontSize', 26, 'VerticalAlignment','Top', 'Interpreter', 'latex');

yt = 0:0.1:1;
set(gca, 'Ytick', yt);

xmax = max(x);
xlim([0, xmax]);
ylim([0, 1]);

fldr = 'figures_Dsv';
[status,message,messageid] = mkdir(fldr);
fileOutBase = [fldr, '/Dsv_', num2str(version), '_s_', num2str(runNumber), '_', xsym, '_', num2str(fieldXIndex)];
fileOutPNG = [fileOutBase, '.png'];
print('-dpng', fileOutPNG);