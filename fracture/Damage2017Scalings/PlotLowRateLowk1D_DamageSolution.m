function PlotLowRateLowk1D_DamageSolution(c, normalized)
if (nargin < 1)
    c = 0.8;
end
if (nargin < 2)
    normalized = 1;
end
if (nargin < 1)
    normalized = 1;
end
lfs = 27;
afs = 30;
fldr = 'LowRateLowk';
[status,msg,msgID] = mkdir(fldr);
fldrBase = fldr;
if (normalized == 1)
    fldr = [fldr, '/Normalized'];
else
    fldr = [fldr, '/NonNormalized'];
end
[status,msg,msgID] = mkdir(fldr);
root = [fldr, '/', fldrBase];
%ssym = '{\mathbf{s}}';
vsym = '{\mathbf{v}}';
sigMx = '\check{';
%D1 = '\hat{';
rsym = ['r^', vsym];



%log10rs = [-1, -2, -3, -4, -5, -6];
log10rs = [-2, -3, -4, -5, -6];
log10eps = - log10rs;
log10ks = [-4, -3, -2, -1];

rs = power(10, log10rs);

numk = length(log10ks);
numrs = length(log10rs);

rsym = 'r';
%tp = t / tau_v
% y = tp 0 c/r
ySymbol = 'y';
zSymbol = 'z';
tpSymbol = '{t^\prime}';


D1tauPrime = getLatexName('\tau', 1, 'v', normalized);
D1tauApproxPrime = getLatexName('{\tau_a}', 1, 'v', normalized);
D1yPrime = getLatexName(ySymbol, 1, 'v', normalized);
D1yApproxPrime = getLatexName(['{', ySymbol, '_a}'], 1, 'v', normalized);
D1zPrime = getLatexName(zSymbol, 1, 'v', normalized);
D1zApproxPrime = getLatexName(['{', zSymbol, '_a}'], 1, 'v', normalized);
D1deluPrime = getLatexName('u', 1, 'v', normalized);
D1deluPrime = ['\Delta ', D1deluPrime];
sigMxtauPrime = getLatexName('\tau', 0, 'v', normalized);
sigMxyPrime = getLatexName(ySymbol, 0, 'v', normalized);
sigMxzPrime = getLatexName(zSymbol, 0, 'v', normalized);
sigMxdeluPrime = getLatexName('u', 0, 'v', normalized);
sigMxdeluPrime = ['\Delta ', sigMxdeluPrime];
D1phiPrime = getLatexName('\phi', 1, 'v', normalized);
sigMxsigPrime = getLatexName('s', 0, 'none', normalized);


%yDeq1Trial
pos = 1;
names{pos} = D1yApproxPrime;
if (normalized == 0)
    names{pos} = [D1yApproxPrime, '/', ySymbol, '^', vsym];
end
%yDeq1
pos = pos + 1;
names{pos} = D1yPrime;
if (normalized == 0)
    names{pos} = [D1yPrime, '/', ySymbol, '^', vsym];
end

pos = pos + 1;
%zDeq1 * sqrt(r)
names{pos} = [D1zPrime, '\!', '\sqrt{', rsym ,'}'];
if (normalized == 0)
    names{pos} = [D1zPrime, '/', zSymbol, '^', vsym];
end

pos = pos + 1;
%tprDeq1 =  r * tp
names{pos} = [D1tauPrime, '\!\!', rsym];
if (normalized == 0)
    names{pos} = [D1yPrime, '/', '\tau', '^', vsym];
end

%%%%%%%%
pos = pos + 1;
%deltauDeq1
names{pos} = D1deluPrime;
if (normalized == 0)
    names{pos} = [names{pos}, '/{\tilde{u}}^', vsym];
end

%%%%%%%%
%ysigM
pos = pos + 1;
names{pos} = sigMxyPrime;
if (normalized == 0)
    names{pos} = [sigMxyPrime, '/', ySymbol, '^', vsym];
end

pos = pos + 1;
%zsigMx * sqrt(r)
names{pos} = [sigMxzPrime, '\!', '\sqrt{', rsym ,'}'];
if (normalized == 0)
    names{pos} = [sigMxzPrime, '/', zSymbol, '^', vsym];
end

pos = pos + 1;
%tpsigMx =  r * tp
names{pos} = [sigMxtauPrime, '\!\!', rsym];
if (normalized == 0)
    names{pos} = [sigMxtauPrime, '/', '\tau', '^', vsym];
end
%%%%%%%%%%%%%%%%%

pos = pos + 1;
%DsigmaMax
names{pos} = [sigMx, 'D}'];

pos = pos + 1;
%sigmaMax
names{pos} = sigMxsigPrime;
if (normalized == 0)
    names{pos} = [names{pos}, '/\bar{s}'];
end

%phi
pos = pos + 1;
%sigmaMax
names{pos} = D1phiPrime; %, '\!', '/\sqrt{', rsym ,'}'];
if (normalized == 0)
    names{pos} = [names{pos}, '/{\tilde{\phi}}^', vsym];
end

pos = pos + 1;
%ysigmaMax2yDeq1
names{pos} = [sigMxyPrime, '/', D1yPrime];

lastPos = pos;

for i = 1:numk
    k = power(10, log10ks(i));
    for j = 1:numrs
        r = power(10, log10rs(j));
        [yDeq1Trial, zDeq1, tpDeq1, yDeq1, tprDeq1, deltauDeq1, zsigmaMax, tpsigmaMax, ysigmaMax, tprsigmaMax, DsigmaMax, sigmaMax, ysigmaMax2yDeq1, phiDeq1] = ComputeLowRateLowk1D_DamageSolution(k, r, c);

        pos = 1;
        val{pos, i}(j) = yDeq1Trial;
        pos = pos + 1;
        val{pos, i}(j) = yDeq1;

        pos = pos + 1;
        val{pos, i}(j) = zDeq1 * sqrt(r);

%        pos = pos + 1;
%        val{pos, i}(j) = tpDeq1 * r;

        pos = pos + 1;
        val{pos, i}(j) = tprDeq1;

%%%%%%%%
        pos = pos + 1;
        val{pos, i}(j) = deltauDeq1;

%%%%%%%%
        pos = pos + 1;
        val{pos, i}(j) = ysigmaMax;
        
        pos = pos + 1;
        val{pos, i}(j) = zsigmaMax * sqrt(r);

%        pos = pos + 1;
%        val{pos, i}(j) = tpsigmaMax * r;

        pos = pos + 1;
        val{pos, i}(j) = tprsigmaMax;

%%%%%%%%
        pos = pos + 1;
        val{pos, i}(j) = DsigmaMax;
        
        pos = pos + 1;
        val{pos, i}(j) = sigmaMax;

        pos = pos + 1;
        val{pos, i}(j) = phiDeq1;
        
        pos = pos + 1;
        val{pos, i}(j) = ysigmaMax2yDeq1;
    end
end
    

%color
clrs = {'k', 'r', 'b', 'm', 'c', 'g', 'y'};
styles = {'-', '-', '-', '-', '-', '-'};

%black/white
clrs = {'k', [0.7, 0.7, 0.7], 'k', 'k', 'k', 'g', 'y'};
styles = {'-', '-', '--', '-.', ':', '-'};


leg{1} = '$$ \log(k) $$';
for i = 1:numk
    leg{i + 1} = ['$$ ', num2str(log10ks(i)),' $$'];
end

for pos = 1:lastPos
    figure(pos);
    clf;
    plot([nan], [nan], 'Color', 'w');
    hold on;
    pos
    for i = 1:numk
        plot(log10eps, val{pos, i}, 'Color', clrs{i}, 'LineStyle', styles{i}, 'Linewidth', 2);
        hold on;
    end
    set(gca, 'FontSize', 20);
    yh = get(gca, 'YLabel');
    labelOut = ['$$ ', names{pos}, ' $$'];
    set(yh, 'String', labelOut, 'FontSize', afs, 'VerticalAlignment','Bottom', 'Interpreter', 'latex');
    xh = get(gca, 'XLabel');
    labelOut = ['$$ \log(1/', rsym, ') $$'];
    set(xh, 'String', labelOut, 'FontSize', afs, 'VerticalAlignment','Top', 'Interpreter', 'latex');
   
    legend(leg, 'Location', 'NorthOutside', 'FontSize', lfs, 'Orientation', 'horizontal', 'Interpreter', 'latex');
    legend('boxoff');
    
    pngName = [root, num2str(pos), '.png'];
    saveName = [root, num2str(pos), '.fig'];
    print('-dpng', pngName);
    savefig(saveName);
end
close('all');