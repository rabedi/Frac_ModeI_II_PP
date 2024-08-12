function [zppCell] = ProcessSVEs(RVENumberString,SVENumberString,InteriorStressBool)
% This function is used to calculate the stress strain curves and other various
% damage parameters for each SVE.

if nargin < 1
    RVENumberString = 'RVE0';
end
if nargin < 2
    SVENumberString = 'SVE0';
end
if nargin < 3
    InteriorStressBool = 1;
end

addpath('../');
DataPath = '../../New_averageS/';
AverageDataPath = '../../HEMresults/';
ConfigFile = 'OSUConfig.txt';
DataExt = '.txt';

OSUConfig = readOSUConfig;
fida = fopen(ConfigFile,'r');
OSUConfig = readOSUConfig.ReadConfig(fida);
allRunsCell = cell(OSUConfig.numLCs, 1);

for i = 1:OSUConfig.numLCs
    allRunsCell{i} = zpp_DamageHomogenization1RConfig;
    fidc = fopen(OSUConfig.ConfigPaths{i}, 'r');
    allRunsCell{i} = allRunsCell{i}.Read(fidc);
    fclose(fidc);
end



runMap = gen_map;
%fidr = fopen('runMap.txt', 'r');
%[buf, success] = runMap.Read_gen_Map(fidr);
%fclose(fidr);

for i = 1:OSUConfig.numLCs
    rawData = gen_textIndexedDatasets;
    LCNo = i-1;
    LCNoString = num2str(LCNo);
    LCString = strcat('LC',LCNoString);
    SVEFileString = strcat(RVENumberString,SVENumberString,LCString,DataExt);
    filename = strcat(DataPath,LCString,'/',SVEFileString);
    [sz,StressStrain] = ImportStressStrainData(filename,InteriorStressBool);
    rawData = rawData.Initialize(sz, 'time');
    rawData = rawData.AddDataSetFirstPt(0, 'zpr_stnst_xx', 0);
    rawData = rawData.AddDataSetFirstPt(0, 'zpr_stnst_yy', 0);
    rawData = rawData.AddDataSetFirstPt(0, 'zpr_stnst_xy', 0);
	rawData = rawData.AddDataSetFirstPt(0, 'zpr_stssh_xx', 0);
    rawData = rawData.AddDataSetFirstPt(0, 'zpr_stssh_yy', 0);
    rawData = rawData.AddDataSetFirstPt(0, 'zpr_stssh_xy', 0);
    rawData = rawData.AddDataSetFirstPt(0, 'zpr_d', 0);
    
    for j = 1:sz
    	t = StressStrain(j,1);
        rawData.xAxesVals(j) = t;
        rawData.data{1}{j} = StressStrain(j,2);
        rawData.data{2}{j} = StressStrain(j,3);
        rawData.data{3}{j} = StressStrain(j,4);
    
        rawData.data{4}{j} = StressStrain(j,5);
        rawData.data{5}{j} = StressStrain(j,6);
        rawData.data{6}{j} = StressStrain(j,7);
        
        rawData.data{7}{j} = StressStrain(j,8);
    end
    
    rawDataCell{i} = rawData;
    
end

E = 1;
nu = 0.3;
planeMode = 1; % 0 1D, 1 p.stn, 2 p.sts, 3 3D
t0 = 0;
%C = StiffnessEquations(rawDataCell);
C = AverageStiffnessCalculation(RVENumberString,SVENumberString,AverageDataPath);
normalizationsUVSEpsIn = [1 1 1 1];

VoigtMatrix = [1,1;2,1;1,-1;2,-1];

fclose(fida);

for i = 1:OSUConfig.numLCs
    zpp = zpp_DamageHomogenization1R;
    allRuns_zppConfig = allRunsCell{i};
    raw = rawDataCell{i};
    zpp = zpp.Initialize4DGRuns(allRuns_zppConfig, runMap, E, nu, planeMode, normalizationsUVSEpsIn, t0, C);
    
    StrsVoigtPos = VoigtMatrix(i,1);
    StrsSign = VoigtMatrix(i,2);
    
    zpp = zpp.Process(raw,StrsVoigtPos, StrsSign);
 
%     eps =  zpp.getDataVectorByDataName('zpp_eps_scalar');
%     sig =  zpp.getDataVectorByDataName('zpp_sig_scalar');
%     plot(eps, sig);  
    zppCell{i} = zpp;
    
    LCName = i-1;
    LCNameString = num2str(LCName);
    Path = strcat(DataPath,'OutputFiles/');
    filename = strcat(Path,RVENumberString,SVENumberString,'LC',LCNameString,'Processed');
    fidzzc = fopen([filename, '.out'], 'w');
    zpp.toFile(fidzzc);
    fclose(fidzzc);
    clear zpp
end

end