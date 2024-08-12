function [Pout, deltaUout] = ComputeLoadVSDisplacement(obj, ~)
Pout = zeros(2,1);
deltaUout = zeros(2,1);

global NULL; NULL = 0;
global NB; NB = 1; 
global SB; SB = 2; 
global EB; EB = 3; 
global WB; WB = 4;
global NUMBDRY; NUMBDRY = 4;

uin0 = obj.find('uin0') + 1;
uin1 = obj.find('uin1') + 1;
uout0 = obj.find('uout0') + 1;
uout1 = obj.find('uout1') + 1;
s0 = obj.find('s0') + 1;
s1 = obj.find('s1') + 1;

%    numflds = obj.numFields;
%    idx = cell(1,numflds); idx(:) = {1};
    
    P_U = cell(NUMBDRY,1);
    for i = 1:NUMBDRY
       P_U{i} = struct('P',0.0,'U',0.0,'L',0.0); 
    end
    
    for i = 1:length(obj.segments)
        xy = [];
%        val = [];
%        Uin01out01 = [];
%        P01 = [];
        Lt = 0.0;

        isBdry = 0;
        for j = 1:obj.segments{i}.numP
            isBdry = isBdry + obj.segments{i}.dat{j}.b; 
        end 

        if (isBdry ~= obj.segments{i}.numP)
            continue;
        else
            Uin = zeros(1,2);
            Uout = zeros(1,2);
            S = zeros(1,2);
            
            x0 = obj.segments{i}.dat{1}.X(1);
            x1 = obj.segments{i}.dat{1}.X(2);
            xy = [xy;[x0 x1]];
            for j = 2:obj.segments{i}.numP
               %...
                x0 = obj.segments{i}.dat{j}.X(1);
                x1 = obj.segments{i}.dat{j}.X(2);
                xy = [xy;[x0 x1]];                
%                 tempval = [];
%                 for f = 1:numflds
%                     fldind = obj.find(obj.pSpecs{f}.Field.NAME) + 1;
%                     tempval(fldind) = obj.segments{i}.dat{j}.flds(fldind);
%                 end
%                 val = [val;tempval];
                xysz = size(xy,1);
                lt = sqrt(sum((xy(xysz,:) - xy(xysz-1,:)).^2));
                Lt = Lt + lt;
                aU0in = (obj.segments{i}.dat{j}.flds(uin0) + obj.segments{i}.dat{j-1}.flds(uin0))/2.0 * lt;
                aU1in = (obj.segments{i}.dat{j}.flds(uin1) + obj.segments{i}.dat{j-1}.flds(uin1))/2.0 * lt;
                aU0out = (obj.segments{i}.dat{j}.flds(uout0) + obj.segments{i}.dat{j-1}.flds(uout0))/2.0 * lt;
                aU1out = (obj.segments{i}.dat{j}.flds(uout1) + obj.segments{i}.dat{j-1}.flds(uout1))/2.0 * lt;
                aS0 = (obj.segments{i}.dat{j}.flds(s0) + obj.segments{i}.dat{j-1}.flds(s0))/2.0 * lt;
                aS1 = (obj.segments{i}.dat{j}.flds(s1) + obj.segments{i}.dat{j-1}.flds(s1))/2.0 * lt;
                
                Uin = Uin + [aU0in,aU1in];
                Uout = Uout + [aU0out,aU1out];
                S = S + [aS0,aS1];
%                Uin01out01 = [Uin01out01;Uin Uout];
%                P01 = [P01; S];
               %...
            end
            %...
%                    Uin01out01 = cell2mat(Uin01out01);

            bdryPos =  whichBoundary(obj,xy);
            if bdryPos == NULL
                THROW('line segments are not boundary segments')
            else
                if bdryPos == NB || bdryPos == SB
                    P_U{bdryPos}.P = P_U{bdryPos}.P + S(2);
                    P_U{bdryPos}.U = P_U{bdryPos}.U + Uin(2);
                    P_U{bdryPos}.L = P_U{bdryPos}.L + Lt;
                elseif bdryPos == EB || bdryPos == WB
                    P_U{bdryPos}.P = P_U{bdryPos}.P + S(1);
                    P_U{bdryPos}.U = P_U{bdryPos}.U + Uin(1);
                    P_U{bdryPos}.L = P_U{bdryPos}.L + Lt;
                end
            end
        end
    end 
    
%     if (P_U{EB}.P ~= P_U{WB}.P)
%         fprintf(1,'WARNING: Left boundary and right boundary average load not equal.\n');
%     end
%     if (P_U{NB}.P ~= P_U{SB}.P)
%         fprintf(1,'WARNING: Top boundary and bottom boundary average load not equal.\n');
%     end
    
    Pout(1) = P_U{EB}.P / P_U{EB}.L;
    Pout(2) = P_U{NB}.P / P_U{NB}.L;
    deltaUout(1) = (P_U{EB}.U / P_U{EB}.L)-(P_U{WB}.U / P_U{WB}.L);
    deltaUout(2) = (P_U{NB}.U / P_U{NB}.L)-(P_U{SB}.U / P_U{SB}.L);   
end

function POSITION = whichBoundary(obj,nXY)
global NULL; NULL = 0;
global NB; NB = 1; 
global SB; SB = 2; 
global EB; EB = 3; 
global WB; WB = 4;
global NUMBDRY; NUMBDRY = 4;

    POSITION = NULL;
    if (nXY(1,1) == nXY(end,1)) %VERTICAL BOUNDARY
        if obj.domainBdryLimitsActive == 1
            if nXY(1,1) == obj.spaceLimits(1,1) % LEFT BOUNDARY
                POSITION = WB;
            elseif nXY(1,1) == obj.spaceLimits(1,2) % RIGHT BOUNDARY            
                POSITION = EB;
            end
        else
            if nXY(1,1) <= obj.spaceLimits(1,1) % LEFT BOUNDARY
                POSITION = WB;
            elseif nXY(1,1) >= obj.spaceLimits(1,2) % RIGHT BOUNDARY            
                POSITION = EB;
            end
        end
    elseif (nXY(1,2) == nXY(end,2)) %HORIZONTAL BOUNDARY
        if obj.domainBdryLimitsActive == 1
            if nXY(1,2) == obj.spaceLimits(2,1) % BOTTOM BOUNDARY
                POSITION = SB;
            elseif nXY(1,2) == obj.spaceLimits(2,2) % TOP BOUNDARY            
                POSITION = NB;
            end
        else
            if nXY(1,2) <= obj.spaceLimits(2,1) % BOTTOM BOUNDARY
                POSITION = SB;
            elseif nXY(1,2) >= obj.spaceLimits(2,2) % TOP BOUNDARY            
                POSITION = NB;
            end
        end
    end
end


