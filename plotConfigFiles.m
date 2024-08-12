function plotConfigFiles(configName, configDirectory)
addpath('LEFM','LEFMsemiInfinite');

global IconfigDirectory;
global IconfigName;
global IflagNoIn;
global IprintOption;
global IplotXuNData;
global IplotBlack;
global IplotEPS;
global IblankRowNInLegend;
global IblankTextInLegend;
global IdisableMarkers;
global IenableMarkerValues;


global IprintDltTtlLabel;
global IdrawLineSegmentes;
global IonlyDrawSize2SolUnit;


global IoutputFolder;
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
global ImaxRelativeSpacePoint2PlotHistories;
global ImaxSpaceDotInClusterReductionRel2cR;
global IallowOverwriteOfRunParameters;



global IaddIntegrateData;
global IitegateDataFileName;
global IderDataFileName;
global IitegrationNormalizationOption;
global IplotAddCRVS;
%global IplotAddCRVSLabel;
%global IplotAddCRVSlColor;
global IplotAddCRVSlStyle;
global IplotAddCRVSlWidth;


global cnfg;
global IdoReg;
tic

if (nargin < 2)
    configDirectory = '';
end




[cnfg, confFid] = readBaseConfigFile(configName, configDirectory);
outputFolder = cnfg{IoutputFolder};
generateHistoryfiles = cnfg{IgenerateHistoryFiles};
siz = length(cnfg{IflagNoIn});
 
flags = cnfg{IflagNoIn};
doReg = cnfg{IdoReg};


regenerateDataFile = 1;

if (cnfg{IplotEPS} == 1)

    if (cnfg{IplotBlack} ~= 1)
        for i = 1: siz
            clear cnfg;
            [cnfg, confFid] = readBaseConfigFile(configName, configDirectory);
            regenerateDataFile = generateHistoryfiles;
            plotConfigFilesSingleFlag(outputFolder, regenerateDataFile, confFid, flags(i), 1, 0);
            regenerateDataFile = 0;
            fclose('all');
        end
    end



    if (cnfg{IplotBlack} ~= 0)
        for i = 1: siz
            clear cnfg;
            cnfg{IoutputFolder} = [];
            [cnfg, confFid] = readBaseConfigFile(configName, configDirectory);
            if (regenerateDataFile == 1)
                regenerateDataFile = generateHistoryfiles;
            end
            plotConfigFilesSingleFlag(outputFolder, regenerateDataFile, confFid, flags(i), 1, 1);
            regenerateDataFile = 0;
            fclose('all');
        end
    end
end


if ((doReg == 0) && (cnfg{IplotEPS} == 1))
    toc
    cls_
    return;
end

if (cnfg{IplotBlack} ~= 1)
    for i = 1: siz
        clear cnfg;
        cnfg{IoutputFolder} = [];
        [cnfg, confFid] = readBaseConfigFile(configName, configDirectory);
        if (regenerateDataFile == 1)
            regenerateDataFile = generateHistoryfiles;
        end
        plotConfigFilesSingleFlag(outputFolder, regenerateDataFile, confFid, flags(i), 0, 0);
        regenerateDataFile = 0;
        fclose('all');
    end
end



if (cnfg{IplotBlack} ~= 0)
    for i = 1: siz
        clear cnfg;
        cnfg{IoutputFolder} = [];
        [cnfg, confFid] = readBaseConfigFile(configName, configDirectory);
        if (regenerateDataFile == 1)
            regenerateDataFile = generateHistoryfiles;
        end
        plotConfigFilesSingleFlag(outputFolder, regenerateDataFile, confFid, flags(i), 0, 1);
        regenerateDataFile = 0;
        fclose('all');
    end
end

toc
cls_