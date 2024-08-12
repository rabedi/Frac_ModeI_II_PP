clear all
rawData = zpp_FakeDamageSet;

allRuns_zppConfig = zpp_DamageHomogenization1RConfig;
fidc = fopen('zpp_config.txt', 'r');
allRuns_zppConfig = allRuns_zppConfig.Read(fidc);
fclose(fidc);

runMap = gen_map;
fidr = fopen('runMap.txt', 'r');
[buf, success] = runMap.Read_gen_Map(fidr);
fclose(fidr);

E = 1;
nu = 0.3;
planeMode = 1; % 0 1D, 1 p.stn, 2 p.sts, 3 3D
normalizationsUVSEpsIn = [0.0001 0.0862 0.1  0.1];
t0 = 0;
C = [];

zpp = zpp_DamageHomogenization1R;
zpp = zpp.Initialize4DGRuns(allRuns_zppConfig, runMap, E, nu, planeMode, normalizationsUVSEpsIn, t0, C);


zpp = zpp.Process(rawData);

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
