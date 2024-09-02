function nameOut = getLatexName(nameIn, usePrime4normalized, forceDroppingDir, forceScaleOpt)
num = str2num(nameIn);
if (length(num) > 0)
    if (num == 222)
        nameOut = '$$\infty$$';
    else
        nameOut = ['$$', nameIn, '$$'];
    end
    return;
end

if (nameIn(1) == '$')
    nameOut = nameIn;
    return;
end

% use prime for normalized value, eg, delta' = delta / delta(tilde)
if (nargin < 2)
    usePrime4normalized = 0;
end

if (nargin < 3)
    forceDroppingDir = 0;
end

% forces scale option to be s (1), or v(2)
if (nargin < 4)
    forceScaleOpt = 1;
end


jumpst = '[\![';
jumpen = ']\!]';
%dirss = '^';
%normss = '_';
%ssym = 's';
%vsym = 'v';

dirss = '_';
normss = '^';
ssym = '{\mathbf{s}}';
vsym = '{\mathbf{v}}';

dirn = '{\mathrm n}';
dirt = '{\mathrm t}';

denom = '';

szn = length(nameIn);
if ((szn > 2) && (strncmp(nameIn, 'OC', 2) == 1))
    nameIn = nameIn(3:end);
    cr = 0;
    if (nameIn(1) == 'k')
        if (nameIn(2) == '=')
            nameIn = nameIn(3:end);
            cr = 1;
        end
    end
    if (cr == 0)
        fprintf(1, 'cannot operate on %s\n', nameIn);
    end
    num = str2num(nameIn);
    if (length(num) > 0)
        v = log10(num);
        v = round(v);
        vs = num2str(v);
    else
        vs = nameIn;
    end
    nameOut = ['$$', vs, '$$'];
    return;
end

C = strsplit(nameIn,'#');
if (length(C) > 2)
    fp = C{2};
    sp = C{3};
    
    normSym = '';
    normalizationMode = 0; % none
    if (fp(end) == 'n')
        normSym = ssym;
        normalizationMode = 1; % stress-based
        fp = fp(1:end - 1);
        pp = '\prime';
    elseif (fp(end) == 'k')
        normSym = vsym;
        normalizationMode = 2; % velocity-based
        fp = fp(1:end - 1);
        pp = '{\prime\prime}';
    end
    
    dir = '';
    dirSet = 0;
    if (fp(end) == '0')
        dir = dirn;
        fp = fp(1:end - 1);
        dirSet = 1;
    elseif (fp(end) == '1')
        dir = dirt;
        fp = fp(1:end - 1);
        dirSet = 2;
    end

    if (forceDroppingDir == 1)
        dirSet = 0;
        dir = '';
    end

    dirSetNorm = dirSet;
    dirNorm = dir;
    
    if (sp(1) == '_')
        sp = sp(2:end);
    end
    ptType = -1;    % 1 critical, 2 final
    ptSym = '';
    if (strcmp(sp, 'c') == 1)
        ptSym = ['{\check{'];
        ptType = 1;
    elseif (strcmp(sp, 'f') == 1)
%       2017/09        
%        ptSym = ['{\breve{'];
        ptSym = ['{\hat{'];
        ptType = 2;
    else
        ptSym = ['{\hat{'];
        ptType = 0;
    end
    
    useJump = 0;
    symfp = '';
    if (strcmp(fp, 'time') == 1)
        symfp = '\tau';
        if ((forceDroppingDir == 0) && (dirSet == 0))
            dirNorm = dirn;
            dirSetNorm = 1;
        end            
    elseif (strcmp(fp, 'du') == 1)
        useJump = 1;
        symfp = 'u';
    elseif (strcmp(fp, 's') == 1)
%        symfp = '\sigma';
        symfp = 's';
    elseif (strcmp(fp, 'e') == 1)
        symfp = '\phi';
    elseif (strcmp(fp, 'Dsu-rel') == 1)
        symfp = [ptSym, 'D', '}}'];
        sym = [symfp, '_', ssym];
    	ptType = -1;
        normalizationMode = 0;
        dirSet = 0;
    elseif ((strcmp(fp, 'Dv-rel') == 1) || (strcmp(fp, 'Dsv-rel') == 1))
        symfp = [ptSym, 'D', '}}'];
        sym = [symfp, '_', vsym];
    	ptType = -1;
        normalizationMode = 0;
        dirSet = 0;
    elseif (strcmp(fp, 'sigmaRatio') == 1)
        symfp = '{\varsigma}';
        normalizationMode = 0;
        dirSet = 0;
    else
        fprintf(1, 'cannot find name for fp = %s\n', fp);
        fp(100);
    end
    if (ptType >= 0)
        sym = [ptSym, symfp, '}}'];
    end
    
    symn = sym;
    if ((normalizationMode ~= 0) && (usePrime4normalized == 1))
        symn = ['{', symfp, '^', pp, '}'];
    end
    
    if (normalizationMode == 0) % nonnormalized
        if (dirSet == 0)
            nameOut = sym;
        else
            nameOut = [sym, dirss, dir];
        end
    else %if (normalizationMode > 0)
        normOpt = [normss, normSym];
        scaleOperator = '\tilde';
        if ((strcmp(symfp, '\sigma') == 1) || (strcmp(symfp, 's') == 1))
            normOpt = '';
            scaleOperator = '\bar';
        end
        if (dirSet == 0)
            nameOut = [symn]; %, normss, normSym];
            if (dirSetNorm == 0)
                denom = ['{', scaleOperator, '{', symfp,'}}', normOpt];
            else
                denom = ['{', scaleOperator, '{', symfp,'}}', normOpt, dirss, dirNorm];
            end
        else
            nameOut = [symn, dirss, dir]; %normss, normSym, dirss, dir];
            denom = ['{', scaleOperator, '{', symfp,'}}', normOpt, dirss, dir];
        end
    end
    
    if ((usePrime4normalized == 0) && (normalizationMode ~= 0))
        nameOut = [nameOut, '/', denom];
    end
    nameOut = ['$$', nameOut, '$$'];    
    return; 
end

wdot = ((strcmp(nameIn, 'w0dot*tau0') == 1) || (strcmp(nameIn, 'w0dot*taus0') == 1));
lwdot = ((strcmp(nameIn, 'log(w0dot*tau0)') == 1) || (strcmp(nameIn, 'log(w0dot*taus0)') == 1));
wdotv = (strcmp(nameIn, 'w0dot*tauv0') == 1);
lwdotv = (strcmp(nameIn, 'log(w0dot*tauv0)') == 1);
dirSet = 1;
dir = dirn;
if (forceDroppingDir == 1)
    dirSet = 0;
end

if (wdotv || lwdotv)
    % velocity scale
    forceScaleOpt = 2;
elseif (forceScaleOpt ~= 2)
    if (wdot || lwdot)
        forceScaleOpt = 1;
    end
end


load = '{\bar{\omega}}';
%2017/09
useAbbreviatedWdot = 1; % use r instead of wDot
if (useAbbreviatedWdot)
    if (forceScaleOpt == 1)
        if (wdotv)
            wdotv = 0;
            wdot = 1;
        elseif (lwdotv)
            lwdotv = 0;
            lwdot = 1;
        end
    elseif (forceScaleOpt == 2)
        if (wdot)
            wdot = 0;
            wdotv = 1;
        elseif (lwdot)
            lwdot = 0;
            lwdotv = 1;
        end
    end
end
if (wdot || lwdot || wdotv || lwdotv)
    tau = '\tau';
    if (forceScaleOpt == 1)
        tau = [tau, normss, ssym];
    elseif (forceScaleOpt == 2)
        tau = [tau, normss, vsym];
    end
    if (dirSet ~= 0)
        tau = [tau, dirss, dir];
    end
    ldot = ['\dot{', load,'}'];
    if (dirSet ~= 0)
        ldot = [ldot, dirss, dir];
    end
    nameOut = [ldot, tau];
    nameOut = [nameOut, ' / \bar{s}'];

    %%2017/09
    if (useAbbreviatedWdot == 1)
        if (wdot || lwdot)
            nameOut = ['r', normss, ssym];
        else
            nameOut = ['r', normss, vsym];
        end
    end    
    if (lwdot|| lwdotv)
        nameOut = ['\log(', nameOut, ')'];
    end
    nameOut = ['$$', nameOut, '$$']; 
    return;
end

ksym = 'k';
if (strcmp(nameIn, 'k') == 1)
    nameOut = ksym;
    nameOut = ['$$', nameOut, '$$']; 
    return;
elseif (strcmp(nameIn, 'k0') == 1)
    if (forceDroppingDir)
        nameOut = ksym;
    else
        nameOut = [ksym, dirss, dirn];
    end
    nameOut = ['$$', nameOut, '$$']; 
    return;
elseif (strcmp(nameIn, 'log(k)') == 1)
    nameOut = ['\log(', ksym, ')'];
    nameOut = ['$$', nameOut, '$$']; 
    return;
elseif (strcmp(nameIn, 'log(k0)') == 1)
    if (forceDroppingDir)
        nameOut = ['\log(', ksym, ')'];
    else
        nameOut = ['\log(', ksym, dirss, dirn, ')'];
    end
    nameOut = ['$$', nameOut, '$$']; 
    return;
end
if ((strcmp(nameIn, 'wM') == 1) || (strcmp(nameIn, 'wM0') == 1))
%2017/09    
%    nameOut = [load, '_M'];
    nameOut = [load, ' / \bar{s}'];
    nameOut = ['$$', nameOut, '$$']; 
    return;
end

if (strcmp(nameIn, 't_r0') == 1)
    nameOut = 't_r';
    nameOut = ['$$', nameOut, '$$']; 
    return;
elseif (strcmp(nameIn, 't_r0') == 1)
    if (forceDroppingDir)
        nameOut = 't_r';
    else
        nameOut = 't_r';
    end
    nameOut = ['$$', nameOut, '$$']; 
    return;
end

normSym = '';
normalizationMode = 0; % none
if (nameIn(end) == 'n')
    normSym = ssym;
    normalizationMode = 1; % stress-based
    nameIn = nameIn(1:end - 1);
    pp = '\prime';
elseif (nameIn(end) == 'k')
    normSym = vsym;
    normalizationMode = 2; % velocity-based
    nameIn = nameIn(1:end - 1);
    pp = '{\prime\prime}';
end


dir = 'none';    % no direction
dirSet = 0;
if (nameIn(end) == '0')
    dir = dirn;
    nameIn = nameIn(1:end - 1);
    dirSet = 1;
elseif (nameIn(end) == '1')
    dir = dirt;
    nameIn = nameIn(1:end - 1);
    dirSet = 2;
end

if (forceDroppingDir == 1)
    dirSet = 0;
    dir = '';
end

nameBase = 'none';
if (strcmp(nameIn, 'time') == 1)
    nameBase = 't';
    dirSet = 0;
    if (normalizationMode == 1)
       nameBase = ['t/\tau', normss, ssym];
    elseif (normalizationMode == 2)
       nameBase = ['t/\tau', normss, vsym];
    end
    normalizationMode = 0;
elseif (strcmp(nameIn, 'du') == 1)
    nameBase = 'u';
elseif (strcmp(nameIn, 's') == 1)
%    nameBase = '\sigma';
    nameBase = 's';
elseif (strcmp(nameIn, 'dv') == 1)
    nameBase = 'v';
elseif (strcmp(nameIn, 'e') == 1)
    nameBase = '\phi';
elseif (strcmp(nameIn, 'w') == 1)
    nameBase = '\omega';
elseif (strcmp(nameIn, 'D') == 1)
    nameBase = 'D';
    dirSet = 0;
    normalizationMode = 0;
elseif (strcmp(nameIn, 'Ddot') == 1)
    nameBase = '\dot{D}';
    dirSet = 0;
    if (normalizationMode == 1)
       nameBase = [nameBase, '\tau', normss, ssym];
    elseif (normalizationMode == 2)
       nameBase = [nameBase, '\tau', normss, vsym];
    end
    normalizationMode = 0;
elseif (strcmp(nameIn, 'fy') == 1)
    nameBase = '{f_y}';
    dirSet = 0;
    normalizationMode = 0;
elseif (strcmp(nameIn, 'DUC') == 1)
    nameBase = '{D_\mathrm{uc}}';
    normalizationMode = 0;
    dirSet = 0;
elseif (strcmp(nameIn, 'Dsu') == 1)
    nameBase = ['D', normss, ssym];
    normalizationMode = 0;
    dirSet = 0;
elseif (strcmp(nameIn, 'Dv') == 1)
    nameBase = ['D', normss, vsym];
    normalizationMode = 0;
    dirSet = 0;
elseif (strcmp(nameIn, 'Dsu2Dtol') == 1)
    nameBase = ['D', normss, ssym, '/D'];
    normalizationMode = 0;
    dirSet = 0;
elseif (strcmp(nameIn, 'Dv2Dtol') == 1)
    nameBase = ['D', normss, vsym, '/D'];
    normalizationMode = 0;
    dirSet = 0;
end

if (strcmp(nameBase, 'none') == 0)
    sym = nameBase;
    symn = sym;
    if ((normalizationMode ~= 0) && (usePrime4normalized == 1))
        symn = ['{', sym, '^', pp, '}'];
    end
else
    nameOut = nameIn;
    return;
%    printf(1', 'invalid nameBase %s\n', nameBase);
end

if (normalizationMode == 0) % nonnormalized
    if (dirSet == 0)
        nameOut = sym;
    else
        nameOut = [sym, dirss, dir];
    end
else %if (normalizationMode > 0)
    nameOut = [symn]; %, normss, normSym];
    normOpt = [normss, normSym];
    scaleOperator = '\tilde';
    if ((strcmp(sym, '\sigma') == 1) || (strcmp(sym, 's') == 1))
        normOpt = '';
        scaleOperator = '\bar';
    end
    if (dirSet == 0)
        denom = ['{', scaleOperator, '{', sym,'}}', normOpt];
    else
        nameOut = [symn, dirss, dir]; %normss, normSym, dirss, dir];
        denom = ['{', scaleOperator, '{', sym,'}}', normOpt, dirss, dir];
    end
end

if ((strcmp(nameIn, 'du') == 1) || (strcmp(nameIn, 'dv') == 1))
%2017/09    
%    nameOut = [jumpst, nameOut, jumpen];
    nameOut = ['\Delta ', nameOut];
end

if ((usePrime4normalized == 0) && (normalizationMode ~= 0))
    nameOut = [nameOut, '/', denom];
end

nameOut = ['$$', nameOut, '$$'];