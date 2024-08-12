function plotSpaceMeshSerialNumber(cnf, ...
                                    nameFlds, nameFldsLatex, timeGiven, timeMinGiven, timeMaxGiven, ...
                                    modifyInput, dataFileNameIn, runNameIn, runFolder, outputPhysicsDirectory, printFinal)
global visSet;
global globalVisibility;

%If general break down of computational times is required
detailed_time = -1; %-1 inactive, 0 status bar inclusion, 1 detailed comp time  
monitoring_points = 9;

global numflds;
global configGen;
global s_runName;
global vpsObj;
global FIG;
global figH1;
%FIG = setDefaultPlotVisible(visSet,'reset');

if (nargin < 7)
    modifyInput = 0;
end

if (nargin < 8)
    runNm = configGen{s_runName};
    doFileNameGiven = 0;
else
    runNm = runNameIn;
    [fFolderPath, rFolderName, rFolderExt] = fileparts(runFolder);
    % adding run folder to not mix runs with the same name
    runNm = [runNm, '_', rFolderName];
    doFileNameGiven = 1;
end

global tmin;
global tmax;
global tave;
global num;
global csegments;


global s_dirOut;
global s_runNameAppendix;
global s_printOptionExt;
%global s_printOption;
global s_doPrintEPS;
global s_dir;
global s_middlename;
global s_midNData;

%global s_doPrintEPS;

global s_b_xlim;
global s_xmin_all;
global s_xmax_all;
global s_b_ylim;
global s_ymin_all;
global s_ymax_all;

global enforceLimitsWithxlim_ylim;
global g_plotAxis;

global g_box_xys;
global g_box_line_width;
global g_box_line_color;

global I_includeRefineInLegend;
global I_includeLegend; 
global I_includeColorbar;
global I_elementEdgeColor;
global I_elementEdgeWidth;
global I_legendLocation;

global I_damageLevelsFlag;
global I_includeRefinementClrs;

global I_numberDistDPts;

global id_clr;
global id_lstyle;
global id_lwdth;

global I_DistDPts;

global g_clr_coarsen;
global g_clr_none;
global g_clr_refine;

global idam_level;

if (doFileNameGiven == 1)
    dataFileName = [runFolder, '/', outputPhysicsDirectory, '/', dataFileNameIn];
    [pathstr,name,ext] = fileparts(dataFileName);
    statFileName = [fullfile(pathstr,name),'.stat'];
else
    dataFileName = [configGen{s_dir}, runNm, configGen{s_middlename}, configGen{s_midNData}, num2str(cnf, '%0.10d'),'.', 'txt'];
    statFileName = [configGen{s_dir}, runNm, configGen{s_middlename}, configGen{s_midNData}, num2str(cnf, '%0.10d'),'.', 'stat'];
end
fprintf(1, 'plotting\t%s\t', dataFileName);

%Progress Location - Start = 0
if detailed_time == 0
    STATUS(monitoring_points,0);
end

%(Pc) Read in pSpec vector information for multiple fields from .stat file
fid = fopen(statFileName, 'r');

if (fid < 0)
    fprintf(1,'statFileName not open: %s',statFileName);
    pause;
end
vpsObj = readStatFile(fid,vpsObj);
numflds = vpsObj.numFields;

global mainMeshPlotActive; mainMeshPlotActive = 1; 

total = tic;
if detailed_time == 1
    preRead = tic;
end

    

for fldind = 1:numflds    
    
f = vpsObj.find(vpsObj.pSpecs{fldind}.Field.NAME) + 1;
fldName = vpsObj.pSpecs{f}.Field.NAME;
proceed = vpsObj.haveScheme(fldName);

if (proceed == 1)

%========================================== 
% 2/8/2017
OutputFigureDir = fullfile(configGen{s_dirOut},['m_',fldName]);
if isdir(OutputFigureDir)
    % continue
else
    mkdir(OutputFigureDir);
end
%========================================== 
%========================================== 
% 11/1/2017
OutputFigureTextDir = fullfile(OutputFigureDir,'TxtFiles');
if isdir(OutputFigureTextDir)
    % continue
else
    mkdir(OutputFigureTextDir);
end
%==========================================
    
%save axes handle
    figH1 = gca; %PC
    if (configGen{I_includeColorbar})
        cbar = colorbar(); %PC
    end
    
    hold(figH1,'on')
    set(figH1,'DrawMode','fast'); %,'Visible',globalVisibility);
    set(FIG,'Visible',globalVisibility)    
    
    damageLevels = vpsObj.getLimitScheme(fldName).distLevels.level;             %configGen{I_damageLevelsFlag};
    includeRefinement = configGen{I_includeRefineInLegend};
    includeAdaptivity = vpsObj.getLimitScheme(fldName).includeRefinementClrs;   %configGen{I_includeRefinementClrs};
    
    tmin = inf;
    tmax = -inf;
    tave = 0;
    num = 0;
    csegments = 0;
    
if (mainMeshPlotActive == 1)
    %

    % if (configGen{I_includeLegend} == 1)
    %     
    %     for i = 1:configGen{I_numberDistDPts} 
    %        plot([inf inf], [inf inf], 'Color', configGen{I_DistDPts}{id_clr}{i},...
    %            'LineStyle', configGen{I_DistDPts}{id_lstyle}{i}, 'LineWidth', configGen{I_DistDPts}{id_lwdth}(i));
    %        if (i==1)
    %         hold on;
    %        end
    %     end
    %     
    %     fill([inf inf inf inf], [inf inf inf inf], configGen{g_clr_coarsen}, ...
    %         'LineStyle', '-', 'EdgeColor', configGen{I_elementEdgeColor}, 'LineWidth', configGen{I_elementEdgeWidth});
    % %    hold on;
    %     fill([inf inf inf inf], [inf inf inf inf], configGen{g_clr_none}, ...
    %         'LineStyle', '-', 'EdgeColor', configGen{I_elementEdgeColor}, 'LineWidth', configGen{I_elementEdgeWidth});
    % %    hold on;
    %     if (includeRefinement == 1)
    %         fill([inf inf inf inf], [inf inf inf inf], configGen{g_clr_refine}, ...
    %         'LineStyle', '-', 'EdgeColor', configGen{I_elementEdgeColor}, 'LineWidth', configGen{I_elementEdgeWidth});
    % %        hold on;
    %     end
    % 
    %     offset = configGen{I_numberDistDPts};
    %     names = cell(1,offset-1);
    %     if ((offset == 1) || (abs(damageLevels) == 1))
    %             names{1} = 'crack';
    %     elseif (damageLevels == 2)
    % %            names{1} = 'D = 1';
    % %            names{2} = 'D < 1';
    %             names{1} = [num2str(max(configGen{I_DistDPts}{idam_level}(1), 0)), ' < D \leq ', num2str(1)];
    %             names{2} = [num2str(max(configGen{I_DistDPts}{idam_level}(2), 0)), ' \leq D \leq ', num2str(max(configGen{I_DistDPts}{idam_level}(1), 0))];
    %     else
    %         if (damageLevels == -2)
    %             names{1} = 'D = 1';
    %             names{2} = [num2str(max(configGen{I_DistDPts}{idam_level}(2), 0)), ' < D < ', num2str(1)];
    %             st = 3;
    %         else
    %             names{1} = [num2str(max(configGen{I_DistDPts}{idam_level}(1), 0)), ' < D'];
    %             st = 2;
    %         end
    %         for i = st:configGen{I_numberDistDPts} - 1
    %             names{i} = [num2str(max(configGen{I_DistDPts}{idam_level}(i), 0)), ' < D < ', num2str(max(configGen{I_DistDPts}{idam_level}(i - 1), 0))];
    %         end    
    %         names{offset} = ['D < ', num2str(max(configGen{I_DistDPts}{idam_level}(offset - 1), 0))];
    %     end
    %     if (includeAdaptivity == 1)
    %         names{offset + 1} = 'coarsen';
    %         names{offset + 2} = 'none';
    %         if (includeRefinement == 1)
    %             names{offset + 3} = 'refine';
    %         end
    %     end
    %     if (length(configGen{I_legendLocation}) > 4)
    %         legendFontSize = 9;
    %         legend(gca, names, 'Location', configGen{I_legendLocation},'FontSize', legendFontSize); 
    % %        legend('boxoff');
    %     elseif (length(configGen{I_legendLocation}) > 2)
    %         legend(gca, names, 'Location', configGen{I_legendLocation}); 
    % %        legend('boxoff');
    %     end
    % %    legend 'boxoff';
    % end

    %%static legend
    %%set(gca,'LegendColorbarListeners',[]); 
    %%setappdata(gca,'LegendColorbarManualSpace',1);
    %%setappdata(gca,'LegendColorbarReclaimSpace',1);

    %lenR = length(dataFileName)

    fid = fopen(dataFileName, 'r');

    if (fid < 0)
        fprintf(1,'dataFileName not open: %s',dataFileName);
        pause;
    end

    %Progress Location - Pre File Read = 1
    if (detailed_time == 0)
        STATUS(monitoring_points,1);
    elseif (detailed_time == 1)
        toRead = toc(preRead);
        atRead = tic;
            subread = tic;
    end

    %Read in space mesh blocks from%file%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    block_num = 1;
    [data, noteof, doPlot] = readSpaceMeshBlock(fid); %[data, noteof, doPlot] = block{i};
    if (doPlot == 1) 
        block{block_num} = data;
        block_num = block_num + 1;
    end 
    while(noteof ~= 0)
        [data, noteof, doPlot] = readSpaceMeshBlock(fid);
        if (doPlot == 1)
            block{block_num} = data;
            block_num = block_num + 1;
        end
    end
    fclose(fid);

    %Progress Location - Post File Read = 2
    if (detailed_time == 0)
        STATUS(monitoring_points,2);
    elseif (detailed_time == 1)
        fprintf(1,'\n+ meshblock read time:  %.3f [min]\n',toc(subread)/60);
    end
    %Progress Location - PreMesh Plotting = 3
    if (detailed_time == 0)
        STATUS(monitoring_points,3);
    elseif (detailed_time == 1)
            subread = tic;
    end

    %Plotting mesh
%    hold on;

    vpsObj = plotSpaceMeshBlock(block,vpsObj);
    clear block;


    %Progress Location - PostMesh Plotting = 4
    if detailed_time == 0
        STATUS(monitoring_points,4);
    elseif (detailed_time == 1)
            fprintf(1,'+ meshblock plot time:  %.3f [min]\n',toc(subread)/60);
        atReadFin = toc(atRead);
        preMainPlt = tic;
    end
 
end
    set(FIG,'Visible',globalVisibility)

    %plotting the boxes
    mat = configGen{g_box_xys};
    lw = configGen{g_box_line_width};
    lc = configGen{g_box_line_color};
    [m, n] = size(mat);

    for i = 1:m
        xmin = mat(i, 1);
        ymin = mat(i, 2);
        xmax = mat(i, 3);
        ymax = mat(i, 4);
        vpsObj.pSpecs{f}.xdat = horzcat(vpsObj.pSpecs{f}.xdat,[xmin,xmax;xmax,xmax;xmax,xmin;xmin,xmin]');
        vpsObj.pSpecs{f}.ydat = horzcat(vpsObj.pSpecs{f}.ydat,[ymin,ymin;ymin,ymax;ymax,ymax;ymax,ymin]');
        for(j = 1:4)
            vpsObj.pSpecs{f}.lstyle{length(vpsObj.pSpecs{f}.lstyle)+1} = '-';
            vpsObj.pSpecs{f}.lclr{length(vpsObj.pSpecs{f}.lclr)+1} = lc;
            vpsObj.pSpecs{f}.lwidth{length(vpsObj.pSpecs{f}.lwidth)+1} = lw;
        end
    end

    % messes up the view in general (zoomed views)
    appendix = configGen{s_runNameAppendix};
    %appendix = [appendix, '_lia', num2str(includeAdaptivity), '_lir', num2str(includeRefinement)];
    %if (damageLevels > 0)
    %    appendix = [appendix, '_dlp', NUM2STR(damageLevels)];
    %else
    %    appendix = [appendix, '_dlm', NUM2STR(-damageLevels)];
    %end    
    plotAxis = configGen{g_plotAxis};
    if (plotAxis == 0)
        axis(figH1, 'off')
    %    set(gcf,'Visible','Off')
        %outputNameBase = [configGen{s_dirOut},  runNm, '_', appendix, '_', 'noAxis_',  num2str(cnf, '%0.8d'),'_fld=', fldName];
        outputNameBase = fullfile(OutputFigureDir,[runNm, '_', appendix, '_', 'noAxis_',  num2str(cnf, '%0.8d'),'_fld=', fldName]);
    else
        %outputNameBase = [configGen{s_dirOut},  runNm, '_', appendix, '_',  num2str(cnf, '%0.8d'),'_fld=', fldName];
        outputNameBase = fullfile(OutputFigureDir,[runNm, '_', appendix, '_', num2str(cnf, '%0.8d'),'_fld=', fldName]);
    end

    %stats
    if (modifyInput == 0)
        tave = tave / num;
%       fname = [configGen{s_dirOut},  runNm , '_', num2str(cnf, '%0.8d'), '.txt'];
%       fname = [configGen{s_dirOut}, runNm, '_', num2str(cnf, '%0.8d'),'_fld=', fldName,'.txt'];
        fname = fullfile(OutputFigureTextDir,[runNm, '_', num2str(cnf, '%0.8d'),'_fld=', fldName,'.txt']);

        fids = fopen(fname,'w');
        fprintf(fids, 'tmin = %g\n', tmin);
        fprintf(fids, 'tmax = %g\n', tmax);
        fprintf(fids, 'tave = %g\n', tave);
        fprintf(fids, 'csegments = %g\n', csegments);
        fprintf(fids, 'numE = %g\n', (num/3));
        fprintf(fids, 'num = %g\n\n', num);
        
        fprintf(fids, 'timeGiven = %g\n', timeGiven);
        fprintf(fids, 'timeMinGiven = %g\n', timeMinGiven);
        fprintf(fids, 'timeMaxGiven = %g\n', timeMaxGiven);
        fprintf(fids, 'nameFlds = %s\n', nameFlds);
        fprintf(fids, 'nameFldsLatex = %s\n', nameFldsLatex);
        fclose(fids);
    end
    lfs = 43;


    %Progress Location - Pre Crack Plotting = 5
    if detailed_time == 0
        STATUS(monitoring_points,5);
    elseif detailed_time == 1
        toMainPlt = toc(preMainPlt);
        atMainPlt = tic;
    end

    %final plot CHECKPOINT
    figH2 = plot(figH1,vpsObj.pSpecs{f}.xdat,vpsObj.pSpecs{f}.ydat);
    set(figH2,{'Color'},vpsObj.pSpecs{f}.lclr');
    set(figH2,{'LineStyle'},vpsObj.pSpecs{f}.lstyle');
    set(figH2,{'LineWidth'},vpsObj.pSpecs{f}.lwidth');
    %%%%
    
    %COLORBAR
    if (configGen{I_includeColorbar})
        COLORBAR(cbar,fldName,vpsObj.getLimitScheme(fldName),figH2);
    end
    %
    
    %Progress Location - Post Crack Plotting = 6
    if detailed_time == 0
        STATUS(monitoring_points,6);
    elseif detailed_time == 1
        atMainPltFin = toc(atMainPlt);
        toFin = tic;
    end
    %Progress Location - Pre Printing = 7
    if detailed_time == 0
        STATUS(monitoring_points,7);
    end

    axis(figH1, 'equal')
    %enforce limits
    if (configGen{enforceLimitsWithxlim_ylim} == 1)
        if (configGen{s_b_xlim} == 1)
            set(figH1,'xlim',[configGen{s_xmin_all} configGen{s_xmax_all}]);
        end
        if (configGen{s_b_ylim} == 1)
            set(figH1,'ylim',[configGen{s_ymin_all} configGen{s_ymax_all}]);
        end
    end
    
    outputName = [outputNameBase, '.', configGen{s_printOptionExt}];
    outputNameEPS = [outputNameBase, '.', 'eps'];
    PRINT(FIG,outputName); %Function for faster printing. removes overhead of predefined print function
    %print(FIG,configGen{s_printOption},outputName);

    %Progress Location - PreMesh Plotting = 8
    if detailed_time == 0
        STATUS(monitoring_points,8);
    end

    if (configGen{s_doPrintEPS} == 1)
        xlabel('xlabel','FontSize', lfs,'VerticalAlignment','Top');
    %    set(get(gca,'xlabel'),'VerticalAlignment','Top');
        ylabel('ylabel','FontSize', lfs,'VerticalAlignment','Bottom');
    %    hold on;
        xlimV = get(figH1,'xlim');
        ylimV = get(figH1,'ylim');
        tol = 0.001;
        xlimV(1) = xlimV(1) + tol * (xlimV(2) - xlimV(1));
        ylimV(2) = ylimV(2) - tol * (ylimV(2) - ylimV(1));

        vpsObj.pSpecs{f}.xdat = horzcat(vpsObj.pSpecs{f}.xdat,[xlimV(2),xlimV(2);xlimV(1),xlimV(1);xlimV;xlimV]');
        vpsObj.pSpecs{f}.ydat = horzcat(vpsObj.pSpecs{f}.ydat,[ylimV;ylimV;ylimV(2),ylimV(2);ylimV(1),ylimV(1)]');
        for(j = 1:4)
            vpsObj.pSpecs{f}.lstyle{length(vpsObj.pSpecs{f}.lstyle)+1} = '-';
            vpsObj.pSpecs{f}.lclr{length(vpsObj.pSpecs{f}.lclr)+1} = 'k';
            vpsObj.pSpecs{f}.lwidth{length(vpsObj.pSpecs{f}.lwidth)+1} = 0.5;
        end

        %refresh plot
    %     figH2 = plot(xdat,ydat);
    %     set(figH2,{'Color'},lclr',{'LineStyle'},lstyle',{'LineWidth'},lwidth');
        refreshdata(figH2);
        %%%%

    %    print(FIG,'-depsc', outputNameEPS);
        PRINT(FIG, outputNameEPS);
    end

    xlabel(figH1,'','FontSize',2);
    ylabel(figH1,'','FontSize',2);

    if (plotAxis >= 2)
        axis(figH1, 'off')
        if (plotAxis == 3)
%            hold on;
            %refresh plot
    %     figH2 = plot(xdat,ydat);
    %     set(figH2,{'Color'},lclr',{'LineStyle'},lstyle',{'LineWidth'},lwidth');
            refreshdata(figH2);
            %%%%
        end

%        outputNameBase = [configGen{s_dirOut},  runNm, '_', appendix, '_noAxis', num2str(cnf, '%0.8d'),'_fld=', fldName];
        outputNameBase = fullfile(OutputFigureDir,[runNm, '_', appendix, '_noAxis', num2str(cnf, '%0.8d'),'_fld=', fldName]);
        outputName = [outputNameBase, '.', configGen{s_printOptionExt}];
        outputNameEPS = [outputNameBase, '.', 'eps'];
        PRINT(FIG, outputName);
    %    print(FIG, configGen{s_printOption},outputName);

        if (configGen{s_doPrintEPS} == 1)
            xlabel(figH1, 'xlabel','FontSize', lfs, 'VerticalAlignment','Top');
    %        set(get(gca,'xlabel'),'VerticalAlignment','Top');
            ylabel(figH1, 'ylabel','FontSize', lfs,'VerticalAlignment','Bottom');
    %        print(FIG,'-depsc', outputNameEPS);
            PRINT(FIG, outputNameEPS);
        end
    end
    
    %Should remove all data from plot
    set(figH2,'XData',[],'YData',[]);
    vpsObj.pSpecs{f}.xdat = [];
    vpsObj.pSpecs{f}.ydat = [];
    vpsObj.pSpecs{f}.lclr = [];
    vpsObj.pSpecs{f}.lstyle = [];
    vpsObj.pSpecs{f}.lwidth = [];
    
mainMeshPlotActive = 0;


hold off
hold(figH1,'off')

end
end

cla(figH1);
clf(FIG,'reset');
vpsObj.reset();


%Progress Location - End = monitoring_points
if detailed_time == 0
    STATUS(monitoring_points,monitoring_points);
elseif detailed_time == 1
    atFin = toc(toFin);
end

fprintf(1,'time:  %.3f [min]\n',toc(total)/60);

if (detailed_time == 1)
    fprintf(1,'File Read = t0: %.3f : tf: %.3f : delta(t): %.3f [min]\n',[toRead,toRead+atReadFin,atReadFin]./60);
    fprintf(1,'Main Plot = t0: %.3f : tf: %.3f : delta(t): %.3f [min]\n',[toMainPlt,toMainPlt+atMainPltFin,atMainPltFin]./60);
    fprintf(1,'Printing  = t0: %.3f : tf: %.3f : delta(t): %.3f [min]\n',[0,0+atFin,atFin]./60);
end

%clearvars -except figH1 figH2 FIG;
end

function strOut = NUM2STR(num,format)
delim = '_';

strOut = '';
for i = 1:length(num)    
    if nargin < 2 || num(i) == inf || num(i) == -inf
       strOut = [strOut,num2str(num(i))]; 
    else
       strOut = [strOut,num2str(num(i),format)];
    end
    
    if i ~= length(num)
        strOut = [strOut,delim];
    end
end
    return;
end


