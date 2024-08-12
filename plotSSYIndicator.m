%function plotSSYIndicator()
clear
cls_
symbl = '-ok';
symbLine = '-';
colLine = [0.7, 0.7, 0.7];
fs = 45;
lfs = 25;
upperLoadLog = [-1.0/8.0, -1.0/16.0, -1.0/32.0, -1.0/64.0, -1.0/128.0];
% rp = cohesive process zone size
% rss = dynamic singular radius (stress) based
upperMinrp_rss = [3.017585, 3.9877, 4.720702, 4.968622, 5.249715];
upperMaxrp_rss = [3.792254, 5.3457, 6.561683, 7.410778, 7.41779];

%upperMinrp_rss = [3.0, 3.9877, 4.7230, 4.9692, 5.2615];
%upperMaxrp_rss = [3.8, 5.3457, 6.5538, 7.41538, 7.4290];
    

% rp = cohesive process zone size
% rss = dynamic singular radius (stress) based

lowerLoadLog = [-14.0/8.0, -12.0/8.0, -10.0/8.0, -8.0/8.0, -7.0/8.0, -6.0/8.0, -5.0/8.0, -4.0/8.0, -3.0/8.0, -2.0/8.0];
lowerMinrp_rss = [0.001242, 0.00518, 0.017202, 0.054013, 0.09809, 0.173115, 0.309182 ,0.552196 ,0.985458 ,1.757364];
lowerMaxrp_rss = [0.001767, 0.005601, 0.017805, 0.056551, 0.100671, 0.1805, 0.322069 ,0.580476 ,1.058175 ,1.96204];



%lowerLoadLog = [-3.0/2.0, -1.0, -1.0/2.0];
%lowerMinrp_rss = [0.00555, 0.05169, 0.55569];
%lowerMaxrp_rss = [0.005552, 0.0581538, 0.581538];
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

plot(loadAll, estimateAll, symbLine, 'Color', colLine);
%errorbar(load, estimate, minV, maxV);
%errorbar(load, estimate, L, M);

i = 1;
hold on;
plot( [load(i), load(i)], [minV(i), maxV(i)], symbl);

legend({'lega', 'legb'}, 'Location', 'NorthWest', 'FontSize', lfs);
legend('boxoff');
for i = 2:len
	hold on;
	plot( [load(i), load(i)], [minV(i), maxV(i)], symbl);
end
xlabel('xlabel', 'FontSize', fs);
ylabel('ylabel', 'FontSize', fs);
print('-depsc', 'loadMimMax.eps');

set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
xlabel('xlabel', 'FontSize', fs);
ylabel('ylabel', 'FontSize', fs);
print('-depsc', 'loadMimMaxMLog.eps');
cls_

plot(loadAllLog, estimateAllLog, symbLine, 'Color', colLine);
%errorbar(loadLog, estimateLog, minVLog, maxVLog);
%errorbar(loadLog, estimateLog, LLog, MLog);

i = 1;
hold on;
plot( [loadLog(i), loadLog(i)], [minVLog(i), maxVLog(i)],symbl);
legend({'lega', 'legb'}, 'Location', 'NorthWest', 'FontSize', lfs);
legend('boxoff');
for i = 2:len
	hold on;
	plot( [loadLog(i), loadLog(i)], [minVLog(i), maxVLog(i)], symbl);
end
xlabel('xlabel', 'FontSize', fs);
ylabel('ylabel', 'FontSize', fs);
print('-depsc', 'loadMimMaxLog.eps');


cls_





plot(estimateAll, estimateAll, symbLine, 'Color', colLine);
i = 1;
hold on;
plot( [estimate(i), estimate(i)], [minV(i), maxV(i)], symbl);
legend({'lega', 'legb'}, 'Location', 'NorthWest', 'FontSize', lfs);
legend('boxoff');

for i = 2:len
	hold on;
	plot( [estimate(i), estimate(i)], [minV(i), maxV(i)], symbl);
end
xlabel('xlabel', 'FontSize', fs);
ylabel('ylabel', 'FontSize', fs);
print('-depsc', 'estimateMimMax.eps');

set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
xlabel('xlabel', 'FontSize', fs);
ylabel('ylabel', 'FontSize', fs);
print('-depsc', 'estimateMimMaxMLog.eps');
cls_

plot(estimateAllLog, estimateAllLog, symbLine, 'Color', colLine);
hold on;
i = 1;
plot( [estimateLog(i), estimateLog(i)], [minVLog(i), maxVLog(i)], symbl);
legend({'lega', 'legb'}, 'Location', 'NorthWest', 'FontSize', lfs);
legend('boxoff');

for i = 1:len
	hold on;
	plot( [estimateLog(i), estimateLog(i)], [minVLog(i), maxVLog(i)], symbl);
end
xlabel('xlabel', 'FontSize', fs);
ylabel('ylabel', 'FontSize', fs);
print('-depsc', 'estimateMimMaxLog.eps');


cls_
