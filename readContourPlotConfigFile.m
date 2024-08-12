function [confGen, confData, conf2DPlot, stepNumNew] = readContourPlotConfigFile(fid, stepNum)

global allowBinary;
readSystemSetting(1);

noFlag = 12e33;
tol = 1e-6;

global I_doLegend4OnlyCrackPath;
global I_cpLegendLocation;

global s_figContourMarkers;
global s_figContoursGen;

global s_maxNumRows2Read;
global s_maxNumRows2ReadBulk;
global s_maxNumRows2ReadBulkTotal;
global s_serialStartAbsolute;
global s_serialEndAbsolute;
global s_serialStart;
global s_serialStep;
global s_serialEnd;
global s_dirPreName;
global s_dirRunName;
global s_dirPostName;
global s_dir;
global s_runParaPreName;
global s_runParaPostName;
global s_runPara;
global s_runData;
global s_dirOut;
global s_runName;
global s_middlename;
global s_midNData;
global s_DataFrmt;
global s_brfStatName;
global s_brfStatFinalName;
global s_cnfgNmlzrName;
global s_coord2sIndex;

global s_x0_dsplcdShape;
global s_x0_cnfgOption;
global s_x0_extraMultplr;
global s_x0_factor;
global s_x1_dsplcdShape;
global s_x1_cnfgOption;
global s_x1_extraMultplr;
global s_x1_factor;
global s_printOptionExt;
global s_printOption;
global s_lfs;
global s_tfs;
global s_pltfs;
global s_symfs;
global s_xminT;
global s_yminT;


global s_plotTime;
global s_plotAxis;
global s_axisXLabel;
global s_axisYLabel;
global s_numFldsTot;
global s_numFlds;
global s_offset;
global s_numFldsAdded;
global s_optionFldsAdded;
global s_loadDirectionFldsAdded;
global s_numFldsTotOriginal;

global s_folderPostNameGeomMesh;
global s_fileNameGeomMesh;
global s_readOptionGeomMesh_cInacrive;
global s_GeomMeshCompFileName;
global s_clr_GeomMesh;
global s_style_GeomMesh;
global s_widthGeomMesh;

global maxNumPtsPerBox;
global precisionRowCounter;
global maxNumRowCounter;
global maxNumGridPtsSingleContour;
global maxNumGridPtsALLContour;
global maxNumDivisions;
global expansionRatio;
global doPlotSubPlotBounds;
global gColormapInput;

global xmin_all_ind;
global xmax_all_ind;
global ymin_all_ind;
global ymax_all_ind;

global ind_u0;
global ind_u1;
global s_times;
global s_startTimes;
global s_timeStep;

global s_startCohNormalizer;
global s_incrmCohNormalizer;
global s_startLoadNormalizer;
global s_incrmLoadNormalizer;

global p_number;
global p_name;
global p_exrnlN;
global p_cnfgBaseN;
global p_cnfgFN;
global p_cnfgCN;
global p_origin;
global p_logBase;
global p_pltFlag;
global p_xminV;
global p_xmaxV;
global p_yminV;
global p_ymaxV;
global p_zlimAbs;
global p_zminV;
global p_zmaxV;
global p_zBaseP;
global p_title;
global p_legLoc;

global p_totN;
global p_xlimB;
global p_ylimB;
global p_zlimB;

global ind_sl_sym;
global ind_sl_index;
global ind_sl_finderT;
global ind_sl_nrmlzrT;
global ind_sl_dim;
global ind_sl_name;
global ind_sl_MkrStyl;
global ind_sl_MkrClr;
global ind_sl_MkrSize;
global ind_sl_MkrActive;



global I_do2DColorPlot;
global I_plotTimeSlice;
global I_TS_StatName;
global I_TS_readOnlyStat;
global I_TS_SliceDataName;
global I_TS_sliceReadFlag;
global I_TS_derOptionForTimeDerivatives;
global I_TS_maxPowerVelocitiesRoundOff;
global I_TS_numReqFlds;
global I_TS_ReqFlds;

global I_TS_numCollectFlds;	
global I_TS_CollectFlds;	
global I_TS_numCollectOffset;

global I_x0C2D;		
global I_x1C2D;
global I_u0C2D;
global I_u1C2D;
global I_plotFld;
global I_fullFldSymbols;
global I_fullFldIndices;


global I_CrackTipDataName;
global I_CrackTipStatName;
global I_CrackTipFlagNum;
global I_CrackTipDataSerialNum;
global I_CrackTipReadFlag;
global I_CrackTipFldsName;
global I_CrackTipFldsMarkerStyle;
global I_CrackTipFldsMarkerColor;
global I_CrackTipFldsMarkerSize;
global I_CrackTipFldsMarkerActive;
global I_CrackTipVelSymIndex;
global I_CrackTipPZSizeSymIndex;
global I_CrackTipFullFldSymbols;
global I_CrackTipFullFldIndices;
global IplotAroundProcessZoneFactorX;
global IplotAroundProcessZoneFactorY;

global I_plotTwoSidedCrack;
global I_TwoSidedCrackDelu0Factor;
global I_TwoSidedCrackDelu1Factor;
global I_TwoSidedCrackDelu0FactorSideIn;
global I_TwoSidedCrackDelu0FactorSideOut;
global I_TwoSidedCrackDelu1FactorSideIn;
global I_TwoSidedCrackDelu1FactorSideOut;
global I_delu0C2D;
global I_delu1C2D;
global I_plotDistinctDamageLevels;
global I_numberDistDPts;
global I_damageLevelsFlag;
global I_DistDPts;
global I_plotOnlyCrackPath;
global I_xylimEqual2AlllimitsGivenPrev;
global I_activexlim_cp;
global I_xmin_cp;
global I_xmax_cp;
global I_activeylim_cp;
global I_ymin_cp;
global I_ymax_cp;

 
global idam_level;
global id_clr;
global id_lstyle;
global id_lwdth;

global s_plot_contours;


global startTimeIndex;
global endTimeIndex;
global timeIncrementInex;

global CTindex;

global EIndex;
global rhoIndex;
global nuIndex;
global plainStrainIndex;
global CdIndex;
global CsIndex;
global CrIndex;

global fnt_cnfgAddedFlds;
global pl_confAddedFlds;
global pf_plotsAddedFlds;
global pl_normalizersAddedFlds;
global figHandlesAddedFlds;
setGlobalValuesContour();

confGen = cell(0);

tmp = fscanf(fid, '%s', 1);
maxNumSlicesPerTime = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_maxNumRows2ReadBulk} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_maxNumRows2ReadBulkTotal} = fscanf(fid, '%d', 1);
if (confGen{s_maxNumRows2ReadBulkTotal} < 0)
    confGen{s_maxNumRows2ReadBulkTotal} = inf;
end
tmp = fscanf(fid, '%s', 1);
confGen{s_maxNumRows2Read} = fscanf(fid, '%d', 1);


tmp = fscanf(fid, '%s', 2);
confGen{s_serialStart} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_serialStep} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_serialEnd} = fscanf(fid, '%d', 1);
if (confGen{s_serialEnd} == -1)
    confGen{s_serialEnd} = confGen{s_serialStart};
end
confGen{s_serialStartAbsolute} = confGen{s_serialStart};
confGen{s_serialEndAbsolute} = confGen{s_serialEnd};


span = confGen{s_serialStart}:confGen{s_serialStep}:confGen{s_serialEnd};
len = length(span);
indexStart = 1 + stepNum * maxNumSlicesPerTime;
if (indexStart > len)
    fprintf(1, 'Error_indexStart > len\n');
    pause;
else
    confGen{s_serialStart} = span(indexStart);
    span = confGen{s_serialStart}:confGen{s_serialStep}:confGen{s_serialEnd};
    if (length(span) > maxNumSlicesPerTime)
        stepNumNew = stepNum + 1;
        confGen{s_serialEnd} = span(maxNumSlicesPerTime);
    else
        stepNumNew = -1;
    end
end
           

tmp = fscanf(fid, '%s', 1);
confGen{s_plot_contours} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_dirPreName} = '';
else
    confGen{s_dirPreName} = tmp;
end

tmp = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_dirRunName} = '';
else
    confGen{s_dirRunName} = tmp;
end

tmp = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_dirPostName} = '';
else
    confGen{s_dirPostName} = tmp;
end

tmp = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_runParaPreName} = '';
else
    confGen{s_runParaPreName} = tmp;
end

tmp = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_runParaPostName} = '';
else
    confGen{s_runParaPostName} = tmp;
end

confGen{s_dir} = [confGen{s_dirPreName} confGen{s_dirRunName} confGen{s_dirPostName}];
if (strcmp(confGen{s_dir}, '') == 0)
    confGen{s_dir} = [confGen{s_dir}, '/'];
end

paraName = [confGen{s_runParaPreName}  confGen{s_dirRunName} confGen{s_runParaPostName}];
fidRunPara = fopen(paraName , 'r');
if (fidRunPara < 0)
    fprintf(1, 'cannot open %s', paraName);
    pause;
end



confGen{s_runPara} = zeros(0,0);
confGen{s_runData} = zeros(0,0);
numFiles_ = fscanf(fidRunPara,'%d', 1);
runname_ = fscanf(fidRunPara,'%s', 1);
middlename_ = fscanf(fidRunPara,'%s', 1);
[confGen{s_runPara}, confGen{s_runData}, s_runSymPara] = readFlagValueData(fidRunPara, [], [], 0, confGen{s_runPara}, confGen{s_runData}, []);

tmp = fscanf(fid, '%s', 1);
confGen{s_dirOut} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
confGen{s_runName} = fscanf(fid, '%s', 1);
confGen{s_middlename} = 'SL';

if (strcmp(confGen{s_runName}, 'auto') == 1)
    confGen{s_runName} = runname_;
    confGen{s_middlename} = middlename_;    
end


confGen{s_startTimes} = confGen{s_runData}(startTimeIndex);
confGen{s_timeStep} = confGen{s_runData}(timeIncrementInex);

confGen{s_times} =  ((confGen{s_serialStart}:confGen{s_serialStep}:confGen{s_serialEnd}) - 1) * confGen{s_runData}(timeIncrementInex) ...
                    + confGen{s_runData}(startTimeIndex);

                
                
if (strcmp(confGen{s_dirOut}, 'same') == 1)
    confGen{s_dirOut} = dirName;
elseif (strcmp(confGen{s_dirOut}, 'runFolder') == 1)
    confGen{s_dirOut} = [confGen{s_runName} confGen{s_dirRunName}];
end

if (strcmp(confGen{s_dirOut}, '') ~= 1)
    b_dir = isdir(confGen{s_dirOut});
    if (b_dir == 1)
    %    rmdir(confGen{s_dirOut},'s');
    else
        mkdir(confGen{s_dirOut});
    end
    confGen{s_dirOut} = [confGen{s_dirOut}, '/'];
end



tmp = fscanf(fid, '%s', 1);
confGen{s_midNData} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
confGen{s_DataFrmt} = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_brfStatName} = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_brfStatFinalName} = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_cnfgNmlzrName} = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_coord2sIndex} = fscanf(fid, '%d', 1) + 1; 

tmp = fscanf(fid, '%s', 1);
confGen{s_folderPostNameGeomMesh} = fscanf(fid, '%s', 1); 

tmp = fscanf(fid, '%s', 1);
confGen{s_fileNameGeomMesh} = fscanf(fid, '%s', 1); 

tmp = fscanf(fid, '%s', 1);
confGen{s_readOptionGeomMesh_cInacrive} = fscanf(fid, '%s', 1); 

if ((allowBinary == 0) && (strcmp(confGen{s_readOptionGeomMesh_cInacrive}, 'b') == 1))
    confGen{s_readOptionGeomMesh_cInacrive} = 'a';
end

tmp = fscanf(fid, '%s', 1);
confGen{s_clr_GeomMesh} = readClr(fid);

tmp = fscanf(fid, '%s', 1);
confGen{s_style_GeomMesh} = fscanf(fid, '%s', 1); 

tmp = fscanf(fid, '%s', 1);
confGen{s_widthGeomMesh} = fscanf(fid, '%lg', 1); 


folderName = [confGen{s_dirPreName} confGen{s_dirRunName} confGen{s_folderPostNameGeomMesh}];
if (strcmp(folderName, '') == 0)
    folderName = [folderName, '/'];
end

serial_ = confGen{s_serialStart};
confGen{s_GeomMeshCompFileName} = [folderName, confGen{s_runName}, confGen{s_middlename}, confGen{s_fileNameGeomMesh}];
%, num2str(serial_, '%0.5d')



tmp = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 2);
confGen{s_x0_dsplcdShape} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_x0_cnfgOption} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_x0_extraMultplr} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 2);
confGen{s_x1_dsplcdShape} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_x1_cnfgOption} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_x1_extraMultplr} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
confGen{s_printOptionExt} = fscanf(fid, '%s', 1);

confGen{s_printOption} = ['-d', confGen{s_printOptionExt}];
if (strcmp(confGen{s_printOptionExt}, 'epsc') == 1)
    confGen{s_printOptionExt} = 'eps';
end

%Razaldo 43
%s_lfs = 43;

tmp = fscanf(fid, '%s', 1);
confGen{s_lfs} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
confGen{s_tfs} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
confGen{s_pltfs} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
confGen{s_symfs} = fscanf(fid, '%lg', 1);

tmp = fscanf(fid, '%s', 1);
confGen{s_xminT} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
confGen{s_yminT} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
confGen{s_plotTime} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
confGen{s_plotAxis} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
confGen{s_axisXLabel} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
confGen{s_axisYLabel} = fscanf(fid, '%s', 1);


tmp = fscanf(fid, '%s', 1);
confGen{s_numFldsTot} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_offset} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_numFldsAdded} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_optionFldsAdded} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{s_loadDirectionFldsAdded} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confignameAddedPlot = fscanf(fid, '%s', 1);
if ((confGen{s_numFldsAdded} > 0) || (confGen{s_optionFldsAdded} > 0))
    E = confGen{s_runData}(EIndex);
    rho = confGen{s_runData}(rhoIndex);
    cd = confGen{s_runData}(CdIndex);
    cs = confGen{s_runData}(CsIndex);
        [fnt_cnfgAddedFlds, pl_confAddedFlds, pf_plotsAddedFlds, pl_normalizersAddedFlds, ...
            figHandlesAddedFlds] = readProcessedPlotsConfigFile(confGen{s_runName}, confignameAddedPlot,...
            confGen{s_optionFldsAdded}, E, rho, cd, cs, confGen{s_printOption}, confGen{s_printOptionExt});
end

confGen{s_numFldsTotOriginal} = confGen{s_numFldsTot};
confGen{s_numFldsTot} = confGen{s_numFldsTot} + confGen{s_numFldsAdded};


tmp = fscanf(fid, '%s', 1);
confGen{maxNumPtsPerBox} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{precisionRowCounter} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{maxNumRowCounter} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{maxNumGridPtsSingleContour} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{maxNumGridPtsALLContour} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{maxNumDivisions} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
confGen{expansionRatio} = fscanf(fid, '%lg', 1);
tmp = fscanf(fid, '%s', 1);
confGen{doPlotSubPlotBounds} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
colorMapName = fscanf(fid, '%s', 1);

colormap(colorMapName);
confGen{gColormapInput} = colormap;


tmp = fscanf(fid, '%s', 1);
xmin_all = fscanf(fid, '%lg', 1);
tmp = fscanf(fid, '%s', 1);
xmax_all = fscanf(fid, '%lg', 1);
tmp = fscanf(fid, '%s', 1);
ymin_all = fscanf(fid, '%lg', 1);
tmp = fscanf(fid, '%s', 1);
ymax_all = fscanf(fid, '%lg', 1);

if (DoublesAreEqual(xmin_all, noFlag, tol) == 1)
    xmin_all = -inf;
end
if (DoublesAreEqual(xmax_all, noFlag, tol) == 1)
    xmax_all = inf;
end

if (DoublesAreEqual(ymin_all, noFlag, tol) == 1)
    ymin_all = -inf;
end
if (DoublesAreEqual(ymax_all, noFlag, tol) == 1)
    ymax_all = inf;
end

confGen{xmin_all_ind} = xmin_all;
confGen{xmax_all_ind} = xmax_all;
confGen{ymin_all_ind} = ymin_all;
confGen{ymax_all_ind} = ymax_all;



confGen{s_numFlds} = confGen{s_numFldsTot} - confGen{s_offset};



offsetP1 = confGen{s_offset} + 1;


basNormalizerFileName = [confGen{s_dir}, confGen{s_runName}, confGen{s_middlename}, confGen{s_cnfgNmlzrName},'.txt'];

fidBaseN = fopen(basNormalizerFileName, 'r');

if (fidBaseN < 0)
    fprintf(1, '%s file could not be opened\n', basNormalizerFileName);
    pause;
end


hasFinalTimeBStat = ~strcmp(confGen{s_brfStatFinalName}, 'NONE');
if (hasFinalTimeBStat == 1)
    finalTimeConfigName = [confGen{s_dir}, confGen{s_runName}, confGen{s_middlename}, confGen{s_brfStatFinalName},'.txt']
    fidFnlTC = fopen(finalTimeConfigName, 'r');
    if (fidFnlTC < 0)
        hasFinalTimeBStat = 0;
        fprintf(1, '%s file could not be opened\n', finalTimeConfigName);
%        pause;
    end
end
if (hasFinalTimeBStat == 1)
    numTotalFlds = fscanf(fidFnlTC, '%d', 1);
    ndata = fscanf(fidFnlTC, '%d', 1);
    [minVT, minCoordT, min_eIDT, min_idT, maxVT, maxCoordT, max_eIDT, max_idT, counterT, averageT, sumT, sDiviationT, nameT] =  ...
        readBriefStat(fidFnlTC, confGen{s_numFldsTotOriginal});
    minCoordT = minVT(1:3);
    maxCoordT = maxVT(1:3);
    minVT = minVT(offsetP1:numTotalFlds);
    maxVT = maxVT(offsetP1:numTotalFlds);
    averageT = averageT(offsetP1:numTotalFlds);
    sumT = sumT(offsetP1:numTotalFlds);
    nameT = nameT(offsetP1:numTotalFlds);
else
    numTotalFlds = confGen{s_numFldsTot};
    minCoordT = ones(1,3);
    maxCoordT = ones(1,3);
    numMoffset = numTotalFlds - offsetP1 + 1;
    minVT = ones(1,numMoffset);
    maxVT = ones(1,numMoffset);
    averageT = ones(1,numMoffset);
    sumT = ones(1,numMoffset);
    if (numTotalFlds == 24)
        nameT = {'s00', 's11', 's01', 'sMax', 'sMaxT', 'sMin', 'sMinT', 'tauM', 'tauMT', 'Es', 'v0',...
            'v1', 'vMag', 'Ev', 'Etot', 'u0', 'u1', 'uMag', 'maxEffS', 'maxEffST'};
    elseif (numTotalFlds == 74)
        nameT = {'delu0', 'delu1', 'Scoh0', 'Scoh1', 'Sout0', 'Sout1', 'Sin0', 'Sin1', 'v0', 'v1', 'delv0', 'delv1', 'u0', 'u1', ...
            'Ss0', 'Ss1', 'Sr0', 'Sr1', 'D0', 'D1', 'D-uc0', 'D-uc1', 'D-ucDot0', 'D-ucDot1', 'evl-src0', 'evl-src1', 'evl-frc0', ...
            'evl-frc1', 'char-val0', 'char-val1', 'DissDot0', 'DissDot1', 'Diss0', 'Diss1', 'DissDgDot0', 'DissDgDot1', 'DissDg0', 'DissDg1', ...
            'delus', 'Scohs', 'Souts', 'Sins', 'vs', 'delvs', 'us', 'Sss', 'Srs', 'Ds', 'D-ucs', 'D-ucDots', 'evl-srcs', 'evl-frcs', ...
            'char-vals', 'DissDots', 'Disss', 'DissDgDots', 'DissDgs', 'VCP_DU0', 'VCP_DU1', 'VCP_S0', 'VCP_S1', ...
            'aSpr', 'aSpa', 'aCnr', 'aCna', 'aSlr', 'aSla', 'aStr', 'aSta', 'aBna'};
    else
        printf(1, 'nameT should be provided for other special cases\n');
        pause;
    end
end    


m = fscanf(fidBaseN, '%d', 1);
n = fscanf(fidBaseN, '%d', 1);
confBaseNormalizer = fscanf(fidBaseN , '%lg', [n inf]);
confBaseNormalizer = confBaseNormalizer';
confBaseNormalizer = confBaseNormalizer(:, offsetP1:numTotalFlds);

confGen{s_startCohNormalizer} = 100;
confGen{s_incrmCohNormalizer} = 100;
confGen{s_startLoadNormalizer} = 150;
confGen{s_incrmLoadNormalizer} = 100;


confData = cell(0);
numFlds = confGen{s_numFlds};




tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    confData{p_number}(i) = fscanf(fid, '%d', 1);
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    confData{p_name}{i} = fscanf(fid, '%s', 1);
end

% normalizers
for i = 1:numFlds
    confData{p_totN}(i) = 1.0;
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    confData{p_exrnlN}(i) = fscanf(fid, '%lg', 1);
    confData{p_totN}(i) = confData{p_totN}(i) * confData{p_exrnlN}(i);
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    tmp = fscanf(fid, '%d', 1);
    if (tmp ~= 0) 
        confData{p_totN}(i) = confData{p_totN}(i) * confBaseNormalizer(tmp, i);
    end
    confData{p_cnfgBaseN}(i) = tmp;
end


tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    tmp = fscanf(fid, '%d', 1);
    if (tmp == 1) 
        confData{p_totN}(i) = confData{p_totN}(i) * maxVT(i);
    elseif (tmp == 2)
       confData{p_totN}(i) = confData{p_totN}(i) * minVT(i);
    end
    confData{p_cnfgFN}(i) = tmp;
end



tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    confData{p_cnfgCN}(i) = fscanf(fid, '%d', 1);
end


tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    confData{p_origin}(i) = fscanf(fid, '%lg', 1);
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    confData{p_logBase}(i) = fscanf(fid, '%lg', 1);
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    confData{p_pltFlag}(i) = fscanf(fid, '%d', 1);
end


for i = 1:numFlds
    confData{p_xlimB}(i) = 1;
    confData{p_ylimB}(i) = 1;
    confData{p_zlimB}(i) = 1;
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    tmp = fscanf(fid, '%lg', 1);
    if (xmin_all ~= -inf)
        if (DoublesAreEqual(tmp, noFlag, tol) == 1)
            tmp = xmin_all;
        else
            tmp = max(tmp, xmin_all);
        end
    end
    confData{p_xminV}(i) = tmp;    
    if (DoublesAreEqual(tmp, noFlag, tol) == 1)
        confData{p_xlimB}(i) = 0;
    end
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    tmp = fscanf(fid, '%lg', 1);
    if (ymin_all ~= inf)
        if (DoublesAreEqual(tmp, noFlag, tol) == 1)
            tmp = xmax_all;
        else
            tmp = min(tmp, xmax_all);
        end
    end
    confData{p_xmaxV}(i) = tmp;    
    if (DoublesAreEqual(tmp, noFlag, tol) == 1)
        confData{p_xlimB}(i) = 0;
    end
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    tmp = fscanf(fid, '%lg', 1);
    if (ymin_all ~= -inf)
        if (DoublesAreEqual(tmp, noFlag, tol) == 1)
            tmp = ymin_all;
        else
            tmp = max(tmp, ymin_all);
        end
    end
    confData{p_yminV}(i) = tmp;    
    if (DoublesAreEqual(tmp, noFlag, tol) == 1)
        confData{p_ylimB}(i) = 0;
    end
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    tmp = fscanf(fid, '%lg', 1);
    if (ymax_all ~= inf)
        if (DoublesAreEqual(tmp, noFlag, tol) == 1)
            tmp = ymax_all;
        else
            tmp = min(tmp, ymax_all);
        end
    end
    confData{p_ymaxV}(i) = tmp;    
    if (DoublesAreEqual(tmp, noFlag, tol) == 1)
        confData{p_ylimB}(i) = 0;
    end
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    confData{p_zlimAbs}(i) = fscanf(fid, '%d', 1);
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    tmp = fscanf(fid, '%lg', 1);
    confData{p_zminV}(i) = tmp;    
    if (DoublesAreEqual(tmp, noFlag, tol) == 1)
        confData{p_zlimB}(i) = 0;
    end
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    tmp = fscanf(fid, '%lg', 1);
    confData{p_zmaxV}(i) = tmp;    
    if (DoublesAreEqual(tmp, noFlag, tol) == 1)
        confData{p_zlimB}(i) = 0;
    end
end

for i = 1:numFlds
    if (confData{p_xlimB}(i) == 0) 
        confData{p_xminV}(i) = -inf;    
        confData{p_xmaxV}(i) =  inf;    
    end
    if (confData{p_ylimB}(i) == 0) 
        confData{p_yminV}(i) = -inf;    
        confData{p_ymaxV}(i) =  inf;    
    end
    if (confData{p_zlimB}(i) == 0) 
        confData{p_zminV}(i) = -inf;    
        confData{p_zmaxV}(i) =  inf;    
    end
end



tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    tmp = fscanf(fid, '%lg', 1);
    confData{p_zBaseP}(i) = tmp;    
    if (DoublesAreEqual(tmp, noFlag, tol) == 1)
        confData{p_zBaseP}(i) = inf;
    end
end


tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    tmp = fscanf(fid, '%s', 1);
    if (strcmp(tmp, 'name') == 1)
        confData{p_title}{i} = confData{p_name}{i};
    else
        confData{p_title}{i} = tmp;
    end
end

tmp = fscanf(fid, '%s', 1);
for i = 1:numFlds
    tmp = fscanf(fid, '%s', 1);
    confData{p_legLoc}{i} = getLegendLocation(tmp);
end


confGen{ind_u0} = -1;
for i = 1:numFlds
    if (strcmp(nameT(i) , 'u0') == 1)
        confGen{ind_u0} = i;
        break;
    end
end
if (confGen{ind_u0} == -1)
    confGen{s_x0_dsplcdShape} = 0;
end

confGen{s_x0_factor} = 0.0;
%if (confGen{s_x0_dsplcdShape} ~= 0)
if (confGen{s_x0_cnfgOption} ~= 0)
    confGen{s_x0_factor} = confGen{s_x0_extraMultplr} / confBaseNormalizer(confGen{s_x0_cnfgOption}, confGen{ind_u0});
end


confGen{ind_u1} = -1;
for i = 1:numFlds
    if (strcmp(nameT(i) , 'u1') == 1)
        confGen{ind_u1} = i;
        break;
    end
end
if (confGen{ind_u1} == -1)
    confGen{s_x1_dsplcdShape} = 0;
end

confGen{s_x1_factor} = 0.0;
if (confGen{s_x1_dsplcdShape} == 1)
    confGen{s_x1_factor} = confGen{s_x1_extraMultplr} / confBaseNormalizer(confGen{s_x1_cnfgOption}, confGen{ind_u1});
elseif (confGen{s_x1_dsplcdShape} == 2)
     confGen{s_x1_factor} = confGen{s_x0_factor};
end

conf2DPlot{I_TwoSidedCrackDelu0Factor} = confGen{s_x0_factor};
conf2DPlot{I_TwoSidedCrackDelu1Factor} = confGen{s_x1_factor};

if (confGen{s_x0_dsplcdShape} == 0)
    confGen{s_x0_factor} = 0.0;
end
if (confGen{s_x1_dsplcdShape} == 0)
    confGen{s_x1_factor} = 0.0;
end


tmp = fscanf(fid, '%s', 2);
conf2DPlot{I_plotTimeSlice} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_do2DColorPlot} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_TS_StatName} = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_TS_readOnlyStat} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_TS_SliceDataName} = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_TS_sliceReadFlag} = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_TS_derOptionForTimeDerivatives} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_TS_maxPowerVelocitiesRoundOff} = fscanf(fid, '%d', 1);

isComplete = 1;
isReqType = 1;
[conf2DPlot{I_TS_ReqFlds}, conf2DPlot{I_TS_numReqFlds}] = readRequested_CollectedConfigValues(fid, isReqType, isComplete);

[cnfgFldCol, NcnfgFldCol] = readRequested_CollectedConfigValues(fid, 0, 0);


tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_x0C2D}{1} = fscanf(fid, '%s', 1);		
conf2DPlot{I_x0C2D}{2} = fscanf(fid, '%d', 1);		
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_x1C2D}{1} = fscanf(fid, '%s', 1);
conf2DPlot{I_x1C2D}{2} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_u0C2D}{1} = fscanf(fid, '%s', 1);
conf2DPlot{I_u0C2D}{2} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_u1C2D}{1} = fscanf(fid, '%s', 1);
conf2DPlot{I_u1C2D}{2} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_delu0C2D}{1} = fscanf(fid, '%s', 1);
conf2DPlot{I_delu0C2D}{2} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_delu1C2D}{1} = fscanf(fid, '%s', 1);
conf2DPlot{I_delu1C2D}{2} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_plotFld}{1} = fscanf(fid, '%s', 1);
conf2DPlot{I_plotFld}{2} = fscanf(fid, '%d', 1);
conf2DPlot{I_plotFld}{3} = fscanf(fid, '%s', 1);

conf2DPlot{I_fullFldSymbols}{1} = conf2DPlot{I_x0C2D}{1};
conf2DPlot{I_fullFldSymbols}{2} = conf2DPlot{I_x1C2D}{1};
conf2DPlot{I_fullFldSymbols}{3} = conf2DPlot{I_u0C2D}{1};
conf2DPlot{I_fullFldSymbols}{4} = conf2DPlot{I_u1C2D}{1};
conf2DPlot{I_fullFldSymbols}{5} = conf2DPlot{I_plotFld}{1};
conf2DPlot{I_fullFldSymbols}{6} = conf2DPlot{I_delu0C2D}{1};
conf2DPlot{I_fullFldSymbols}{7} = conf2DPlot{I_delu1C2D}{1};
conf2DPlot{I_fullFldSymbols}{8} = 'normal';
conf2DPlot{I_fullFldSymbols}{9} = 'normal';
%conf2DPlot{I_fullFldSymbols}{10} = 'normal';


conf2DPlot{I_fullFldIndices}(1) = conf2DPlot{I_x0C2D}{2};
conf2DPlot{I_fullFldIndices}(2) = conf2DPlot{I_x1C2D}{2};
conf2DPlot{I_fullFldIndices}(3) = conf2DPlot{I_u0C2D}{2};
conf2DPlot{I_fullFldIndices}(4) = conf2DPlot{I_u1C2D}{2};
conf2DPlot{I_fullFldIndices}(5) = conf2DPlot{I_plotFld}{2};
conf2DPlot{I_fullFldIndices}(6) = conf2DPlot{I_delu0C2D}{2};
conf2DPlot{I_fullFldIndices}(7) = conf2DPlot{I_delu1C2D}{2};
conf2DPlot{I_fullFldIndices}(8) = 0;
conf2DPlot{I_fullFldIndices}(9) = 1;
%conf2DPlot{I_fullFldIndices}(10) = 2;

offsetUsefulFlds = 5;
%offset = length(conf2DPlot{I_fullFldIndices});
offset = offsetUsefulFlds;
conf2DPlot{I_TS_numCollectOffset} = offset ;
for i = 1:offset
    conf2DPlot{I_TS_CollectFlds}{i}{1} = conf2DPlot{I_fullFldSymbols}{i};
    conf2DPlot{I_TS_CollectFlds}{i}{2} = conf2DPlot{I_fullFldIndices}(i);
    conf2DPlot{I_TS_CollectFlds}{i}{4} = 'none';
    if (strcmp(conf2DPlot{I_fullFldSymbols}{i}, 'fld0') == 1)
        conf2DPlot{I_TS_CollectFlds}{i}{5} = 0;
    elseif (strcmp(conf2DPlot{I_fullFldSymbols}{i}, 'fld1') == 1)
        conf2DPlot{I_TS_CollectFlds}{i}{5} = 1;
    elseif (strcmp(conf2DPlot{I_fullFldSymbols}{i}, 'flds') == 1)
        conf2DPlot{I_TS_CollectFlds}{i}{5} = 2;
    elseif (strcmp(conf2DPlot{I_fullFldSymbols}{i}, 'X') == 1)
        conf2DPlot{I_TS_CollectFlds}{i}{5} = conf2DPlot{I_fullFldIndices}(i);
    end
end

for i = 1:NcnfgFldCol
   conf2DPlot{I_TS_CollectFlds}{i + offset} = cnfgFldCol{i};
end
conf2DPlot{I_TS_numCollectFlds} = NcnfgFldCol + offset;
    


tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipDataName} = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipStatName} = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipFlagNum} = fscanf(fid, '%d', 1);
if (conf2DPlot{I_CrackTipFlagNum} < 0)
    conf2DPlot{I_CrackTipFlagNum} = confGen{s_runData}(CTindex);
end



tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipDataSerialNum} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipReadFlag} = fscanf(fid, '%s', 1);

tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipFldsName} = fscanf(fid, '%s', 1);
tmp = fscanf(fid, '%s', 1);
inp = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipFldsMarkerStyle} = getMarkerStyleByInput(inp);


tmp = fscanf(fid, '%s', 1);
inp = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipFldsMarkerColor} = getColorByInput(inp);
tmp = fscanf(fid, '%s', 1);
inp = fscanf(fid, '%d', 1);
conf2DPlot{I_CrackTipFldsMarkerSize} = getMarkerSizeByInput(inp);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipFldsMarkerActive} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipVelSymIndex}{1} = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipVelSymIndex}{2} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipPZSizeSymIndex}{1} = fscanf(fid, '%s', 1);
conf2DPlot{I_CrackTipPZSizeSymIndex}{2} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
conf2DPlot{IplotAroundProcessZoneFactorX} = fscanf(fid, '%lg', 1);
if (conf2DPlot{IplotAroundProcessZoneFactorX} <= 0)
    conf2DPlot{IplotAroundProcessZoneFactorX} = inf;
end

tmp = fscanf(fid, '%s', 1);
conf2DPlot{IplotAroundProcessZoneFactorY} = fscanf(fid, '%lg', 1);
if (conf2DPlot{IplotAroundProcessZoneFactorY} <= 0)
    conf2DPlot{IplotAroundProcessZoneFactorY} = inf;
end

conf2DPlot{I_CrackTipFullFldSymbols} = conf2DPlot{I_fullFldSymbols};
conf2DPlot{I_CrackTipFullFldSymbols}{offset + 1} = 'time';
conf2DPlot{I_CrackTipFullFldSymbols}{offset + 2} = conf2DPlot{I_CrackTipVelSymIndex}{1};
conf2DPlot{I_CrackTipFullFldSymbols}{offset + 3} = conf2DPlot{I_CrackTipPZSizeSymIndex}{1};
conf2DPlot{I_CrackTipFullFldSymbols}{offset + 4} = 'space';


conf2DPlot{I_CrackTipFullFldIndices} = conf2DPlot{I_fullFldIndices};
conf2DPlot{I_CrackTipFullFldIndices}(offset + 1) = 0;
conf2DPlot{I_CrackTipFullFldIndices}(offset + 2) = conf2DPlot{I_CrackTipVelSymIndex}{2};
conf2DPlot{I_CrackTipFullFldIndices}(offset + 3) = conf2DPlot{I_CrackTipPZSizeSymIndex}{2};
conf2DPlot{I_CrackTipFullFldIndices}(offset + 4) = 0;


tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_plotTwoSidedCrack} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
useSameDeluFactorAsAllMesh = fscanf(fid, '%d', 1);

if (useSameDeluFactorAsAllMesh == 1)
    conf2DPlot{I_TwoSidedCrackDelu0Factor} = confGen{s_x0_factor};
    conf2DPlot{I_TwoSidedCrackDelu1Factor} = confGen{s_x1_factor};
end

toldle = 1e-15;
if (DoublesAreEqual(conf2DPlot{I_TwoSidedCrackDelu0Factor}, confGen{s_x0_factor}, toldle) == 1)
    conf2DPlot{I_TwoSidedCrackDelu0FactorSideIn}  = 0.0;
    conf2DPlot{I_TwoSidedCrackDelu0FactorSideOut} = 1.0;
else
    conf2DPlot{I_TwoSidedCrackDelu0FactorSideIn}  = -0.5;
    conf2DPlot{I_TwoSidedCrackDelu0FactorSideOut} = 0.5;
end

if (DoublesAreEqual(conf2DPlot{I_TwoSidedCrackDelu1Factor}, confGen{s_x1_factor}, toldle) == 1)
    conf2DPlot{I_TwoSidedCrackDelu1FactorSideIn}  = 0.0;
    conf2DPlot{I_TwoSidedCrackDelu1FactorSideOut} = 1.0;
else
    conf2DPlot{I_TwoSidedCrackDelu1FactorSideIn}  = -0.5;
    conf2DPlot{I_TwoSidedCrackDelu1FactorSideOut} = 0.5;
end

if ((conf2DPlot{I_TwoSidedCrackDelu0Factor} == 0) && (conf2DPlot{I_TwoSidedCrackDelu1Factor} == 0))
    conf2DPlot{I_plotTwoSidedCrack} = 0;
end

tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_plotDistinctDamageLevels} = fscanf(fid, '%d', 1);

stmp = fscanf(fid, '%s', 1);
damageLFlags = fscanf(fid, '%d', 1);
conf2DPlot{I_damageLevelsFlag} = damageLFlags;

stmp = fscanf(fid, '%s', 1);
conf2DPlot{I_numberDistDPts} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 5);
for i = 1:conf2DPlot{I_numberDistDPts}
    conf2DPlot{I_DistDPts}{idam_level}(i) = fscanf(fid, '%lg', 1);
    conf2DPlot{I_DistDPts}{id_clr}{i} = readClr(fid);
    conf2DPlot{I_DistDPts}{id_lstyle}{i} = fscanf(fid, '%s', 1);
    conf2DPlot{I_DistDPts}{id_lwdth}(i) = fscanf(fid, '%lg', 1);
end    

if (abs(damageLFlags) == 1)
    if (damageLFlags == -1)
        conf2DPlot{I_DistDPts}{idam_level} = conf2DPlot{I_DistDPts}{idam_level}(conf2DPlot{I_numberDistDPts});
    else
        conf2DPlot{I_DistDPts}{idam_level} = conf2DPlot{I_DistDPts}{idam_level}(1);
    end
    conf2DPlot{I_numberDistDPts} = 1;
    
    tmp = conf2DPlot{I_DistDPts}{id_clr}{1};
    conf2DPlot{I_DistDPts}{id_clr} = cell(1,1);
    conf2DPlot{I_DistDPts}{id_clr}{1} = tmp;

    tmp = conf2DPlot{I_DistDPts}{id_lstyle}{1};
    conf2DPlot{I_DistDPts}{id_lstyle} = cell(1,1);
    conf2DPlot{I_DistDPts}{id_lstyle}{1} = tmp;

    conf2DPlot{I_DistDPts}{id_lwdth} = conf2DPlot{I_DistDPts}{id_lwdth}(1);
elseif (damageLFlags == 2)
    num = conf2DPlot{I_numberDistDPts};
    tmp1 = conf2DPlot{I_DistDPts}{idam_level}(1);
    tmp2 = conf2DPlot{I_DistDPts}{idam_level}(num);
    conf2DPlot{I_DistDPts}{idam_level} = zeros(1,2);
    conf2DPlot{I_DistDPts}{idam_level}(1) = tmp1;
    conf2DPlot{I_DistDPts}{idam_level}(2) = tmp2;

    conf2DPlot{I_numberDistDPts} = 2;

    tmp1 = conf2DPlot{I_DistDPts}{id_clr}{1};
    tmp2 = conf2DPlot{I_DistDPts}{id_clr}{2};
    conf2DPlot{I_DistDPts}{id_clr} = cell(2,1);
    conf2DPlot{I_DistDPts}{id_clr}{1} = tmp1;
    conf2DPlot{I_DistDPts}{id_clr}{2} = tmp2;
    
    tmp1 = conf2DPlot{I_DistDPts}{id_lstyle}{1};
    tmp2 = conf2DPlot{I_DistDPts}{id_lstyle}{2};
    conf2DPlot{I_DistDPts}{id_lstyle} = cell(2,1);
    conf2DPlot{I_DistDPts}{id_lstyle}{1} = tmp1;
    conf2DPlot{I_DistDPts}{id_lstyle}{2} = tmp2;

    tmp1 = conf2DPlot{I_DistDPts}{id_lwdth}(1);
    tmp2 = conf2DPlot{I_DistDPts}{id_lwdth}(num);
    conf2DPlot{I_DistDPts}{id_lwdth} = zeros(1,2);
    conf2DPlot{I_DistDPts}{id_lwdth}(1) = tmp1;
    conf2DPlot{I_DistDPts}{id_lwdth}(2) = tmp2;
end

tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_doLegend4OnlyCrackPath} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_cpLegendLocation} = fscanf(fid, '%s', 1);

if (conf2DPlot{I_numberDistDPts} <= 2)
    conf2DPlot{I_doLegend4OnlyCrackPath} = 0;
end


tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_plotOnlyCrackPath} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
usePrevLim = fscanf(fid, '%d', 1);
conf2DPlot{I_xylimEqual2AlllimitsGivenPrev} = usePrevLim;


tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_activexlim_cp} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_xmin_cp} = fscanf(fid, '%lg', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_xmax_cp} = fscanf(fid, '%lg', 1);
if (usePrevLim == 1)
    conf2DPlot{I_xmin_cp} = confGen{xmin_all_ind};
    conf2DPlot{I_xmax_cp} = confGen{xmax_all_ind};
end


tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_activeylim_cp} = fscanf(fid, '%d', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_ymin_cp} = fscanf(fid, '%lg', 1);
tmp = fscanf(fid, '%s', 1);
conf2DPlot{I_ymax_cp} = fscanf(fid, '%lg', 1);
if (usePrevLim == 1)
    conf2DPlot{I_ymin_cp} = confGen{ymin_all_ind};
    conf2DPlot{I_ymax_cp} = confGen{ymax_all_ind};
end


pltfs = confGen{s_pltfs};
xminT = confGen{s_xminT};
yminT = confGen{s_yminT};

if (conf2DPlot{I_plotOnlyCrackPath} == 1)
    confGen{s_figContourMarkers} = figure(10000);
    setAxisMinorTicksAndFontSize(pltfs, xminT, yminT)
end

offset = confGen{s_offset};
offsetP1 = offset + 1;
%numTotalFlds = fscanf(fidStat, '%d', 1);
numFlds = numTotalFlds - offsetP1 + 1;
numFldsAddedFlds = numFlds + confGen{s_numFldsAdded};
confGen{s_figContoursGen} = zeros(1, numFldsAddedFlds);
for fld = 1:numFldsAddedFlds
    if (confData{p_pltFlag}(fld)  == 0)
        confGen{s_figContoursGen}(fld) = 0;
        continue;
    end
	confGen{s_figContoursGen}(fld) = figure(fld);
    setAxisMinorTicksAndFontSize(pltfs, xminT, yminT, 0)
end
