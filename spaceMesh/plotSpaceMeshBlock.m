%function [xdat,ydat,lclr,lstyle,lwidth] = plotSpaceMeshBlock(blocks,vpsObj)
function vpsObj = plotSpaceMeshBlock(blocks,vpsObj)
%FOR DEBUGGING
%global tempnumflds

sz = length(blocks)*3; %1E+5;
numflds = vpsObj.numFields;
%numflds = tempnumflds;

c = NaN(1,sz);
tclrmap = NaN(sz,3);
xpts = NaN(1,sz);
ypts = NaN(1,sz);

% xdat = NaN(2,sz);
% ydat = NaN(2,sz);
% lclr = cell(1,sz);
% lstyle = cell(1,sz);
% lwidth = cell(1,sz);

global flag2LineWMap;
%TODO: DETERMINE EDGE FLAG

global tmin;
global tmax;
global tave;
global num;
global csegments;

global configGen;

global g_clr_none;
global g_clr_refine;
global g_clr_coarsen;

global g_plot_spaceElement;
global g_spaceElement_font_size;
global g_spaceElement_text_color;

global g_plt_vids;
global g_vids_fnt_sz;
global g_plt_noncollinearCoarsenable;
global g_noncollinearCoarsenable_symbl;
global g_noncollinearCoarsenable_clr;
global g_noncollinearCoarsenable_sz;

global g_pltDmgdUnDmaged;
global g_plotAxis;
global I_numberDistDPts;
global I_DistDPts;
%global g_pltDmgdUnDmaged;
%global g_plotAxis;


global I_includeRefineInLegend;
global I_includeLegend;
global I_elementEdgeColor;
global I_elementEdgeWidth;
global I_legendLocation;

global I_damageLevelsFlag;
global I_includeRefinementClrs;

global g_plotMeshCoh;
global g_MeshCohLineColor;
global g_MeshCohLineStyle;
global g_MeshCohLineWidth;

global idam_level;
global id_clr;
global id_lstyle;
global id_lwdth;


global NONE;
global REFINE;
global COARSEN;

global MAX_T;

global d_id;
global d_adp;
global d_angleMark;
global d_faceMark;

global d_vid;
global d_vNonCollinearCoarsenable;
global d_vDirGiven;

global d_crd;
global d_edgef;

global d_numInflowE;
global d_inflowData;

    global d_infd_id;
	global d_infd_face;
	global d_infd_numEdge;
	global d_infd_edgeData;
        global difnd_edgeIndex;
        global difnd_numInfCracks;
        global difnd_InfCracksData;

           	global 	nbhd_ind;
           	global 	nbhd_limT;
           	global 	nbhd_startP;
           	global 	nbhd_endP;
           	global 	nbhd_numP;

                global pt_dataCrd;
                global pt_dataDamage;
                global pt_dataVector;
                
                pt_dataVector = pt_dataDamage;
                
global figH1;

OldOpt = 1;

%global I_elementEdgeColor;
%global I_elementEdgeWidth;


%loop over data within function and return full
% xdat = NaN(2,1e9);
% ydat = NaN(2,1e9);
idx = cell(1,numflds); idx(:) = {1};
idx2 = 1;
idx3 = 1;
len = length(blocks);

    for (d = 1:len)
        data = blocks{d};
        if (configGen{g_plot_spaceElement} == 1)
            id = data{d_id};
            ave = sum(data{d_crd}(1:3,  1:2)) / 3;
            text(ave(1), ave(2), num2str(id), 'FontSize', configGen{g_spaceElement_font_size}, 'Color', configGen{g_spaceElement_text_color});
        end

        adp = data{d_adp};
        % data{d_angleMark} = fscanf(fid, '%d', 1);
        % data{d_faceMark} = fscanf(fid, '%d', 1);
        % 
        t = data{d_crd}(1:3, 3);
        tmin = min(tmin, min(t));
        tmax = max(tmax, max(t));
        tsum = sum(t);
        tave = tave + tsum;
        num = num + 3;

        fx(:,idx3) = data{d_crd}(:, 1);
        fy(:,idx3) = data{d_crd}(:, 2);
        
       if (adp == NONE)
           tclrmap(idx3,:) = configGen{g_clr_none}; % n by 3 rbg matrix for creation of colormap
        elseif (adp == REFINE)
            tclrmap(idx3,:) = configGen{g_clr_refine}; % n by 3 rbg matrix for creation of colormap
        else 
            tclrmap(idx3,:) = configGen{g_clr_coarsen}; % n by 3 rbg matrix for creation of colormap
       end
        if (~OldOpt) 
            tclrmap(idx3,1) = NaN;
            tclrmap(idx3,2) = NaN;
            tclrmap(idx3,3) = NaN;
        end
%        tclr(1,idx3,1:3) = rgb; %1 by n by 3 matrix
        c(idx3) = idx3;
        
        idx3 = idx3 + 1;
        
        vids = data{d_vid};



        if (configGen{g_plt_noncollinearCoarsenable} == 1)
            clr = configGen{g_noncollinearCoarsenable_clr};
        %    nlcoarse = ones(1,3);
            nlcoarse = data{d_vNonCollinearCoarsenable};
        %     if (sum(nlcoarse) > 0)
        %         w = 10
        %         pause
        %     end
            for v = 1:3
                if (nlcoarse(v) == 1)
                    xpts(idx2) = data{d_crd}(v, 1);
                    ypts(idx2) = data{d_crd}(v, 2);
                    idx2 = idx2 + 1;
                end
            end
        end




        if (configGen{g_plt_vids} == 1)
            for v = 1:3
                text(data{d_crd}(v, 1), data{d_crd}(v, 2), num2str(vids(v)), 'FontSize', configGen{g_vids_fnt_sz});
            end
        end

        if (configGen{g_plotMeshCoh} == 1)
            edgeFlag = data{d_edgef};
            for fldind = 1:numflds
                f = vpsObj.find(obj.pSpecs{fldind}.Field.NAME) + 1;
                if (vpsObj.haveScheme(vpsObj.pSpecs{f}.Field.NAME) == 1)
                    for i = 1:3
                        if (edgeFlag(i) > 0)
                            vpsObj.pSpecs{f}.xdat(:,idx{f}) = [data{d_crd}(i, 1) data{d_crd}(i + 1, 1)]';
                            vpsObj.pSpecs{f}.ydat(:,idx{f}) = [data{d_crd}(i, 2) data{d_crd}(i + 1, 2)]';
                            vpsObj.pSpecs{f}.lclr{idx{f}} = configGen{g_MeshCohLineColor};
                            vpsObj.pSpecs{f}.lstyle{idx{f}} = configGen{g_MeshCohLineStyle};
                            vpsObj.pSpecs{f}.lwidth{idx{f}} = configGen{g_MeshCohLineWidth};
                            idx{f} = idx{f} + 1;
                        end
                    end
                end
            end
        end

        % data{d_vDirGiven} = fscanf(fid, '%d', 3);
        % data{d_edgef} = fscanf(fid, '%d', 3);

        numInf = data{d_numInflowE};

        for infE = 1:data{d_numInflowE}
        %    data{d_inflowData}{infE}{d_infd_id} = fscanf(fid, '%d', 1);
        %    data{d_inflowData}{infE}{d_infd_face} = fscanf(fid, '%d', 1);
            numEdge = data{d_inflowData}{infE}{d_infd_numEdge};

            for edge = 1:numEdge
                flg = data{d_edgef}(edge);
                
                numInfCrack = data{d_inflowData}{infE}{d_infd_edgeData}{difnd_numInfCracks}{edge};
                csegments = csegments + numInfCrack;
                for ic = 1:numInfCrack
                    limT = data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{nbhd_limT}{ic};
                    startP = data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{nbhd_startP}{ic};
                    endP = data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{nbhd_endP}{ic};
                    
                  for fldind = 1:numflds
                    f = vpsObj.find(vpsObj.pSpecs{fldind}.Field.NAME) + 1;
                    fldName = vpsObj.pSpecs{f}.Field.NAME;
                    if (vpsObj.haveScheme(fldName) == 1)  
                        %INITIALIZATION MOVED HERE WITHIN LOOP
                        lScheme = vpsObj.getLimitScheme(fldName);
                        
                        pltDmgdUnDmaged = lScheme.pltDmgdUnDmaged;          %configGen{g_pltDmgdUnDmaged};
                        plotAxis = configGen{g_plotAxis};

                        if (pltDmgdUnDmaged == 1)
                            clrDmgd = lScheme.distLevels.lClr{1};           %configGen{I_DistDPts}{id_clr}{1};
                            lStyleDmgd = lScheme.distLevels.lStyle{1};      %configGen{I_DistDPts}{id_lstyle}{1};
                            lWidthDmgd = lScheme.distLevels.lWidth{1};      %configGen{I_DistDPts}{id_lwdth}(1);

                            numAll = lScheme.numberDistPts;                 %configGen{I_numberDistDPts};
                            clrAll = lScheme.distLevels.lClr{numAll};       %configGen{I_DistDPts}{id_clr}{numAll};
                            lStyleAll = lScheme.distLevels.lStyle{numAll};  %configGen{I_DistDPts}{id_lstyle}{numAll};
                            lWidthAll = lScheme.distLevels.lWidth{numAll};  %configGen{I_DistDPts}{id_lwdth}(numAll);

                        else
                            levels = lScheme.distLevels.level;              %configGen{I_DistDPts}{idam_level};
                            segColors = lScheme.distLevels.lClr;            %configGen{I_DistDPts}{id_clr};
                            segLineStyles = lScheme.distLevels.lStyle;      %configGen{I_DistDPts}{id_lstyle};
                            segLineWidths = lScheme.distLevels.lWidth;      %configGen{I_DistDPts}{id_lwdth};    
                        end   
                        if (pltDmgdUnDmaged == 1)
                            if (limT == MAX_T)
                                vpsObj.pSpecs{f}.xdat(:,idx{f}) = [startP(1) endP(1)]';
                                vpsObj.pSpecs{f}.ydat(:,idx{f}) = [startP(2) endP(2)]';
                                vpsObj.pSpecs{f}.lclr{idx{f}} = clrDmgd;
                                vpsObj.pSpecs{f}.lstyle{idx{f}} = lStyleDmgd;
                                vpsObj.pSpecs{f}.lwidth{idx{f}} = lWidthDmgd;
                                idx{f} = idx{f} + 1;
                            else
                                vpsObj.pSpecs{f}.xdat(:,idx{f}) = [startP(1) endP(1)]';
                                vpsObj.pSpecs{f}.ydat(:,idx{f}) = [startP(2) endP(2)]';
                                vpsObj.pSpecs{f}.lclr{idx{f}} = clrAll;
                                vpsObj.pSpecs{f}.lstyle{idx{f}} = lStyleAll;
                                vpsObj.pSpecs{f}.lwidth{idx{f}} = lWidthAll;
                                idx{f} = idx{f} + 1;
                            end
                            
                           %Line Width
                           %override.
                           if ~isempty(flag2LineWMap)
                              if flag2LineWMap.isKey(flg) == 1                                                                                                                                                                                   
                                vpsObj.pSpecs{f}.lwidth{idx{f} - 1} = flag2LineWidth(flg);                                                          
                              end
                           end
                            
                        else
                           crd_ = data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{pt_dataCrd}{ic};  

                           z = data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{pt_dataVector}{ic};

%                            if f == 14
%                             disp('break')
%                            end
                        
                           try
                                [X,Y,LCLR,LS,LW] = plot2DSegments(crd_(:, 1), crd_(:, 2), z(:,f), levels, segColors, segLineStyles, segLineWidths);
                           catch ME
                               disp(ME)
                                disp(' ') 
                           end
                           
                           %Line Width
                           %override.
                           if ~isempty(flag2LineWMap)
                              if flag2LineWMap.isKey(flg) == 1                                                                                                                                                                                   
                                LW(:,:) = {flag2LineWMap(flg)};                                                          
                              end
                           end
                           
                           vpsObj.pSpecs{f}.xdat(:,idx{f}:idx{f}+size(X,2)-1) = X;
                           vpsObj.pSpecs{f}.ydat(:,idx{f}:idx{f}+size(Y,2)-1) = Y;
                           vpsObj.pSpecs{f}.lclr(idx{f}:idx{f}+size(LCLR,2)-1) = LCLR;
                           vpsObj.pSpecs{f}.lstyle(idx{f}:idx{f}+size(LS,2)-1) = LS;
                           vpsObj.pSpecs{f}.lwidth(idx{f}:idx{f}+size(LS,2)-1) = LW;
                           idx{f} = idx{f} + size(X,2);
                           
                           clearvars X Y LCLR LS LW
                        end
                    end
                  end
                end
             end
        end
    end

if (configGen{g_plt_noncollinearCoarsenable} == 1)
    plot(figH1, xpts, ypts,'LineStyle','none','Marker', configGen{g_noncollinearCoarsenable_symbl}, ...
                   'MarkerEdgeColor', clr, 'MarkerFaceColor', clr, 'MarkerSize', configGen{g_noncollinearCoarsenable_sz});
end

if (OldOpt) 
    clrmap = colormap; %save current color map
    tclrmap = tclrmap(~any(isnan(tclrmap),2),:); szCheck = size(tclrmap);
    c = c(:,~any(isnan(c),1));
    if szCheck(1) == length(c);
        colormap(tclrmap);
    else
       fprintf(1,'ERROR: colormap and indexing vector length need to agree');
        pause; 
    end
    figPatch = patch(fx,fy,c,'CDataMapping','direct');
    set(figPatch,'LineStyle', '-', 'EdgeColor', configGen{I_elementEdgeColor}, 'LineWidth', configGen{I_elementEdgeWidth});

%    colormap(clrmap); %return colormap to default
end

for fldind = 1:numflds
    f = vpsObj.find(vpsObj.pSpecs{fldind}.Field.NAME) + 1;
    if (vpsObj.haveScheme(vpsObj.pSpecs{f}.Field.NAME) == 1)
        vpsObj.pSpecs{f}.xdat = vpsObj.pSpecs{f}.xdat(:,~any(isnan(vpsObj.pSpecs{f}.xdat),1));
        vpsObj.pSpecs{f}.ydat = vpsObj.pSpecs{f}.ydat(:,~any(isnan(vpsObj.pSpecs{f}.ydat),1));

        xSz = size(vpsObj.pSpecs{f}.xdat);
        ySz = size(vpsObj.pSpecs{f}.ydat);
        if xSz(2) == ySz(2)
            emptyCells1 = cellfun('isempty', vpsObj.pSpecs{f}.lclr); 
            vpsObj.pSpecs{f}.lclr(emptyCells1) = [];
            emptyCells2 = cellfun('isempty', vpsObj.pSpecs{f}.lstyle); 
            vpsObj.pSpecs{f}.lstyle(emptyCells2) = [];
            emptyCells3 = cellfun('isempty', vpsObj.pSpecs{f}.lwidth); 
            vpsObj.pSpecs{f}.lwidth(emptyCells3) = [];
        else
            fprintf(1,'ERROR: x and y matrices need to be of same dimension');
            pause;
        end
    end
end

end
