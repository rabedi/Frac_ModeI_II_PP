function setGlobalValues()

% all quantities are normalized
%PZ process zone size
% v velocity
% t time
% a crack length (increment)
% vMax is maximum material velocity normal to crack surface (for mode I)
% vc: is cohesive time scale

global AddCRVSopt_a_t;
global AddCRVSopt_v_t;
global AddCRVSopt_PZ_v;
global AddCRVSopt_00_11Unbounded;
global AddCRVSopt_00_11Bounded;
global AddCRVSopt_1_Unbounded;
global AddCRVSopt_1Bounded;
global AddCRVSopt_vMax_rp2rsv;
global AddCRVSopt_rp_rsv_GivenSigmaForceSigmaC;
global AddCRVSopt_vMax_vc;
global AddCRVSopt_rprss_sigmaForceSigmaCUnbounded;
global AddCRVSopt_rprss_sigmaForceSigmaCBounded;
global AddCRVSopt_rprss_velocityUnbounded;
global AddCRVSopt_rprss_velocityBounded;

AddCRVSopt_a_t = 0;
AddCRVSopt_v_t = 1;
AddCRVSopt_PZ_v = 2;
AddCRVSopt_00_11Unbounded = 3;
AddCRVSopt_00_11Bounded = 4;
AddCRVSopt_1_Unbounded = 5;
AddCRVSopt_1Bounded = 6;
AddCRVSopt_vMax_rp2rsv = 7;
AddCRVSopt_rp_rsv_GivenSigmaForceSigmaC = 8;
AddCRVSopt_vMax_vc = 9;
AddCRVSopt_rprss_sigmaForceSigmaCUnbounded = 10;
AddCRVSopt_rprss_sigmaForceSigmaCBounded = 11;
AddCRVSopt_rprss_velocityUnbounded = 12;
AddCRVSopt_rprss_velocityBounded = 13;


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
global Icoord2sIndex;
global IenableMarkerValues;
global IelementBndryMarkerSize;
global IdisableElementBndry;
global IdisableProcessZones;
global IdisableExtrmmValues;
global IdisableLocalExtrmmValues;
global IplotAroundProcessZoneFactor;
global IplotAroundProcessZoneMinValues;
global IplotAroundProcessZoneMaxValues;
global IplotAroundProcessZoneSize;



global IprintDltTtlLabel;
global IdrawLineSegmentes;
global IonlyDrawSize2SolUnit;
global IplotAddCRVS;
%global IplotAddCRVSLabel;
%global IplotAddCRVSlColor;
global IplotAddCRVSlStyle;
global IplotAddCRVSlWidth;



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


global kappaOption_spz;
global kappaOptionMyEstimate_spz;
global beta_rpv_rps;
global distnceRatio_rpv2SingularVelocityCore;


IconfigDirectory = 1;
IconfigName = 2;
IflagNoIn = 3;
IprintOption = 4;
IplotXuNData = 5;
IplotBlack = 6;
IplotEPS = 7;
IblankRowNInLegend = 8;
IblankTextInLegend = 9;
Icoord2sIndex = 10;
IdisableMarkers = 11;
IelementBndryMarkerSize = 12;
IenableMarkerValues = 13;
IdisableElementBndry = 14;
IdisableProcessZones = 15;
IdisableExtrmmValues = 16;
IdisableLocalExtrmmValues = 17;
IplotAroundProcessZoneFactor = 18;
IplotAroundProcessZoneMinValues = 19;
IplotAroundProcessZoneMaxValues = 20;

IprintDltTtlLabel = 21;
IdrawLineSegmentes = 22;
IonlyDrawSize2SolUnit = 23;
IplotAddCRVS = 24;
%IplotAddCRVSLabel = 25;
%IplotAddCRVSlColor = 26;
IplotAddCRVSlStyle = 27;
IplotAddCRVSlWidth = 28;

IplotAroundProcessZoneSize = 29;


IoutputFolder = 31;
IappendRunMidName2OutFldr = 32;
IreadStat = 33;
IreadStatFinalTime = 34;
IStatFinalTimeName = 35;
IreadHistories = 36;
IgenerateHistoryFiles = 37;
ImaxPower_historyDerInfow = 38;
IhistoryFileName = 39;
IhistoryStatFileName = 40;
IcracktipVSymbol = 41;
IcracktipVIndex = 42;
IprocessZoneSymbol = 43;
IprocessZoneIndex = 44;
IprocessZoneRelativeCrackOpeningSymbol = 45;
IprocessZoneRelativeCrackOpeningIndex = 46;
IprocessZoneCrackOpeningSymbol = 47;
IprocessZoneCrackOpeningIndex = 48;
ICrackOpeningSymbol = 49;
ICrackOpeningIndex = 50;
IcohesiveZoneSizeConfigFileName = 51;
IcohesiveZoneSizeFileName = 52;
ImodifierForHistoryFiles = 53;
IAddSerialNumber2ModifedFilesBasedOnRunOrder = 54;
IallowOverwriteOfRunParameters = 55;
ImaxRelativeSpacePoint2PlotHistories = 56;
ImaxSpaceDotInClusterReductionRel2cR = 57;

IaddIntegrateData = 60;
IitegateDataFileName = 61;
IderDataFileName = 62;
IitegrationNormalizationOption = 63;


ImaxPowerRatioEReleaseRate = 70;
Iadd_LEFM_Data = 71;
ImaxPowerRatioRelativeProcessZoneSize = 72;
I_LEFMAngle_resolution = 73;
I_LEFMnumPtPerT = 74;
I_LEFMnumPtPerRamp = 75;
I_LEFM_rSigMethod = 76;
I_LEFM_rVelMethod = 77;
I_LEFM_rVelDir = 78;



I_TS_addData = 80;
I_TS_StatName = 81;
I_TS_readOnlyStat = 82;
I_TS_SliceDataName = 83;
I_TS_sliceReadFlag = 84;
I_TS_derOptionForTimeDerivatives = 85;
I_TS_interpolantOptCZEndPoints = 86;
I_TS_maxPowerVelocitiesRoundOff = 87;
I_TS_processZoneValSymbol = 88;
I_TS_processZoneValIndex = 89;
I_TS_processZoneNormalizerRunFlagData = 90;

I_TS_numReqFlds = 100;
I_TS_ReqFldsSymbol = 101;
I_TS_ReqFldsIndex = 102;
I_TS_ReqFldsFinderType = 103;
I_TS_ReqFldsNormalizerType = 104;
I_TS_numCollectFlds = 105;
I_TS_CollectFldsSymbol = 106;
I_TS_CollectFldsIndex = 107;
I_TS_CollectFldsNormalizerType = 108;
I_TS_ReqFlds = 109;
I_TS_CollectFlds = 110;
I_TS_totalFldsPerReqFld = 111;




IstartCohNormalizer = 120;
IincrmCohNormalizer = 121;
IstartLoadNormalizer = 122;
IincrmLoadNormalizer = 123;


Ilfs = 130;
Itfs = 131;
Ipltfs = 132;
Isymfs = 133;
IxminT = 134;   
IyminT = 135;
Idlwidth = 136;
Idhhlwidth = 137;
Idhdlwidth = 138;
IdLlwidth = 139;
Ipsfrag = 140;
IwriteTitleEPS = 141;
IpsfragSym = 142;
IdoReg = 143;
IShowArrowheadSwitch = 144;
IRegFlNo = 145;
IRegCrvNo = 146;
IRegPlotNo = 147;
IsymfsReg = 148;
Iafctr = 149;
Iaafctrb = 150;
Iaafctrh = 151;
Ibfctr = 152;
Ibafctrb = 153;
Ibafctrh = 154;


%spz static process zone
kappaOption_spz = 160;
kappaOptionMyEstimate_spz = 161;
beta_rpv_rps = 162;
distnceRatio_rpv2SingularVelocityCore = 163;

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
global plateTimeScale;

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
global cdRhoInvIndex;
global csRhoInvIndex;
global cdRhoIndex;
global csRhoIndex;
global tauLEFMIndex;	
global lengthLEFMIndex;


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
startCohFaceYIndex = 32;
plateTimeScale = 33;



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
cdRhoInvIndex = 93;
csRhoInvIndex = 94;
cdRhoIndex = 95;
csRhoIndex = 96;
tauLEFMIndex = 97;	
lengthLEFMIndex = 98;

