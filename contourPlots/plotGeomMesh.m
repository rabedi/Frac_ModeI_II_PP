function plotGeomMesh(fileName, readOption, clr, style, wdth)

numCol = 10;  % elementID three coordinates
ext = 'txt';
if (readOption == 'b')
    ext = 'bin';
end
fid = fopen([fileName, '.',ext], 'r');

if (fid < 0)
    fprintf(1, 'could not open %s\n', fileName);
    pause;
end
    

%cntr = 0;
[vec, noteof] = readVector(fid, numCol, readOption);
while (noteof ~= 0)
%   cntr = cntr + 1;
%   eID = vec(1);
    x  = [vec(2) vec(5) vec(8) vec(2)];
    y  = [vec(3) vec(6) vec(9) vec(3)];
%    z  = [vec(4) vec(7) vec(10) vec(4)];
    hold on;
    plot(x, y, 'Color',clr ,'LineStyle', style, 'LineWidth', wdth);
    [vec, noteof] = readVector(fid, numCol, readOption);
end