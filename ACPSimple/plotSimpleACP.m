function [t, cntr] = plotSimpleACP(fid, plotEndPt, plotSV, numInterval, outputFolder, outputFile, printOption, cntrIn)

fs = 13;

t = 0;
global sVertID;
global stVertID;
global stCrd;

if (plotEndPt == 1)
    sym = '-o';
else
    sym = '-';
end

noteof = 1;
cntr = cntrIn;
[pID, faceFlag, src, tar, noteof] = readSimpleACP(fid);
while (noteof ~= 0)
    x = [src{stCrd}(1) tar{stCrd}(1)];
    y = [src{stCrd}(2) tar{stCrd}(2)];
    t = src{stCrd}(3);
if (plotEndPt == 1)
    plot(x, y, '-b', 'Marker', 'o', 'MarkerFaceColor', 'r');
else
    plot(x, y, '-b');
end
    hold on;
    if (plotSV == 1)
       textV1 = [num2str(src{sVertID})];
       textV2 = [num2str(tar{sVertID})];
%       text(x(1), y(1), textV1, 'Color', 'g','FontSize', fs, 'HorizontalAlignment', 'Right', 'VerticalAlignment','Top');
%       text(x(2), y(2), textV2, 'Color', 'g','FontSize', fs, 'HorizontalAlignment', 'Right', 'VerticalAlignment','Top');
       text(x(1), y(1), textV1, 'Color', 'g','FontSize', fs);
       text(x(2), y(2), textV2, 'Color', 'g','FontSize', fs);
    end
    cntr = cntr + 1;
    if (mod(cntr, numInterval) == 0)
        num = cntr / numInterval;
        fileName = [outputFolder, outputFile, '_', num2str(num, '%08d'), '.', printOption];
        print(['-d', printOption], fileName);
    end
    [pID, faceFlag, src, tar, noteof] = readSimpleACP(fid);
end
