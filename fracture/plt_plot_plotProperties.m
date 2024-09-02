classdef plt_plot_plotProperties
	properties
       titleFontSize = 26;
       plotFontSize = 19;
       axisLabelFontSize = 43;
       titleLabel = 'auto';
       % 1. given text, e.g., 'title' it will apear as actual title
       % 2. 'auto' the title is obtained from the names of the input fields
       % 3. 'none' no title will appear
      legend = plt_plot_legendProperties;
      xAxis = plt_plot_axisProperties;
      yAxis = plt_plot_axisProperties;
    end
    methods
            % format is as follows:
            % [ FLG VAL ]
            % FLGs VAL pairs are
            % 1. titleFontSize       tfs       number
            % 2. plotFontSize        pfs       number
            % 3. axisLabelFontSize   alfs      number
            % 4. titleLabel          title     string
                                               % 4.1. given text, e.g., 'title' it will apear as actual title
                                               % 4.2. 'auto' the title is obtained from the names of the input fields
                                               % 4.3. 'none' no title will appear
            % 5. legend             legend     read a legend type plt_plot_legendProperties
            % 6. xAxis              xAxis      read an axis type plt_plot_axisProperties
            % 7. yAxis              yAxis      read an axis type plt_plot_axisProperties
        function objout = read(obj, fid)
            objout = plt_plot_plotProperties;
            buf = fscanf(fid, '%s', 1);
            if (strcmp(buf, '[') == 0)
                fprintf(1, 'reading plt_plot_plotProperties: data set does not start with [, instead %s\n', buf);
                pause;
            end

            buf = fscanf(fid, '%s', 1);
            while (strcmp(buf, ']') == 0)
                if (strcmp(buf, 'tfs') == 1)
                    objout.titleFontSize = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'pfs') == 1 )
                    objout.plotFontSize = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'alfs') == 1)
                    objout.axisLabelFontSize = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'title') == 1)
                    str = fscanf(fid, '%s', 1);
                    objout.titleLabel = readStringWithoutSpace(str, '*', ' ');
                elseif (strcmp(buf, 'legend') == 1)
%                    objout.legend = plt_plot_legendProperties;
                    objout.legend = objout.legend.read(fid);
                elseif (strcmp(buf, 'xAxis') == 1)
%                    objout.xAxis = plt_plot_axisProperties;
                    objout.xAxis = objout.xAxis.read(fid);
                elseif (strcmp(buf, 'yAxis') == 1)
%                    objout.yAxis = plt_plot_axisProperties;
                    objout.yAxis = objout.yAxis.read(fid);
                elseif (strcmp(buf, ']') == 0)
                    buf
                    fprintf(1, 'invalid format in reading plt_plot_plotProperties %s \n', buf);
                    pause;
                end
                buf = fscanf(fid, '%s', 1);
            end
        end
        
        function h = setLegend(obj, axes, labels, isLatex, forceDroppingDir, forceScaleOpt, addFieldNameInsideLeg, runsParameterName)
           h = obj.legend.setLegend(axes, labels, isLatex, forceDroppingDir, forceScaleOpt, addFieldNameInsideLeg, runsParameterName);
        end
        function setTitleAndPlotFontSize(obj, axes, titleIn, isPSFrag, isLatex) 
            if nargin < 3
                isPSFrag = 0;
            end
            if nargin < 4
                isLatex = 1 - isPSFrag;
            end
            set(axes, 'FontSize', obj.plotFontSize);
            
            if (strcmp(obj.titleLabel, 'none') == 0)
                tfs = obj.titleFontSize;
                titl = get(axes, 'title');
                if (isPSFrag == 1)
                    set(titl, 'String', 'title', 'FontSize', tfs);
                else
                    if (~isLatex)
                        if (strcmp(obj.titleLabel, 'auto') == 1)
                            set(titl, 'String', titleIn, 'FontSize', tfs);
                        else
                            set(titl, 'String', obj.titleLabel, 'FontSize', tfs);
                        end
                    end
                end
            end
        end
        
        function [appendAxisDataLabel2TitleX, appendAxisDataLabel2TitleY] = setAxesLimitsLabelsFontSize(obj, axes, xLabelIn, yLabelIn, isPSFrag, userConfigSpecifiedAxisLims, xMinIn, xMaxIn, yMinIn, yMaxIn, isLatex, addFieldNameInsideLeg, runsParameterName, forceDroppingDir, forceScaleOpt)
            if nargin < 4
                isPSFrag = 0;
            end
%            hasInputXMinMax = 1;
            if nargin < 6
%                hasInputXMinMax = 0;
                limActual = get(axes, 'xlim');
                xMinIn = limActual(1);
                xMaxIn = limActual(2);
            end
%            hasInputYMinMax = 1;
            if nargin < 8
%                hasInputYMinMax = 0;
                limActual = get(axes, 'ylim');
                yMinIn = limActual(1);
                yMaxIn = limActual(2);
            end
            if nargin < 11
                isLatex = 1 - isPSFrag;
            end
            if nargin < 12
                forceDroppingDir = 0;
            end
            if nargin < 13
                addFieldNameInsideLeg = 0;
            end
            [lims, setlims] = obj.xAxis.getAxisLimits(xMinIn, xMaxIn, userConfigSpecifiedAxisLims);
            if (setlims == 1)
                set(axes, 'xlim', lims);
            end
            set(axes, 'XScale', obj.xAxis.scale);
            set(axes, 'XMinorTick', obj.xAxis.minorTick);
            set(axes, 'XDir', obj.xAxis.dir);
            [labelOut, setLabel, appendAxisDataLabel2TitleX] = obj.xAxis.getAxisLabel(xLabelIn, 'X', isPSFrag, isLatex, forceDroppingDir, forceScaleOpt);
            if (setLabel == 1)
                xh = get(axes, 'XLabel');
                if (isLatex == 0)
                    set(xh, 'String', labelOut, 'FontSize', obj.axisLabelFontSize, 'VerticalAlignment','Top');
                else
                    set(xh, 'String', labelOut, 'FontSize', obj.axisLabelFontSize, 'VerticalAlignment','Top', 'Interpreter', 'latex');
                end
            end
            
            [lims, setlims] = obj.yAxis.getAxisLimits(yMinIn, yMaxIn, userConfigSpecifiedAxisLims);
            if (setlims == 1)
                set(axes, 'ylim', lims);
            end
            set(axes, 'YScale', obj.yAxis.scale);
            set(axes, 'YMinorTick', obj.yAxis.minorTick);
            set(axes, 'YDir', obj.yAxis.dir);
            [labelOut, setLabel, appendAxisDataLabel2TitleY] = obj.yAxis.getAxisLabel(yLabelIn, 'Y', isPSFrag, isLatex, forceDroppingDir, forceScaleOpt);
            if (setLabel == 1)
                yh = get(axes, 'YLabel');
                if (isLatex == 0)
                    set(yh, 'String', labelOut, 'FontSize', obj.axisLabelFontSize, 'VerticalAlignment','Bottom');
                else
                    set(yh, 'String', labelOut, 'FontSize', obj.axisLabelFontSize, 'VerticalAlignment','Bottom', 'Interpreter', 'latex');
                end
            end
        end            
        
        function hLegend = setPlotLabelsAxis(obj, axes, titleIn, legendLabels, xLabelIn, yLabelIn, isPSFrag, userConfigSpecifiedAxisLims, isLatex, addFieldNameInsideLeg, runsParameterName, forceDroppingDir, forceScaleOpt, xMinIn, xMaxIn, yMinIn, yMaxIn)
%             if nargin < 7
%                 isPSFrag = 0;
%             end
%             if nargin < 14
%                 isLatex = 1 - isPSFrag;
%             end
%             if nargin < 15
%                 addFieldNameInsideLeg = 0;
%             end
%             if nargin < 16
%                 runsParameterName = '';
%             end
%             if nargin < 17
%                 forceDroppingDir = 0;
%             end
%             if nargin < 18
%                 forceScaleOpt = 0;
%             end
            if nargin < 14
                limActual = get(axes, 'xlim');
                xMinIn = limActual(1);
                xMaxIn = limActual(2);
            end
            if nargin < 16
                limActual = get(axes, 'ylim');
                yMinIn = limActual(1);
                yMaxIn = limActual(2);
            end

            hasLegend = (length(legendLabels) > 1);
            if hasLegend
                hLegend = setLegend(obj, axes, legendLabels, isLatex, forceDroppingDir, forceScaleOpt, addFieldNameInsideLeg, runsParameterName);
            end
            [appendAxisDataLabel2TitleX, appendAxisDataLabel2TitleY] = setAxesLimitsLabelsFontSize(obj, axes, xLabelIn, yLabelIn, isPSFrag, userConfigSpecifiedAxisLims, xMinIn, xMaxIn, yMinIn, yMaxIn, isLatex, addFieldNameInsideLeg, runsParameterName, forceDroppingDir, forceScaleOpt);
            title = titleIn;
            if ((appendAxisDataLabel2TitleX == 1) || (appendAxisDataLabel2TitleY == 1))
                title = [title, '( ', xLabelIn, ' vs. ', yLabelIn, ' )'];
            end
            setTitleAndPlotFontSize(obj, axes, title, isPSFrag, isLatex);
        end
    end        
end
