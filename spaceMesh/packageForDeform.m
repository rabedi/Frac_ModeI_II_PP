function obj = packageForDeform(obj, args)
%arguments set are [X,Y,LCLR,LSTYLE,LWIDTH]
global uniColorMFOSM;
global uniLineWidthMFOSM;
global flag2LineWMap;

numflds = obj.numFields;
idx = cell(1,numflds); idx(:) = {1};

            alpha = args.scalingFactor;
            
            for i = 1:length(obj.segments)
                xy = [];
                val = [];
                Uin01out01 = [];

                isBdry = 0;
                for j = 1:obj.segments{i}.numP
                    isBdry = isBdry + obj.segments{i}.dat{j}.b; 
                end 
                
                if (args.plotBdry == 0) && (isBdry == obj.segments{i}.numP)
                    continue;
                else
                    for j = 1:obj.segments{i}.numP
                        flag = obj.segments{i}.dat{j}.flg;

                        if(~any(flag==args.discardFlgs))
                           if isempty(args.keepFlgs)
                               %...
                                x0 = obj.segments{i}.dat{j}.X(1);
                                x1 = obj.segments{i}.dat{j}.X(2);
                                xy = [xy;[x0 x1]];
                                tempval = [];
                                    for f = 1:numflds
                                        fldind = obj.find(obj.pSpecs{f}.Field.NAME) + 1;
                                        tempval(fldind) = obj.segments{i}.dat{j}.flds(fldind);
                                    end
                                    val = [val;tempval];
                                
                                uin0 = obj.find('uin0') + 1;
                                uin1 = obj.find('uin1') + 1;
                                uout0 = obj.find('uout0') + 1;
                                uout1 = obj.find('uout1') + 1;
                                
                                Uin = [obj.segments{i}.dat{j}.flds(uin0),obj.segments{i}.dat{j}.flds(uin1)];
                                Uout = [obj.segments{i}.dat{j}.flds(uout0),obj.segments{i}.dat{j}.flds(uout1)];
                                Uin01out01 = [Uin01out01;Uin Uout];
                               %...
                           else
                               if (any(flag==args.keepFlgs))
                                   %...
                                    x0 = obj.segments{i}.dat{j}.X(1);
                                    x1 = obj.segments{i}.dat{j}.X(2);
                                    xy = [xy;[x0 x1]];
                                    tempval = [];
                                    for fldind = 1:numflds
                                        f = obj.find(obj.pSpecs{fldind}.Field.NAME) + 1;
                                        tempval(f) = obj.segments{i}.dat{j}.flds(f);
                                    end
                                    val = [val;tempval];

                                    uin0 = obj.find('uin0') + 1;
                                    uin1 = obj.find('uin1') + 1;
                                    uout0 = obj.find('uout0') + 1;
                                    uout1 = obj.find('uout1') + 1;

                                    Uin = [obj.segments{i}.dat{j}.flds(uin0),obj.segments{i}.dat{j}.flds(uin1)];
                                    Uout = [obj.segments{i}.dat{j}.flds(uout0),obj.segments{i}.dat{j}.flds(uout1)];
                                    Uin01out01 = [Uin01out01;Uin Uout];
                                   %...
                               else
                                   continue;
                               end
                           end
                        else
                            continue;
                        end 
                    end
                    %...
%                    Uin01out01 = cell2mat(Uin01out01);
                    
                    szX = size(xy,1);
                    szU = size(Uin01out01,1);
                  
                    if (szX == szU)
                       for pt = 1:szX-1
                          xtemp = [xy(pt,1),xy(pt+1,1)];
                          ytemp = [xy(pt,2),xy(pt+1,2)];
                          %FIELD ITERATE...........................................
                            for fldind = 1:numflds
                            f = obj.find(obj.pSpecs{fldind}.Field.NAME) + 1;
                            fldName = obj.pSpecs{f}.Field.NAME;
                                                if (obj.haveScheme(fldName) == 1)  
                                                    %INITIALIZATION MOVED HERE WITHIN LOOP
                                                    lScheme = obj.getLimitScheme(fldName);

                                                    pltDmgdUnDmaged = lScheme.pltDmgdUnDmaged;          %configGen{g_pltDmgdUnDmaged};
%                                                    plotAxis = configGen{g_plotAxis};

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
                            %                         if (pltDmgdUnDmaged == 1)
                            %                             if (limT == MAX_T)
                            %                                 obj.pSpecs{f}.xdat(:,idx{f}) = [startP(1) endP(1)]';
                            %                                 obj.pSpecs{f}.ydat(:,idx{f}) = [startP(2) endP(2)]';
                            %                                 obj.pSpecs{f}.lclr{idx{f}} = clrDmgd;
                            %                                 obj.pSpecs{f}.lstyle{idx{f}} = lStyleDmgd;
                            %                                 obj.pSpecs{f}.lwidth{idx{f}} = lWidthDmgd;
                            %                                 idx{f} = idx{f} + 1;
                            %                             else
                            %                                 obj.pSpecs{f}.xdat(:,idx{f}) = [startP(1) endP(1)]';
                            %                                 obj.pSpecs{f}.ydat(:,idx{f}) = [startP(2) endP(2)]';
                            %                                 obj.pSpecs{f}.lclr{idx{f}} = clrAll;
                            %                                 obj.pSpecs{f}.lstyle{idx{f}} = lStyleAll;
                            %                                 obj.pSpecs{f}.lwidth{idx{f}} = lWidthAll;
                            %                                 idx{f} = idx{f} + 1;
                            %                             end
                            %                         else
                                                       crd_ = [xtemp', ytemp'];  
                                                       z = [val(pt,f),val(pt+1,f)]';

%                                                       if f == 2
%                                                        disp('break')
%                                                       end
                                                       try
                                                            [Xtemp,Ytemp,LCLR,LS,LW] = plot2DSegments(crd_(:, 1), crd_(:, 2), z, levels, segColors, segLineStyles, segLineWidths, flag);
                                                       catch ME
                                                           disp(ME)
                                                            disp(' ') 
                                                       end
                                                      
                                                       %For superposition
                                                       %of plots if
                                                       %distinquished by line colour 
                                                       uniLineWidthMFOSM = LW{end};
                                                       if ~isempty(uniColorMFOSM)
                                                          if obj.segments{i}.dat{end}.b ~= 1                                                                                                                                                                                      
                                                            LCLR(:,:) = {uniColorMFOSM};
                                                          else
                                                            LCLR(:,:) = {RGB('k')};
                                                          end
                                                       end  
                                                       
                                                       %Line Width
                                                       %override.
                                                       if ~isempty(flag2LineWMap)
                                                          if flag2LineWMap.isKey(obj.segments{i}.dat{end}.flg) == 1 && obj.segments{i}.dat{end}.b ~= 1                                                                                                                                                                                     
                                                            LW(:,:) = {flag2LineWMap(obj.segments{i}.dat{end}.flg)};                                                          
                                                          end
                                                       end
                                                       
                                                      X = [[Xtemp(1)+alpha*Uin01out01(pt,1) Xtemp(2)+alpha*Uin01out01(pt+1,1)]',...
                                                           [Xtemp(1)+alpha*Uin01out01(pt,3) Xtemp(2)+alpha*Uin01out01(pt+1,3)]'];
                                                      Y = [[Ytemp(1)+alpha*Uin01out01(pt,2) Ytemp(2)+alpha*Uin01out01(pt+1,2)]',...
                                                           [Ytemp(1)+alpha*Uin01out01(pt,4) Ytemp(2)+alpha*Uin01out01(pt+1,4)]'];
                                                      LCLR = [LCLR,LCLR];
                                                      LS = [LS,LS];
                                                      LW = [LW,LW];

                                                       obj.pSpecs{f}.xdat(:,idx{f}:idx{f}+size(X,2)-1) = X;
                                                       obj.pSpecs{f}.ydat(:,idx{f}:idx{f}+size(Y,2)-1) = Y;
                                                       obj.pSpecs{f}.lclr(idx{f}:idx{f}+size(LCLR,2)-1) = LCLR;
                                                       obj.pSpecs{f}.lstyle(idx{f}:idx{f}+size(LS,2)-1) = LS;
                                                       obj.pSpecs{f}.lwidth(idx{f}:idx{f}+size(LS,2)-1) = LW;
                                                       idx{f} = idx{f} + size(X,2);
                                                       
                                                       clearvars Xtemp Ytemp LCLR LS LW
                                                end
                            end
                          %........................................................
                          
                          
                          
                          X = [X;[xtemp(1)+alpha*Uin01out01(pt,1) xtemp(2)+alpha*Uin01out01(pt+1,1)]];
                          X = [X;[xtemp(1)+alpha*Uin01out01(pt,3) xtemp(2)+alpha*Uin01out01(pt+1,3)]];
                          Y = [Y;[ytemp(1)+alpha*Uin01out01(pt,2) ytemp(2)+alpha*Uin01out01(pt+1,2)]];
                          Y = [Y;[ytemp(1)+alpha*Uin01out01(pt,4) ytemp(2)+alpha*Uin01out01(pt+1,4)]];
                       end
                    else
                       THROW(['ERROR:Dimension mismatch']);  
                    end
                    %...
                end
            end
            
for fldind = 1:numflds
    f = obj.find(obj.pSpecs{fldind}.Field.NAME) + 1;
    if (obj.haveScheme(obj.pSpecs{f}.Field.NAME) == 1)
        obj.pSpecs{f}.xdat = obj.pSpecs{f}.xdat(:,~any(isnan(obj.pSpecs{f}.xdat),1));
        obj.pSpecs{f}.ydat = obj.pSpecs{f}.ydat(:,~any(isnan(obj.pSpecs{f}.ydat),1));

        xSz = size(obj.pSpecs{f}.xdat);
        ySz = size(obj.pSpecs{f}.ydat);
        if xSz(2) == ySz(2)
            emptyCells1 = cellfun('isempty', obj.pSpecs{f}.lclr); 
            obj.pSpecs{f}.lclr(emptyCells1) = [];
            emptyCells2 = cellfun('isempty', obj.pSpecs{f}.lstyle); 
            obj.pSpecs{f}.lstyle(emptyCells2) = [];
            emptyCells3 = cellfun('isempty', obj.pSpecs{f}.lwidth); 
            obj.pSpecs{f}.lwidth(emptyCells3) = [];
        else
            fprintf(1,'ERROR: x and y matrices need to be of same dimension');
            pause;
        end
    end
end            
         
end


