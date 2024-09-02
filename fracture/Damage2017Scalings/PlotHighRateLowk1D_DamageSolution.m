function PlotHighRateLowk1D_DamageSolution(normalized)
if (nargin < 1)
    normalized = 1;
end
lfs = 27;
afs = 30;
fldr = 'HighRateLowk';
[status,msg,msgID] = mkdir(fldr);
fldrBase = fldr;
if (normalized == 1)
    fldr = [fldr, '/Normalized'];
else
    fldr = [fldr, '/NonNormalized'];
end
vsym = '{\mathbf{v}}';
sigMx = '\check{';
%D1 = '\hat{';
rsym = ['r^', vsym];

[status,msg,msgID] = mkdir(fldr);
root = [fldr, '/', fldrBase];
log10ks = [-4, -3, -2, -1, 0, 1];
log10rs = [0, 1, 2, 3, 4, 5, 6];
log10eps = - log10rs;
log10ks = [-4, -3, -2, -1, 0];
log10ks = [-4, -3, -2, -1];

rs = power(10, log10rs);

numk = length(log10ks);
numrs = length(log10rs);


D1tauPrime = getLatexName('\tau', 1, 'v', normalized);
D1tauApproxPrime = getLatexName('{\tau_a}', 1, 'v', normalized);
D1deluPrime = getLatexName('u', 1, 'v', normalized);
D1deluPrime = ['\Delta ', D1deluPrime];
sigMxtauPrime = getLatexName('\tau', 0, 'v', normalized);
sigMxdeluPrime = getLatexName('u', 0, 'v', normalized);
sigMxdeluPrime = ['\Delta ', sigMxdeluPrime];
D1phiPrime = getLatexName('\phi', 1, 'v', normalized);
sigMxsigPrime = getLatexName('s', 0, 'none', normalized);


%zDeq1Trial
pos = 1;
names{pos} = [D1tauApproxPrime, '\sqrt{', rsym ,'}'];
if (normalized == 0)
    names{pos} = [names{pos}, '/\tau^', vsym];
end

pos = pos + 1;
%zDeq1
names{pos} = [D1tauPrime, '\sqrt{', rsym ,'}'];
if (normalized == 0)
    names{pos} = [names{pos}, '/\tau^', vsym];
end
pos = pos + 1;
%deltauDeq1
names{pos} = D1deluPrime;
if (normalized == 0)
    names{pos} = [names{pos}, '/{\tilde{u}}^', vsym];
end

pos = pos + 1;
%%%%zsigmaMaxTrial
%zsigmaMax
names{pos} = [sigMxtauPrime, '\sqrt{', rsym ,'}'];
if (normalized == 0)
    names{pos} = [names{pos}, '/\tau^', vsym];
end

pos = pos + 1;
%DsigmaMax
names{pos} = [sigMx, 'D}'];

pos = pos + 1;
%sigmaMax
names{pos} = [sigMxsigPrime, '/\sqrt{', rsym ,'}'];
if (normalized == 0)
    names{pos} = [names{pos}, '/\bar{s}'];
end

%phi
pos = pos + 1;
%sigmaMax
names{pos} = [D1phiPrime, '/\sqrt{', rsym ,'}'];
if (normalized == 0)
    names{pos} = [names{pos}, '/{\tilde{\phi}}^', vsym];
end


pos = pos + 1;
%tauMaxsigma/tauDeq1
names{pos} = [sigMxtauPrime, '/', D1tauPrime];

lastPos = pos;

for i = 1:numk
    k = power(10, log10ks(i));
    for j = 1:numrs
    eps = power(10, log10eps(j));
    [zDeq1Trial, zDeq1, deltauDeq1, zsigmaMaxTrial, zsigmaMax, DsigmaMax, sigmaMax, phiDeq1] = ComputeHighRateLowk1D_DamageSolution(k, eps);
    pos = 1;
    val{pos, i}(j) = zDeq1Trial;
    pos = pos + 1;
    val{pos, i}(j) = zDeq1;
    pos = pos + 1;
    val{pos, i}(j) = deltauDeq1;
    pos = pos + 1;
    val{pos, i}(j) = zsigmaMax;
    pos = pos + 1;
    val{pos, i}(j) = DsigmaMax;
    pos = pos + 1;
    val{pos, i}(j) = sigmaMax;
    pos = pos + 1;
    val{pos, i}(j) = phiDeq1;
    pos = pos + 1;
    val{pos, i}(j) = zsigmaMax / zDeq1;
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
    for i = 1:numk
        plot(log10rs, val{pos, i}, 'Color', clrs{i}, 'LineStyle', styles{i}, 'Linewidth', 2);
        hold on;
    end
    set(gca, 'FontSize', 20);
    yh = get(gca, 'YLabel');
    labelOut = ['$$ ', names{pos}, ' $$'];
    set(yh, 'String', labelOut, 'FontSize', afs, 'VerticalAlignment','Bottom', 'Interpreter', 'latex');
    xh = get(gca, 'XLabel');
    labelOut = ['$$ \log(', rsym, ') $$'];
    set(xh, 'String', labelOut, 'FontSize', afs, 'VerticalAlignment','Top', 'Interpreter', 'latex');
   
    legend(leg, 'Location', 'NorthOutside', 'FontSize', lfs, 'Orientation', 'horizontal', 'Interpreter', 'latex');
    legend('boxoff');
    
    pngName = [root, num2str(pos), '.png'];
    saveName = [root, num2str(pos), '.fig'];
    print('-dpng', pngName);
    savefig(saveName);
end
close('all');