clear all
addpath('../');
% Create a fake data set where damage initiated at strain = 0.5 and
% completes at strain = 1
rawData = zpp_FakeDamageSet;

% next lines specify the configuration files that specifies how to go from
% raw strain-stress data to processed energies, damage model, etc.
allRuns_zppConfig = zpp_DamageHomogenization1RConfig;
fidc = fopen('zpp_config.txt', 'r');
allRuns_zppConfig = allRuns_zppConfig.Read(fidc);
fclose(fidc);

% for a particular run, we can provide additional parameters that can
% affect going from raw strain / stress data to homogenized damage and
% critical points. These additional parameters are stored in a map that is
% in the form of a string key to a string value (string value is turned to
% a number is needed). An example is ( serialMax	399 ) that the user
% manuallry specifies to ignore whatever data is for this data set after serial number 399
runMap = gen_map;
fidr = fopen('runMap.txt', 'r');
[buf, success] = runMap.Read_gen_Map(fidr);
fclose(fidr);

% specifying C matrix, it can be specified by E, nu, plain mode if material
% is isotropic in 2D, otherwise full C is needed.

E = 1;
nu = 0.3;
planeMode = 1; % 0 1D, 1 p.stn, 2 p.sts, 3 3D
t0 = 0;
C = [];

%Say raw data is specified in GPa but we want to present stresses in MPa, or other scenarios like this. In this case, we want to specify what is the scale of raw data quantities (relative to what we want them to be). The order of scales is:
%U, V, stress, epsilon
normalizationsUVSEpsIn = [0.0001 0.0862 0.1  0.1];

% raw data (zpr) to processed data (zpp)
zpp = zpp_DamageHomogenization1R;
zpp = zpp.Initialize4DGRuns(allRuns_zppConfig, runMap, E, nu, planeMode, normalizationsUVSEpsIn, t0, C);
zpp = zpp.Process(rawData, 1, 1);

% Once zpp data is created it can be stored and read back for future use:
nm = 'zzpProcessed';
fidzzc = fopen([nm, '.orig'], 'w');
zpp.toFile(fidzzc);
fclose(fidzzc);

zpp = cell(0);
zpp = zpp_DamageHomogenization1R;

fidzzc = fopen([nm, '.orig'], 'r');
zpp = zpp.fromFile(fidzzc);
fclose(fidzzc);

fidzzc = fopen([nm, '2.orig'], 'w');
zpp.toFile(fidzzc);
fclose(fidzzc);

plt = 1;
if (plt)
    x = 1:length(zpp.pData.xAxesVals);
    xVals = zpp.pData.xAxesVals;
    for fld = 1:zpp.pData.numDataSets
        y = zpp.pData.getDataVectorByDataIndex(fld);
        plot(xVals, y);
        ylabel(zpp.pData.dataNames{fld});
    %    xlim([390, 392]);
    %    xlim([.97, 0.975]);
        print('-dpng', [num2str(fld), '.png']);
    end
end


fidfld = fopen('_testZPP.txt', 'r');
fidfldo = fopen('_testZPP.out', 'w');

buf = READ(fidfld,'s');
buf = READ(fidfld,'s');
cntr = 0;
while (strcmp(buf, '}') == 0)
    cntr = cntr + 1;
    flds{cntr} = buf;
    buf = READ(fidfld,'s');
end
fclose(fidfld);
for i = 1:length(flds)
    dataName = flds{i};
    data = zpp.getDataVectorByDataName(dataName);

    fprintf(fidfldo, '\n\n%s\n', dataName);
    gen_toFile_matrix(fidfldo, data);
end

fclose(fidfldo);
