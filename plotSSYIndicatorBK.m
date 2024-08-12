%function plotSSYIndicator()
clear
cls_
symbl = '-ok'
fs = 45;
upperLoadLog = [-1.0/8.0, -1.0/16.0, -1.0/32.0, -1.0/64.0, -1.0/128.0];
% rp = cohesive process zone size
% rss = dynamic singular radius (stress) based
upperMinrp_rss = [3.0, 3.9877, 4.6975, 4.9599, 5.2377];
upperMaxrp_rss = [3.8, 5.3457, 6.5494, 6.8580, 7.4290];
    

lowerLoadLog = [-3.0/2.0, -1.0, -1.0/2.0];
% rp = cohesive process zone size
% rss = dynamic singular radius (stress) based
lowerMinrp_rss = [0.00555, 0.05169, 0.55569];
lowerMaxrp_rss = [0.005552, 0.0581538, 0.581538];


%lowerMinrp_rss = [0.006461538461538, 0.056000000000000, 0.551384615384615];
%lowerMaxrp_rss = [0.006461538461538, 0.058153846153846, 0.581538461538462];

loadLog = [lowerLoadLog, upperLoadLog];
minV = [lowerMinrp_rss, upperMinrp_rss];
maxV = [lowerMaxrp_rss, upperMaxrp_rss];
len = length(minV);
fact = 9.0/16.0;
for i = 1:len
    minVLog(i) = log10(minV(i));
    maxVLog(i) = log10(maxV(i));
    load(i) = power(10.0, loadLog(i));
    estimate(i) = pi * pi * fact * load(i) * load(i);
    estimateLog(i) = log10(estimate(i));
	L(i) = estimate(i) - minV(i);
	M(i) = max(i) - estimate(i);	
end
%loadLog
%load
%estimate
%minV
%maxV
%pause
loadAllLog = [-2, loadLog, -1/256];
len2 = length(loadAllLog);
for i = 1:len2
    loadAll(i) = power(10.0, loadAllLog(i));
    estimateAll(i) = pi * pi * fact * loadAll(i)^2;
    estimateAllLog(i) = log10(estimateAll(i));
end

plot(loadAll, estimateAll, '-k');
%errorbar(load, estimate, minV, maxV);
%errorbar(load, estimate, L, M);
for i = 1:len
	hold on;
	plot( [load(i), load(i)], [minV(i), maxV(i)], symbl);
end
xlabel('xlabel', 'FontSize', fs);
ylabel('ylabel', 'FontSize', fs);
print('-deps', 'loadMimMax.eps');

set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
xlabel('xlabel', 'FontSize', fs);
ylabel('ylabel', 'FontSize', fs);
print('-deps', 'loadMimMaxMLog.eps');
cls_

plot(loadAllLog, estimateAllLog, '-k');
%errorbar(loadLog, estimateLog, minVLog, maxVLog);
%errorbar(loadLog, estimateLog, LLog, MLog);
for i = 1:len
	hold on;
	plot( [loadLog(i), loadLog(i)], [minVLog(i), maxVLog(i)], symbl);
end
xlabel('xlabel', 'FontSize', fs);
ylabel('ylabel', 'FontSize', fs);
print('-deps', 'loadMimMaxLog.eps');


cls_





plot(estimateAll, estimateAll, '-k');
for i = 1:len
	hold on;
	plot( [estimate(i), estimate(i)], [minV(i), maxV(i)], symbl);
end
xlabel('xlabel', 'FontSize', fs);
ylabel('ylabel', 'FontSize', fs);
print('-deps', 'estimateMimMax.eps');

set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
xlabel('xlabel', 'FontSize', fs);
ylabel('ylabel', 'FontSize', fs);
print('-deps', 'estimateMimMaxMLog.eps');
cls_

plot(estimateAllLog, estimateAllLog, '-k');
for i = 1:len
	hold on;
	plot( [estimateLog(i), estimateLog(i)], [minVLog(i), maxVLog(i)], symbl);
end
xlabel('xlabel', 'FontSize', fs);
ylabel('ylabel', 'FontSize', fs);
print('-deps', 'estimateMimMaxLog.eps');


cls_
