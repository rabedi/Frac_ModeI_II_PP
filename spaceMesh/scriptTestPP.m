addpath('../');
if 0
    fidm = fopen('__mapTest.txt', 'r');
    map = gen_map;
%    map = map.Read_gen_Map(fidm);
     map.Read_gen_Map(fidm);
     [val, valid] = map.AccessNumber('timeMax')
     [val, valid] = map.AccessNumber('eps00Max')
     [val, valid] = map.AccessNumber('eps11Max')
     [val, valid] = map.AccessNumber('name')
     
     pos = map.AddKeyVal('name', 'www')
     [val, pos2] = map.AccessStr('name')
    
     map2 = gen_map;
     pos = map2.AddKeyVal('qq', 'qqqq')
     pos = map2.AddKeyVal('timeMax', '200')
     pos = map2.AddKeyVal('eps00Max', '2.324')

 	map.AppendOtherMap(map2)
end

if 0
    ww(1, 3) = 12;
    ww(2, 1) = 2;
    ww(1, 2) = log(-1);
    ww(1, 1) = nan;
    ww(2, 2) = inf;
    ww(2, 3) = 1/0;
    zw = 12;
    fido = fopen('outTest.txt', 'w');
    gen_toFile_matrix(fido, ww);
    gen_toFile_matrix(fido, zw);
    fclose(fido);
    fidi = fopen('outTest.txt', 'r');
    wwr = gen_fromFile_matrix(fidi)
    zr = gen_fromFile_matrix(fidi)
    fclose(fidi);
end
if 0
    crackStat = pp_stat_crackDir;
    doSymXYRealization = 1; %1;
    numSegments = -4; %-4;
    numRegions = 4;
    if (doSymXYRealization)
        numRegions = 4;
    end    
    useCracklength = 1;
    crackStat = crackStat.Initialize(numSegments, useCracklength);
    num = 1000;
    minAngle = 30;
    maxAngle = 40;
    thetMean = (minAngle + maxAngle) / 2;
    thetaSymXYIncrement = 180 - 2 * thetMean;
    
    delAngle = maxAngle - minAngle;
    for j = 1:numRegions
        if (doSymXYRealization == 0)
            thetBase = 360 * (j - 1) / numRegions;
        else
            if (j == 1)
                thetBase = 0;
            elseif (j == 2)
                thetBase = thetaSymXYIncrement;
            elseif (j == 3)
                thetBase = 180;
            elseif (j == 4)
                thetBase = 180 + thetaSymXYIncrement;
            end
        end
        for i = 1:num
            angle = thetBase + minAngle + delAngle * rand();
            crackLength = rand();
            angleRad = angle * pi / 180;
            crackOrientation = [cos(angleRad), sin(angleRad)];
            crackStat = crackStat.Update(crackOrientation, crackLength);
        end
    end
    crackStat = crackStat.Finalize();
    crackStat
end

if 0
    z = pp_energyDispBoundary;
    z = z.SetDomainCentroid([1e-16, 1e-16]);
    numPoints = 3;
    Xs = cell(numPoints, 1);
    Us = cell(numPoints, 1);
    Vs = cell(numPoints, 1);
    Trcns = cell(numPoints, 1);

    Xs{1} = [-0.484375	-0.5];
    Xs{2} = [-0.488161	-0.5];
    Xs{3} = [-0.491947	-0.5];

    Us{1} = [-0.0644611	-1.27E-06];
    Us{2} = [-0.064486	5.36E-07];
    Us{3} = [-0.0645607	1.17E-06];

    Trcns{1} = [0.00768283	0.000238942];
    Trcns{2} = [0.0806681	0.000709102];
    Trcns{3} = [0.14737	0.00040291];

    Vs{1} = [-0.0278348	1.14E-06];
    Vs{2} = [-0.0278342	9.68E-07];
    Vs{3} = [-0.0278337	8.15E-07];

    z = z.UpdateBySegment(Xs, Us, Trcns, Vs);
end

if 0
    gti = gen_textIndexedDatasets;
    numPts = 6;
    gti = gti.Initialize(numPts, 'x');
    gti = gti.AddDataSetFirstPt([0 1; 2 3], 'stress');
    gti = gti.AddDataSetFirstPt(12.3, 'energy');
    gti = gti.AddDataSetFirstPt([1 2], 'vecRow');
    gti = gti.AddDataSetFirstPt([2; 3], 'vecCol');
    for pt = 2:numPts
        dt = rand(2, 2);
        gti.data{1}{pt} = dt;
        
        dt = rand();
%        gti.data{2}(pt) = dt;
        gti.data{2}{pt} = dt;

        dt = rand(1, 2);
        gti.data{3}{pt} = dt;

        dt = rand(2, 1);
        gti.data{4}{pt} = dt;
    end
    for pt = 1:numPts
        gti.xAxesVals(pt) = pt * pt;
    end
    
    vc1 = gti.getDataVectorByDataName('stress', 2, 1);
    vc2 = gti.getDataVectorByDataName('energy');
    vc3 = gti.getDataVectorByDataName('vecRow');
    vc4 = gti.getDataVectorByDataName('vecCol', 2);

    c1 = gti.getDataCellByDataName('stress');
    c2 = gti.getDataCellByDataName('energy');
    c4 = gti.getDataCellByDataName('vecCol');
    extHeader = 'none';
    gti.toFile('testnameDat.out', extHeader);
    
    gti2 = gen_textIndexedDatasets;
    gti2 = gti2.fromFile('testnameDat.out');
    
    gti2.toFile('testnameDat2.out', extHeader);
end
    

if 0
    zwd = pp_energyDispWholeDomain;
    fileNameDatIn = '../../../old_2017_09_29_MicriUST_NA064_NP00_infxinf_tau1ep16em2_x_a013/physics/output_front/MicroSLfrontSync0000000399.txt';
    domainCentroidIn = [1e-16; 1e-16];
    step4ScalarCDFsIn = 0.1;
%	step4ScalarCDFsIn = [0.5, 0.7, 0.9, .999];
    numAngleRangesIn = 18;
    crackBinSizeIn = 180;
    newNormalizationsUVSEpsIn = [1; 1; 1; 1];
    sigmac = 0.1;
    E = 1;
    tau = 0.0011602387022306;
    delscale = 0.001;
    epsScale = sigmac / E; % sigmac / E
    vscale = delscale / tau;
    newNormalizationsUVSEpsIn = [1; 1; 1; 1];
    epsScale = 1;
    newNormalizationsUVSEpsIn = []; %1; 1; 1; 1];
    zwd = zwd.MainFunction(fileNameDatIn, domainCentroidIn, step4ScalarCDFsIn, numAngleRangesIn, crackBinSizeIn, newNormalizationsUVSEpsIn);
%    fido = fopen('outTestB.out', 'w');
%     nbegline = 2;
%     zwd.domainInteriorEdgesByFlagCombined.crackAngleStatWNumber.toFile(fido, nbegline);
%     fclose(fido);
%     
%     fidi = fopen('outTestB.out', 'r');
%     ppscd = pp_stat_crackDir;
%     ppscd = ppscd.fromFile(fidi);
%     fclose(fidi);
% 
%     fido = fopen('outTestC.out', 'w');
%     nbegline = 3;
%     ppscd.toFile(fido, nbegline);
%     fclose(fido);
% 
% 

%    fido = fopen('outTestB.out', 'w');
%     nbegline = 2;
%     zwd.domainInteriorEdgesByFlagCombined.toFile(fido, nbegline);
%     fclose(fido);
% 
%     fidi = fopen('outTestB.out', 'r');
%     tmpd = pp_energyDispInterior;
%     tmpd = tmpd.fromFile(fidi);
%     fclose(fidi);
% 
%     fido = fopen('outTestC.out', 'w');
%     nbegline = 3;
%     tmpd.toFile(fido, nbegline);
%     fclose(fido);


%     fido = fopen('outTestC.out', 'w');
%     nbegline = 3;
%     ppscd.toFile(fido, nbegline);
%     fclose(fido);
% 
% 

%    fido = fopen('outTestB.out', 'w');
%     nbegline = 2;
%     zwd.domainBCEdgesCombined.toFile(fido, nbegline);
%     fclose(fido);
% 
%     fidi = fopen('outTestB.out', 'r');
%     tmpd = pp_energyDispBoundary;
%     tmpd = tmpd.fromFile(fidi);
%     fclose(fidi);
% 
%     fido = fopen('outTestC.out', 'w');
%     nbegline = 3;
%     tmpd.toFile(fido, nbegline);
%     fclose(fido);

   fido = fopen('outTestB.out', 'w');
   nbegline = 0;
   zwd.toFile(fido, nbegline);
   fclose(fido);

    fidi = fopen('outTestB.out', 'r');
    tmpd = pp_energyDispWholeDomain;
    tmpd = tmpd.fromFile(fidi);
    fclose(fidi);

    fido = fopen('outTestC.out', 'w');
    nbegline = 0;
    tmpd.toFile(fido, nbegline);
    fclose(fido);
end

if 1
    ppar = pp_synFilesAllR;
    fidConf = fopen('_config_AllRun.txt');
    ppar = ppar.fromFile(fidConf);
    fclose(fidConf);
    
    pp1r = pp_synFiles1R;
%    pp1r.allRunsConfigs = ppar;
%    pp1r.frontAllPath = '../../../old_2017_09_29_MicriUST_NA064_NP00_infxinf_tau1ep16em2_x_a013/physics';
    frontAllPathIn = '../../../old_2017_09_29_MicriUST_NA064_NP00_infxinf_tau1ep16em2_x_a013/physics';
%    pp1r.
    % cpp refers to C++
    cpp_timeIndexStartIn = 0;
    addedParas = gen_map;
%    pos = addedParas.AddKeyVal('serialMin', '10');
%    pos = addedParas.AddKeyVal('serialMax', '15');
%    pos = addedParas.AddKeyVal('timeMax', '0.5');
    pp1r = pp1r.ProcessAllSyncFiles(frontAllPathIn, ppar, addedParas);
end

fclose('all');