function plotProcessedPlots(x, y, z, originalXvals, originalYvals)


global fnt_cnfgAddedFlds;
global pl_confAddedFlds;
global pf_plotsAddedFlds;
%global pl_normalizersAddedFlds;
global figHandlesAddedFlds;



global plt_active;
global plt_xReductionType;
global pl_numPlots;
global plt_numCurves;
global aveRedType;
global allRedType;
global rangeRedType;
global singleRangeRedType;
global pl_activeFlds;
global pl_numNames;
global pl_activeFldsRangeVals;
global pl_activeFldsAveVals;
global pl_xlimAve;
global pl_xlimAll;
global pl_xlimRange;
global pl_xlimRangeStep;
global pl_xlimRangeNum;
global pl_xlimRangeInterval;
global plt_Curves;
global crv_yaxis;
global crv_zaxis;

global pl_SingleXAxisValue;


global crv_LineStyle;
global crv_LlineColor;
global crv_LlineWidth;
global crv_Lsymbol;
global crv_LmarkerStyle;
global crv_LmarkerSize;
global crv_LmarkerEdgeColor;
global crv_LmarkerFaceColor;

global INumStates;












% 
% 
% 
% 
if (pl_confAddedFlds{pl_SingleXAxisValue} == 1)         % single plot
    stIndex = 1;
    stIndexRange = 1;
    numPlots = pl_confAddedFlds{pl_numPlots};
    numStated = fnt_cnfgAddedFlds{INumStates};
    for pl = 1:numPlots
        if (pf_plotsAddedFlds{pl}{plt_active} == 0)
            continue;
        end
        for st = 1:numStated
        %   pl
            figure(figHandlesAddedFlds{st}{pl});
            numCurves = pf_plotsAddedFlds{pl}{plt_numCurves};
            Lnum = numCurves * (stIndexRange - 1);
            xnum = stIndexRange;

            indInRange = xnum - stIndexRange + 1; 
            for crv = 1:numCurves
                Lnum = Lnum + 1;
            styl = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LineStyle}{Lnum}{st}; 
            clr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LlineColor}{Lnum}{st};
            width = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LlineWidth}{Lnum}{st};
            marker = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerStyle}{Lnum}{st};
            markerSize = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerSize}{Lnum}{st};
            edgeClr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerEdgeColor}{Lnum}{st};
            faceClr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerFaceColor}{Lnum}{st};
            fldY = pf_plotsAddedFlds{pl}{plt_Curves}{crv_yaxis}{crv};
            fldZ = pf_plotsAddedFlds{pl}{plt_Curves}{crv_zaxis}{crv};
            if (fldY == -2)
                    ytemp = y;%originalYvals;
                elseif (fldY < 0)
                   fprintf(1, 'invalid fldY\n');
                   pause;
                else
                    ytemp = z(L, fldY);%z{fldY}(:, indInRange);
            end
            if (fldZ < 0)
               fprintf(1, 'invalid fldZ\n');
               pause;
            end
            if (fldZ > 1000)
                fldZ = fldZ - 1000;
                if ((fldZ == 9) || (fldZ == 10)) % v field
                    fldDelZ = fldZ + 2;
                elseif ((fldZ == 13) || (fldZ == 14)) % u field
                    fldDelZ = fldZ - 12;
                else
                    fprintf(1, 'wrong fldNumber over 1000');
                    pause;
                end
%                zFld = z{fldZ}(:, indInRange);   
%                zDelFld = z{fldDelZ}(:, indInRange);   
                zFld = z(:, fldZ);%(:, indInRange);   
                zDelFld = z(:, fldDelZ);%(:, indInRange);   
               ztemp = zFld + zDelFld;
            else
               ztemp = z(:, fldZ);
            end

                hold on;
                plot(ytemp, ztemp,'Color',clr, 'LineStyle', styl,'LineWidth',width,...
                'Marker',marker,'MarkerSize',markerSize,'MarkerEdgeColor',edgeClr,...
                'MarkerFaceColor', faceClr);
            end
        end
    end
    return;
end




numStated = fnt_cnfgAddedFlds{INumStates};


xlimAve = pl_confAddedFlds{pl_xlimAve};
xlimAll = pl_confAddedFlds{pl_xlimAll};
xlimRange = pl_confAddedFlds{pl_xlimRange};
xlimRangeStep = pl_confAddedFlds{pl_xlimRangeStep};
xlimRangeNum = pl_confAddedFlds{pl_xlimRangeNum};
xlimRangeInterval = pl_confAddedFlds{pl_xlimRangeInterval};


if (length(x) < 10)
    return;
end

oneXpoint = 0;
xminOriginal = originalXvals(1);
lengthxOriginal = length(originalXvals);
xmaxOriginal = originalXvals(lengthxOriginal);

if (length(originalXvals) > 1)
    delxOriginal = originalXvals(2) - originalXvals(1);
else
    delxOriginal = 0;
    oneXpoint = 1;
end

yminOriginal = originalYvals(1);
lengthyOriginal = length(originalYvals);
ymaxOriginal = originalYvals(lengthyOriginal);
delyOriginal = originalYvals(2) - originalYvals(1);

%num2AddEachSideForUnitX = 5;
include = 0;
[stIndexRange, enIndexRange, foundRange] = ...
    findStartEndIndicesOfIntervalEndPointInIndexOrderedInterval(xminOriginal, xmaxOriginal, xlimRangeInterval, include);
 if (foundRange == 1)
     xRangeModified = xlimRangeInterval(stIndexRange:enIndexRange);
%      unitCol = 0;
%      if (stIndexRange == enIndexRange)
%          unitCol = 1;
%          indn = max(1, stIndexRange - num2AddEachSideForUnitX);
%          indx = min(lengthxOriginal, stIndexRange + num2AddEachSideForUnitX);
%          numExtract = stIndexRange - indn + 1;
%          xRangeModified = xlimRangeInterval(stIndexRange:enIndexRange);
 end 
 
xminAve = xlimAve(1);
xmaxAve = xlimAve(2);
xminAll = xlimAll(1);
xmaxAll = xlimAll(2);


include = 0;
[stIndexAve, enIndexAve, foundAve] = ...
    findStartEndIndicesOfIntervalEndPointInIndexOrderedInterval(xminAve, xmaxAve, originalXvals, include);

[stIndexAll, enIndexAll, foundAll] = ...
    findStartEndIndicesOfIntervalEndPointInIndexOrderedInterval(xminAll, xmaxAll, originalXvals, include);

if ((foundRange == 0) && (foundAve == 0) && (foundAll == 0))
    return;
end

% first we want to produce data needed for the plots:
numFlds = pl_confAddedFlds{pl_numNames};
Z = cell(numFlds, 1);
Zrange = cell(numFlds, 1);
ZAve = cell(numFlds, 1);
[X,Y] = meshgrid(originalXvals, originalYvals);

optNearest = ((lengthxOriginal < 10) || (lengthyOriginal < 10));


% computing delu and delv when u and v are only required to be computed
if (pl_confAddedFlds{pl_activeFldsRangeVals}(1) == 0)
    pl_confAddedFlds{pl_activeFldsRangeVals}(1) = pl_confAddedFlds{pl_activeFldsRangeVals}(13);
end

if (pl_confAddedFlds{pl_activeFldsRangeVals}(2) == 0)
    pl_confAddedFlds{pl_activeFldsRangeVals}(2) = pl_confAddedFlds{pl_activeFldsRangeVals}(14);
end

if (pl_confAddedFlds{pl_activeFldsRangeVals}(11) == 0)
    pl_confAddedFlds{pl_activeFldsRangeVals}(11) = pl_confAddedFlds{pl_activeFldsRangeVals}(9);
end

if (pl_confAddedFlds{pl_activeFldsRangeVals}(12) == 0)
    pl_confAddedFlds{pl_activeFldsRangeVals}(12) = pl_confAddedFlds{pl_activeFldsRangeVals}(10);
end

for fld = 1:numFlds
    if (pl_confAddedFlds{pl_activeFlds} == 0)
        continue;
    end
    
    if (optNearest == 1)
        Z{fld} = griddata(x, y, z(:,fld),X,Y, 'nearest');
    else
        Z{fld} = griddata(x, y, z(:,fld),X,Y);
    end        

    if ((foundAve == 1) || (pl_confAddedFlds{pl_activeFldsAveVals}(fld) == 1))
        ZAve{fld} = averageDim(Z{fld}, 2, stIndexAve, enIndexAve);
    end
    if ((foundRange == 0) || (pl_confAddedFlds{pl_activeFldsRangeVals}(fld) == 0))
        continue;
    end
    [Xrange, Yrange] = meshgrid(xRangeModified, originalYvals);
    Zrange{fld} = interp2(X, Y, Z{fld}, Xrange, Yrange);
end        
    

numPlots = pl_confAddedFlds{pl_numPlots};
for pl = 1:numPlots
    if (pf_plotsAddedFlds{pl}{plt_active} == 0)
        continue;
    end
    for st = 1:numStated
    %   pl
        figure(figHandlesAddedFlds{st}{pl});
        xRedType = pf_plotsAddedFlds{pl}{plt_xReductionType};
        numCurves = pf_plotsAddedFlds{pl}{plt_numCurves};
        if ((xRedType == rangeRedType) && (foundRange == 1))
            Lnum = numCurves * (stIndexRange - 1);
            for xnum = stIndexRange:enIndexRange
                indInRange = xnum - stIndexRange + 1; 
                for crv = 1:numCurves
                    Lnum = Lnum + 1;
                styl = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LineStyle}{Lnum}{st}; 
                clr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LlineColor}{Lnum}{st};
                width = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LlineWidth}{Lnum}{st};
                marker = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerStyle}{Lnum}{st};
                markerSize = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerSize}{Lnum}{st};
                edgeClr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerEdgeColor}{Lnum}{st};
                faceClr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerFaceColor}{Lnum}{st};
                    fldY = pf_plotsAddedFlds{pl}{plt_Curves}{crv_yaxis}{crv};
                    fldZ = pf_plotsAddedFlds{pl}{plt_Curves}{crv_zaxis}{crv};
                    if (fldY == -2)
                        ytemp = originalYvals;
                    elseif (fldY < 0)
                       fprintf(1, 'invalid fldY\n');
                       pause;
                    else
                        ytemp = Zrange{fldY}(:, indInRange);
                    end
                    if (fldZ < 0)
                       fprintf(1, 'invalid fldZ\n');
                       pause;
                    end
                    if (fldZ > 1000)
                        fldZ = fldZ - 1000;
                        if ((fldZ == 9) || (fldZ == 10)) % v field
                            fldDelZ = fldZ + 2;
                        elseif ((fldZ == 13) || (fldZ == 14)) % u field
                            fldDelZ = fldZ - 12;
                        else
                            fprintf(1, 'wrong fldNumber over 1000');
                            pause;
                        end
                       zFld = Zrange{fldZ}(:, indInRange);   
                       zDelFld = Zrange{fldDelZ}(:, indInRange);   
                       ztemp = zFld + zDelFld;
                    else
                       ztemp = Zrange{fldZ}(:, indInRange);   
                    end
                    
                    hold on;
                    plot(ytemp, ztemp,'Color',clr, 'LineStyle', styl,'LineWidth',width,...
                    'Marker',marker,'MarkerSize',markerSize,'MarkerEdgeColor',edgeClr,...
                    'MarkerFaceColor', faceClr);
                end
            end
        elseif ((xRedType < 0) && (foundRange == 1))
            xnum = -xRedType;
            if ((xnum >= stIndexRange) && (xnum <= enIndexRange))
                indInRange = xnum - stIndexRange + 1; 
                
                Lnum = 0;
                for crv = 1:numCurves
                    Lnum = Lnum + 1;
                    styl = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LineStyle}{Lnum}{st}; 
                    clr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LlineColor}{Lnum}{st};
                    width = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LlineWidth}{Lnum}{st};
                    marker = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerStyle}{Lnum}{st};
                    markerSize = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerSize}{Lnum}{st};
                    edgeClr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerEdgeColor}{Lnum}{st};
                    faceClr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerFaceColor}{Lnum}{st};
                    fldY = pf_plotsAddedFlds{pl}{plt_Curves}{crv_yaxis}{crv};
                    fldZ = pf_plotsAddedFlds{pl}{plt_Curves}{crv_zaxis}{crv};
                    if (fldY == -2)
                        ytemp = originalYvals;
                    elseif (fldY < 0)
                       fprintf(1, 'invalid fldY\n');
                       pause;
                    else
                        ytemp = Zrange{fldY}(:, indInRange);
                    end
                    if (fldZ < 0)
                       fprintf(1, 'invalid fldZ\n');
                       pause;
                    end
                    if (fldZ > 1000)
                        fldZ = fldZ - 1000;
                        if ((fldZ == 9) || (fldZ == 10)) % v field
                            fldDelZ = fldZ + 2;
                        elseif ((fldZ == 13) || (fldZ == 14)) % u field
                            fldDelZ = fldZ - 12;
                        else
                            fprintf(1, 'wrong fldNumber over 1000');
                            pause;
                        end
                       zFld = Zrange{fldZ}(:, indInRange);   
                       zDelFld = Zrange{fldDelZ}(:, indInRange);   
                       ztemp = zFld + zDelFld;
                    else
                       ztemp = Zrange{fldZ}(:, indInRange);   
                    end
                    hold on;
                    plot(ytemp, ztemp,'Color',clr, 'LineStyle', styl,'LineWidth',width,...
                    'Marker',marker,'MarkerSize',markerSize,'MarkerEdgeColor',edgeClr,...
                    'MarkerFaceColor', faceClr);
                end
            end
        elseif ((xRedType == aveRedType) && (foundAve == 1))
            Lnum = 0;
            for crv = 1:numCurves
                Lnum = Lnum + 1;
                styl = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LineStyle}{Lnum}{st}; 
                clr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LlineColor}{Lnum}{st};
                width = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LlineWidth}{Lnum}{st};
                marker = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerStyle}{Lnum}{st};
                markerSize = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerSize}{Lnum}{st};
                edgeClr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerEdgeColor}{Lnum}{st};
                faceClr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerFaceColor}{Lnum}{st};
                fldY = pf_plotsAddedFlds{pl}{plt_Curves}{crv_yaxis}{crv};
                fldZ = pf_plotsAddedFlds{pl}{plt_Curves}{crv_zaxis}{crv};
                if (fldY == -2)
                    ytemp = originalYvals;
                elseif (fldY < 0)
                   fprintf(1, 'invalid fldY\n');
                   pause;
                else
                    ytemp = ZAve{fldY};
                end
                if (fldZ < 0)
                   fprintf(1, 'invalid fldZ\n');
                   pause;
                end
                if (fldZ > 1000)
                    fldZ = fldZ - 1000;
                    if ((fldZ == 9) || (fldZ == 10)) % v field
                        fldDelZ = fldZ + 2;
                    elseif ((fldZ == 13) || (fldZ == 14)) % u field
                        fldDelZ = fldZ - 12;
                    else
                        fprintf(1, 'wrong fldNumber over 1000');
                        pause;
                    end
                   zFld = ZAve{fldZ};   
                   zDelFld = ZAve{fldDelZ};   
                   ztemp = zFld + zDelFld;
                else
                   ztemp = ZAve{fldZ};   
                end
                hold on;
                plot(ytemp, ztemp,'Color',clr, 'LineStyle', styl,'LineWidth',width,...
                'Marker',marker,'MarkerSize',markerSize,'MarkerEdgeColor',edgeClr,...
                'MarkerFaceColor', faceClr);
            end
        elseif ((xRedType == allRedType) && (foundAll == 1))
            Lnum = 0;
            for crv = 1:numCurves
                Lnum = Lnum + 1;
                styl = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LineStyle}{Lnum}{st}; 
                clr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LlineColor}{Lnum}{st};
                width = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LlineWidth}{Lnum}{st};
                marker = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerStyle}{Lnum}{st};
                markerSize = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerSize}{Lnum}{st};
                edgeClr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerEdgeColor}{Lnum}{st};
                faceClr = pf_plotsAddedFlds{pl}{plt_Curves}{crv_LmarkerFaceColor}{Lnum}{st};
                fldY = pf_plotsAddedFlds{pl}{plt_Curves}{crv_yaxis}{crv};
                fldZ = pf_plotsAddedFlds{pl}{plt_Curves}{crv_zaxis}{crv};
                for ind = stIndexAll:enIndexAll
                    if (fldY == -2)
                        ytemp = originalYvals;
                    elseif (fldY < 0)
                       fprintf(1, 'invalid fldY\n');
                       pause;
                    else
                        ytemp = Z{fldY}(:, ind);
                    end
                    if (fldZ < 0)
                       fprintf(1, 'invalid fldZ\n');
                       pause;
                    end
                    if (fldZ > 1000)
                        fldZ = fldZ - 1000;
                        if ((fldZ == 9) || (fldZ == 10)) % v field
                            fldDelZ = fldZ + 2;
                        elseif ((fldZ == 13) || (fldZ == 14)) % u field
                            fldDelZ = fldZ - 12;
                        else
                            fprintf(1, 'wrong fldNumber over 1000');
                            pause;
                        end
                       zFld = Z{fldZ}(:, ind);
                       zDelFld = Z{fldDelZ}(:, ind);   
                       ztemp = zFld + zDelFld;
                    else
                       ztemp = Z{fldZ}(:, ind);
                    end
                    hold on;
                    plot(ytemp, ztemp,'Color',clr, 'LineStyle', styl,'LineWidth',width,...
                    'Marker',marker,'MarkerSize',markerSize,'MarkerEdgeColor',edgeClr,...
                    'MarkerFaceColor', faceClr);
                end
            end
        end
    end
end
