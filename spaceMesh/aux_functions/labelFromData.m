function [latexStr] = labelFromData(str, dataObj, field2Latex, useNameDirectly)
if nargin < 4
   useNameDirectly = 0; 
end

extfields = {'count','measure','serial','time'};
extString = {'n','L','serial','t'};

parser = '|';
parserNorm = '||';
covStr = 'cov';
corrStr = 'corr';

found = strfind(str,parser);
foundN = strfind(str,parserNorm);
if isempty(found)
    tmpInd = find(cellfun(@(x) strcmp(x,str),dataObj.names,'UniformOutput',true));
    tmpExt = find(cellfun(@(x) strcmp(x,str),extfields,'UniformOutput',true));
    [latexString,~] = field2Latex.find(str);
    
    if isempty(tmpInd) && isempty(tmpExt) && isempty(latexString)
        msg = sprintf('field{%s} not valid for plotting.',str);
        THROW(msg);
    elseif length(tmpInd) > 1
        THROW('field name conflict. consider renaming field to avoid name conflicts.');
    end
    if useNameDirectly == 1
        latexStr = str;
        return;
    end
    if ~isempty(tmpInd)
        latexStr = dataObj.fields{tmpInd}.latexString;
        %indices = [tmpInd(1)];
        return;
    elseif ~isempty(tmpExt)
        latexStr = extString{tmpExt};
        %indices = [];
        return;
    else
        latexStr = latexString;
        %indices = [];    
    end
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
        tmpInd1 = find(cellfun(@(x) strcmp(x,namePairs{1}),dataObj.names,'UniformOutput',true));
        tmpInd2 = find(cellfun(@(x) strcmp(x,namePairs{2}),dataObj.names,'UniformOutput',true));
        
        [latexString1,~] = field2Latex.find(namePairs{1});
        [latexString2,~] = field2Latex.find(namePairs{2});
        
        lhs = '';
        rhs = '';    
        if length(tmpInd1) > 1 || length(tmpInd2) > 1
            THROW('field name conflict. consider renaming field to avoid name conflicts.');
        end  
        
        if useNameDirectly == 1 && (~isempty(tmpInd1) || ~isempty(latexString1))
            lhs = namePairs{1};
        elseif ~isempty(tmpInd1)
            lhs = dataObj.fields{tmpInd1(1)}.latexString;
        elseif ~isempty(latexString1)
            lhs = latexString1;
        else
            msg = sprintf('field{%s} not valid for plotting.',namePairs{1});
            THROW(msg);
        end
        
        if useNameDirectly == 1 && (~isempty(tmpInd2) || ~isempty(latexString2))
            rhs = namePairs{2};
        elseif ~isempty(tmpInd2)
            rhs = dataObj.fields{tmpInd2(1)}.latexString;
        elseif ~isempty(latexString2)
            rhs = latexString2;
        else
            msg = sprintf('field{%s} not valid for plotting.',namePairs{2});
            THROW(msg);
        end 
        
        if ~isempty(foundN)
           latexStr = [corrStr,'(',lhs,',',rhs,')']; 
        else
           latexStr = [covStr,'(',lhs,',',rhs,')'];  
        end
        %indices = [tmpInd1,tmpInd2];        
    end
end

end