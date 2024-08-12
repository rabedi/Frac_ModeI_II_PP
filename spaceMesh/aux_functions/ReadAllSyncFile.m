function [fc, numfc, folder, syncDatName, syncStatName, runName, phy, midName, sn, timeMinI] = ReadAllSyncFile(frontAllPath, frontFileName, addedParas, ignoreMinConstraints)

if (nargin < 3)
    addedParas = gen_map;
end

if (nargin < 4)
    ignoreMinConstraints = 1;
end

if (~ignoreMinConstraints)
    [serialMin, validsMin] = addedParas.AccessNumber('serialMin');
else
    validsMin = 0;
end
    
[serialMax, validsMax] = addedParas.AccessNumber('serialMax');
if (~validsMax)
    serialMax = -1;
end

[timeMax, validTimeMax] = addedParas.AccessNumber('timeMax');
if (~validTimeMax)
    timeMax = -1;
end

fid = fopen(fullfile(frontAllPath,[frontFileName,'.all']),'r');
if fid < 1
   msg = sprintf('File [%s] not open for read.\n',fullfile(frontAllPath,[frontFileName,'.all'])); 
   THROW(msg);
end
fclose(fid);

folder = 2;
runName = 4;
phy = 6;
midName = 8;
sn = 10;
syncDatName = 15;
syncStatName = 17;
cLength = 29;

timeMinI = 21;

impDat = importdata(fullfile(frontAllPath,[frontFileName,'.all']));
fc = impDat.textdata;
[numfc, c0] = size(fc);

st = 0;
en = numfc - 1;

changeMin = 0;
if (validsMin)
    if (serialMin <= en)
        st = serialMin;
        changeMin = 1;
    else
        setrialMin
        en
        THROW('seiralMin not less than equal en\n');
    end
end

changeMax = 0;
if (validsMax)
    if ((serialMax <= en) || (serialMax >= 0))
        en = serialMax;
        changeMax = 1;
    end
end


if (validTimeMax)
    runTimeMax = str2num(fc{numfc,timeMinI});
    tol = 1e-5 * runTimeMax;
    enTmp = en;
    for i = st:enTmp
        s = i + 1;
        tm = str2num(fc{s,timeMinI});
        if (tm  - timeMax > tol)
            en = i - 1;
            if (en == -1)
                timeMax
                runTimeMax
                THROW('timeMax (requested time) is so small that it is larger than all run time values. FYI time max of run is runTimeMax\n');
            end
            changeMax = 1;
            break;
        end
    end
    en = min(en, enTmp);
end

if (changeMax || changeMin)
    fcTmp = fc;
    [r0, c0] = size(fc);
    fc = cell(en - st + 1, c0);
    for ri = st:en
        s = ri + 1;
        for ci = 1:c0
            fc{ri - st + 1, ci} = fcTmp{s, ci};
        end
    end
    [r1, c1] = size(fc);
    numfc = r1;
end

if ((mod(numfc, 100) == 1) && (str2num(fc{numfc,cLength}) < str2num(fc{numfc - 1,cLength})))
    numfc = numfc - 1;
    [r, c] = size(fc);
    fc = fc(1:r - 1, 1:c);
end
% s = numfc;

% while (1 && (s > 0))
%     statFile = fullfile(frontAllPath,...
%         fc{s,folder},...
%         sprintf('%s%s%s%010d.%s',... 
%         fc{s,runName},...
%         fc{s,phy},...
%         fc{s,midName},...
%         str2double(fc{s,sn}),...
%         'stat'));
%     fidstat = fopen(statFile,'r');
%     acceptable = 0;
%    if (fidstat > 0)
%         while (~feof(fidstat))
%             buf = fscanf(fidstat, '%s', 1);
%             if (strcmp(buf, 'statThisFrontBrief') == 1)
%                 for i = 1:4
%                     buf = fscanf(fidstat, '%s', 1);
%                 end
%                 slved = fscanf(fidstat, '%d', 1);
%                 if (slved > 0)
%                     acceptable = 1;
%                 end
%             end
%         end
%         fclose(fidstat);
%    end
%    if (acceptable == 1)
%        break;
%    else
%        s = s - 1;
%        numfc = numfc - 1;
%    end
% end