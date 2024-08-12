function plotDistributions(nu, VscaleCR, VmaxCR, maxVValue, vresolution, resolution, E, rho, normalizeVbymu)

printExt = 'pdf';
printOption = ['-d',printExt];
[colorCode, colorName] = getColorMap();

if nargin < 2
    VscaleCR = 1;
end

if nargin < 3
    VmaxCR = 1;
end

if nargin < 4
    maxVValue = 0.85;
end

if nargin < 5
    vresolution = 0.1;
end
if nargin < 6
    resolution = 200;
end

if nargin < 7
    E = 1;
end

if nargin < 8
    rho = 1;
end

if nargin < 9
    normalizeVbymu = 0;
end

normalization2cs = ~VscaleCR;
[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);
if (VmaxCR == 1)
    vma = cr * maxVValue;
else
    vma = cs * maxVValue;
end
if (VscaleCR == 1)
    vm = vma / cr;
else
    vm = vma / cs;
end
v = 0:vresolution:vm;
numv = length(v);
if (v(numv) ~= vm)
    v(numv + 1) = vm;
    numv = numv + 1;
end

if (VscaleCR == 1)
    for nv = 1:numv
        if (v(nv) == 1)
            v(nv) = 0.5 * (v(nv) + v(nv - 1));
            break;
        end
    end
end

for nv = 1:numv
    leg{nv} = num2str(v(nv));
end
xlabel_ = 'teta';
ylabels = {'s11', 's22', 's12', 'stet', 'tautet', 'smax', 'smin', 'taumax', 'v1', 'v2', 'vs'};
numP = length(ylabels);
if (VscaleCR == 1)
    vsl = 'v2cR';
else
    vsl = 'v2cS';
end
prename = [num2str(nu), '__',vsl];
for p = 1:numP
    titles{p} = [ylabels{p},'_',prename];
    fileName{p} = [titles{p}, '.', printExt];
end
figs11 = figure(1);
figs22 = figure(2);
figs12 = figure(3);
figstet = figure(4);
figtautet = figure(5);
figsmax = figure(6);
figsmin = figure(7);
figtaumax = figure(8);
figv1 = figure(9);
figv2 = figure(10);
figvs = figure(11);

for nv = 1:numv
    [teta, s11, s22, s12, stet, tautet, smax, smin, taumax, v1, v2, vs] = getCrackTipFields(E, nu, rho, resolution, v(nv), normalization2cs, normalizeVbymu);
    tetaDegree = (180 / pi) * teta;
    figure(1);
    hold on;
    plot(tetaDegree, s11, 'Color', colorCode{nv});
    figure(2);
    hold on;
    plot(tetaDegree, s22, 'Color', colorCode{nv});
    figure(3);
    hold on;
    plot(tetaDegree, s12, 'Color', colorCode{nv});
    figure(4);
    hold on;
    plot(tetaDegree, stet, 'Color', colorCode{nv});
    figure(5);
    hold on;
    plot(tetaDegree, tautet, 'Color', colorCode{nv});
    figure(6);
    hold on;
    plot(tetaDegree, smax, 'Color', colorCode{nv});
    figure(7);
    hold on;
    plot(tetaDegree, smin, 'Color', colorCode{nv});
    figure(8);
    hold on;
    plot(tetaDegree, taumax, 'Color', colorCode{nv});
    figure(9);
    hold on;
    plot(tetaDegree, v1, 'Color', colorCode{nv});
    figure(10);
    hold on;
    plot(tetaDegree, v2, 'Color', colorCode{nv});
    figure(11);
    hold on;
    plot(tetaDegree, vs, 'Color', colorCode{nv});
end    

    
for p = 1:numP
    figure(p);
    title(titles{p});
    xlabel(xlabel_);
    ylabel(ylabels{p});
    legend(leg);
    legend('boxoff');
    print(printOption, fileName{p});
    close(figure(p));
end
