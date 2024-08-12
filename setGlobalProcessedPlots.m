function setGlobalProcessedPlots()


global pl_l0normalizer;
global pl_l1normalizer;
global pl_plateLength;
global pl_xlim;
global pl_ylim;
global pl_zlim;
global pl_xlimAve;
global pl_xlimAll;
global pl_xlimRange;
global pl_xlimRangeStep;
global pl_xlimRangeNum;
global pl_xlimRangeInterval;
global pl_numNames;
global pl_fldNames;
global pl_numPlots;
global pl_activeFlds;       % these are the fields that need computation 
global pl_activeFldsRangeVals; % for those that need computing the value at given x values
global pl_activeFldsAveVals; % actives for average type
global plt_active;
global plt_title;
global plt_yLbl;
global plt_zLbl;
global plt_legendLocation;
global plt_xReductionType;
global plt_yRange;
global plt_yRangeEffective;
global plt_zRange;
global plt_zRangeEffective;
global plt_numCurves;
global plt_Curves;
global pl_SingleXAxisValue;


global aveRedType;
global allRedType;
global rangeRedType;
global singleRangeRedType;

global crv_yaxis;
global crv_zaxis;
global crv_ClrNum;
global crv_StyleNum;
global crv_LineStyle;
global crv_LlineColor;
global crv_LlineWidth;
global crv_Lsymbol;
global crv_LmarkerStyle;
global crv_LmarkerSize;
global crv_LmarkerEdgeColor;
global crv_LmarkerFaceColor;




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
global IprintFlag;
global IprintExt;
global IColorPrint;
global INumStates;
global IwriteTitleEPS;
global IpsfragSym;


pl_l0normalizer = 1;
pl_l1normalizer = 2;
pl_plateLength = 3;
pl_xlim = 4;
pl_ylim = 5;
pl_zlim = 6;
pl_xlimAve = 7;
pl_xlimAll = 8;
pl_xlimRange = 9;
pl_xlimRangeStep = 10;
pl_xlimRangeNum = 11;
pl_xlimRangeInterval = 12;
pl_numNames = 13;
pl_fldNames = 14;
pl_numPlots = 15;
pl_activeFlds = 16; 
pl_activeFldsRangeVals = 17; 
pl_activeFldsAveVals = 18;
pl_SingleXAxisValue = 19;

plt_active = 1;
plt_title = 2;
plt_yLbl = 3;
plt_zLbl = 4;
plt_legendLocation = 5;
plt_xReductionType = 6;
plt_yRange = 8;
plt_yRangeEffective = 9;
plt_zRange = 10;
plt_zRangeEffective = 11;
plt_numCurves = 12;
plt_Curves = 13;



aveRedType = 1; 
allRedType = 2;
rangeRedType = 3;
singleRangeRedType = 4;

crv_yaxis = 1;
crv_zaxis = 2;
crv_ClrNum = 3;
crv_StyleNum = 4;
crv_LineStyle = 10;
crv_LlineColor = 11;
crv_LlineWidth = 12;
crv_Lsymbol = 13;
crv_LmarkerStyle = 14;
crv_LmarkerSize = 15;
crv_LmarkerEdgeColor = 16;
crv_LmarkerFaceColor = 17;


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
IprintFlag = 141;
IprintExt = 142;
IColorPrint = 143;
INumStates = 144;



IwriteTitleEPS = 150;
IpsfragSym = 151;
