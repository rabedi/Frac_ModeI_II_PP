function outputData = takeDerivativeOfBlockData(inputData, maxPIndexDiff, derMethod, ...
    xValueIndex, yValueIndex, solValueIndex, sizeOneSolDerivativeVal, ...
    spaceIndex, timeIndex, spaceDotTol)

global cnfg;
global ImaxPower_historyDerInfow;
maxVal = power(10.0, cnfg{ImaxPower_historyDerInfow});
returnInfs = 1;

%derMethod == 0  -> cetntered finite differece 
%derMethod == 1  -> linear least square fit on three points

outputData = inputData;
len = length(inputData);
if (len <= 1)
    return;
end

index = 1;
while (index <= len)
    if (length(inputData{index}) > 0)
        break;
    end
    index = index + 1;
end


if (index == (len + 1))
    return;
end

clusterSize = length(inputData{index});
mainIndex = 1;
subIndex = 1;
indexCell{mainIndex}{subIndex} = index;
%acceptable{mainIndex}{subIndex} = 1;
prevIndex = index;

while(index < len)
    index = index + 1;
    if (length(inputData{index}) == 0)
        continue;
    end
    if ((length(inputData{index}) ~= clusterSize) || ((index - prevIndex) > maxPIndexDiff))
        clusterSize = length(inputData{index});
        mainIndex = mainIndex + 1;
        subIndex = 1;
    else
        subIndex = subIndex + 1;
    end
    prevIndex = index;
    indexCell{mainIndex}{subIndex} = index;
%    acceptable{mainIndex}{subIndex} = 1;
end

infv = 1e100;
derSize = length(xValueIndex);
inClen = length(indexCell);
for mainIndex = 1:inClen
    pointSeriesSize = length(indexCell{mainIndex}); % number of successive points for computing derivative
    baseIndex = indexCell{mainIndex}{1};
    clusterSize = length(inputData{baseIndex});
    if (pointSeriesSize == 1)
        for cluster = 1:clusterSize
           acceptable{baseIndex}{cluster} = 0;
            for der = 1:derSize
                outputData{baseIndex}{cluster}(solValueIndex(der)) = sizeOneSolDerivativeVal;
            end
        end
    else
        for cluster = 1:clusterSize
           acceptable{baseIndex}{cluster} = 1;
        end

        secondIndex = indexCell{mainIndex}{2};
        firstIndex = indexCell{mainIndex}{1};
        for cluster = 1:clusterSize
            dsdt = computeRatioTwoSided((inputData{secondIndex}{cluster}(spaceIndex) - inputData{firstIndex}{cluster}(spaceIndex)) , ...
                (inputData{secondIndex}{cluster}(timeIndex) - inputData{firstIndex}{cluster}(timeIndex)),...
                infv, 0);
            if (abs(dsdt) > spaceDotTol) 
               acceptable{baseIndex}{cluster} = 0;
            else
               acceptable{baseIndex}{cluster} = 1;
            end
            for der = 1:derSize
                outputData{baseIndex}{cluster}(solValueIndex(der)) = ...
                computeRatioTwoSided((inputData{secondIndex}{cluster}(yValueIndex(der)) - inputData{firstIndex}{cluster}(yValueIndex(der))) , ...
                (inputData{secondIndex}{cluster}(xValueIndex(der)) - inputData{firstIndex}{cluster}(xValueIndex(der))),...
                maxVal, returnInfs);
            end
        end
        for pt = 2:(pointSeriesSize - 1)
            pIndex = indexCell{mainIndex}{pt - 1};
            Index = indexCell{mainIndex}{pt};
            nIndex = indexCell{mainIndex}{pt + 1};

            for cluster = 1:clusterSize
%               compute ds/dt
                xm1 = inputData{pIndex}{cluster}(timeIndex);
                x0 = inputData{Index}{cluster}(timeIndex);
                xp1 = inputData{nIndex}{cluster}(timeIndex);

                ym1 = inputData{pIndex}{cluster}(spaceIndex);
                y0 = inputData{Index}{cluster}(spaceIndex);
                yp1 = inputData{nIndex}{cluster}(spaceIndex);

                if (derMethod == 0) % "centered" finite difference
                    A = - (xp1 - x0)^2;
                    B = (xm1 - x0)^2;
                    dsdt = computeRatioTwoSided((A * (ym1 - y0) + B * (yp1 - y0)) , ...
                        (A * (xm1 - x0) + B * (xp1 - x0)), infv, 0);
                elseif (derMethod == 1) % slope of a  quadratic fit at the middle point
                    fm1 = computeRatioTwoSided(x0 - xp1, ((xm1 - xp1) * (xm1 - x0)) , maxVal, returnInfs);
                    fp1 = computeRatioTwoSided(x0 - xm1, ((xp1 - xm1) * (xp1 - x0)), maxVal, returnInfs);
                    f0  = computeRatioTwoSided(2 * x0 - xm1 - xp1, ((x0 - xm1) * (x0 - xp1)), maxVal, returnInfs); 
                    dsdt = (fm1 * ym1 + fp1 * yp1 + f0 * y0);
                elseif (derMethod == 2) % line least square on three points
                    sigmaxy = xm1 * ym1 + x0 * y0 + xp1 * yp1;
                    sigmax = xm1 + x0 + xp1;
                    sigmay = ym1 + y0 + yp1;
                    sigmax2 = xm1 * xm1 + x0 * x0 + xp1 * xp1;
                    n = 3;
                    dsdt = computeRatioTwoSided((n * sigmaxy - sigmax * sigmay) , ...
                        (n * sigmax2 - sigmax^2), infv, 0);
                end
                if (abs(dsdt) >= spaceDotTol)
                   acceptable{Index}{cluster} = 0;
                else
                   acceptable{Index}{cluster} = 1;
                end
                % other derivative calculations
                for der = 1:derSize
                    xm1 = inputData{pIndex}{cluster}(xValueIndex(der));
                    x0 = inputData{Index}{cluster}(xValueIndex(der));
                    xp1 = inputData{nIndex}{cluster}(xValueIndex(der));
                    
                    ym1 = inputData{pIndex}{cluster}(yValueIndex(der));
                    y0 = inputData{Index}{cluster}(yValueIndex(der));
                    yp1 = inputData{nIndex}{cluster}(yValueIndex(der));

                    if (derMethod == 0) % "centered" finite difference
                        A = - (xp1 - x0)^2;
                        B = (xm1 - x0)^2;
                        outputData{Index}{cluster}(solValueIndex(der)) = computeRatioTwoSided((A * (ym1 - y0) + B * (yp1 - y0)) , ...
                            (A * (xm1 - x0) + B * (xp1 - x0)), maxVal, returnInfs);
                    elseif (derMethod == 1) % slope of a  quadratic fit at the middle point
                        fm1 = computeRatioTwoSided(x0 - xp1, ((xm1 - xp1) * (xm1 - x0)) , maxVal, returnInfs);
                        fp1 = computeRatioTwoSided(x0 - xm1, ((xp1 - xm1) * (xp1 - x0)), maxVal, returnInfs);
						f0  = computeRatioTwoSided(2 * x0 - xm1 - xp1, ((x0 - xm1) * (x0 - xp1)), maxVal, returnInfs); 
                        outputData{Index}{cluster}(solValueIndex(der)) = (fm1 * ym1 + fp1 * yp1 + f0 * y0);
                    elseif (derMethod == 2) % line least square on three points
                        sigmaxy = xm1 * ym1 + x0 * y0 + xp1 * yp1;
                        sigmax = xm1 + x0 + xp1;
                        sigmay = ym1 + y0 + yp1;
                        sigmax2 = xm1 * xm1 + x0 * x0 + xp1 * xp1;
                        n = 3;
                        outputData{Index}{cluster}(solValueIndex(der)) = computeRatioTwoSided((n * sigmaxy - sigmax * sigmay) , ...
                            (n * sigmax2 - sigmax^2), maxVal, returnInfs);
                    end
                end
            end
        end
        secondIndex = indexCell{mainIndex}{pointSeriesSize};
        firstIndex = indexCell{mainIndex}{pointSeriesSize - 1};
       
        for cluster = 1:clusterSize
            dsdt = ...
            computeRatioTwoSided((inputData{secondIndex}{cluster}(spaceIndex) - inputData{firstIndex}{cluster}(spaceIndex)) , ...
            (inputData{secondIndex}{cluster}(timeIndex) - inputData{firstIndex}{cluster}(timeIndex)), infv, 0);
            if (abs(dsdt) >= spaceDotTol)
               acceptable{secondIndex}{cluster} = 0;
            else
               acceptable{secondIndex}{cluster} = 1;
            end
            
            for der = 1:derSize
                outputData{secondIndex}{cluster}(solValueIndex(der)) = ...
                computeRatioTwoSided((inputData{secondIndex}{cluster}(yValueIndex(der)) - inputData{firstIndex}{cluster}(yValueIndex(der))) , ...
                (inputData{secondIndex}{cluster}(xValueIndex(der)) - inputData{firstIndex}{cluster}(xValueIndex(der))), maxVal, returnInfs);
            end
        end
    end    
end


for mainIndex = 1:inClen
    pointSeriesSize = length(indexCell{mainIndex}); % number of successive points for computing derivative
%    baseIndex = indexCell{mainIndex}{1};
    clusterSize = length(inputData{baseIndex});
    for pt = 1:pointSeriesSize
        Index = indexCell{mainIndex}{pt};
        for cluster = 1:clusterSize
            if (acceptable{Index}{cluster} == 0)
                time = outputData{Index}{cluster}(timeIndex);
                outputData{Index}{cluster} = nan * outputData{Index}{cluster};
                outputData{Index}{cluster}(timeIndex) = time;
            end
        end
    end
end