function [noteof, fidDataBulkOut] = ...
    plotSingleSerialContourData(confGen, confData, serialNum, serialNumAbsolute, pauseTime, addMarkerData, fidDataBulk, maxNumRows2ReadBulk, make_noteofZero)

if nargin < 7
    fidDataBulk = -2;
end

if nargin < 8
    maxNumRows2ReadBulk = inf;
end

if (fidDataBulk == -2)
    closable = 1;
    useWholeFileXYZMinMax = 0;
else
    closable = 0;
    useWholeFileXYZMinMax = 1;
end



global conf2DPlot;
global I_do2DColorPlot;
global I_plotTimeSlice;
global s_figContoursGen;

global figAdd;

global allowBinary;

global s_lfs;
global s_tfs;
global s_pltfs;
global s_symfs;
global s_plotTime;
global s_plotAxis;
global s_axisXLabel;
global s_axisYLabel;


global fnt_cnfgAddedFlds;
global pl_confAddedFlds;
global pf_plotsAddedFlds;
global pl_normalizersAddedFlds;
global figHandlesAddedFlds;


global plt_active;
global pl_numPlots;
global plt_title;
global plt_yRange;
global plt_yRangeEffective;
global plt_zRange;
global plt_zRangeEffective;


    
global s_folderPostNameGeomMesh;
global s_fileNameGeomMesh;
global s_readOptionGeomMesh_cInacrive;
global s_GeomMeshCompFileName;
global s_clr_GeomMesh;
global s_style_GeomMesh;
global s_widthGeomMesh;

if nargin < 4
    pauseTime = 0;
end

if nargin < 5
    addMarkerData = 0;
end
global xLMrkr;
global yLMrkr;


global ctRelVels;

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
global s_numFldsTot;
global s_numFlds;
global s_offset;

global maxNumPtsPerBox;
global precisionRowCounter;
global maxNumRowCounter;
global maxNumGridPtsSingleContour;
global maxNumGridPtsALLContour;
global maxNumDivisions;
global expansionRatio;
global doPlotSubPlotBounds;
global gColormapInput;
global ind_u0;
global ind_u1;



global s_numFldsAdded;
global s_optionFldsAdded;
global s_loadDirectionFldsAdded;
global s_numFldsTotOriginal;

global xmin_all_ind;
global xmax_all_ind;
global ymin_all_ind;
global ymax_all_ind;



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

global rhoIndex;
global CdIndex;
global CsIndex;

global IprintFlag;
global IprintExt;
global INumStates;



 ind_x0 = 0;
 ind_x1 = 1;
% ind_t = 2;
% ind_eID = 3;
% ind_s00 = 4;
% ind_s11 = 5;
% ind_s01 = 6;
% ind_sMax = 7;
% ind_sMaxT = 8;
% ind_sMin = 9;
% ind_sMinT = 10;
% ind_tauM = 11;
% ind_tauMT = 12;
% ind_Es = 13;
% ind_v0 = 14;
% ind_v1 = 15;
% ind_vMag = 16;
% ind_Ev = 17;
% ind_Etot = 18;
% ind_u0 = 19;
% ind_u1 = 20;
% ind_uMag = 21;
% ind_maxEffS = 22;
% ind_maxEffST = 23;




dataFileFormat = confGen{s_DataFrmt};

if (allowBinary == 0)
    dataFileFormat = 'a';
end

if (strcmp(dataFileFormat, 'a') == 1)
    dataExt = 'txt';
else
    dataExt = 'bin';
end
 
if (serialNum < 100)
    sN = serialNum;
else
    sN = floor(serialNum / 100);
end
statFileName = [confGen{s_dir}, confGen{s_runName}, confGen{s_middlename}, confGen{s_brfStatName}, num2str(sN, '%0.5d'),'.txt'];

dataFileName = [confGen{s_dir}, confGen{s_runName}, confGen{s_middlename}, confGen{s_midNData}, num2str(serialNum, '%0.5d'),'.', dataExt];

fidStat = fopen(statFileName, 'r');

if (fidStat < 0)
    fprintf(1, '%s file could not be opened\n', statFileName);
    pause;
end

if (fidDataBulk < 0)
    fidDataBulk = fopen(dataFileName, 'r');
    showLegend = 1;

    if (fidDataBulk < 0)
        fprintf(1, '%s file could not be opened\n', dataFileName);
        pause;
    end
else
    showLegend = 0;
end

offset = confGen{s_offset};
offsetP1 = offset + 1;
numTotalFlds = fscanf(fidStat, '%d', 1);
numData = fscanf(fidStat, '%d', 1);
numData2Read = min(numData, maxNumRows2ReadBulk);
[minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, counter, average, sum, sDiviation, name] =  ...
readBriefStat(fidStat, numTotalFlds, 0);
fclose(fidStat);
minCoord = minV(1:3);
maxCoord = maxV(1:3);
time = minCoord(3); 
minV = minV(offsetP1:numTotalFlds);
maxV = maxV(offsetP1:numTotalFlds);
average = average(offsetP1:numTotalFlds);
sum = sum(offsetP1:numTotalFlds);
name = name(offsetP1:numTotalFlds);
numFlds = numTotalFlds - offsetP1 + 1;

xDataMin = minCoord(1);
yDataMin = minCoord(2);
tDataMin = minCoord(3);
xDataMax = maxCoord(1);
yDataMax = maxCoord(2);
tDataMax = maxCoord(3);

zDataMin = [];
zDataMax = [];

% computing normalizer
for i = 1:numFlds
    if (confData{p_cnfgCN}(i)  == 1) 
        normalizer(i) =  confData{p_totN}(i) * maxV(i);
    elseif (confData{p_cnfgCN}(i) == 2)
        normalizer(i) =  confData{p_totN}(i) * minV(i);
    else
        normalizer(i) =  confData{p_totN}(i);        
    end
    if (normalizer(i) == 0)
        normalizer(i) = 1.0;
    end
    zmxtData = maxV(i);
    zDataMax(i) = (zmxtData - confData{p_origin}(i)) / normalizer(i);
    if (confData{p_logBase}(i) > 0)
        zDataMax(i) = log(abs(zDataMax(i))) / log(confData{p_logBase}(i));
    end
    zmntData = minV(i);
    zDataMin(i) = (zmntData - confData{p_origin}(i)) / normalizer(i);
    if (confData{p_logBase}(i) > 0)
        zDataMin(i) = log(abs(zDataMin(i))) / log(confData{p_logBase}(i));
    end
    
    zmin(i) = confData{p_zminV}(i);
    zmax(i) = confData{p_zmaxV}(i);
    if (confData{p_zlimAbs}(i) ~= 0) 
        if (confData{p_zlimB}(i) == 1)
            if (zmax(i) ~= inf)
                zmxt = confData{p_zmaxV}(i);
                zmxt = (zmxt - confData{p_origin}(i)) / normalizer(i);
                if (confData{p_logBase}(i) > 0)
                    zmax(i) = log(abs(zmxt)) / log(confData{p_logBase}(i));
                end
            end

            if (zmin(i) ~= -inf)
                zmnt = confData{p_zminV}(i);
                zmnt = (zmnt - confData{p_origin}(i)) / normalizer(i);
                if (confData{p_logBase}(i) > 0)
                    zmin(i) = log(abs(zmnt)) / log(confData{p_logBase}(i));
                end
            end
        end
    end
end

numFldsAddedFlds = numFlds + confGen{s_numFldsAdded};
numTotalFldsAddedFlds = numTotalFlds + confGen{s_numFldsAdded};

noteof = 1;
X = zeros(numData2Read, 1);
Y = zeros(numData2Read, 1);
z = zeros(numData2Read, numFldsAddedFlds);

addData = 0;
numAdded = confGen{s_numFldsAdded};
opt_ = confGen{s_optionFldsAdded};


if (confGen{s_numFldsAdded} > 0)
    if (confGen{s_optionFldsAdded} ~= 0)
        fprintf(1, ' only option 0 is implemented for confGen{s_optionFldsAdded}\n');
        pause;
    end
    rho = confGen{s_runData}(rhoIndex);
    cd = confGen{s_runData}(CdIndex);
    cs = confGen{s_runData}(CsIndex);
    rhocd = rho * cd;
    rhocs = rho * cs;
    if (confGen{s_loadDirectionFldsAdded} == 0)
        crho0 = rhocd;
        crho1 = rhocs;
    else
        crho0 = rhocs;
        crho1 = rhocd;
    end
    inds00 = 4 + 1;
    inds11 = 5 + 1;
    indv0 = 14 + 1;
    indv1 = 15 + 1;
    addData = 1;
    normalizer = pl_normalizersAddedFlds;
end



cntr = 0;
while ((noteof ~= 0) && (cntr <= maxNumRows2ReadBulk))
    [vec, noteof] = readVector(fidDataBulk, numTotalFlds, dataFileFormat);
    if ((noteof ~= 0) && (length(vec) >= numTotalFldsAddedFlds))
        cntr = cntr + 1;
        if ((addData ~= 0) && (opt_ == 0))
           len = length(vec);
           vec(len + 1) = vec(inds00) + vec(indv0) * crho0;
           vec(len + 2) = vec(inds00) - vec(indv0) * crho0;
           vec(len + 3) = vec(inds11) + vec(indv1) * crho1;
           vec(len + 4) = vec(inds11) - vec(indv1) * crho1;
        end
        X(cntr) = vec(ind_x0 + 1);
        Y(cntr) = vec(ind_x1 + 1);
        z(cntr, :) = vec(offsetP1:numTotalFldsAddedFlds);
    else
        noteof = 0;
    end
end

if (make_noteofZero ~= 0)
    noteof = 0;
end

if (((numAdded > 0) || (opt_ > 0)) && (noteof == 0))
    printLegendProcessedPlots();    
end


fidDataBulkOut = fidDataBulk;

if ((noteof == 0) || (closable == 1))
    fclose(fidDataBulk);
end

if (numData2Read ~= cntr)
    numData2Read = cntr;
    X = X(1:numData2Read);
    Y = Y(1:numData2Read);
    z = z(1:numData2Read, :);
end


if (confGen{s_x0_dsplcdShape} ~= 0)
    ind_u0V = confGen{ind_u0};
    x = X + confGen{s_x0_factor} * z(:, ind_u0V);
    xDataMin = xDataMin +  confGen{s_x0_factor} * minV(ind_u0V);
    xDataMax = xDataMax +  confGen{s_x0_factor} * maxV(ind_u0V);
else
    x = X;
end


if (confGen{s_x1_dsplcdShape} ~= 0)
    ind_u1V = confGen{ind_u1};
    y = Y + confGen{s_x1_factor} * z(:, ind_u1V);
    yDataMin = yDataMin +  confGen{s_x1_factor} * minV(ind_u1V);
    yDataMax = yDataMax +  confGen{s_x1_factor} * maxV(ind_u1V);
else
    y = Y;
end


origins = confData{p_origin};
logBase = confData{p_logBase};
for fld = 1:(numFlds + numAdded)
    for dat = 1:numData2Read
        z(dat, fld) = (z(dat, fld) - origins(fld)) / normalizer(fld);
        if (logBase(i) > 0)
            z(dat, fld) = log(abs(z(dat, fld))) / log(logBase(fld));
        end
    end
end    

for fld = 1:numFldsAddedFlds
    if (confData{p_pltFlag}(fld)  == 0)
        lablIn{fld} = [];
        continue;
    end
    lablIn{fld} = [];
%    fig(fld) = figure(fld);
end

xmin = confData{p_xminV}(1);
xmax = confData{p_xmaxV}(1);
ymin = confData{p_yminV}(1);
ymax = confData{p_ymaxV}(1);
%showLegend = 1;

% xmin
% xmax
% ymin
% ymax
% confData{p_zminV}
% confData{p_zmaxV}
% confGen{maxNumPtsPerBox}
% confGen{precisionRowCounter}
% confGen{maxNumRowCounter}
% confGen{maxNumGridPtsSingleContour}
% confGen{maxNumGridPtsALLContour}
% confGen{doPlotSubPlotBounds}
% confGen{expansionRatio}
% confGen{maxNumDivisions}
% w = confData{p_zBaseP}
% colormapInput
% confGen{colormapInput}
% ww = confGen{colormapInput}
% confData{p_pltFlag}
% showLegend
% lablIn
%



if ((conf2DPlot{I_do2DColorPlot} ~= 0) && (addMarkerData ~= 0) && (length(xLMrkr) > 0)) 
    xmin = max(xmin, xLMrkr{serialNumAbsolute}(1));
    xmax = min(xmax, xLMrkr{serialNumAbsolute}(2));
    ymin = max(ymin, yLMrkr{serialNumAbsolute}(1));
    ymax = min(ymax, yLMrkr{serialNumAbsolute}(2));
end


if (useWholeFileXYZMinMax == 0)
    zDataMin = [];
    zDataMax = [];
    xDataMin = [];
    xDataMax = [];
    yDataMin = [];
    yDataMax = [];
end

if (length(x) == 0)
    return;
end

contourPlot(x, y, z,xmin, xmax, ymin, ymax, confData{p_zminV}, confData{p_zmaxV}, confGen{maxNumPtsPerBox}, confGen{precisionRowCounter},...
confGen{maxNumRowCounter}, confGen{maxNumGridPtsSingleContour}, confGen{maxNumGridPtsALLContour},...
    confGen{doPlotSubPlotBounds}, confGen{expansionRatio}, confGen{maxNumDivisions}, ...
    confData{p_zBaseP}, confGen{gColormapInput}, confGen{s_figContoursGen}, confData{p_pltFlag},...
    showLegend, lablIn, serialNumAbsolute, addMarkerData,...
    zDataMin, zDataMax, xDataMin, xDataMax, yDataMin, yDataMax, confData{p_legLoc});

% not print figures until all the data is plotted
if (noteof ~= 0)
    return;
end
    

velTitle = [];

if ((addMarkerData ~= 0) && (length(ctRelVels) > 0) && (length(ctRelVels{serialNumAbsolute}) > 0))
    len = length(ctRelVels{serialNumAbsolute});
%     for i = 1:len
%        velTitle = [velTitle, '  ', num2str(ctRelVels{serialNumAbsolute}{i}, '%8.6g')];
%     end
    velTitle = num2str(max(ctRelVels{serialNumAbsolute}), '%8.6g');
    velTitle = ['  vCT = ', velTitle];
end
for fld = 1:numFldsAddedFlds
    flg = confData{p_pltFlag}(fld);
    if (flg == 0)
        continue;
    end
    if (flg > 0)
        filledContour = 0;
    else
        filledContour = 1;
    end 
    flg = abs(flg);
    heightFlag = floor(flg / 100);

    figure(confGen{s_figContoursGen}(fld));

 

    if (confGen{s_readOptionGeomMesh_cInacrive} ~= 'c')
        fileNameGeomMesh = [confGen{s_GeomMeshCompFileName}, num2str(serialNum, '%0.5d')];
        plotGeomMesh(fileNameGeomMesh, confGen{s_readOptionGeomMesh_cInacrive}, ...
                confGen{s_clr_GeomMesh}, confGen{s_style_GeomMesh}, confGen{s_widthGeomMesh});
    end
    
    
    if (confData{p_pltFlag}(fld) ~= 0)
        ptitle = [confData{p_title}{fld}, '  t = ', num2str(time), velTitle];
        % psfrag does not work on contour data
        if (strcmp(confGen{s_printOption}, '-depsc') == 0)
            if (confGen{s_plotTime} == 1)
                tfs = confGen{s_tfs};
                title(ptitle, 'FontSize', tfs);
            end
            xlab = confGen{s_axisXLabel};
            if (strcmp(xlab, 'NONE') == 0)
                xlabel(xlab,'FontSize', confGen{s_lfs});
                if (heightFlag == 0) 
                    set(get(gca,'xlabel'),'VerticalAlignment','Top');
                end
            end
            ylab = confGen{s_axisYLabel};
            if (strcmp(ylab, 'NONE') == 0)
                ylabel(ylab,'FontSize', confGen{s_lfs});
                if (heightFlag == 0)
    %                ylabel(ylab,'FontSize', s_lfs,'VerticalAlignment','Bottom');
                    set(get(gca,'ylabel'),'VerticalAlignment','Bottom');
                else
                    set(get(gca,'ylabel'),'VerticalAlignment','Middle');
                end                
            end
            if ((heightFlag ~= 0) && (strcmp(xlab, 'NONE') == 0))
                if (strcmp(confGen{s_printOptionExt}, 'eps') == 1)
                    zlabel('z', 'FontSize', confGen{s_lfs});
                else
                    zlabel(confData{p_title}{fld}, 'FontSize', confGen{s_lfs});
                end
            end
        end
        if (heightFlag ~= 0)
            set(gca, 'XGrid', 'on', 'YGrid', 'on', 'ZGrid', 'on');
        end
        
        if (confGen{s_plotAxis} == 0)
            axis off;
        end
        
        %tmp
        %REZA
        if (fld == 65)
            zlim([-.05,1.05]);
        end
        
        outputName = [confGen{s_dirOut},  confGen{s_runName}, '_', num2str(fld, '%0.5d'),'_', confData{p_name}{fld}, '_', num2str(serialNum, '%0.5d'), '.', confGen{s_printOptionExt}];
        
        print(confGen{s_printOption},outputName);
%        pause(pauseTime);
    end
%   close(fld);
end


numStated = fnt_cnfgAddedFlds{INumStates};

if ((numAdded > 0) || (opt_ > 0))
    pt_numPlots = pl_confAddedFlds{pl_numPlots};
    for st = 1:numStated
        printOpt = fnt_cnfgAddedFlds{IprintFlag}{st};
        printExt = fnt_cnfgAddedFlds{IprintExt}{st};
        baseFigFlagNum = st * 100;

        for pl = 1:pt_numPlots
            if (pf_plotsAddedFlds{pl}{plt_active} == 0)
                continue;
            end
            figure(figHandlesAddedFlds{st}{pl});
            ylm = pf_plotsAddedFlds{pl}{plt_yRange};
            bylim = pf_plotsAddedFlds{pl}{plt_yRangeEffective};
            if (bylim == 1)
                ylmCrnt = xlim(gca);
                ylmFinal = ylm;
                if (isfinite(ylm(1)) == 0)
                    ylmFinal(1) = ylmCrnt(1);
                end
                if (isfinite(ylm(2)) == 0)
                    ylmFinal(2) = ylmCrnt(2);
                end
                xlim(ylmFinal);
            end
            zlm = pf_plotsAddedFlds{pl}{plt_zRange};
            bzlim = pf_plotsAddedFlds{pl}{plt_zRangeEffective};
             if (bzlim == 1)
                zlmCrnt = ylim(gca);
                zlmFinal = zlm;
                if (isfinite(zlm(1)) == 0)
                    zlmFinal(1) = zlmCrnt(1);
                end
                if (isfinite(zlm(2)) == 0)
                    zlmFinal(2) = zlmCrnt(2);
                end
                ylim(zlmFinal);
             end

            figTitle = pf_plotsAddedFlds{pl}{plt_title};
            outputName = [confGen{s_dirOut},  confGen{s_runName}, '_', num2str(baseFigFlagNum + pl, '%0.5d'),'_', figTitle, '_', num2str(serialNum, '%0.5d'), '.', printExt];
            print(printOpt,outputName);
    %        pause(pauseTime);
    %       close(figHandlesAddedFlds{pl});
        end
    end
end