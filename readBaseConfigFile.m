function [cnfg, fid] = readBaseConfigFile(configName, configDirectory)

global allowBinary;
readSystemSetting(0);

global kappaOption_spz;
global kappaOptionMyEstimate_spz;
global beta_rpv_rps;
global distnceRatio_rpv2SingularVelocityCore;

global IconfigDirectory;
global IconfigName;
global IflagNoIn;
global IprintOption;
global IplotXuNData;
global IplotBlack;
global IplotEPS;
global IblankRowNInLegend;
global IblankTextInLegend;
global Icoord2sIndex;
global IdisableMarkers;
global IenableMarkerValues;
global IdisableMarkers;
global IenableMarkerValues;
global IdisableElementBndry;
global IelementBndryMarkerSize;
global IdisableProcessZones;
global IdisableExtrmmValues;
global IdisableLocalExtrmmValues;
global IplotAroundProcessZoneFactor;
global IplotAroundProcessZoneMinValues;
global IplotAroundProcessZoneMaxValues;

global IprintDltTtlLabel;
global IdrawLineSegmentes;
global IonlyDrawSize2SolUnit;


global IoutputFolder;
global IappendRunMidName2OutFldr;
global IreadStat;
global IreadStatFinalTime;
global IStatFinalTimeName;
global IreadHistories;
global IgenerateHistoryFiles;
global ImaxPower_historyDerInfow;
global IhistoryFileName;
global IhistoryStatFileName;
global IcracktipVSymbol;
global IcracktipVIndex;
global IprocessZoneSymbol;
global IprocessZoneIndex;
global IprocessZoneRelativeCrackOpeningSymbol;
global IprocessZoneRelativeCrackOpeningIndex;
global IprocessZoneCrackOpeningSymbol;
global IprocessZoneCrackOpeningIndex;
global ICrackOpeningSymbol;
global ICrackOpeningIndex;
global IcohesiveZoneSizeFileName;
global IcohesiveZoneSizeConfigFileName;
global ImodifierForHistoryFiles;
global IAddSerialNumber2ModifedFilesBasedOnRunOrder;
global ImaxRelativeSpacePoint2PlotHistories;
global ImaxSpaceDotInClusterReductionRel2cR;
global IallowOverwriteOfRunParameters;

global IaddIntegrateData;
global IitegateDataFileName;
global IderDataFileName;
global IitegrationNormalizationOption;
global ImaxPowerRatioEReleaseRate;

global IplotAddCRVS;
%global IplotAddCRVSLabel;
%global IplotAddCRVSlColor;
global IplotAddCRVSlStyle;
global IplotAddCRVSlWidth;

global Iadd_LEFM_Data;
global ImaxPowerRatioRelativeProcessZoneSize;
global I_LEFMAngle_resolution;
global I_LEFMnumPtPerT;
global I_LEFMnumPtPerRamp;
global I_LEFM_rSigMethod;
global I_LEFM_rVelMethod;
global I_LEFM_rVelDir;

global I_TS_addData;
global I_TS_StatName;
global I_TS_readOnlyStat;
global I_TS_SliceDataName;
global I_TS_sliceReadFlag;
global I_TS_derOptionForTimeDerivatives;
global I_TS_interpolantOptCZEndPoints;
global I_TS_maxPowerVelocitiesRoundOff;
global I_TS_processZoneValSymbol;
global I_TS_processZoneValIndex;
global I_TS_processZoneNormalizerRunFlagData;
global I_TS_numReqFlds;
global I_TS_ReqFldsSymbol;
global I_TS_ReqFldsIndex;
global I_TS_ReqFldsFinderType;
global I_TS_ReqFldsNormalizerType;
global I_TS_numCollectFlds;
global I_TS_CollectFldsSymbol;
global I_TS_CollectFldsIndex;
global I_TS_CollectFldsNormalizerType;
global I_TS_ReqFlds;
global I_TS_CollectFlds;
global I_TS_totalFldsPerReqFld;

global IstartCohNormalizer;
global IincrmCohNormalizer;
global IstartLoadNormalizer;
global IincrmLoadNormalizer;

global Ilfs;
global Itfs;
global Ipltfs;
global Isymfs;
global IxminT;   
global IyminT;
global Idlwidth;
global Idhhlwidth;
global Idhdlwidth;
global IdLlwidth;
global Ipsfrag;
global IwriteTitleEPS;
global IpsfragSym;
global IdoReg;
global IShowArrowheadSwitch;
global IRegFlNo;
global IRegCrvNo;
global IRegPlotNo;
global IsymfsReg;
global Iafctr;
global Iaafctrb;
global Iaafctrh;
global Ibfctr;
global Ibafctrb;
global Ibafctrh;


setGlobalValues();

if nargin < 2
    configDirectory = '';
end

if (strcmp(configDirectory , '') ~= 1)
    configDirectory = [configDirectory, '/'];
end

fileName = [configDirectory, configName];

cnfg{IconfigDirectory} = configDirectory;
cnfg{IconfigName} = configName;

fid = fopen(fileName, 'r');

tmp = fscanf(fid, '%s', 1);
start = fscanf(fid, '%d', 1);
step = fscanf(fid, '%d', 1);
endV = fscanf(fid, '%d', 1);
if (endV < 0)
    endV = start;
end

cnfg{IflagNoIn} = start:step:endV;


tmp = fscanf(fid, '%s', 1);
cnfg{kappaOption_spz} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{kappaOptionMyEstimate_spz} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{beta_rpv_rps} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{distnceRatio_rpv2SingularVelocityCore} = fscanf(fid, '%lg', 1);



tmp = fscanf(fid, '%s', 1);
cnfg{IprintOption} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IplotXuNData} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IplotAddCRVS} = fscanf(fid, '%d', 1);

%tmp = fscanf(fid, '%s', 1);
%cnfg{IplotAddCRVSLabel} = fscanf(fid, '%s', 1);

%tmp = fscanf(fid, '%s', 1);
%cnfg{IplotAddCRVSlColor} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IplotAddCRVSlStyle} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IplotAddCRVSlWidth} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IplotBlack} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IplotEPS} = fscanf(fid, '%d', 1);


tmp = fscanf(fid, '%s', 1);
haveBlankLinesInLegend = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
sizeBlankRowsInLegend = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
for i = 1:sizeBlankRowsInLegend
    cnfg{IblankRowNInLegend}(i) = fscanf(fid, '%d', 1);
end

tmp = fscanf(fid, '%s', 1);
for i = 1:sizeBlankRowsInLegend
    cnfg{IblankTextInLegend}{i} = fscanf(fid, '%s', 1);
end

if (haveBlankLinesInLegend == 0)
    cnfg{IblankRowNInLegend} = [];
    cnfg{IblankTextInLegend} = cell(0);
end
    
tmp = fscanf(fid, '%s', 1);
cnfg{Icoord2sIndex} = fscanf(fid, '%d', 1) + 1;

tmp = fscanf(fid, '%s', 1);
cnfg{IdisableMarkers} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
num = fscanf(fid, '%d', 1);
cnfg{IenableMarkerValues} = fscanf(fid, '%d', num);

tmp = fscanf(fid, '%s', 1);
cnfg{IelementBndryMarkerSize} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IdisableElementBndry} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IdisableProcessZones} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IdisableExtrmmValues} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IdisableLocalExtrmmValues} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IplotAroundProcessZoneFactor} = fscanf(fid, '%lg', 1);

cnfg{IplotAroundProcessZoneMinValues} = inf * ones(1, 4);
cnfg{IplotAroundProcessZoneMaxValues} = -inf * ones(1, 4);




tmp = fscanf(fid, '%s', 1);
cnfg{IprintDltTtlLabel} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IdrawLineSegmentes} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IonlyDrawSize2SolUnit} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IoutputFolder} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IappendRunMidName2OutFldr} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IreadStat} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IreadStatFinalTime} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IStatFinalTimeName} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IreadHistories} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IgenerateHistoryFiles} = fscanf(fid, '%d', 1);

if (cnfg{IreadHistories} == 0)
    cnfg{IgenerateHistoryFiles} = 0;
end

tmp = fscanf(fid, '%s', 1);
cnfg{IAddSerialNumber2ModifedFilesBasedOnRunOrder} = fscanf(fid, '%d', 1);


tmp = fscanf(fid, '%s', 1);
cnfg{ImaxPower_historyDerInfow} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IhistoryFileName} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IhistoryStatFileName} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IcracktipVSymbol} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IcracktipVIndex} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IprocessZoneSymbol} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IprocessZoneIndex} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IprocessZoneRelativeCrackOpeningSymbol} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IprocessZoneRelativeCrackOpeningIndex} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IprocessZoneCrackOpeningSymbol} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IprocessZoneCrackOpeningIndex} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{ICrackOpeningSymbol} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{ICrackOpeningIndex} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IcohesiveZoneSizeFileName} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IcohesiveZoneSizeConfigFileName} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{ImodifierForHistoryFiles} = fscanf(fid, '%s', 1);


tmp = fscanf(fid, '%s', 1);
cnfg{ImaxRelativeSpacePoint2PlotHistories} = fscanf(fid, '%lg', 1);
if (cnfg{ImaxRelativeSpacePoint2PlotHistories} < 0)
    cnfg{ImaxRelativeSpacePoint2PlotHistories} = 1.0;
end

tmp = fscanf(fid, '%s', 1);
cnfg{ImaxSpaceDotInClusterReductionRel2cR} = fscanf(fid, '%lg', 1);
if (cnfg{ImaxSpaceDotInClusterReductionRel2cR} < 0)
    cnfg{ImaxSpaceDotInClusterReductionRel2cR} = inf;
end



tmp = fscanf(fid, '%s', 1);
cnfg{IallowOverwriteOfRunParameters} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IaddIntegrateData} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IitegateDataFileName} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IderDataFileName} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IitegrationNormalizationOption} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{ImaxPowerRatioEReleaseRate} = fscanf(fid, '%lg', 1);



tmp = fscanf(fid, '%s', 1);
cnfg{Iadd_LEFM_Data} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{ImaxPowerRatioRelativeProcessZoneSize} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_LEFMAngle_resolution} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_LEFMnumPtPerT} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_LEFMnumPtPerRamp} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_LEFM_rSigMethod} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_LEFM_rVelMethod} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_LEFM_rVelDir} = fscanf(fid, '%d', 1);



tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_addData} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_StatName} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_readOnlyStat} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_SliceDataName} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_sliceReadFlag} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_derOptionForTimeDerivatives} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_interpolantOptCZEndPoints} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_maxPowerVelocitiesRoundOff} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_processZoneValSymbol} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_processZoneValIndex} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_processZoneNormalizerRunFlagData} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_numReqFlds} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
for i = 1:cnfg{I_TS_numReqFlds}
    cnfg{I_TS_ReqFldsSymbol}{i} = fscanf(fid, '%s', 1);
end
tmp = fscanf(fid, '%s', 1);
for i = 1:cnfg{I_TS_numReqFlds}
    cnfg{I_TS_ReqFldsIndex}{i} = fscanf(fid, '%d', 1);
end
tmp = fscanf(fid, '%s', 1);
for i = 1:cnfg{I_TS_numReqFlds}
    cnfg{I_TS_ReqFldsFinderType}{i} = fscanf(fid, '%s', 1);
end

tmp = fscanf(fid, '%s', 1);
for i = 1:cnfg{I_TS_numReqFlds}
    tmp = fscanf(fid, '%d', 1);
    if (tmp == 0)
        cnfg{I_TS_ReqFldsNormalizerType}{i} = 'relCoh';
    elseif (tmp == 1)
        cnfg{I_TS_ReqFldsNormalizerType}{i} = 'relLoad';
    else
        cnfg{I_TS_ReqFldsNormalizerType}{i} = 'none';
    end
end

for i = 1:cnfg{I_TS_numReqFlds}
    cnfg{I_TS_ReqFlds}{i}{1} = cnfg{I_TS_ReqFldsSymbol}{i};
    cnfg{I_TS_ReqFlds}{i}{2} = cnfg{I_TS_ReqFldsIndex}{i};
    cnfg{I_TS_ReqFlds}{i}{3} = cnfg{I_TS_ReqFldsFinderType}{i};
    dim = -1;
    if (strcmp(cnfg{I_TS_ReqFldsSymbol}{i}, 'fld0') == 1)
        dim = 0;
    elseif (strcmp(cnfg{I_TS_ReqFldsSymbol}{i}, 'fld1') == 1)
        dim = 1;
    elseif (strcmp(cnfg{I_TS_ReqFldsSymbol}{i}, 'flds') == 1)
        dim = 2;
    end
    if (dim < 0)
        cnfg{I_TS_ReqFldsNormalizerType}{i} = 'none';
    end

    cnfg{I_TS_ReqFlds}{i}{4} = cnfg{I_TS_ReqFldsNormalizerType}{i};
    cnfg{I_TS_ReqFlds}{i}{5} = dim;
end


tmp = fscanf(fid, '%s', 1);
cnfg{I_TS_numCollectFlds} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
for i = 1:cnfg{I_TS_numCollectFlds}
    cnfg{I_TS_CollectFldsSymbol}{i} = fscanf(fid, '%s', 1);
end
tmp = fscanf(fid, '%s', 1);
for i = 1:cnfg{I_TS_numCollectFlds}
    cnfg{I_TS_CollectFldsIndex}{i} = fscanf(fid, '%d', 1);
end
tmp = fscanf(fid, '%s', 1);
for i = 1:cnfg{I_TS_numCollectFlds}
    tmp = fscanf(fid, '%d', 1);
    if (tmp == 0)
        cnfg{I_TS_CollectFldsNormalizerType}{i} = 'relCoh';
    elseif (tmp == 1)
        cnfg{I_TS_CollectFldsNormalizerType}{i} = 'relLoad';
    else
        cnfg{I_TS_CollectFldsNormalizerType}{i} = 'none';
    end
end

for i = 1:cnfg{I_TS_numCollectFlds}
    cnfg{I_TS_CollectFlds}{i}{1} = cnfg{I_TS_CollectFldsSymbol}{i};
    cnfg{I_TS_CollectFlds}{i}{2} = cnfg{I_TS_CollectFldsIndex}{i};

    dim = -1;
    if (strcmp(cnfg{I_TS_CollectFldsSymbol}{i}, 'fld0') == 1)
        dim = 0;
    elseif (strcmp(cnfg{I_TS_CollectFldsSymbol}{i}, 'fld1') == 1)
        dim = 1;
    elseif (strcmp(cnfg{I_TS_CollectFldsSymbol}{i}, 'flds') == 1)
        dim = 2;
    end
    if (dim < 0)
        cnfg{I_TS_CollectFldsNormalizerType}{i} = 'none';
    end
    cnfg{I_TS_CollectFlds}{i}{4} = cnfg{I_TS_CollectFldsNormalizerType}{i};
    cnfg{I_TS_CollectFlds}{i}{5} = dim;

end
    

cnfg{I_TS_totalFldsPerReqFld} = (3 + cnfg{I_TS_numCollectFlds}) * 2;

tmp = fscanf(fid, '%s', 1);
cnfg{Ilfs} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Itfs} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Ipltfs} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Isymfs} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IxminT} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IyminT} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Idlwidth} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Idhhlwidth} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Idhdlwidth} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IdLlwidth} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Ipsfrag} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IwriteTitleEPS} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IpsfragSym} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IdoReg} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IShowArrowheadSwitch} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IRegFlNo} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IRegCrvNo} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IRegPlotNo} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IsymfsReg} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Iafctr} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Iaafctrb} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Iaafctrh} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Ibfctr} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Ibafctrb} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{Ibafctrh} = fscanf(fid, '%lg', 1);


if (strcmp(cnfg{IoutputFolder}, '') ~= 1)
    b_dir = isdir(cnfg{IoutputFolder});
    if (b_dir == 1)
    %    rmdir(cnfg{IoutputFolder},'s');
    else
        mkdir(cnfg{IoutputFolder});
    end
    cnfg{IoutputFolder} = [cnfg{IoutputFolder}, '/'];
end


cnfg{IstartCohNormalizer} = 100;
cnfg{IincrmCohNormalizer} = 100;
cnfg{IstartLoadNormalizer} = 150;
cnfg{IincrmLoadNormalizer} = 100;
