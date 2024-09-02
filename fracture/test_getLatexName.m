function test_getLatexName(forceDroppingDir, usePrime4normalized)
if (nargin < 1)
    forceDroppingDir = 0;
end
if (nargin < 2)
    usePrime4normalized = 0;
end

v{1} = {'time',	'du0', 's0', 'dv0', 'e0', 'w0', 'D0', 'Ddot0', 'fy0', 'DUC0', 'Dsu0', 'Dv0', 'Dsu2Dtol0', 'Dv2Dtol0'};
sz = length(v{1});
for i = 1:sz
    v{2}{i} = [v{1}{i}, 'n'];
    v{3}{i} = [v{1}{i}, 'k'];
end
v{4} = {'k0', 'log(k0)', 't_r0', 'wM0', 'w0dot*tau0', 'w0dot*tauv0', 'log(w0dot*tau0)', 'log(w0dot*tauv0)'};


v{5} = {'#sigmaRatio#_c', '#time#_c', '#du0#_c', '#s0#_c', '#e0#_c', '#Dsu-rel0#_c', '#Dv-rel0#_c'};  
v{6} = {'#sigmaRation#_c', '#timen#_c', '#du0n#_c', '#s0n#_c', '#e0n#_c', '#Dsu-rel0n#_c', '#Dsv-rel0n#_c'};
v{7} = {'#sigmaRatiok#_c', '#timek#_c', '#du0k#_c', '#s0k#_c', '#e0k#_c', '#Dsu-rel0k#_c', '#Dsv-rel0k#_c'};

for r = 1:7
    sz = length(v{r});
    for ii = 1:sz
        name = v{r}{ii};
%        name(end) = 'f';
%        name = [name, '0.01'];
        nameOut = getLatexName(name, usePrime4normalized, forceDroppingDir);
        
        figure(1);
        plot([1:10], [1:10]);
        leg{1} = nameOut;
        legend(leg, 'FontSize', 20, 'Interpreter', 'latex');
        nm = ['plot_', num2str(r), '_', num2str(ii), '.png'];
        print('-dpng', nm);
    end
end
