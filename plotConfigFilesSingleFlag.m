function plotConfigFilesSingleFlag(outputFolderIn, regenerateDataFile, confFid, flagNoIn, plotEPS, plotBlack)
global kappaOption_spz;
global kappaOptionMyEstimate_spz;
global beta_rpv_rps;
global distnceRatio_rpv2SingularVelocityCore;


global cnfg;

%clear cnfg;

kappaOpt = cnfg{kappaOption_spz};
kappaMyEstOpt = cnfg{kappaOptionMyEstimate_spz};
crpv_rps = cnfg{beta_rpv_rps};
crelDist = cnfg{distnceRatio_rpv2SingularVelocityCore};

%2. if r_p /2 is used or r_p in computing MY process zone size and maximum
% v1 velocity
global pz_rpFactor;
%pz_rpFactor = 1;    % options are 1, and 0.5
%pz_rpFactor = 0.5;    % options are 1, and 0.5

% if (pz_potential_Rice == 1)
%     pz_rpFactor = 1;
% end

% since in fem static process zone size is only computed based on potential
% model I may need to modifiy it as a post-processing step. rp0New =
% rpFromConfigFile * fem_pzStaticFactor
global fem_pzStaticFactor;
% static process zone size is  FValuePZSize * pi / (1 - nu) * mu *
% FractureEnergy / sigmaC^2
global FValuePZSize;

%tslModel 0 for XuN,
%         1     Ortiz
%         2     Dugdale
%         others not implemented
tslModel = 0;
[fem_pzStaticFactor, FValuePZSize, pz_rpFactor] = computeStaticProcessZoneSizeFactor(tslModel, kappaOpt, kappaMyEstOpt, crpv_rps, crelDist);

global fidQuasiSingular;
global flagValueBase; 
global flagDataBase;
global flagValueFile; 
global flagDataFile;
global flagValueCurvex;% = cell(0,10); 
global flagDataCurvex;% = cell(0,10);
global flagValueCurvey;% = cell(0,10); 
global flagDataCurvey;% = cell(0,10);
global flagSimDataCurvex;
global flagSimDataCurvey;
global nuIndex;
global IplotAroundProcessZoneFactor;


global gColor;
global gColorname;
global gLineStyle;
global gLineStyleName;
global gMarkerStyle;
global gMarkerStyleName;
global gMarkerSize;

global dlwidth;
global dhhlwidth;
global dhdlwidth;
global dLlwidth;

global fReg; % regrassion for the front of the shock
global bReg; %regression data for the back of the shock


global indn;    
global indx;
global indy;
global indxy;
global indx2;
global inda;
global indb;
global indr;
global indxs;
global indys;
global indxe;
global indye;
global indxa;
global indya;

%following are flag indices
% flag 11 min distance front of CT
% flag 12 max distance front of CT
% flag 13 min distance back of CT
% flag 14 max distance back of CT
global indcmnf;
global indcmxf;
global indcmnb;
global indcmxb;



%following global members are for plotting regression on velocity log log
%plots
global doReg;
global RegFlNo;
global RegCrvNo;
global RegPlotNo;
global plotRegAheadCrackTip;






global minVflag;
global maxVflag;
global averageVflag;
global minVtotal;
global maxVtotal;
global averageVtotal;


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


%global IoutputFolder;
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
%global IplotAddCRVSLabel;
%global IplotAddCRVSlColor;
global IplotAddCRVSlStyle;
global IplotAddCRVSlWidth;
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

global IplotAroundProcessZoneMinValues;
global IplotAroundProcessZoneMaxValues;


global IplotAddCRVS;

cnfg{IplotAroundProcessZoneMinValues} = inf * ones(1, 4);
cnfg{IplotAroundProcessZoneMaxValues} = -inf * ones(1, 4);

 

configDirectory = cnfg{IconfigDirectory};
configName = cnfg{IconfigName};
readStat = cnfg{IreadStat};

printOption = cnfg{IprintOption};
printDltTtlLabel = cnfg{IprintDltTtlLabel};
drawLineSegmentes = cnfg{IdrawLineSegmentes};
onlyDrawSize2SolUnit = cnfg{IonlyDrawSize2SolUnit};
readHistories = cnfg{IreadHistories};
historyFileName = cnfg{IhistoryFileName};
historyStatFileName = cnfg{IhistoryStatFileName};
cracktipVSymbol = cnfg{IcracktipVSymbol};
cracktipVIndex = cnfg{IcracktipVIndex};
processZoneSymbol = cnfg{IprocessZoneSymbol};
processZoneIndex = cnfg{IprocessZoneIndex};
cohesiveZoneSizeFileName = cnfg{IcohesiveZoneSizeFileName};
modifierForHistoryFiles = cnfg{ImodifierForHistoryFiles};
blankTextInLegend = cnfg{IblankTextInLegend};
plotXuNData = cnfg{IplotXuNData};
plotAddCRVS = cnfg{IplotAddCRVS};



lfs = cnfg{Ilfs};
tfs = cnfg{Itfs};
pltfs = cnfg{Ipltfs};
symfs = cnfg{Isymfs};
xminT = cnfg{IxminT};   
yminT = cnfg{IyminT};
dlwidth = cnfg{Idlwidth};
dhhlwidth = cnfg{Idhhlwidth};
dhdlwidth = cnfg{Idhdlwidth};
dLlwidth = cnfg{IdLlwidth};
psfrag = cnfg{Ipsfrag};
writeTitleEPS = cnfg{IwriteTitleEPS};
psfragSym = cnfg{IpsfragSym};
doReg = cnfg{IdoReg};
ShowArrowheadSwitch = cnfg{IShowArrowheadSwitch};
RegFlNo = cnfg{IRegFlNo};
RegCrvNo = cnfg{IRegCrvNo};
RegPlotNo = cnfg{IRegPlotNo};
symfsReg = cnfg{IsymfsReg};
afctr = cnfg{Iafctr};
aafctrb = cnfg{Iaafctrb};
aafctrh = cnfg{Iaafctrh};
bfctr = cnfg{Ibfctr};
bafctrb = cnfg{Ibafctrb};
bafctrh = cnfg{Ibafctrh};



%clear flagValueBase flagDataBase;
%clear flagValueFile flagDataFile;
%clear flagValueCurvex flagDataCurvex;
%clear flagValueCurvey flagDataCurvey;

%global numFields; % this is number of pairwise fields output on cohesive side. Old outputs have 7 new ones (2/20/08) 10 
%numFields = 19;%14 %10 





% lfs = 43;%27; %18;
% tfs = 26;%26;
% pltfs = 19;%22; %13;
% 
% symfs =  22;%CHANGE TO 28 28; %-> FOR LOGLOGXUN 26 OTHERS 28 (XUN SDG 7)  28;%22;%22;%17   21;%21%16; %15;
% xminT = 1;   
% yminT = 1;




% dlwidth = 1.8;%1.8 use 1.4 for trajectory convergences
% dhhlwidth = 2.5;
% dhdlwidth = 3.0;
% dLlwidth = 3.0;
% 
% psfrag = 1;
% writeTitleEPS = 0; % if 1 write title for eps figures 
% psfragSym = 0;

if ((psfrag == 1) && (plotEPS == 1))
    psfragSym = 1;
end


% doReg = 0; % set this to on for having regression on the plot
% ShowArrowheadSwitch = 'off';
% RegFlNo = 1;
% RegCrvNo = 3;
% RegPlotNo = 3;
% symfsReg = 17;
% % factor size
% afctr = .33;%0.09; % is a factor how much reg equiation is distanced from the reg itself
% aafctrb = 0.05;%0.35; % on the distance frm reg text to reg line this is factor that the arrow does not extent on either side
% aafctrh = 0.15;%0.35; % on the distance frm reg text to reg line this is factor that the arrow does not extent on either side
% 
% bfctr = 0.11;
% bafctrb = 0.08; % on the distance frm reg text to reg line this is factor that the arrow does not extent on either side
% bafctrh = 0.15; % on the distance frm reg text to reg line this is factor that the arrow does not extent on either side



%these indices are used on regression
%n number of points
% x y x2 xy summs of these variables 
%a b r reggression values
%x, y s e start and end points
% sa ya averages


if (doReg == 1)
    indn = 1;   indx = 2;   indy = 3;   indxy = 4;  indx2 = 5;  inda = 6;   indb = 7;
    indr = 8;   indxs = 9;  indys = 10; indxe = 11; indye = 12; indxa = 13; indya = 14;
    fReg = zeros(1,14);
    bReg = zeros(1,14);
    indcmnf = 11;
    indcmxf = 12;
    indcmnb = 13;
    indcmxb = 14;
    regsymbb = 'Behind crack tip';
    regsymbf = 'Ahead of crack tip';
    if (plotEPS == 1)
        regsymbb = 'behind';
        regsymbf = 'ahead';
        regtextb = 'behindbehindtext';
        regtextf = 'aheadaheadahtext';
    end
    
%   if (plotBlack == 0)
    
    % 1 refers to behind 2 to ahead
        reglstl{1} = '-';%'--';
        reglstl{2} = '-';%'-.';
    %    reglstl{2} = ':';

       reglwdth{1} = 3 * dlwidth;
       reglwdth{2} = 3 * dlwidth;

       regclr{1} = [0 1 0];
       regclr{2} = [1 0 0];
%    else
%     % 1 refers to behind 2 to ahead
%         reglstl{1} = '-';%'--';
%         reglstl{2} = '-';%'-.';
%     %    reglstl{2} = ':';
% 
%        reglwdth{1} = 3 * dlwidth;
%        reglwdth{2} = 3 * dlwidth;
% 
%        regclr{1} = [0.6 0.6 0.6];
%        regclr{2} = [0.3 0.3 0.3];
%    end       
end





[gColor, gLinename] = getColorMap();
[gLineStyle, gLineStyleName] = getLineStyle();
[gMarkerStyle, gMarkerStyleName] = getMarkerStyle();
gMarkerSize = getMarkerSize();




blankRowNInLegend = cnfg{IblankRowNInLegend};


if (plotXuNData == 1)
numxn = 2;
num11a = 1;
num11b = 3;
num11a30 = 2;
num11b30 = 4;
nummrgn = 5;

xnlstl{1} = ':';%'-.';%'--';
xnlstl{2} = '-.';%':'; %'-.';
xnlstl{3} = '--';
xnlstl{4} = '-';
xnlstl{5} = '-.';


xnlclr{1} = [0 0 0];
xnlclr{2} = [0 0 0];
xnlclr{3} = [0 0 0];
xnlclr{4} = [0.7 0.7 0.7];
xnlclr{5} = [0.3 0 0.3];

xnsymb{num11a} = 'XN15';%'Xu Needleman15';%'Xu Needleman(11a)';%'Xu Needleman(11a)';
xnsymb{num11b} = 'Xu Needleman(11b)';
xnsymb{num11a30} = 'XN30';%'Xu Needleman30'%'Xu Needleman(11a) V = 30m/s';
xnsymb{num11b30} = 'Xu Needleman(11b) V = 30m/s';
xnsymb{nummrgn} = 'Xu Needleman(morgan)';

xndata{num11a} = [1.612612613	4.25	0.031126951
1.657657658	4.252038535	0.065366598
1.675675676	4.253669363	0.1276205
1.684684685	4.255050306	0.199212488
1.711711712	4.261086999	0.277029866
1.72972973	4.266610771	0.37663611
1.756756757	4.27726376	0.463791574
1.774774775	4.285838758	0.550947037
1.81981982	4.311287565	0.653665977
1.882882883	4.352623792	0.743934135
1.972972973	4.41930361	0.834202294
1.981981982	4.426366147	0.837314989
2.009009009	4.447751036	0.84976577
2.054054054	4.484313145	0.880892721
2.108108108	4.529450253	0.899568892
2.162162162	4.575455382	0.915132367
2.261261261	4.661534162	0.936921233
2.36036036	4.749348984	0.952484709
2.468468468	4.846725192	0.968048185
2.621621622	4.986463471	0.97738627
2.747747748	5.102830933	0.98983705
2.864864865	5.211570329	0.98983705
2.990990991	5.32885842	0.992949746
3.117117117	5.446330637	0.992949746
3.324324324	5.6396232	0.996062441
3.441441441	5.749046492	0.996062441];


xndata{num11b} = [1.741573034	4.25	0.187674968
1.764044944	4.254417461	0.231465794
1.775280899	4.257120683	0.281512452
1.786516854	4.260318398	0.325303278
1.797752809	4.263895223	0.353454523
1.808988764	4.267785226	0.384733684
1.820224719	4.272120271	0.437908258
1.831460674	4.276966292	0.481699084
1.853932584	4.287647317	0.531745742
1.876404494	4.299515123	0.594304065
1.898876404	4.312437845	0.631839058
1.921348315	4.326151754	0.669374052
1.966292135	4.355227878	0.710036962
2.011235955	4.385886377	0.744444039
2.04494382	4.409918684	0.7757232
2.08988764	4.443280404	0.807002362
2.134831461	4.477828906	0.832025691
2.202247191	4.531431829	0.863304852
2.235955056	4.558925579	0.875816516
2.269662921	4.586617126	0.875816516
2.325842697	4.633099365	0.888328181
2.370786517	4.670746683	0.897711929
2.415730337	4.708723661	0.903967762
2.426966292	4.718316804	0.916479426
2.438202247	4.728041812	0.928991091
2.460674157	4.747359963	0.903967762
2.483146067	4.766546249	0.916479426
2.494382022	4.776304222	0.935246923
2.539325843	4.815270185	0.91335151
2.561797753	4.834687234	0.928991091
2.606741573	4.873982858	0.935246923
2.617977528	4.883905662	0.947758587
2.651685393	4.913674075	0.935246923
2.674157303	4.933255955	0.922735258
2.719101124	4.972419714	0.935246923
2.797752809	5.041879344	0.947758587
2.853932584	5.091823027	0.947758587
2.898876404	5.13197577	0.957142336
2.943820225	5.171996648	0.941502755
2.97752809	5.201962858	0.95401442
3	5.222171094	0.963398168
3.078651685	5.293015302	0.957142336
3.146067416	5.353738908	0.963398168
3.202247191	5.404259498	0.95401442
3.258426966	5.454697673	0.960270252
3.325842697	5.51542128	0.960270252
3.370786517	5.555771819	0.95401442
3.426966292	5.606045164	0.95401442
3.471910112	5.646263839	0.95401442
3.494382022	5.666373177	0.95401442];


xndata{num11a30} = [1.488789238	4.25	0.052915817
1.488789238	4.25	0.102718939
1.497757848	4.251073615	0.152522061
1.506726457	4.252605479	0.211663269
1.524663677	4.256690452	0.273917171
1.533632287	4.259662532	0.432664623
1.551569507	4.267701548	0.522932781
1.560538117	4.272454257	0.60697555
1.578475336	4.283373703	0.691018318
1.605381166	4.30203103	0.787511867
1.641255605	4.329735524	0.859103855
1.695067265	4.375220124	0.943146624
1.713004484	4.3912196	0.958710099
1.748878924	4.423951753	0.986724355
1.793721973	4.465914373	1.008513221
1.838565022	4.508662564	1.024076697
1.865470852	4.534664986	1.036527477
1.928251121	4.596070505	1.048978258
1.99103139	4.658025924	1.055203648
2.062780269	4.729251088	1.061429038
2.143497758	4.809732906	1.064541733
2.224215247	4.89056823	1.070767124
2.286995516	4.953715099	1.073879819
2.349775785	5.017136919	1.080105209
2.394618834	5.062569147	1.080105209
2.520179372	5.189596085	1.076992514
2.618834081	5.289258944	1.076992514
2.735426009	5.406872115	1.073879819
2.896860987	5.569249779	1.070767124
3.058295964	5.731391771	1.070767124];



xndata{num11b30} = [1.49103139	4.25	0.294024116
1.502242152	4.253322113	0.337814942
1.524663677	4.261282029	0.419140761
1.547085202	4.271149692	0.519234078
1.558295964	4.277267644	0.644350723
1.591928251	4.299075181	0.738188207
1.6367713	4.331506902	0.803874445
1.692825112	4.375664697	0.875816516
1.726457399	4.403688862	0.900839845
1.748878924	4.422865021	0.922735258
1.748878924	4.422865021	0.928991091
1.771300448	4.442402995	0.928991091
1.793721973	4.462072538	0.941502755
1.804932735	4.472088217	0.963398168
1.872197309	4.532873025	0.963398168
1.928251121	4.584513798	1.000933162
1.961883408	4.616386352	1.019700658
1.984304933	4.637667613	1.004061078
2.01793722	4.669786858	1.032212323
2.040358744	4.691331257	1.016572742
2.051569507	4.702087011	1.029084407
2.118834081	4.767114914	1.032212323
2.118834081	4.767114914	1.013444826
2.152466368	4.799382175	1.032212323
2.197309417	4.842865679	1.035340239
2.208520179	4.853818786	1.047851904
2.275784753	4.919932132	1.047851904
2.320627803	4.964402403	1.0666194
2.343049327	4.986637539	1.047851904
2.365470852	5.008872674	1.0666194
2.399103139	5.042225377	1.047851904
2.421524664	5.064427621	1.063491484
2.5	5.142711086	1.063491484
2.533632287	5.176014451	1.047851904
2.567264574	5.209268477	1.060363568
2.612107623	5.253607179	1.047851904
2.656950673	5.298406372	1.082258981
2.679372197	5.320838861	1.05097982
2.746636771	5.387840297	1.072875233
2.791479821	5.432771059	1.063491484
2.914798206	5.55596884	1.0666194
2.926008969	5.567267315	1.082258981
2.948430493	5.589864265	1.0666194
2.993273543	5.634597673	1.060363568
3.004484305	5.64584681	1.079131065
3.038116592	5.67959422	1.060363568];


xndata{nummrgn} = [1.6	4.25	0.042643923
1.65	4.253	0.085287846
1.8	4.301	0.597014925
1.9	4.365	0.767590618
2	4.441	0.852878465
2.1	4.523	0.895522388
2.2	4.609	0.938166311
2.3	4.69725	0.943496802
2.35	4.741875	0.959488273
2.5	4.877625	0.970149254
2.6	4.969125	0.980810235
3	5.339125	0.991471215
3.4	5.712125	0.996801706];
    
% xnt = [1.60
% 1.65
% 1.80
% 1.90
% 2.00
% 2.10
% 2.20
% 2.30
% 2.35
% 2.50
% 2.60
% 3.00
% 3.40];
% 
% xna = [0
% 0.002
% 0.014
% 0.07
% 0.142
% 0.222
% 0.306
% 0.394
% 0.43825
% 0.57325
% 0.66425
% 1.03225
% 1.40425];
% 
% xnnv = [
% 0.04
% 0.08
% 0.56
% 0.72
% 0.8
% 0.84
% 0.88
% 0.885
% 0.9
% 0.91
% 0.92
% 0.93
% 0.935];
% 
% xnv = 938 * xnnv;
% 
% xna = xna + 4.25;
end



% figVec, 

[numSubConfig, maxPlotNoToPlot, plotComponentSize, plotFileNumber, Size, xcol, ycol, ...
    curve, linespec, symbol, xaxis, yaxis, xMaxDist, yMaxDist, marker,  startingPts, colSize, ...
    maxCross, minVflag, minCoord, min_eID, min_id, maxVflag, maxCoord, max_eID, max_id, counter, averageVflag, ...
    sum, sDiviation, fieldName, directoryO, runnameO, middlenameO ,name, flagnum, serial, ext, minVtotal, minCoordT, ...
    maxVtotal, maxCoordT, averageVtotal, outputFolderT] = ...
readConfig(outputFolderIn, regenerateDataFile, confFid,  flagNoIn, readStat, readHistories, historyFileName, historyStatFileName, ...
    cracktipVSymbol, cracktipVIndex, processZoneSymbol, processZoneIndex, cohesiveZoneSizeFileName, modifierForHistoryFiles, plotBlack);

outputFolder = outputFolderT; %cnfg{IoutputFolder};


    

%lfs = cnfg{Ilfs};


%  minV{1}
% for i=1:55
%     i
%     d = maxV{1}(i)
% end
% pause
% 
% minCoord{1}
% min_eID{1}
% min_id{1}
% maxV{1}
% maxCoord{1}
% max_eID{1}
% max_id{1}
% pause
printOptionR = sprintf('-d%s',printOption);
if (strcmp(outputFolder,'') ~= 1)
    outputFolder = [outputFolder,'/'];
end



if (strcmp(printOption, 'eps') == 1)
    printDltTtlLabel = 1;
end


drawLines = 1;
numberOfSegments = -1;
drawPoints = 1;
numberOfPoints = -1;

Lsymbol = cell(0);
LlineColor = cell(0);
LlineStyle = cell(0);
LmarkerStyle = cell(0);
LmarkerSize = cell(0);
LmarkerEdgeColor = cell(0);
LmarkerFaceColor = cell(0);

additionalCurveOptionNumber = zeros(maxPlotNoToPlot, 1);
additionalCurveColorNum = zeros(maxPlotNoToPlot, 1);
additionalCurveXLog = zeros(maxPlotNoToPlot, 1);
additionalCurveYLog = zeros(maxPlotNoToPlot, 1);
additionalCurveLabel =  cell(maxPlotNoToPlot, 1);

additionalCurveDefaultColorNum = numSubConfig + 1;
if (additionalCurveDefaultColorNum <= 6)
    additionalCurveDefaultColorNum = 6;
elseif (additionalCurveDefaultColorNum <= 10)
    additionalCurveDefaultColorNum = 10;
elseif (additionalCurveDefaultColorNum <= 14)
    additionalCurveDefaultColorNum = 14;
elseif (additionalCurveDefaultColorNum <= 18)
    additionalCurveDefaultColorNum = 18;
end


actualPlotNo = 0;

while (actualPlotNo < maxPlotNoToPlot)
    AddCRVSDone = 0;
    
%Legend location    
    legL = 'Best';
    optionSubdivide = 0;
    xlimType = 1;    % means Min and Max values given are relative to min and max values plotted 
                        %       xlimMin = 0    xlimMax = 1 means tight plot
                        %       and -0.1 1.1 means %10 spacing on each side
                        %       xlimRelDiv is number of spacing in coming
                        %       up with min and max value 0 means actual
                        %       min and max are set (refer to subdivide
                        %       function)
                        % value 2 means user has specified min / max values

    xlimMin = 0.0;
    xlimMax = 1.0;
    xlimRelDiv = 0;

    ylimType = 1;
    ylimMin = -0.1;
    ylimMax = 1.1;
    ylimRelDiv = 0;
    
%     ylimMin = inf;
%     ylimMax = -inf;
    
    x1Max = -inf;
    x1Min = inf;
    
    y1Max = -inf;
    y1Min = inf;
    
%-------------------------------------------------------------------------------------------------------------------------    
%part to do with the setting of the plot
    actualPlotNo = fscanf(confFid,'%d', 1);
%   figVec(plotNo) = figHandle;
%   figure(figVec(plotNo));

%     if (actualPlotNo == 2)
%         actualPlotNo
%     end
    
    
    doPlotFlag_ = fscanf(confFid,'%d', 1);
    additionalCurveOptionNumber(actualPlotNo) = fscanf(confFid,'%d', 1);
    colNum_ = fscanf(confFid,'%d', 1);
    if (colNum_ < 0)
        colNum_ = additionalCurveDefaultColorNum;
    end
    additionalCurveColorNum(actualPlotNo) = colNum_;
    additionalCurveXLog(actualPlotNo) = fscanf(confFid,'%d', 1);
    additionalCurveYLog(actualPlotNo) = fscanf(confFid,'%d', 1);
    xLimIsRegularSpace = fscanf(confFid,'%d', 1);
    plotRegAheadCrackTip = fscanf(confFid,'%d', 1);
    additionalCurveLabel{actualPlotNo} = fscanf(confFid,'%s', 1);
    
    plotAddModifiedOptNumber = getAddCurveOptionNumber(plotAddCRVS, additionalCurveOptionNumber(actualPlotNo));
    if (plotAddModifiedOptNumber >= 0)
    	plotAddCRVSLabel = additionalCurveLabel{actualPlotNo};
    	plotAddCRVSlColorNum = additionalCurveColorNum(actualPlotNo);
        plotAddCRVSlStyle = cnfg{IplotAddCRVSlStyle};
        plotAddCRVSlWidth = cnfg{IplotAddCRVSlWidth};
        plotAddCRVSlMarker = 'none';

        if (plotBlack == 1)
            [plotAddCRVSlStyle, plotAddCRVSlColor, plotAddCRVSlMarker] = gLineStyleBlack(plotAddCRVSlColorNum);
        else
            plotAddCRVSlColor = gColor{plotAddCRVSlColorNum};
        end
    end
   

if (doReg == 1)
    indn = 1;   indx = 2;   indy = 3;   indxy = 4;  indx2 = 5;  inda = 6;   indb = 7;
    indr = 8;   indxs = 9;  indys = 10; indxe = 11; indye = 12; indxa = 13; indya = 14;
    fReg = zeros(1,14);
    bReg = zeros(1,14);
    indcmnf = 11;
    indcmxf = 12;
    indcmnb = 13;
    indcmxb = 14;
    regsymbb = 'Behind crack tip';
    regsymbf = 'Ahead of crack tip';
    if (plotEPS == 1)
        regsymbb = 'behind';
        regsymbf = 'ahead';
        regtextb = 'behindbehindtext';
        regtextf = 'aheadaheadahtext';
    end
   reglstl{1} = '-';%'--';
   reglstl{2} = '-';%'-.';
   
   reglwdth{1} = 3 * dlwidth;
   reglwdth{2} = 3 * dlwidth;

   regclr{1} = [0 1 0];
   regclr{2} = [1 0 0];
end
    
%     if (actualPlotNo ~= plotNo)
%         fprintf(1,'main Config file plotNo = %d is missing\n', plotNo);
%         return;
%     end
    sentinal = 'x';
    plotTitle = 'title';
    xlab = 'xlabel';
    ylab = 'ylabel';
    
    xminReq = -inf;
    xmaxReq = inf;
    yminReq = -inf;
    ymaxReq = inf;
    
    while (strcmp(sentinal, 'end') ~= 1)
%       read some stuff here
        sentinal = fscanf(confFid,'%s', 1);
%       xlim
        if (strcmp(sentinal, 'xlim') == 1)
            temp = fscanf(confFid,'%s', 1);
            if (strcmp(temp,'rel') == 1)
                xlimType = 1;
            elseif (strcmp(temp,'abs') == 1)
                xlimType = 2;
            else
                xlimType = 0;
            end
            xlimMin = fscanf(confFid,'%lg', 1);
            xlimMax = fscanf(confFid,'%lg', 1);
            if (xlimType == 1)
                xlimRelDiv = fscanf(confFid,'%lg', 1);
            end
            if (xlimType == 2)
                xminReq = xlimMin;
                xmaxReq = xlimMax;
            end
        end
    
%       ylim
        if (strcmp(sentinal, 'ylim') == 1)
            temp = fscanf(confFid,'%s', 1);
            if (strcmp(temp,'rel') == 1)
                ylimType = 1;
            elseif (strcmp(temp,'abs') == 1)
                ylimType = 2;
            else
                ylimType = 0;
            end
            ylimMin = fscanf(confFid,'%lg', 1);
            ylimMax = fscanf(confFid,'%lg', 1);
            if (ylimType == 1)
                ylimRelDiv = fscanf(confFid,'%lg', 1);
            end
            
            if (ylimType == 2)
                yminReq = ylimMin;
                ymaxReq = ylimMax;
            end
            
        end
        
%       title         
        if (strcmp(sentinal, 'title') == 1)
            plotTitle = fscanf(confFid,'%s', 1);
            plotTitle = readStringWithoutSpace(plotTitle, '*', ' ');
        end
%       xlabel         
        if (strcmp(sentinal, 'xlabel') == 1)
            xlab = fscanf(confFid,'%s', 1);
            xlab = readStringWithoutSpace(xlab, '*', ' ');
        end
    
%       ylabel         
        if (strcmp(sentinal, 'ylabel') == 1)
            ylab = fscanf(confFid,'%s', 1);
            ylab = readStringWithoutSpace(ylab, '*', ' ');
        end

%       xscale      linear log
        if (strcmp(sentinal, 'xscale') == 1)
            opt = fscanf(confFid,'%s', 1);
            set(gca,'XScale', opt);
        end

%       yscale
        if (strcmp(sentinal, 'yscale') == 1)
            opt = fscanf(confFid,'%s', 1);
            set(gca,'YScale', opt);
        end

%       xdir    normal reverse
        if (strcmp(sentinal, 'xdir') == 1)
            opt = fscanf(confFid,'%s', 1);
            set(gca,'XDir', opt);
        end

%       xdir    normal reverse
        if (strcmp(sentinal, 'ydir') == 1)
            opt = fscanf(confFid,'%s', 1);
            set(gca,'YDir', opt);
        end

%       xdir    normal reverse
        if (strcmp(sentinal, 'legend') == 1)
            prop = fscanf(confFid,'%s', 1);
            while (strcmp(prop,'legendEnd') ~= 1)
                if (strcmp(prop,'location') == 1)
                    legL = fscanf(confFid,'%s', 1);
                    legend(gca,'Location', legL);
                    prop = fscanf(confFid,'%s', 1);
                end
            end
            legend('boxoff');
        end
        
    end

    xlimProcessZoneRegSpace = ((cnfg{IplotAroundProcessZoneFactor} > 0) && (xLimIsRegularSpace == 1));
    if (xlimProcessZoneRegSpace == 1)
        [xMinRegPZSpace xMaxRegPZSpace] = computeLimitsAroundProcessZone();
    end
    b_regPlot = ((doReg ~= 0) && (actualPlotNo <= RegPlotNo));
    if (b_regPlot == 1)
        xlimProcessZoneRegSpace = 0;
        fReg = zeros(1,14);
        bReg = zeros(1,14);
        
    end
        
%    xlimProcessZoneLogSpace = ((cnfg{IplotAroundProcessZoneFactor} > 0) && (xLimIsRegularSpace > 1));
    if (xlimProcessZoneRegSpace == 1)
        xminReq = xMinRegPZSpace;
        xmaxReq = xMaxRegPZSpace;
    end
    
%-------------------------------------------------------------------------------------------------------------------------
    if (length(Size) < actualPlotNo)
        continue;
    end
    if (length(Size{actualPlotNo}) == 0)
        continue;
    end

    if (doPlotFlag_ == 0)
        continue;
    end
    
    figHandle = figure(actualPlotNo);
    
    Lnum = 0;
    LnumP = 0;
    Lsymbol = cell(0);
    LlineColor = cell(0);
    LlineStyle = cell(0);
    LmarkerStyle = cell(0);
    LmarkerSize = cell(0);
    LmarkerEdgeColor = cell(0);
    LmarkerFaceColor = cell(0); 
%    clear Lsymbol;
%    clear LlineColor LlineStyle LmarkerStyle LmarkerSize LmarkerEdgeColor LmarkerFaceColor; 
    clear LsymbolP LlineColorP LlineStyleP LmarkerStyleP LmarkerSizeP LmarkerEdgeColorP LmarkerFaceColorP; 


    for filePlot = 1:plotComponentSize(actualPlotNo)
%         Lsymbol = cell(0);
%         LlineColor = cell(0);
%         LlineStyle = cell(0);
%         LmarkerStyle = cell(0);
%         LmarkerSize = cell(0);
%         LmarkerEdgeColor = cell(0);
%         LmarkerFaceColor = cell(0);
        fileNumber = plotFileNumber{actualPlotNo}{filePlot};

%        actualPlotNo
%         if (actualPlotNo == 21)
%             aa = 12;
%         end

        cntr = counter{fileNumber}(1);
%         xc = xcol{actualPlotNo}{filePlot}
%         ln = length(xcol{actualPlotNo}{filePlot})
%         onv = ones(1, length(xcol{actualPlotNo}{filePlot}))
%         vl = cntr * ones(1, length(xcol{actualPlotNo}{filePlot}))
        dataSize = cntr * ones(1, length(xcol{actualPlotNo}{filePlot}));
        pointDataSize = cntr * ones(1, length(xcol{actualPlotNo}{filePlot}));

%     if ((actualPlotNo == 1) && (xlimProcessZoneRegSpace == 1))
%         xminReq = -inf;
%         xmaxReq = inf;
%     end
         
        flagCol = getColNumberFromSymbolNumber('id', 0, startingPts{fileNumber});
              [lastIndex , lastIndexPoints, x1Min, x1Max, y1Min, y1Max] = ...
      	plotFileSerialPointsOrLines(xminReq, xmaxReq, yminReq, ymaxReq, fileNumber, curve{actualPlotNo}{filePlot}, xcol{actualPlotNo}{filePlot}, ycol{actualPlotNo}{filePlot}, ...
               dataSize, startingPts{fileNumber}, linespec{actualPlotNo}{filePlot}{2}, linespec{actualPlotNo}{filePlot}{1}, ...
               linespec{actualPlotNo}{filePlot}{3}, colSize{fileNumber}, drawLineSegmentes, xMaxDist{actualPlotNo}{filePlot}, ...
               yMaxDist{actualPlotNo}{filePlot}, flagCol, marker{actualPlotNo}{filePlot}{1}, marker{actualPlotNo}{filePlot}{3}, ...
               marker{actualPlotNo}{filePlot}{4}, marker{actualPlotNo}{filePlot}{5}, pointDataSize, directoryO{fileNumber}, ...
               runnameO{fileNumber}, middlenameO{fileNumber}, flagnum{fileNumber}, serial{fileNumber}, name{fileNumber}, ...
               ext{fileNumber}, drawLines, numberOfSegments, drawPoints, numberOfPoints, ...
               x1Min, x1Max, y1Min, y1Max, xlimType, ylimType, onlyDrawSize2SolUnit);
           
%     if ((actualPlotNo == 1) && (xlimProcessZoneRegSpace == 1))
%         [xMinRegPZSpace xMaxRegPZSpace] = computeLimitsAroundProcessZone();
%     end
%         if (ylimType == 1) 
%            ylimMin = min(ylimMin, y1Min);
%            ylimMax = max(ylimMax, y1Max);
%         end
                              
        if ((plotXuNData == 1) && (  (actualPlotNo == 1) || (actualPlotNo == 2)  ))
            if (actualPlotNo == 1)
                j = filePlot;
    %            for j = 1:numxn
                    hold on;
                    linWidth = dlwidth;
                    if (xnlstl{j} == ':')
                        linWidth = dLlwidth;
                    end
                    if (xnlstl{j} == '--')
                        linWidth = dhhlwidth;
                    end
                    if (xnlstl{j} == '-.')
                        linWidth = dhdlwidth;
                    end
                    plot(xndata{j}(:,1),xndata{j}(:,2),'LineStyle',  xnlstl{j}, 'Color', xnlclr{j},'LineWidth',linWidth);
     %           end
            end
            if (actualPlotNo == 2)
                j = filePlot;
    %            for j = 1:numxn
                    hold on;
                    linWidth = dlwidth;
                    if (xnlstl{j} == ':')
                        linWidth = dLlwidth;
                    end
                    plot(xndata{j}(:,1),xndata{j}(:,3),'LineStyle',  xnlstl{j}, 'Color', xnlclr{j},'LineWidth',linWidth);
    %            end
            end
        end
        
        len = length(xcol{actualPlotNo}{filePlot});

        for col = 1:len
            if ((strcmp(symbol{actualPlotNo}{filePlot}{col},'none') == 1) || (lastIndex(col) == 0))
                continue;
            end
            Lnum = Lnum + 1;
            for j = 1:length(blankRowNInLegend)
                if (blankRowNInLegend(j) == Lnum)
                    Lsymbol{Lnum} = blankTextInLegend{j};
                    if (psfragSym == 1)
                        Lsymbol{Lnum} = clearFromLatexOperands(Lsymbol{Lnum});
                    end
                    LlineColor{Lnum} = [1 1 1];
                    LlineStyle{Lnum} = 'none';
                    LmarkerStyle{Lnum} = 'none';
                    LmarkerSize{Lnum} = get(0,'DefaultLineMarkerSize');
                    LmarkerEdgeColor{Lnum} = get(0,'DefaultLineMarkerEdgeColor');
                    LmarkerFaceColor{Lnum} = 'none';
                    Lnum = Lnum + 1;
                end
            end
            Lsymbol{Lnum} = symbol{actualPlotNo}{filePlot}{col};
            % don't want any latex output for psfrag substitution of symbols
            if (psfragSym == 1)
                Lsymbol{Lnum} = clearFromLatexOperands(Lsymbol{Lnum});
            end
            
            LlineColor{Lnum} = linespec{actualPlotNo}{filePlot}{2}{col};
            LlineStyle{Lnum} = linespec{actualPlotNo}{filePlot}{1}{col};
%           temp
%            if Lnum == 3
%                LlineStyle{Lnum} = '--';
%            end
            LmarkerStyle{Lnum} = linespec{actualPlotNo}{filePlot}{3}{col};
            LmarkerSize{Lnum} = get(0,'DefaultLineMarkerSize');
            LmarkerEdgeColor{Lnum} = get(0,'DefaultLineMarkerEdgeColor');
            LmarkerFaceColor{Lnum} = 'none';
        end
		


        
        for col = 1:len
            numMarker = length(marker{actualPlotNo}{filePlot}{1}{col});
            for mark = 1:numMarker
                if ((strcmp(marker{actualPlotNo}{filePlot}{2}{col}{mark},'none') == 1) || (lastIndexPoints{col}{mark} == 0))
                    continue;
                end
                
                LnumP = LnumP + 1;
                LsymbolP{LnumP} = marker{actualPlotNo}{filePlot}{2}{col}{mark};
            % don't want any latex output for psfrag substitution of symbols
            if (psfragSym == 1)
                LsymbolP{LnumP} = clearFromLatexOperands(LsymbolP{LnumP});
            end

                
                
                LlineColorP{LnumP} = 'k';
                LlineStyleP{LnumP} = 'none';
                LmarkerStyleP{LnumP} = marker{actualPlotNo}{filePlot}{3}{col}{mark};
                LmarkerSizeP{LnumP} = marker{actualPlotNo}{filePlot}{5}{col}{mark};
                color = marker{actualPlotNo}{filePlot}{4}{col}{mark};
                if (strcmp(color,'curve') == 1)
                    color = linespec{actualPlotNo}{filePlot}{2}{col};
                elseif (strcmp(color,'curveBlack') == 1)
                    color = 'k';
                end
                
            colorFace = 'none';
            if ((marker{actualPlotNo}{filePlot}{1}{col}{mark} <= -1)    && (marker{actualPlotNo}{filePlot}{1}{col}{mark} >= -4))
                colorFace = color;
            end    
                
                LmarkerEdgeColorP{LnumP} = color;
                LmarkerFaceColorP{LnumP} = colorFace;
            end
        end
        
                
    if ((plotXuNData == 1) && (  (actualPlotNo == 1) || (actualPlotNo == 2)  ))
%        for j = 1:numxn
            j = filePlot;
            Lnum = Lnum + 1;
            for k = 1:length(blankRowNInLegend)
                if (blankRowNInLegend(k) == Lnum)
                    Lsymbol{Lnum} = blankTextInLegend{k};
                    if (psfragSym == 1)
                        Lsymbol{Lnum} = clearFromLatexOperands(Lsymbol{Lnum});
                    end
                    LlineColor{Lnum} = [1 1 1];
                    LlineStyle{Lnum} = 'none';
                    LmarkerStyle{Lnum} = 'none';
                    LmarkerSize{Lnum} = get(0,'DefaultLineMarkerSize');
                    LmarkerEdgeColor{Lnum} = get(0,'DefaultLineMarkerEdgeColor');
                    LmarkerFaceColor{Lnum} = 'none';
                    Lnum = Lnum + 1;
                end
            end            
            Lsymbol{Lnum} = xnsymb{j};

            % don't want any latex output for psfrag substitution of symbols
            if (psfragSym == 1)
                Lsymbol{Lnum} = clearFromLatexOperands(Lsymbol{Lnum});
            end

            
            
       %    if (plotBlack == 0)
                LlineStyle{Lnum} = xnlstl{j}; %'-'
                LlineColor{Lnum} = xnlclr{j};%[1 0 0]%'r';
                LmarkerStyle{Lnum} = 'none';
        %   else
        %       [LlineStyle{Lnum} , LlineColor{Lnum}, LmarkerStyle{Lnum}] = gLineStyleBlack(Lnum);

        %   end
            xnlstl{j} = LlineStyle{Lnum};
            xnlclr{j} = LlineColor{Lnum};
            LmarkerSize{Lnum} = 6;
            LmarkerEdgeColor{Lnum} = get(0,'DefaultLineMarkerEdgeColor');
            LmarkerFaceColor{Lnum} = 'none';
        end
%    end
    % end Xu N data
        
        
    end

    
    for i = 1:LnumP
            Lnum = Lnum + 1;
            for j = 1:length(blankRowNInLegend)
                if (blankRowNInLegend(j) == Lnum)
                    Lsymbol{Lnum} = blankTextInLegend{j};
                    if (psfragSym == 1)
                        Lsymbol{Lnum} = clearFromLatexOperands(Lsymbol{Lnum});
                    end
                    LlineColor{Lnum} = [1 1 1];
                    LlineStyle{Lnum} = 'none';
                    LmarkerStyle{Lnum} = 'none';
                    LmarkerSize{Lnum} = get(0,'DefaultLineMarkerSize');
                    LmarkerEdgeColor{Lnum} = get(0,'DefaultLineMarkerEdgeColor');
                    LmarkerFaceColor{Lnum} = 'none';
                    Lnum = Lnum + 1;
                end
            end            
            Lsymbol{Lnum} = LsymbolP{i};
            LlineColor{Lnum} = LlineColorP{i};
            LlineStyle{Lnum} = LlineStyleP{i};
            LmarkerStyle{Lnum} = LmarkerStyleP{i};
            LmarkerSize{Lnum} = LmarkerSizeP{i};
            LmarkerEdgeColor{Lnum} = LmarkerEdgeColorP{i};
            LmarkerFaceColor{Lnum} = LmarkerFaceColorP{i};
    end
    
    if ((plotAddModifiedOptNumber >= 0) && (AddCRVSDone == 0) && (filePlot == plotComponentSize(actualPlotNo)))
        sym = clearFromLatexOperands(Lsymbol{Lnum});
        if (strcmp(sym, 'none') == 0)
            Lnum = Lnum + 1;
            Lsymbol{Lnum} = plotAddCRVSLabel;
            LlineColor{Lnum} = plotAddCRVSlColor;
            LlineStyle{Lnum} = plotAddCRVSlStyle;
            LmarkerStyle{Lnum} = plotAddCRVSlMarker;;
            LmarkerSize{Lnum} = get(0,'DefaultLineMarkerSize');
            LmarkerEdgeColor{Lnum} = get(0,'DefaultLineMarkerEdgeColor');
            LmarkerFaceColor{Lnum} = 'none';
            if (psfragSym == 1)
                Lsymbol{Lnum} = plotAddCRVSLabel; %sym; %clearFromLatexOperands(Lsymbol{Lnum});
            end
        end
        AddCRVSDone = 1;
    end
    
% plotting reggression curve for log log plots
    if (b_regPlot == 1)
%setting curve attributes
        numPlotRegCases = 1;
        if (plotRegAheadCrackTip > 0)
            numPlotRegCases = 2;
        end
        for j = 1:numPlotRegCases
            Lnum = Lnum + 1;
            for k = 1:length(blankRowNInLegend)
                if (blankRowNInLegend(k) == Lnum)
                    Lsymbol{Lnum} = blankTextInLegend{k};
                    if (psfragSym == 1)
                        Lsymbol{Lnum} = clearFromLatexOperands(Lsymbol{Lnum});
                    end
                    LlineColor{Lnum} = [1 1 1];
                    LlineStyle{Lnum} = 'none';
                    LmarkerStyle{Lnum} = 'none';
                    LmarkerSize{Lnum} = get(0,'DefaultLineMarkerSize');
                    LmarkerEdgeColor{Lnum} = get(0,'DefaultLineMarkerEdgeColor');
                    LmarkerFaceColor{Lnum} = 'none';
                    Lnum = Lnum + 1;
                end
            end            
            if (j == 1)
                Lsymbol{Lnum} = regsymbb;
            else
                Lsymbol{Lnum} = regsymbf;
            end
            
            % don't want any latex output for psfrag substitution of symbols
            if (psfragSym == 1)
                Lsymbol{Lnum} = clearFromLatexOperands(Lsymbol{Lnum});
            end
            

            if (plotBlack == 0)
                LlineStyle{Lnum} = reglstl{j}; %'-'
                LlineColor{Lnum} = regclr{j};%[1 0 0]%'r';
                LmarkerStyle{Lnum} = 'none';
            else
                ind = j + 1;%j;
                if (j == 1)
                    ind = j + 1;%j + 2;
                end
                [LlineStyle{Lnum} , LlineColor{Lnum}, LmarkerStyle{Lnum}] = gRegLineStyleBlack(ind);%Lnum);
%                 reglstl{j} = LlineStyle{Lnum};
%                 regclr{j} = LlineColor{Lnum};
           end
            reglstl{j} = LlineStyle{Lnum};
            regclr{j} = LlineColor{Lnum};
            LmarkerSize{Lnum} = 6;
            LmarkerEdgeColor{Lnum} = get(0,'DefaultLineMarkerEdgeColor');
            LmarkerFaceColor{Lnum} = 'none';
        end
        
        
       
        % drawing the actual data
        %        behind of the crack is done first
        bReg(inda) = (bReg(indn) * bReg(indxy) - bReg(indx) * bReg(indy)) / (bReg(indx2) * bReg(indn) - bReg(indx) * bReg(indx));
        bReg(indxa) = bReg(indx) / bReg(indn);
        bReg(indya) = bReg(indy) / bReg(indn);
        bReg(indb) = bReg(indya) - bReg(indxa) * bReg(inda);
        bReg(indys) = bReg(inda) * bReg(indxs) + bReg(indb);
        bReg(indye) = bReg(inda) * bReg(indxe) + bReg(indb);
        

        hold on;
%        [bReg(indxs) bReg(indxe)]
%        [bReg(indys) bReg(indye)]
%        reglstl{1}
%        regclr{1}
%        reglwdth{1} 
        plot([bReg(indxs) bReg(indxe)], [bReg(indys) bReg(indye)], 'LineStyle',  reglstl{1}, 'Color', regclr{1},'LineWidth',reglwdth{1});

        
        
        
        if (plotEPS == 0)
            av = bReg(inda);
            bv = bReg(indb);
            av = round(av * 10000)/10000;
            bv = round(bv * 10000)/10000;
            
            if (bv > 0)
                regtextb = ['y = ', num2str(av), 'x + ',  num2str(bv)];
            else
                regtextb = ['y = ', num2str(av), 'x - ',  num2str(-bv)];
            end
        end
        sizx = abs(bReg(indxe) - bReg(indxs));
        avx = 0.5 * (bReg(indxe) + bReg(indxs));

        sizy = abs(bReg(indye) - bReg(indys));
        avy = 0.5 * (bReg(indye) + bReg(indys));

        pos(1) = avx + sizy * bfctr;
        pos(2) = avy + sizx * bfctr;

        hold on;
        text(pos(1), pos(2), regtextb, 'FontSize', symfsReg,'HorizontalAlignment','Left','VerticalAlignment','Bottom');

        if (plotEPS == 0)
            fprintf(fidQuasiSingular, 'BACK:\ta\t%g\tb\t%g\n', av, bv);
        end
        
        aBx1 = (1 - bafctrb) * pos(1) + bafctrb       * avx;
        aBx2 = bafctrh       * pos(1) + (1 - bafctrh) * avx;
        
        aBy1 = (1 - bafctrb) * pos(2) + bafctrb       * avy;
        aBy2 = bafctrh       * pos(2) + (1 - bafctrh) * avy;

        u1 = aBx2 - aBx1;
        u2 = aBy2 - aBy1;
        hold on;
        quiver(aBx1, aBy1, u1, u2, 0, 'ShowArrowhead',ShowArrowheadSwitch,'Color',[0 0 0],'MaxHeadSize',0.4);%, 'HeadStyle', 'vback1');
        
        if (plotRegAheadCrackTip > 0)
            fReg(inda) = (fReg(indn) * fReg(indxy) - fReg(indx) * fReg(indy)) / (fReg(indx2) * fReg(indn) - fReg(indx) * fReg(indx));
            fReg(indxa) = fReg(indx) / fReg(indn);
            fReg(indya) = fReg(indy) / fReg(indn);
            fReg(indb) = fReg(indya) - fReg(indxa) * fReg(inda);
            fReg(indys) = fReg(inda) * fReg(indxs) + fReg(indb);
            fReg(indye) = fReg(inda) * fReg(indxe) + fReg(indb);

            hold on;
            plot([fReg(indxs) fReg(indxe)], [fReg(indys) fReg(indye)], 'LineStyle',  reglstl{2}, 'Color', regclr{2},'LineWidth',reglwdth{2});

            if (plotEPS == 0)
                av = fReg(inda);
                bv = fReg(indb);
                av = round(av * 1000)/1000;
                bv = round(bv * 1000)/1000;

                if (bv > 0)
                    regtextf = ['y = ', num2str(av), 'x + ',  num2str(bv)];
                else
                    regtextf = ['y = ', num2str(av), 'x - ',  num2str(-bv)];
                end
            end

            sizx = abs(fReg(indxe) - fReg(indxs));
            avx = 0.5 * (fReg(indxe) + fReg(indxs));

            sizy = abs(fReg(indye) - fReg(indys));
            avy = 0.5 * (fReg(indye) + fReg(indys));

            pos(1) = avx - sizy * afctr;
            pos(2) = avy - sizx * afctr;

            aBx1 = (1 - aafctrb) * pos(1) + aafctrb       * avx;
            aBx2 = aafctrh       * pos(1) + (1 - aafctrh) * avx;

            aBy1 = (1 - aafctrb) * pos(2) + aafctrb       * avy;
            aBy2 = aafctrh       * pos(2) + (1 - aafctrh) * avy;

            u1 = aBx2 - aBx1;
            u2 = aBy2 - aBy1;
            hold on;
            quiver(aBx1, aBy1, u1, u2, 0, 'ShowArrowhead',ShowArrowheadSwitch,'Color',[0 0 0],'MaxHeadSize',0.4);%, 'HeadStyle', 'vback1');


            hold on;
            text(pos(1), pos(2), regtextf, 'FontSize', symfsReg,'HorizontalAlignment','Right','VerticalAlignment','Top');
            if (plotEPS == 0)
                fprintf(fidQuasiSingular, 'FRONT:\ta\t%g\tb\t%g\n', av, bv);
            end

            save 'front.txt' -ascii -tabs fReg;
        end
        save 'back.txt' -ascii -tabs bReg;
    end
    

    symfs = cnfg{Isymfs};
    symfs = computeSymbolFS(symfs, Lsymbol);
    prepareLineSymbolsForLegend(gcf, legL, 'boxoff', Lnum, Lsymbol, LlineColor, LlineStyle, LmarkerStyle, LmarkerSize, LmarkerEdgeColor, LmarkerFaceColor, pltfs, symfs, xminT, yminT);


    
   xlimPlot = get(gca, 'xlim');
   xlimMinChosen = xlimPlot(1);
   xlimMaxChosen = xlimPlot(2);
   
   
    if (xlimProcessZoneRegSpace == 1)
%        [startP endP] = computeLimitsAroundProcessZone();
        xlimMinChosen = xMinRegPZSpace;
        xlimMaxChosen = xMaxRegPZSpace;
    elseif (xlimType == 1)
%        elseif ((xlimType == 1) && (length(Lsymbol) > 0))
        expandFactorx = [xlimMin xlimMax];
        [xlimMin, xlimMax, stepx] = subdivide(x1Min, x1Max, xlimRelDiv, expandFactorx, optionSubdivide);
        if (isfinite(xlimMin * xlimMax))
            xlimMinChosen = xlimMin;
            xlimMaxChosen = xlimMax;
        end
    elseif (xlimType == 2)
        if (isfinite(xlimMin * xlimMax))
            xlimMinChosen = xlimMin;
            xlimMaxChosen = xlimMax;
        end
    end


%    if ((plotAddModifiedOptNumber >= 0)  && (AddCRVSDone == 0))
    if (plotAddModifiedOptNumber >= 0)
        flagsAddCRVS = flagDataFile{1};
        doPlot = 1;
        hold on;    
        xlogOption = additionalCurveXLog(actualPlotNo);
        ylogOption = additionalCurveYLog(actualPlotNo);
        [xAddCRVS, yAddCRVS] = plotAddCRVSData(doPlot, plotAddModifiedOptNumber, plotAddCRVSlStyle, ...
            plotAddCRVSlColor, plotAddCRVSlWidth, plotAddCRVSlMarker, flagsAddCRVS, xlimMinChosen,  ...
            xlimMaxChosen, xlogOption, ylogOption);
        y1Min = min(y1Min, min(yAddCRVS));
        y1Max = max(y1Max, max(yAddCRVS));
    end
    
    if (xlimProcessZoneRegSpace == 1)
 %       xlim([xlimMinChosen,  xlimMaxChosen ]);
         xlim([xMinRegPZSpace xMaxRegPZSpace]);
    elseif ((xlimType == 1) && (length(Lsymbol) > 0))
        if (isfinite(xlimMin* xlimMax))
            xlim([xlimMinChosen,  xlimMaxChosen]);
        end
    elseif (xlimType == 2)
        if (isfinite(xlimMin * xlimMax))
            xlim([xlimMinChosen,  xlimMaxChosen ]);
        end
    end


    
    if ((ylimType == 1) && (length(Lsymbol) > 0))
        expandFactory = [ylimMin ylimMax];
        [ylimMin, ylimMax, stepy] = subdivide(y1Min, y1Max, ylimRelDiv, expandFactory, optionSubdivide);
        if (isfinite(ylimMin * ylimMax))
            ylim([ylimMin ylimMax]);
        end
    elseif (ylimType == 2)
        if (isfinite(ylimMin * ylimMax))
            ylim([ylimMin ylimMax]);
        end
    end

    
%Xu Needleman data
	if ((plotXuNData == 1) && (  (actualPlotNo == 1) || (actualPlotNo == 2)  ))
        xlim([1 5]);
        if (actualPlotNo == 1)
            ylim([4 7]);
        end
    end
    
    if ((strcmp(printOption, 'png') == 1) && (flagNoIn > 0))
		plotTitle_ = [plotTitle, ' ', num2str(flagNoIn)];
    else
        plotTitle_ = plotTitle;
	end	

    
    
    if ((strcmp(plotTitle, 'title') == 0) || (printDltTtlLabel == 1))
        if ((plotEPS == 0) || ((plotEPS == 1) && (writeTitleEPS == 0) && (psfrag == 0)))
            title(plotTitle_,'FontSize', tfs);
        end
    end
    if ((strcmp(xlab, 'xlabel') == 0) || (printDltTtlLabel == 1))
        xlabel(xlab,'FontSize', lfs);
        set(get(gca,'xlabel'),'VerticalAlignment','Top');
    end

    if ((strcmp(ylab, 'ylabel') == 0) || (printDltTtlLabel == 1))
        ylabel(ylab,'FontSize', lfs,'VerticalAlignment','Bottom');
    end
    
    
    printMName = sprintf('P%03d_F%03d',actualPlotNo, filePlot);
    if (strcmp(plotTitle, 'title') == 0)
        printMName = readStringWithoutSpace(plotTitle, ' ', '_');
    end
       
    printBN = '';
    if (plotBlack == 1)
        printBN = 'B';
    end
    
    if ((doReg == 0) || (plotEPS == 0))
        if (flagNoIn < 0)
            FigureName = sprintf('%s%03d%s%s.%s',outputFolder, actualPlotNo, printBN, printMName, printOption);
        else
            FigureName = sprintf('%s%03d%s%s_%05d.%s',outputFolder, actualPlotNo, printBN, printMName, flagNoIn , printOption);
        end
        print(printOptionR,FigureName);
    end    
    
    if (plotEPS == 1)
        if (writeTitleEPS == 1)
            title('title','FontSize', tfs);
        end
        xlabel('xlabel','FontSize', lfs);
        set(get(gca,'xlabel'),'VerticalAlignment','Top');
        ylabel('ylabel','FontSize', lfs,'VerticalAlignment','Bottom');

        if (flagNoIn < 0)
            FigureName = sprintf('%s%03d%s%s.%s',outputFolder, actualPlotNo, printBN, printMName, 'eps');
        else
            FigureName = sprintf('%s%03d%s%s_%05d.%s',outputFolder, actualPlotNo, printBN, printMName, flagNoIn , 'eps');
        end
%         if ((plotBlack == 1) && (doReg == 0))
%             print('-deps',FigureName);
%         else
            print('-depsc',FigureName);
%        end            
    end
    delete(figHandle);
end        
fclose(confFid);


cls_

%cnfg{IoutputFolder}
%fclose(fid);