function outvec = ReadAllVDatStatsFilesMatrix(staticvec, runFolder,...
    outputPhysicsDirectory,...
    frontFileName,...
    vdsFileSuffix,...
    energiesActive,...
    stress_strain, addedParas)
addpath('../');
addpath('aux_functions');
global TOPDIR; TOPDIR = '../../';
ext = 'vds';
pdext = 'pudat';
ssext = 'ssdat';

edgeFlg = [2,3,4,5];

vdsDir = 'output_vdstats';
frontDir = 'output_front';

if nargin < 2
    runFolder = '';
else
    if isempty(runFolder)
        runFolder = '';
    else
        runFolder = fullfile('..',runFolder);
    end
end
if nargin < 3
    outputPhysicsDirectory = 'physics';
end
if nargin < 4
    frontFileName = 'frontSync';
end
if nargin < 5
    vdsFileSuffix = 'misc_all';
end
if nargin < 6
    energiesActive = 1;
end
if nargin < 7
    stress_strain = 2;
end

if nargin < 8
    addedParas = gen_map;
end

if strcmpi(frontFileName,'frontSync')~=1
    stress_strain = 0;
end

skipstatics = ~isempty(staticvec);

frontAllPath = fullfile(TOPDIR,runFolder,outputPhysicsDirectory);

%fc = frontClass();

%2019
ignoreMinConstraints = 1;
[fc, numfc, folder, syncDatName, syncStatName, runName, phy, midName, sn, timeMinI] = ReadAllSyncFile(frontAllPath, frontFileName, addedParas, ignoreMinConstraints);

outvec = struct('var',[],'static',[]);

%if fc.numFiles ~= 0
if numfc ~= 0
    
    outvec.var = struct('count',[],'measure',[],'names',{{}},'vals',[],'covs',[]);
    
    if skipstatics == 0
        outvec.static = struct('serial',[],'t',[],...
            'enActive',energiesActive,'en',[],'enClass',[],...
            'ssActive',(stress_strain==1 || stress_strain==2),'ss',[]);
    else
        outvec.static = staticvec;
    end
    
    strStrnOut = -1;
    if skipstatics == 0
        %CheckBeforeWriting:1
        %Overwrite:2
        [~,rFolder,~] = fileparts(runFolder);
        ssfilePath = fullfile(frontAllPath,frontDir,[rFolder,'.',pdext]);
        ssfileExist = isFile(ssfilePath);
        if stress_strain == 2 || (stress_strain == 1 && ssfileExist == 0)
            strStrnOut = fopen(ssfilePath,'w');
            data = cell(numfc,1);
            vspecObj = Vector_syncSpec();
        end
        
        outvec.static.t = repmat([inf -inf],numfc,1);
        outvec.static.serial = -1.*ones(numfc,1);
    end
    
    outvec.var.count = zeros(numfc,1);
    outvec.var.measure = zeros(numfc,1);
    
    %zzz
    for s = 400:numfc
        intermFileName = sprintf('%s%s%s%010d_%s.%s',...
            fc{s,runName},...
            fc{s,phy},...
            fc{s,midName},...
            str2double(fc{s,sn}),...
            vdsFileSuffix,...
            ext);
        energyFileName = sprintf('EDenergy%s_All_%i.%s',...
            frontFileName,...
            str2double(fc{s,sn}),...
            'txt');
        
        inputFile = fullfile(frontAllPath,vdsDir,intermFileName);
        energyFile = fullfile(frontAllPath,fc{s,folder},energyFileName);
        stattxtFile = fullfile(frontAllPath,...
            fc{s,folder},...
            sprintf('%s%s%s%010d.%s',...
            fc{s,runName},...
            fc{s,phy},...
            fc{s,midName},...
            str2double(fc{s,sn}),...
            'txt'));
        
        %outvec{s} = ReadVDatStatsFile(inputFile);
        outvec.var = ReadVDatStatsFileMatrix(outvec.var,inputFile,s);
        
        if skipstatics == 0
            if outvec.static.enActive == 1
                ef = energyFrontClass(energyFile);
                if ~isempty(ef)
                    outvec.static.en(:,:,s) = getAllEnergies(ef);
                    outvec.static.enClass = ef;
                end
            end
            
            if strStrnOut > 0
                data = PvsDisp(vspecObj, stattxtFile, edgeFlg);
                %==============
                %OUTPUT
                % HARDCODED FOR NOW SINCE WE KNOW ITS 4 FLAGS (2,3,4,5)
                fprintf(strStrnOut,'%.20f\t%i\t%.20f\t%.20f\t%.20f\t%.20f\t%.20f\t%i\t%.20f\t%.20f\t%.20f\t%.20f\t%.20f\t%i\t%.20f\t%.20f\t%.20f\t%.20f\t%.20f\t%i\t%.20f\t%.20f\t%.20f\t%.20f\t%.20f\n',...
                    data{end}.T,...
                    edgeFlg(1), data{1}.L(data{1}.L~=0.0), data{1}.P(1), data{1}.P(2), data{1}.U(1), data{1}.U(2),...
                    edgeFlg(2), data{2}.L(data{2}.L~=0.0), data{2}.P(1), data{2}.P(2), data{2}.U(1), data{2}.U(2),...
                    edgeFlg(3), data{3}.L(data{3}.L~=0.0), data{3}.P(1), data{3}.P(2), data{3}.U(1), data{3}.U(2),...
                    edgeFlg(4), data{4}.L(data{4}.L~=0.0), data{4}.P(1), data{4}.P(2), data{4}.U(1), data{4}.U(2));
                %==============
            end
            
            %UPDATE TIME & STAT-FILE-SPECIFIC INFO
            statFile = fullfile(frontAllPath,...
                fc{s,folder},...
                sprintf('%s%s%s%010d.%s',...
                fc{s,runName},...
                fc{s,phy},...
                fc{s,midName},...
                str2double(fc{s,sn}),...
                'stat'));
            sfid = fopen(statFile,'r');
            [~,sdata] = readStatFile(sfid);
            try
                outvec.static.serial(s) = str2double(fc{s,sn});
                outvec.static.t(s,1) = sdata.timeMin;
                outvec.static.t(s,2) = sdata.timeMax;
            catch ME
                disp(ME);
            end
            fclose(sfid);
        end
    end
    
    if skipstatics == 0
        if strStrnOut > 0
            fclose(strStrnOut);
        end
        
        if outvec.static.ssActive == 1
            do_plot = 0;
            stress_strain_curves(ssfilePath, do_plot);
            [spath,sfile,~] = fileparts(ssfilePath);
            ssFile = fullfile(spath,[sfile,'.',ssext]);
            % t s00L s00R s01L s01R e00 e01 s11T s11B s10T s10B e11 e10
            outvec.static.ss = load(ssFile);
        end
    end
end
end