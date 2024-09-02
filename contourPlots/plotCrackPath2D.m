function plotCrackPath2D(serialNum, aboluteSerialNumberRel, aboluteSerialNumberAbs, time)

global confGen;
global s_dirOut;
global s_runName; 
global s_printOptionExt;

global I_activexlim_cp;
global I_xmin_cp;
global I_xmax_cp;
global I_activeylim_cp;
global I_ymin_cp;
global I_ymax_cp;

global conf2DPlot;
global s_printOption;
global s_plotTime;
global s_plotAxis;
global s_axisXLabel;
global s_axisYLabel;

global s_lfs;
global s_tfs;
global s_pltfs;
global s_symfs;

global s_plotTime;
global s_plotAxis;
global s_axisXLabel;
global s_axisYLabel;

global I_doLegend4OnlyCrackPath;
global I_cpLegendLocation;

global s_figContourMarkers;
global I_DistDPts;

global idam_level;
global id_clr;
global id_lstyle;
global id_lwdth;
global I_numberDistDPts;
global I_damageLevelsFlag;
global I_damageLevelsFlag;

figure(confGen{s_figContourMarkers});



if (conf2DPlot{I_doLegend4OnlyCrackPath} == 1)
    damageLevels = conf2DPlot{I_damageLevelsFlag};
    loc = conf2DPlot{I_cpLegendLocation};

    for i = 1:conf2DPlot{I_numberDistDPts}
       plot([inf inf], [inf inf], 'Color', conf2DPlot{I_DistDPts}{id_clr}{i},...
           'LineStyle', conf2DPlot{I_DistDPts}{id_lstyle}{i}, 'LineWidth', conf2DPlot{I_DistDPts}{id_lwdth}(i));
       hold on;
    end    
    

    offset = conf2DPlot{I_numberDistDPts};
    if ((offset == 1) || (abs(damageLevels) == 1))
            names{1} = 'crack';
    elseif (damageLevels == 2)
            names{1} = 'D = 1';
            names{2} = 'D < 1';
    else
        if (damageLevels == -2)
            names{1} = 'D = 1';
            names{2} = [num2str(conf2DPlot{I_DistDPts}{idam_level}(2)), ' < D < ', num2str(1)];
            st = 3;
        else
            names{1} = [num2str(conf2DPlot{I_DistDPts}{idam_level}(1)), ' < D'];
            st = 2;
        end
        for i = st:conf2DPlot{I_numberDistDPts} - 1
            names{i} = [num2str(conf2DPlot{I_DistDPts}{idam_level}(i)), ' < D < ', num2str(conf2DPlot{I_DistDPts}{idam_level}(i - 1))];
        end    
        names{offset} = ['D < ', num2str(conf2DPlot{I_DistDPts}{idam_level}(offset - 1))];
    end
    symfs = confGen{s_symfs};
    symfs = computeSymbolFS(symfs, names);
    leg = legend(names, 'Location', loc, 'FontSize', symfs); 
    if (strcmp(loc, 'NorthWest') ~= 0)
        pos = get(leg, 'Position');
        pos = [0.12, 0.95 - pos(4), pos(3), pos(4)];
        set(leg, 'Position', pos);
    end
    legend 'boxoff';
end
    




PlotContourMarkers(aboluteSerialNumberRel);
%ptitle = [confData{p_title}{fld}, '  t = ', num2str(time), velTitle];
%axis equal;

ptitle = ['  time = ', num2str(time)];
if (confGen{s_plotTime} == 1)
    tfs = confGen{s_tfs};
    title(ptitle, 'FontSize', tfs);
end
xlab = confGen{s_axisXLabel};
if (strcmp(xlab, 'NONE') == 0)
    xlabel(xlab,'FontSize', confGen{s_lfs});
    set(get(gca,'xlabel'),'VerticalAlignment','Top');
end

ylab = confGen{s_axisYLabel};
if (strcmp(ylab, 'NONE') == 0)
    ylabel(ylab,'FontSize', confGen{s_lfs},'VerticalAlignment','Bottom');
end

%axis equal;
%axis equal;
axis 'equal';
if (conf2DPlot{I_activexlim_cp} == 1)
    xlim([conf2DPlot{I_xmin_cp}  conf2DPlot{I_xmax_cp} ]);
end

%axis equal;

if (conf2DPlot{I_activeylim_cp} == 1)
    ylim([conf2DPlot{I_ymin_cp}  conf2DPlot{I_ymax_cp} ]);
end



if (confGen{s_plotAxis} == 0)
    axis off;
end

outputName = [confGen{s_dirOut},  confGen{s_runName}, '_','crackPath', '_', num2str(serialNum, '%0.5d'), '.', confGen{s_printOptionExt}];
print(confGen{s_printOption},outputName);
%close(10000);
