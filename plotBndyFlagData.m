function plotBndyFlagData(numFlag)

if nargin < 1
    numFlag = 6;
end
    
fid = fopen('../dbicbc.txt', 'r');

[x, noteof] = fscanf(fid,'%lg', 1);
cntr = ones(1, numFlag);
X = cell(numFlag, 1);
Y = cell(numFlag, 1);
T = cell(numFlag, 1);
Flag1 = cell(numFlag, 1);
Flag2 = cell(numFlag, 1);
Data1 = cell(numFlag, 1);
Data2 = cell(numFlag, 1);

while (noteof ~= 0)
    y = fscanf(fid,'%lg', 1);
    t = fscanf(fid,'%lg', 1);
    gflag = fscanf(fid, '%d', 1);
    flag1 = fscanf(fid, '%d', 1);
    flag2 = fscanf(fid, '%d', 1);
    data1 = fscanf(fid, '%lg', 1);
    data2 = fscanf(fid, '%lg', 1);
    X{gflag}(cntr(gflag)) = x;
    Y{gflag}(cntr(gflag)) = y;
    T{gflag}(cntr(gflag)) = t;
    Flag1{gflag}(cntr(gflag)) = flag1;
    Flag2{gflag}(cntr(gflag)) = flag2;
    Data1{gflag}(cntr(gflag)) = data1;
    Data2{gflag}(cntr(gflag)) = data2;
    cntr(gflag) = cntr(gflag) + 1;
    [x, noteof] = fscanf(fid,'%lg', 1);
    cntr
end

for gflag = 1:numFlag
    if (cntr(gflag) == 1)
        continue;
    end
    plot(T{gflag}, Flag1{gflag}, '.');
    name = ['flag1_',num2str(gflag)];
    title(name);
    outputName = ['../',name, '.png'];
    print('-dpng',outputName);
    clf;
    plot(T{gflag}, Flag2{gflag}, '.');
    name = ['flag2_',num2str(gflag)];
    title(name);
    outputName = ['../',name, '.png'];
    print('-dpng',outputName);
    clf;
    plot(T{gflag}, Data1{gflag}, '.');
    name = ['data1_',num2str(gflag)];
    title(name);
    outputName = ['../',name, '.png'];
    print('-dpng',outputName);
    clf;
    plot(T{gflag}, Data2{gflag}, '.');
    name = ['data2_',num2str(gflag)];
    title(name);
    outputName = ['../',name, '.png'];
    print('-dpng',outputName);
    clf;
end
