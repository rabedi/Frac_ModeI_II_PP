function outvec = ReadAllVDatStatsFiles(runFolder,...
                                    outputPhysicsDirectory,...
                                    frontFileName,...
                                    vdsFileSuffix,...
                                    energiesActive)
addpath('../');
addpath('aux_functions');
global TOPDIR; TOPDIR = '../../'; 
ext = 'vds';
pdext = 'pudat';
ssext = 'ssdat';

vdsDir = 'output_vdstats';
frontDir = 'output_front';

if nargin < 1
    runFolder = '';
else
    if isempty(runFolder)
        runFolder = '';
    else
        runFolder = fullfile('..',runFolder);
    end
end
if nargin < 2
    outputPhysicsDirectory = 'physics';
end
if nargin < 3
    frontFileName = 'frontSync';
end
if nargin < 4
    vdsFileSuffix = 'misc_all';
end
if nargin < 5
    energiesActive = 1;
end


frontAllPath = fullfile(TOPDIR,runFolder,outputPhysicsDirectory);

fc = frontClass();
fid = fopen(fullfile(frontAllPath,[frontFileName,'.all']),'r');
if fid < 1
   msg = sprintf('File [%s] not open for read.\n',fullfile(frontAllPath,[frontFileName,'.all'])); 
   THROW(msg);
end
fc.readAll(fid);
fclose(fid);

outvec = cell(fc.numFiles,1);

if fc.numFiles ~= 0
    for s = 1:fc.numFiles
        intermFileName = sprintf('%s%s%s%010d_%s.%s',...           
            fc.fronts{s}.runName,...
            fc.fronts{s}.phy,...
            fc.fronts{s}.midName,...
            fc.fronts{s}.sn,...
            vdsFileSuffix,...
            ext);
        energyFileName = sprintf('EDenergy%s_All_%i.%s',...           
            frontFileName,...
            fc.fronts{s}.sn,...            
            'txt');
        inputFile = fullfile(frontAllPath,vdsDir,intermFileName);
        energyFile = fullfile(frontAllPath,fc.fronts{s}.folder,energyFileName);
        
        %outvec{s} = ReadVDatStatsFile(inputFile);
        outvec = ReadVDatStatsFile(outvec,inputFile,s);
        
        ef = energyFrontClass(energyFile);
        if ~isempty(ef) && energiesActive == 1
            outvec{s}.energyActive = 1;
            outvec{s}.energy = ef;
        end
        
        %UPDATE TIME & STAT-FILE-SPECIFIC INFO
        statFile = fullfile(frontAllPath,...
            fc.fronts{s}.folder,...
            sprintf('%s%s%s%010d.%s',... 
            fc.fronts{s}.runName,...
            fc.fronts{s}.phy,...
            fc.fronts{s}.midName,...
            fc.fronts{s}.sn,...
            'stat'));
        sfid = fopen(statFile,'r');
        [~,sdata] = readStatFile(sfid);
        outvec{s}.serial = fc.fronts{s}.sn;
        outvec{s}.t_min = sdata.timeMin;
        outvec{s}.t_max = sdata.timeMax;
        fclose(sfid);
    end
end
end