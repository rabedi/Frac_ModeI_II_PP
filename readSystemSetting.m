function readSystemSetting(higherLevelFolder)

global allowBinary;

if (higherLevelFolder == 0)
    fid = fopen('system/system.txt', 'r');
else
    fid = fopen('../system/system.txt', 'r');
end    
tmp = fscanf(fid, '%s', 1);
allowBinary = fscanf(fid, '%d', 1);