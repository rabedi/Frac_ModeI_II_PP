function [cnfg, pl_conf, pf_plots, pl_normalizers, figHandles] = readProcessedPlotsConfigFile(runName, configFileName, option, E, rho, cd, cs,...
    printOption, printOptionExt)

if (nargin < 6)
    configFileName = 'constantTime_contactConfig.txt';
    option = 0;
    E = 3.24;
    rho = 1.19;
    cd = 2.09;
    cs = 1.0034;
end

pl_normalizers = 0;
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

global dlwidth;
global dhhlwidth;
global dhdlwidth;
global dLlwidth;
global psfrag;
global writeTitleEPS;
global psfragSym;


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
global pl_activeFldsAveVals; % for those that need computing the value at given x values
global pl_SingleXAxisValue;


global pl_timeScale;


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



fid = fopen(configFileName, 'r');
if (fid < 0)
    configFileName
end




setGlobalProcessedPlots();
[gLineStyle, gLineStyleName] = getLineStyle();
[gColor, gLinename] = getColorMap();
[styleBlack, colorBlack, markerBlack] = gLineStyleBlackAll();



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
tmp = fscanf(fid, '%s', 1);
regularPrint = fscanf(fid, '%d', 2);
tmp = fscanf(fid, '%s', 1);
psfragPrint = fscanf(fid, '%d', 2);

printOptionPSFRag = '-depsc';
printOptionExtPSFRag = 'eps';

cnfg{Ipsfrag} = [];
cnfg{IprintFlag} = [];
cnfg{IprintExt} = [];
cnfg{IColorPrint} = [];

cntrS = 1;
if (regularPrint(1) == 1)
    cnfg{Ipsfrag}(cntrS) = 0;
    cnfg{IprintFlag}{cntrS} = printOption;
    cnfg{IprintExt}{cntrS} = printOptionExt;
    cnfg{IColorPrint}(cntrS) = 1;
    cntrS = cntrS + 1;
end

if (regularPrint(2) == 1)
    cnfg{Ipsfrag}(cntrS) = 0;
    cnfg{IprintFlag}{cntrS} = printOption;
    cnfg{IprintExt}{cntrS} = printOptionExt;
    cnfg{IColorPrint}(cntrS) = 0;
    cntrS = cntrS + 1;
end

if (psfragPrint(1) == 1)
    cnfg{Ipsfrag}(cntrS) = 1;
    cnfg{IprintFlag}{cntrS} = printOptionPSFRag;
    cnfg{IprintExt}{cntrS} = printOptionExtPSFRag;
    cnfg{IColorPrint}(cntrS) = 1;
    cntrS = cntrS + 1;
end

if (psfragPrint(2) == 1)
    cnfg{Ipsfrag}(cntrS) = 1;
    cnfg{IprintFlag}{cntrS} = printOptionPSFRag;
    cnfg{IprintExt}{cntrS} = printOptionExtPSFRag;
    cnfg{IColorPrint}(cntrS) = 0;
    cntrS = cntrS + 1;
end

numStated = cntrS - 1;
cnfg{INumStates} = numStated;


tmp = fscanf(fid, '%s', 1);
cnfg{IwriteTitleEPS} = fscanf(fid, '%d', 1);

tmp = fscanf(fid, '%s', 1);
cnfg{IpsfragSym} = fscanf(fid, '%d', 1);
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


%config_constantTime_contact
tmp = fscanf(fid, '%s', 1);
pl_conf{pl_l0normalizer} = fscanf(fid, '%lg', 1);
tmp = fscanf(fid, '%s', 1);
pl_conf{pl_l1normalizer} = fscanf(fid, '%lg', 1);
tmp = fscanf(fid, '%s', 1);
pl_conf{pl_plateLength} = fscanf(fid, '%lg', 1);
tmp = fscanf(fid, '%s', 1);
xlim_ = fscanf(fid, '%lg', 2);
pl_conf{pl_xlim} = xlim_;
tmp = fscanf(fid, '%s', 1);
ylim_ = fscanf(fid, '%lg', 2);
pl_conf{pl_ylim} = ylim_;
tmp = fscanf(fid, '%s', 1);
zlim_ = fscanf(fid, '%lg', 2);
pl_conf{pl_zlim} = zlim_;


%%%%%%%%% this is were we are supposed to read t he time scale 
% for quick fix I just modify the value here

pl_conf{pl_timeScale} = 1.0;
if (strcmp(configFileName, 'contourProcessed_brakeBase.txt') == 1)
    pl_conf{pl_timeScale} = 1e-6;
end


tmp = fscanf(fid, '%s', 1);
xmin = readConfigCoordinateLimitpt(fid, xlim_, 1);
xmax = readConfigCoordinateLimitpt(fid, xlim_, 2);
if (xmax == inf)
    fprintf('error xmax == infAve\n');
    pause;
end
pl_conf{pl_xlimAve} = [xmin xmax];

if (xmin < xmax)
    pl_conf{pl_SingleXAxisValue} = 0;
else
    pl_conf{pl_SingleXAxisValue} = 1;
end

tmp = fscanf(fid, '%s', 1);
xmin = readConfigCoordinateLimitpt(fid, xlim_, 1);
xmax = readConfigCoordinateLimitpt(fid, xlim_, 2);
if (xmax == inf)
    fprintf('error xmax == infAve\n');
    pause;
end
pl_conf{pl_xlimAll} = [xmin xmax];

tmp = fscanf(fid, '%s', 1);
xmin = readConfigCoordinateLimitpt(fid, xlim_, 1);
xmax = readConfigCoordinateLimitpt(fid, xlim_, 2);
tmp = fscanf(fid, '%s', 1);
step = fscanf(fid, '%lg', 1);
if (xmax == inf)
    xmax = xmin;
    len = 1;
else
    len = length(xmin:step:xmax);
end
pl_conf{pl_xlimRange} = [xmin xmax];
pl_conf{pl_xlimRangeStep} = step;
pl_conf{pl_xlimRangeNum} = len;
pl_conf{pl_xlimRangeInterval} = xmin:step:xmax;


tmp = fscanf(fid, '%s', 1);
numNames = fscanf(fid, '%d', 1);
pl_conf{pl_numNames} = numNames;
pl_conf{pl_fldNames} = cell(numNames, 1);
tmp = fscanf(fid, '%s', 1);
for i = 1:numNames
    pl_conf{pl_fldNames}{i} = fscanf(fid, '%s', 1);
end
pl_conf{pl_activeFlds} = zeros(numNames, 1);
pl_conf{pl_activeFldsRangeVals} = zeros(numNames, 1);
pl_conf{pl_activeFldsAveVals} = zeros(numNames, 1); 


tmp = fscanf(fid, '%s', 1);
numPlots = fscanf(fid, '%d', 1);
pl_conf{pl_numPlots} = numPlots;

pf_plots = cell(numPlots, 1);
for pl = 1:numPlots
    tmp = fscanf(fid, '%s', 2);
    pf_plots{pl}{plt_active} = fscanf(fid, '%d', 1);
    tmp = fscanf(fid, '%s', 1);
    pf_plots{pl}{plt_title} = fscanf(fid, '%s', 1);
    tmp = fscanf(fid, '%s', 1);
    pf_plots{pl}{plt_yLbl} = fscanf(fid, '%s', 1);
    tmp = fscanf(fid, '%s', 1);
    pf_plots{pl}{plt_zLbl} = fscanf(fid, '%s', 1);
    tmp = fscanf(fid, '%s', 1);
    pf_plots{pl}{plt_legendLocation} = fscanf(fid, '%s', 1);
    tmp = fscanf(fid, '%s', 1);
    xRedType = fscanf(fid, '%s', 1);
    if (strcmp(xRedType, 'ave') == 1)
        pf_plots{pl}{plt_xReductionType} = aveRedType;
    elseif (strcmp(xRedType, 'all') == 1)
        pf_plots{pl}{plt_xReductionType} = allRedType;
    elseif (strcmp(xRedType, 'range') == 1)
        pf_plots{pl}{plt_xReductionType} = rangeRedType; 
    else
        numType = str2num(xRedType);
        if ((length(numType) == 0) || (~isfinite(numType)) || (numType > 0))
            fprintf(1, 'unacceptable numType %s\n', xRedType);
            pause;
        end
        pf_plots{pl}{plt_xReductionType} = numType;
    end
    tmp = fscanf(fid, '%s', 1);
    minv = readConfigCoordinateLimitpt(fid, ylim_, 1);
    maxv = readConfigCoordinateLimitpt(fid, ylim_, 2);
    pf_plots{pl}{plt_yRange} = [minv maxv];
    tmp = fscanf(fid, '%s', 1);
    pf_plots{pl}{plt_yRangeEffective} = fscanf(fid, '%d', 1);
    
    tmp = fscanf(fid, '%s', 1);
    minv = readConfigCoordinateLimitpt(fid, zlim_, 1);
    maxv = readConfigCoordinateLimitpt(fid, zlim_, 2);
    pf_plots{pl}{plt_zRange} = [minv maxv];
    tmp = fscanf(fid, '%s', 1);
    pf_plots{pl}{plt_zRangeEffective} = fscanf(fid, '%d', 1);
    
    tmp = fscanf(fid, '%s', 1);
    numCurves = fscanf(fid, '%d', 1);
    pf_plots{pl}{plt_numCurves} = numCurves;
    pf_plots{pl}{plt_Curves} = cell(numCurves, 1);
    
    for crv = 1:numCurves
        tmp = fscanf(fid, '%s', 1);
        pf_plots{pl}{plt_Curves}{crv_yaxis}{crv} = fscanf(fid, '%d', 1);
        tmp = fscanf(fid, '%s', 1);
        pf_plots{pl}{plt_Curves}{crv_zaxis}{crv} = fscanf(fid, '%d', 1);
        tmp = fscanf(fid, '%s', 1);
        pf_plots{pl}{plt_Curves}{crv_ClrNum}{crv} = fscanf(fid, '%d', 1);
        tmp = fscanf(fid, '%s', 1);
        pf_plots{pl}{plt_Curves}{crv_StyleNum}{crv} = fscanf(fid, '%d', 1);
    end
end
fclose(fid);

%preparing figures and there legends
baseFigureCntr = 30000;
incrementFigureCntr = 10000;
for st = 1:numStated
    psfrag = cnfg{Ipsfrag}(st);
    clrPrint = cnfg{IColorPrint}(st);
    baseFigTemp = baseFigureCntr + incrementFigureCntr * st;
    for pl = 1:numPlots
        if (pf_plots{pl}{plt_active} == 0)
            figHandles{pl} = [];
            continue;
        end

        Lsymbol = cell(0);
        LlineColor = cell(0);
    %    LineStyle = cell(0);
        LmarkerStyle = cell(0);
        LmarkerSize = cell(0);
        LmarkerEdgeColor = cell(0);
        LmarkerFaceColor = cell(0);

        figHandles{st}{pl} = figure(baseFigTemp + pl);

        xRedType = pf_plots{pl}{plt_xReductionType};
        numX = pl_conf{pl_xlimRangeNum};
        if ((xRedType ~= rangeRedType) || (numX == 1))
    %        xValsSym{1} = '';
            numX = 1;
        else
            xmin = pl_conf{pl_xlimRange}(1);
            xmax = pl_conf{pl_xlimRange}(2);
            step = pl_conf{pl_xlimRangeStep};
            ran = xmin:step:xmax;
            for i = 1:numX
                xValsSym{i} = num2str(ran(i));
            end
        end

        numCurves = pf_plots{pl}{plt_numCurves};
        Lnum = 0;
        legL = pf_plots{pl}{plt_legendLocation};
        
        for xnum = 1:numX
            for crv = 1:numCurves
                Lnum = Lnum + 1;
                clrNum = pf_plots{pl}{plt_Curves}{crv_ClrNum}{crv};
                stlyeNum = pf_plots{pl}{plt_Curves}{crv_StyleNum}{crv};
                if (clrNum > 0)
                    clrNum = (xnum - 1) * numCurves + clrNum;
                else
                    clrNum = Lnum;
                end
                if (stlyeNum < 0)
                    stlyeNum = crv;
                end
                fldY = pf_plots{pl}{plt_Curves}{crv_yaxis}{crv};
                fldZ = pf_plots{pl}{plt_Curves}{crv_zaxis}{crv};
                fldZm = mod(fldZ, 1000);
                if (fldY > 0)
                    pl_conf{pl_activeFlds}(fldY) = 1;
                    if ((xRedType == rangeRedType) || (xRedType < 0))
                        pl_conf{pl_activeFldsRangeVals}(fldY) = 1;
                    end
                    if (xRedType == aveRedType)
                        pl_conf{pl_activeFldsAveVals}(fldY) = 1;
                    end
                end
                if (fldZ > 0)
                    pl_conf{pl_activeFlds}(fldZ) = 1;
                    if ((xRedType == rangeRedType) || (xRedType < 0))
                        pl_conf{pl_activeFldsRangeVals}(fldZm) = 1;
                    end
                    if (xRedType == aveRedType)
                        pl_conf{pl_activeFldsAveVals}(fldZm) = 1;
                    end
                end
                
                if (psfrag == 1)
                    if (fldZ > 1000)
                        fldZsym = fldZm + 100;
                    else
                        fldZsym = fldZ;
                    end
                    
                    if (fldY > 0)
                        sym = ['x', '-', num2str(fldY), '-',  num2str(fldZsym)];
                    else
                        sym = ['x', '-', num2str(fldZsym)];
                    end
%                    sym = ['x', num2str(xnum), 'c', num2str(crv)];
                else
                    if (fldZ <= 1000)
                       zSym = pl_conf{pl_fldNames}{fldZ};
                    elseif (fldZ == 1009)
                        zSym = 'vO0';
                    elseif (fldZ == 1010)
                        zSym = 'vO1';
                    elseif (fldZ == 1013)
                        zSym = 'uO0';
                    elseif (fldZ == 1014)
                        zSym = 'uO1';
                    end
                    if (numX > 1)
                        if (fldY > 0)
                            sym = ['x',xValsSym{xnum}, '-', pl_conf{pl_fldNames}{fldY}, '-',  zSym];
                        else
                            sym = ['x',xValsSym{xnum}, '-',zSym];
                        end
                    else
                        if (fldY > 0)
                            sym = [pl_conf{pl_fldNames}{fldY}, '-',  zSym];
                        else
                            sym = zSym;
                        end
                    end
                end
                if (clrPrint == 1)
                    LlineColor{st}{Lnum} = gColor{clrNum};
                    LineStyle{st}{Lnum} = gLineStyle{stlyeNum};
                    LmarkerStyle{st}{Lnum} = 'none';
                else
                    LlineColor{st}{Lnum} = colorBlack{clrNum};
                    LineStyle{st}{Lnum} = styleBlack{clrNum};
                    LmarkerStyle{st}{Lnum} = markerBlack{clrNum};
                end                    
                Lsymbol{st}{Lnum} = sym;
                LmarkerSize{st}{Lnum} = get(0,'DefaultLineMarkerSize');
                LmarkerEdgeColor{st}{Lnum} = get(0,'DefaultLineMarkerEdgeColor');
                LmarkerFaceColor{st}{Lnum} = 'none';
            end
        end
        
        if ((strcmp(legL, 'EastOutside') == 1) && (psfrag == 1))
            Lnum = Lnum + 1;
            LlineColor{st}{Lnum} = 'w';
            LineStyle{st}{Lnum} = 'none';
            LmarkerStyle{st}{Lnum} = 'none';
            Lsymbol{st}{Lnum} = 'zzzzzzz';
            LmarkerSize{st}{Lnum} = get(0,'DefaultLineMarkerSize');
            LmarkerEdgeColor{st}{Lnum} = get(0,'DefaultLineMarkerEdgeColor');
            LmarkerFaceColor{st}{Lnum} = 'none';
        end
        
        doPlotTheory2bars = ((pl <= 5) && (strcmp(runName(1:2), 'BR') == 1));
        if (doPlotTheory2bars)
            Lnum = Lnum + 1;
            LlineColor{st}{Lnum} = 'k';
            LineStyle{st}{Lnum} = '--';
            LmarkerStyle{st}{Lnum} = 'none';
            Lsymbol{st}{Lnum} = 'Theory';
            LmarkerSize{st}{Lnum} = get(0,'DefaultLineMarkerSize');
            LmarkerEdgeColor{st}{Lnum} = get(0,'DefaultLineMarkerEdgeColor');
            LmarkerFaceColor{st}{Lnum} = 'none';
        end

            [lineHandle, symbolOut, numOut, lineWidthOut] = prepareLineSymbolsForLegend(gcf, legL, 'boxoff', Lnum, Lsymbol{st}, LlineColor{st}, ...
             LineStyle{st}, LmarkerStyle{st}, LmarkerSize{st}, LmarkerEdgeColor{st}, LmarkerFaceColor{st}, pltfs, symfs, xminT, yminT);

        if (doPlotTheory2bars)
            finalTime = 0.7;
            areSimilar = 0;
            plotDissimilarBars(pl, areSimilar, finalTime);
        end

         for crv = 1:Lnum
            pf_plots{pl}{plt_Curves}{crv_LineStyle}{crv}{st} = LineStyle{st}{crv}; 
            pf_plots{pl}{plt_Curves}{crv_LlineColor}{crv}{st} = LlineColor{st}{crv}; 
            pf_plots{pl}{plt_Curves}{crv_LlineWidth}{crv}{st} = lineWidthOut{crv}; 
            pf_plots{pl}{plt_Curves}{crv_Lsymbol}{crv}{st} = Lsymbol{st}{crv}; 
            pf_plots{pl}{plt_Curves}{crv_LmarkerStyle}{crv}{st} = LmarkerStyle{st}{crv}; 
            pf_plots{pl}{plt_Curves}{crv_LmarkerSize}{crv}{st} = LmarkerSize{st}{crv}; 
            pf_plots{pl}{plt_Curves}{crv_LmarkerEdgeColor}{crv}{st} = LmarkerEdgeColor{st}{crv}; 
            pf_plots{pl}{plt_Curves}{crv_LmarkerFaceColor}{crv}{st} = LmarkerFaceColor{st}{crv}; 
        end

        
        if (psfrag == 1)
            xlab = 'xlabel';
            ylab = 'ylabel';
            plotTitle_ = 'title';
        else
            xlab = pf_plots{pl}{plt_yLbl};
            ylab = pf_plots{pl}{plt_zLbl};
            plotTitle_ = pf_plots{pl}{plt_title};
        end
        xlabel(xlab,'FontSize', lfs);
        set(get(gca,'xlabel'),'VerticalAlignment','Top');
        if (psfrag == 0)
            ylabel(ylab,'FontSize', lfs,'VerticalAlignment','Bottom');
            title(plotTitle_,'FontSize', tfs);
        end
        hold on;
    end
end

% normalization step:
l0 = pl_conf{pl_l0normalizer};
l1 = pl_conf{pl_l1normalizer};
lnth = pl_conf{pl_plateLength};

if (abs(l0) > abs(l1))
    c(1) = cd;
    c(2) = cs;
else
    c(2) = cd;
    c(1) = cs;
end

if (abs(l1) < 1e-10)
    l1 = l0;
end
if (abs(l0) < 1e-10)
    l0 = l1;
end
if (abs(l1) < 1e-10)
    l0 = 1;
    l1 = 1;
end


lmax = max(l0, l1);
pl_normalizers = ones(pl_conf{pl_numNames}, 1);

if (option == 0)
    if (pl_conf{pl_numNames} ~= 24)
        fprintf(1, '(pl_conf{pl_numNames} ~= 24)\n');
        pause;
    end
    s00_ind = 1;
    s11_ind = 2;
    s01_ind = 3;
    sMax_ind = 4;
    sMaxT_ind = 5;
    sMin_ind = 6;
    sMinT_ind = 7;
    tauM_ind = 8;
    tauMT_ind = 9;
    Es_ind = 10;
    v0_ind = 11;
    v1_ind = 12;
    vMag_ind = 13;
    Ev_ind = 14;
    Etot_ind = 15;
    u0_ind = 16;
    u1_ind = 17;
    uMag_ind = 18;
    maxEffS_ind = 19;
    maxEffST_ind = 20;
    w0p_ind = 21;
    w0m_ind = 22;
    w1p_ind = 23;
    w1m_ind = 24;

    pl_normalizers(s00_ind) = l0;
    pl_normalizers(s11_ind) = l1;
    pl_normalizers(s01_ind) = lmax;
    pl_normalizers(sMax_ind) = lmax;
    pl_normalizers(sMaxT_ind) = lmax;
    pl_normalizers(sMin_ind) = lmax;
    pl_normalizers(sMinT_ind) = lmax;
    pl_normalizers(tauM_ind) = lmax;
    pl_normalizers(tauMT_ind) = 1;
    pl_normalizers(Es_ind) = lmax * lmax;
    pl_normalizers(v0_ind) = l0 / c(1) / rho;
    pl_normalizers(v1_ind) = l1 / c(2) / rho;
    pl_normalizers(vMag_ind) = lmax / cd / rho;
    pl_normalizers(Ev_ind) = lmax * lmax;
    pl_normalizers(Etot_ind) = lmax * lmax;
    pl_normalizers(u0_ind) = l0 / E * lnth;
    pl_normalizers(u1_ind) = l1 / E * lnth;
    pl_normalizers(uMag_ind) = lmax / E * lnth;
    pl_normalizers(maxEffS_ind) = lmax;
    pl_normalizers(maxEffST_ind) = 1;
    pl_normalizers(w0p_ind) = l0;
    pl_normalizers(w0m_ind) = l0;
    pl_normalizers(w1p_ind) = l1;
    pl_normalizers(w1m_ind) = l1;
end