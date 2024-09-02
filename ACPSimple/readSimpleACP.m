function [pID, faceFlag, src, tar, noteof] = readSimpleACP(fid) 

global sVertID;
global stVertID;
global stCrd;

sVertID = 1;
stVertID = 2;
stCrd = 3;

[pID, noteof] = fscanf(fid, '%d',1);
if (noteof == 0)
    faceFlag = 0;
    src = cell(0);
    tar = cell(0);
    return;
end

[faceFlag, noteof] = fscanf(fid, '%d', 1);
src{sVertID} = fscanf(fid, '%d', 1);
src{stVertID} = fscanf(fid, '%d', 1);
src{stCrd} = fscanf(fid, '%lg', 3);
tar{sVertID} = fscanf(fid, '%d', 1);
tar{stVertID} = fscanf(fid, '%d', 1);
tar{stCrd} = fscanf(fid, '%lg', 3);
