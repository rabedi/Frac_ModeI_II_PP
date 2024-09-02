function latexName = getLatexName(val, D1md, s, normalized)
sigMx = '\check';
D1 = '\hat';

if (D1md == 1)
    type = D1;
else
    type = sigMx;
end

symM = 0;
if (strcmp(s, 's') == 1) 
    sym = '{\mathbf{s}}';
    symM = 1;
elseif (strcmp(s, 'v') == 1) 
    sym = '{\mathbf{v}}';
    symM = 1;
end

latexName = ['{', type, ' ', val, '}'];
if (symM == 1)
    if (normalized)
        latexName = [latexName, '^{\prime^', sym, '}'];  
    else
        latexName = [latexName, '^', sym];  
    end
else
    if (normalized)
        latexName = [latexName, '^\prime'];  
%    else
%        latexName = latexName;  
    end
end
