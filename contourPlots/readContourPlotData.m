function readContourPlotData(serialNum, dir, runName, middleName, dataFileFormat, briefStatMiddleName, simNormalizerMidName)

% offset is the start of useful data for contour plots first 4 are x0,1, t
% and element coordinate
offset = 4;
offsetP1 = offset + 1;

ind_x0 = 0;
ind_x1 = 1;
ind_t = 2;
ind_eID = 3;
ind_s00 = 4;
ind_s11 = 5;
ind_s01 = 6;
ind_sMax = 7;
ind_sMaxT = 8;
ind_sMin = 9;
ind_sMinT = 10;
ind_tauM = 11;
ind_tauMT = 12;
ind_Es = 13;
ind_v0 = 14;
ind_v1 = 15;
ind_vMag = 16;
ind_Ev = 17;
ind_Etot = 18;
ind_u0 = 19;
ind_u1 = 20;
ind_uMag = 21;
ind_maxEffS = 22;
ind_maxEffST = 23;



if (nargin < 2)
    dir = 'trunk_working/physics/output';
    dir = 'outputTW/output';
end

if (nargin < 3)
    runName = 'XuN';
end

if (nargin < 4)
    middleName = 'BTimeSlice';
end

if (nargin < 5)
    dataFileFormat = 'a';
end
if (nargin < 6)
    briefStatMiddleName = 'BStatTimeBrief';
end

if (nargin < 7)
    simNormalizerMidName = 'BTSNorm';
end

if (strcmp('dir' , 'NULL') == 1)
    dir = '';
elseif (strcmp('dir' , '') == 0)
    dir = [dir,'/'];
end



if (allowBinary == 0)
    dataFileFormat = 'a';
end

if (strcmp(dataFileFormat,'a') == 1)
    dataExt = 'txt';
else
    dataExt = 'bin';
end
 
statFileName = [dir, runName, confGen{s_middlename}, briefStatMiddleName, num2str(serialNum, '%0.5d'),'.txt'];
dataFileName = [dir, runName, confGen{s_middlename}, middleName, num2str(serialNum, '%0.5d'),'.', dataExt];
normalizerFileName = [dir, runName, confGen{s_middlename}, simNormalizerMidName,'.txt'];

fidStat = fopen(statFileName, 'r');

if (fidStat < 0)
    fprintf(1, '%s file could not be opened\n', statFileName);
    pause;
end

fidData = fopen(dataFileName, 'r');

if (fidData < 0)
    fprintf(1, '%s file could not be opened\n', dataFileName);
    pause;
end

fidNorm = fopen(normalizerFileName, 'r');

if (fidNorm < 0)
    fprintf(1, '%s file could not be opened\n', normalizerFileName);
    pause;
end


numTotalFlds = fscanf(fidStat, '%d', 1);
numData = fscanf(fidStat, '%d', 1);
[minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, counter, average, sum, sDiviation, name] =  ...
    readBriefStat(fidStat, numTotalFlds);
minCoord = minV(1:3);
maxCoord = maxV(1:3);


minV = minV(offsetP1:numTotalFlds);
maxV = maxV(offsetP1:numTotalFlds);
average = average(offsetP1:numTotalFlds);
sum = sum(offsetP1:numTotalFlds);
name = name(offsetP1:numTotalFlds)

numFlds = numTotalFlds - offsetP1 + 1;

dispStart = 1;
while (strcmp(name{dispStart}, 'u0') == 0)
    dispStart = dispStart + 1;
end

m = fscanf(fidNorm, '%d', 1);
n = fscanf(fidNorm, '%d', 1);

confNormalizer = fscanf(fidNorm, '%lg', [n inf]);
confNormalizer = confNormalizer';

noteof = 1;
X = zeros(numData, 1);
Y = zeros(numData, 1);
z = zeros(numData, numFlds);

cntr = 0;
while (noteof ~= 0)
    [vec, noteof] = readVector(fidData, numTotalFlds, dataFileFormat);
    if (noteof ~= 0)
        cntr = cntr + 1;
        X(cntr) = vec(ind_x0 + 1);
        Y(cntr) = vec(ind_x0 + 2);
        z(cntr, :) = vec(offsetP1:numTotalFlds);
    end
end

fclose(fidStat);
fclose(fidData);
fclose(fidNorm);