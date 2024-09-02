function getLowRateHighKParameterss()
cc = 0.5:0.02:0.96;
lenc = length(cc);
for i = 1:lenc
    c = cc(i);
    [timeDeq1xepsDivtauScale(i), deltuxepsDivdeluScale(i), timeMaxStressxepsDivtauScale(i), D4sigmaMaxDivsigmaScale(i), sigmaMaxDivsigmaScale(i)] = getLowRateHighKParameters(c);
    val{1}(i) = timeDeq1xepsDivtauScale(i);
    val{2}(i) = deltuxepsDivdeluScale(i);
    val{3}(i) = timeMaxStressxepsDivtauScale(i);
    val{4}(i) = D4sigmaMaxDivsigmaScale(i);
    val{5}(i) = sigmaMaxDivsigmaScale(i);
end

for j = 1:5
    figure(j);
    plot(cc, val{j});
end
    

    