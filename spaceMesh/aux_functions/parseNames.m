function [namePairs,normalizedBool] = parseNames(str)
parser = '|';
parserNorm = '||';

normalizedBool = 0;
found = strfind(str,parser);
foundN = strfind(str,parserNorm);
if isempty(found)
    namePairs = {str};
else
    if length(found) > 2
        msg = sprintf('name pairs should be concatenated a max of %i "%s" characters.',length(parserNorm),parser);
        THROW(msg);
    else
        v1 = [found found(end)+1];
        v2 = [found(1)-1 found];
        if ~(all((v1-v2)==1))
            msg = sprintf('covariance "%s" or correlations notation "%s" must be continuous with no whitespace.',parser, parserNorm);
            THROW(msg);
        end
        if found(1) == 1 || found(end) == length(str);
            msg = sprintf('two valid name pairs should be concatenated with covariance "%s" or correlations notation "%s" character.',parser, parserNorm);
            THROW(msg);
        end
        namePairs = cell(2,1);
        namePairs{1} = str(1:found(1)-1);
        namePairs{2} = str(found(end)+1:end);
    end
end
if ~isempty(foundN)
    normalizedBool = 1;
end
end