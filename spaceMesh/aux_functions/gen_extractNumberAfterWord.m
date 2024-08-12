function [index, wordAfterSpecifier] = gen_extractNumberAfterWord(str, indexSpecifier)
index = nan;
sz = length(str);
szInd = length(indexSpecifier);
pos = strfind(str, indexSpecifier);
if (length(pos) == 0)
    return;
end
posStart = pos + szInd;
if (posStart <= sz)
    char = str(posStart);
    if (char == '_')
        posStart = posStart + 1;
    end
end
if (posStart > sz)
    return;
end
char = str(posStart);
if (strcmp(indexSpecifier, 'ind') == 1)
    if (char == 'n')
        index = 1;
        return;
    elseif ((char == 's') || (char == 't'))
        index = 2;
        return;
    end
end
wordAfterSpecifier = str(posStart:sz);
digitPos = isstrprop(wordAfterSpecifier, 'digit');
if (length(digitPos) == 0)
    return;
end
sz2 = length(digitPos);
numTmp = [];
for i = 1:sz2
    if (digitPos(i) == 1)
        numTmp = [numTmp, wordAfterSpecifier(i)];
    else
        break;
    end
end
if (length(numTmp) == 0)
    index = nan;
    return;
end
index = str2num(numTmp);
if (length(index) == 0)
    index = nan;
    return;
end
revWrd = ['rev', indexSpecifier];
if (contains(str, revWrd))
    index = -index;
end
