function nval = operateOnValBasedOnFlagValueData(val, flagValue, flagData)

if (iscell(flagData) == 0)
    flagDataBK = flagData;
    flagData = cell(1, 4);
    n = length(val);
    nvec = ones(1, n);
    for i = 1:4
        flagData{i} = flagDataBK(i) * ones(1, n);
    end
end

nval = val;
%if (flagValue(1) == 0)
%    return;
%end


% flag position 2:
% translation
% flagvalue(2) == 1                 nval = nval - flagData(2)
% flagvalue(2) == 2                 nval = nval + flagData(2)


if (flagValue(2) == 1)
    nval = nval - flagData{2};
elseif (flagValue(2) == 2)
    nval = nval + flagData{2};
end


% flag position 3:
% scaling
% flagvalue(3) == 1                 nval = nval / flagData{3}
% flagvalue(3) == 2                 nval = nval * flagData{3}


if (flagValue(3) == 1)
    nval = nval ./ flagData{3};
elseif (flagValue(3) == 2)
    nval = nval .* flagData{3};
elseif (flagValue(3) == 3)
    nval = nval ./ -flagData{3};
elseif (flagValue(3) == 4)
    nval = nval .* -flagData{3};
end

% flag position 4:
% log
% flagvalue(4) == 1                 nval = log(abs(nval)) Base  flagData{4}
% flagvalue(4) == 1                 nval = Sign(nval) log(abs(nval)) Base  flagData{4}



if (flagValue(4) == 1)
    nval = log(abs(nval)) ./ log(flagData{4});
elseif (flagValue(4) == 2)
    nval = sign(nval) .* (log(abs(nval)) ./ log(flagData{4}));
end
