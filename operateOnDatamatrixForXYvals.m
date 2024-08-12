function [xval, yval, cont] = operateOnDatamatrixForXYvals(len, xcol, ycol, data, fileNo, curveNo, offValuel)

global plotRegAheadCrackTip;
global IplotAroundProcessZoneSize;
global cnfg;
global minVflag;
global maxVflag;
global averageVflag;
global minVtotal;
global maxVtotal;
global averageVtotal;


global flagValueBase; 
global flagDataBase;
global flagValueFile; 
global flagDataFile;
global flagValueCurvex; 
global flagDataCurvex;
global flagValueCurvey; 
global flagDataCurvey;
global flagSimDataCurvex;
global flagSimDataCurvey;



global doReg;
global RegFlNo;
global RegCrvNo;
global RegPlotNo;
global fReg; % regrassion for the front of the shock
global bReg; %regression data for the back of the shock


%these indices are used on regression
%n number of points
% x y x2 xy summs of these variables 
%a b r reggression values
%x, y s e start and end points
% sa ya averages
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

[n, m] = size(data);
nvec = ones(n, 1);
for i = 1:len
    xval{i} = data(:,xcol(i));
    yval{i} = data(:,ycol(i));
    
    for j = 1:length(xval{i})
        if ((xval{i}(j) == offValuel) || (yval{i}(j) == offValuel))
            cont = 0;
            return;
        end    
    end
%     XcolNo = getActualColNumFromColNum(xcol(i));
%     YcolNo = getActualColNumFromColNum(ycol(i));
    curve = curveNo(i);
    
        

    %position 1 means to check other flags value 0 means no further check
    % flagValue(1) = 0 stop other flag checks

    if ((flagValueCurvex{curve}(1) == 0) && (flagValueCurvey{curve}(1) == 0))
        continue;
    end


    datax = cell(1, 4);
    datay = cell(1, 4);
    for ind = 1:4
        simDx = flagSimDataCurvex{curve}(ind);
        simDy = flagSimDataCurvey{curve}(ind);
        if (simDx < 0)
            datax{ind} = flagDataCurvex{curve}(ind) * nvec;
        else
            datax{ind} = flagDataCurvex{curve}(ind) * data(:, simDx);
        end

        if (simDy < 0)
            datay{ind} = flagDataCurvey{curve}(ind) * nvec;
        else
            datay{ind} = flagDataCurvey{curve}(ind) * data(:, simDy);
        end
    end

    Xt = operateOnValBasedOnFlagValueData(xval{i}, flagValueCurvex{curve}, datax);
    Yt = operateOnValBasedOnFlagValueData(yval{i}, flagValueCurvey{curve}, datay);
    
    
% this part is for regression on velocity log log plots    
    x = xval{i};
%    y = yval{i};
%    y = Yt;
    if ((doReg == 1) && (fileNo <= RegFlNo))%&& (RegCrvNo == curve))
        pzSize = cnfg{IplotAroundProcessZoneSize};
        logBase = flagDataCurvey{curve}(4);
        if ((length(pzSize) == 1) && (isfinite(pzSize) == 1) && (pzSize > 0))
            baseAddition = log(pzSize) / log(logBase);
        else
            baseAddition = 0;
        end
            
        for m = 1: length(Xt)
            xt = Xt(m);
            yt = Yt(m);
            
            x0 = flagDataCurvex{curve}(2);


            front = 0;
            back = 0;
            if (x > x0)
                front = 1;
            end
            if (x < x0)
                back = 1;
            end

            if (front == 1) 

                if (plotRegAheadCrackTip > 0)
                    % redundant calculation for xtmin and max:) needed only once
                    xtmin = flagDataCurvex{curve}(indcmnf);
                    xtmax = flagDataCurvex{curve}(indcmxf);
                    
                    if (xtmin > 10000)
                        xtmin = xtmin - 11000 + baseAddition;
                    end
                        
                    if (xtmax > 10000)
                        xtmax = xtmax - 11000 + baseAddition;
                    end
                    
                    if ((xt >= xtmin) && (xt <= xtmax))
                       fReg(indn) = fReg(indn) + 1;
                       fReg(indx) = fReg(indx) + xt;
                       fReg(indy) = fReg(indy) + yt;
                       fReg(indxy) = fReg(indxy) + xt * yt;
                       fReg(indx2) = fReg(indx2) + xt * xt;
                       fReg(indxs) = xtmin;
                       fReg(indxe) = xtmax;
                    end
                elseif (plotRegAheadCrackTip < 0)
                    [m, n] = size(Xt);
                    Xt = NaN * ones(m, n);
                    Yt = NaN * ones(m, n);
                end
            end            

            if (back == 1)
                % redundant calculation for xtmin and max:) needed only once
                xtmin = flagDataCurvex{curve}(indcmnb);
                xtmax = flagDataCurvex{curve}(indcmxb);

                if (xtmin > 10000)
                    xtmin = xtmin - 11000 + baseAddition;
                end

                if (xtmax > 10000)
                    xtmax = xtmax - 11000 + baseAddition;
                end

                if ((xt >= xtmin) && (xt <= xtmax))
                   bReg(indn) = bReg(indn) + 1;
                   bReg(indx) = bReg(indx) + xt;
                   bReg(indy) = bReg(indy) + yt;
                   bReg(indxy) = bReg(indxy) + xt * yt;
                   bReg(indx2) = bReg(indx2) + xt * xt;
                   bReg(indxs) = xtmin;
                   bReg(indxe) = xtmax;
                end
            end
        end
    end

    xval{i} = Xt;
    yval{i} = Yt;
        
    
end

cont = 1;