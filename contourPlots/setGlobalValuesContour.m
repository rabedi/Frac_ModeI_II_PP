function setGlobalValuesContour()

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
global s_maxNumRows2Read;
global s_maxNumRows2ReadBulk;
global s_maxNumRows2ReadBulkTotal;

global maxNumPtsPerBox;
global precisionRowCounter;
global maxNumRowCounter;
global maxNumGridPtsSingleContour;
global maxNumGridPtsALLContour;
global maxNumDivisions;
global expansionRatio;
global doPlotSubPlotBounds;
global gColormapInput;
global s_plot_contours;

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


global s_folderPostNameGeomMesh;
global s_fileNameGeomMesh;
global s_readOptionGeomMesh_cInacrive;
global s_GeomMeshCompFileName;
global s_clr_GeomMesh;
global s_style_GeomMesh;
global s_widthGeomMesh;


global s_figContourMarkers;
global s_figContoursGen;

global s_lfs;
global s_tfs;
global s_pltfs;
global s_symfs;
global s_xminT;
global s_yminT;

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

global I_plotTimeSlice;
global I_do2DColorPlot;
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
global I_doLegend4OnlyCrackPath;
global I_cpLegendLocation;
 
global idam_level;
global id_clr;
global id_lstyle;
global id_lwdth;
 


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


ind_sl_sym = 1;
ind_sl_index = 2;
ind_sl_finderT = 3;
ind_sl_nrmlzrT = 4;
ind_sl_dim = 5;
ind_sl_name = 6;
ind_sl_MkrStyl = 7;
ind_sl_MkrClr = 8;
ind_sl_MkrSize = 9;
ind_sl_MkrActive = 10;








s_serialStartAbsolute = 1;
s_serialEndAbsolute = 2;
s_serialStart = 3;
s_serialStep = 4;
s_serialEnd = 5;
s_dirPreName = 6;
s_dirRunName = 7;
s_dirPostName = 8;
s_dir = 9;
s_runParaPreName = 10;
s_runParaPostName = 11;
s_runPara = 12;
s_runData = 13;
s_dirOut = 14;
s_runName = 15;
s_middlename = 16;
s_midNData = 17;
s_DataFrmt = 18;
s_brfStatName = 19;
s_brfStatFinalName = 20;
s_cnfgNmlzrName = 21;
s_coord2sIndex = 22;

s_x0_dsplcdShape = 23;
s_x0_cnfgOption = 24;
s_x0_extraMultplr = 25;
s_x0_factor = 26;
s_x1_dsplcdShape = 27;
s_x1_cnfgOption = 28;
s_x1_extraMultplr = 29;
s_x1_factor = 30;
s_printOptionExt = 31;
s_printOption = 32;
s_plotTime = 33;
s_plotAxis = 34;
s_axisXLabel = 35;
s_axisYLabel = 36;

s_numFldsTot = 37;
s_numFlds = 38;
s_offset = 39;
s_numFldsAdded = 40;
s_optionFldsAdded = 41;
s_loadDirectionFldsAdded = 42;
s_numFldsTotOriginal = 43;

maxNumPtsPerBox = 44; 
precisionRowCounter = 45;
maxNumRowCounter = 46;
maxNumGridPtsSingleContour = 47;
maxNumGridPtsALLContour = 48;
maxNumDivisions = 49;
expansionRatio = 50;
doPlotSubPlotBounds = 51;
gColormapInput = 52;
ind_u0 = 53;
ind_u1 = 54;
s_times = 55;
s_startTimes = 56;
s_timeStep = 57;


s_startCohNormalizer = 60;
s_incrmCohNormalizer = 61;
s_startLoadNormalizer = 62;
s_incrmLoadNormalizer = 63;
s_maxNumRows2Read = 64;
s_maxNumRows2ReadBulk = 65;



xmin_all_ind = 66;
xmax_all_ind = 67;
ymin_all_ind = 68;
ymax_all_ind = 69;

s_folderPostNameGeomMesh = 70;
s_fileNameGeomMesh = 71;
s_readOptionGeomMesh_cInacrive = 72;
s_GeomMeshCompFileName = 73;
s_clr_GeomMesh = 74;
s_style_GeomMesh = 75;
s_widthGeomMesh = 76;



s_plot_contours = 80;

s_figContourMarkers = 81;
s_figContoursGen = 82;

s_maxNumRows2ReadBulkTotal = 85;


s_lfs = 86;
s_tfs = 87;
s_pltfs = 88;
s_symfs = 89;
s_xminT = 90;
s_yminT = 91;


p_number = 1;
p_name = 2;
p_exrnlN = 3;
p_cnfgBaseN = 4;
p_cnfgFN = 5;
p_cnfgCN = 6;
p_origin = 7;
p_logBase = 8;
p_pltFlag = 9;
p_xminV = 10;
p_xmaxV = 11;
p_yminV = 12;
p_ymaxV = 13;
p_zlimAbs = 14;
p_zminV = 15;
p_zmaxV = 16;
p_zBaseP = 17;

p_title = 18;
p_legLoc = 19;

p_totN = 20;
p_xlimB = 21;
p_ylimB = 22;
p_zlimB = 23;



I_plotTimeSlice = 1;
I_do2DColorPlot = 2;
I_TS_StatName = 3;
I_TS_readOnlyStat = 4;
I_TS_SliceDataName = 5;
I_TS_sliceReadFlag = 6;
I_TS_derOptionForTimeDerivatives = 7;
I_TS_maxPowerVelocitiesRoundOff = 8;
I_TS_numReqFlds = 9;
I_TS_ReqFlds = 10;

I_TS_numCollectFlds = 11;	
I_TS_CollectFlds = 12;	
I_TS_numCollectOffset = 13;

I_x0C2D = 20;		
I_x1C2D = 21;
I_u0C2D = 22;
I_u1C2D = 23;
I_plotFld = 24;
I_fullFldSymbols = 25;
I_fullFldIndices = 26;


I_CrackTipDataName = 30;
I_CrackTipStatName = 31;
I_CrackTipFlagNum = 32;
I_CrackTipDataSerialNum = 33;
I_CrackTipReadFlag = 34;
I_CrackTipFldsName = 35;
I_CrackTipFldsMarkerStyle = 36;
I_CrackTipFldsMarkerColor = 37;
I_CrackTipFldsMarkerSize = 38;
I_CrackTipFldsMarkerActive = 39;

I_CrackTipVelSymIndex = 40;
I_CrackTipPZSizeSymIndex = 41;
I_CrackTipFullFldSymbols = 42;
I_CrackTipFullFldIndices = 43;
IplotAroundProcessZoneFactorX = 44;
IplotAroundProcessZoneFactorY = 45;


I_plotTwoSidedCrack = 60;
I_TwoSidedCrackDelu0Factor = 61;
I_TwoSidedCrackDelu1Factor = 62;
I_TwoSidedCrackDelu0FactorSideIn = 63;
I_TwoSidedCrackDelu0FactorSideOut = 64;
I_TwoSidedCrackDelu1FactorSideIn = 65;
I_TwoSidedCrackDelu1FactorSideOut = 66;
I_delu0C2D = 67;
I_delu1C2D = 68;
I_plotDistinctDamageLevels = 69;
I_damageLevelsFlag = 70;
I_numberDistDPts = 71;
I_DistDPts = 72;
I_plotOnlyCrackPath = 80;
I_xylimEqual2AlllimitsGivenPrev = 81;
I_activexlim_cp = 82;
I_xmin_cp = 83;
I_xmax_cp = 84;
I_activeylim_cp = 85;
I_ymin_cp = 86;
I_ymax_cp = 87;
I_doLegend4OnlyCrackPath = 88;
I_cpLegendLocation = 89;



idam_level = 1; 
id_clr = 2;
id_lstyle = 3;
id_lwdth = 4;



global startTimeIndex;
global endTimeIndex;
global timeIncrementInex;
global sigmaNcohIndex;
global deltaNcohIndex;
global sigmaTcohIndex;
global deltaTcohIndex;
global EIndex;
global rhoIndex;
global nuIndex;
global plainStrainIndex;
global CdIndex;
global CsIndex;
global CrIndex;
global v0Index;
global sigma0Index;
global rampTimeIndex;
global plateWidthIndex;
global loadTypeIndex;
global loadIncrementFactorInex;
global loadFinalTimeIndex;

global startCohFaceIndex;
global endCohFaceIndex;
global lengthCohFaceIndex;

global startCohFaceXIndex;
global startCohFaceYIndex;

global CZstartIndex; % start of process zone which is going to be the tip of proces zone 
global CZendIndex; % end of process zone when there is almost complete separation
global CTindex;
% reduction methods available if a cluster of points exist either min max
    % or average value of coordinate is used for single data extraction
    %1 average values is considered
    %2 min value is considered
    %3 max value is considered
global CZstartReductionIndex; % min suggested? used (gives smaller process zone size)
global CZendReductionIndex;   % max suggested? used (gives smaller process zone size) 
global allFlagsReductionIndex;% average is used in general Xu Needleman use max value for computing crack-tip position 
global maxDistInClusterIndex; % span in coordinate that defines a cluster

% derivative method used:
% 0 finite differece
% 1 slope of quadratice polynomial fit at centerpoint for every 3 succesive
% points
% 2 slope of best line fit for every 3 succesive points
global derMethodIndex;   
% if there is a jump in the data (e.g.) crack tip we don't consider those
% as same data set in computing derivative for example  Jump is defined
% when the time index difference between two points of the same data set
% (crack tip for example) is larger than the value in following:
global maxPIndexDerDiffIndex; 
global flagStartIndex;
global flagEndIndex;
global serialStartIndex;
global serialEndIndex;
global CZstaticSizeIndex;

%damage related values
% dDot = 1/tau_C[1 - H[<f(y) - d>+]]
% f(y) = exp(-a y)

global stressFraction;    % if effective stress is smaller than this value there is no damage force (look at flag 84)
global dam_tau_C;	
global dam_a;	
global limitFy;  % if y > 1.0 f(y) is limited by 1 if this value is larger than 0.0 otherwise it takes larger values
global allowMinusDu;  % if true for negative unbounded damage values even if f(y) == 0 we allow f(y) - du = -du > 0.0 to cause damage rate

global fracEneryCrackLengthIndex; % energy needed to break up the whole plate
global energyReleaseRateIndex;	   % energy released by crack per unit time
global fracEneryIndex;			   	


startTimeIndex = 1;
endTimeIndex = 2;
timeIncrementInex = 3;
sigmaNcohIndex = 4;
deltaNcohIndex = 5;
sigmaTcohIndex = 6;
deltaTcohIndex  = 7;
EIndex = 8;
rhoIndex = 9;
nuIndex = 10;
plainStrainIndex = 11;
CdIndex = 12;
CsIndex = 13;
CrIndex = 14;
v0Index = 21;
sigma0Index = 22;
rampTimeIndex = 23;
plateWidthIndex = 24;
loadTypeIndex = 25;
loadIncrementFactorInex = 26;
loadFinalTimeIndex = 27;

startCohFaceIndex	=	28;
endCohFaceIndex	=	29;
lengthCohFaceIndex	=	30;

startCohFaceXIndex = 31;
startCohFaceYIndex  = 32;


CZstartIndex = 51; % start of process zone which is going to be the tip of proces zone 
CZendIndex = 52; % end of process zone when there is almost complete separation
CTindex = 53;
% reduction methods available if a cluster of points exist either min max
    % or average value of coordinate is used for single data extraction
    %1 average values is considered
    %2 min value is considered
    %3 max value is considered
CZstartReductionIndex = 54; % min suggested? used (gives smaller process zone size)
CZendReductionIndex = 55;   % max suggested? used (gives smaller process zone size) 
allFlagsReductionIndex = 56;% average is used in general Xu Needleman use max value for computing crack-tip position 
maxDistInClusterIndex = 57; % span in coordinate that defines a cluster

% derivative method used:
% 0 finite differece
% 1 slope of quadratice polynomial fit at centerpoint for every 3 succesive
% points
% 2 slope of best line fit for every 3 succesive points
derMethodIndex = 58;   
% if there is a jump in the data (e.g.) crack tip we don't consider those
% as same data set in computing derivative for example  Jump is defined
% when the time index difference between two points of the same data set
% (crack tip for example) is larger than the value in following:
maxPIndexDerDiffIndex = 59; 
flagStartIndex = 60;
flagEndIndex = 61;
serialStartIndex = 62;
serialEndIndex = 63;
CZstaticSizeIndex = 64;

%damage related values
% dDot = 1/tau_C[1 - H[<f(y) - d>+]]
% f(y) = exp(-a y)

stressFraction = 80;    % if effective stress is smaller than this value there is no damage force (look at flag 84)
dam_tau_C = 81;	
dam_a	= 82;	
limitFy  = 83;  % if y > 1.0 f(y) is limited by 1 if this value is larger than 0.0 otherwise it takes larger values
allowMinusDu = 84;  % if true for negative unbounded damage values even if f(y) == 0 we allow f(y) - du = -du > 0.0 to cause damage rate


fracEneryCrackLengthIndex = 90; % energy needed to break up the whole plate
energyReleaseRateIndex = 91;	   % energy released by crack per unit time
fracEneryIndex = 92;			   	


global gMarkerStyle;
global gMarkerStyleName;
[gMarkerStyle, gMarkerStyleName] = getMarkerStyle();

global gColor;
global gLinename;
[gColor, gLinename] = getColorMap();

global gMarkerSize;
gMarkerSize = getMarkerSize();

global confGen;
global conf2DPlot;
