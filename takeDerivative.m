function dy = takeDerivative(x, y, derMethod, maxPower, returnInfs)

maxVal = power(10.0, maxPower);

[m, n] = size(y);
dy = zeros(m, n);
if (m <= 1)
    return;
end

dy(1, :) = (y(2, :) - y(1, :)) / (x(2) - x(1));
dy(m, :) = (y(m, :) - y(m - 1, :)) / (x(m) - x(m - 1));


for pt = 2:(m - 1)
    pIndex = pt - 1;
    Index = pt;
    nIndex = pt + 1;

    xm1 = x(pt - 1) * ones(1, n);
    x0 = x(pt) * ones(1, n);
    xp1 = x(pt + 1) * ones(1, n);

    ym1 = y(pt - 1, :);
    y0 = y(pt, :);
    yp1 = y(pt + 1, :);

    if (derMethod == 0) % "centered" finite difference
        A = - (xp1 - x0).^2;
        B = (xm1 - x0).^2;
        dy(pt, :) = computeRatioTwoSided((A .* (ym1 - y0) + B .* (yp1 - y0)) , ...
                (A .* (xm1 - x0) + B .* (xp1 - x0)), maxVal, returnInfs);
    elseif (derMethod == 1) % slope of a  quadratic fit at the middle point
        fm1 = computeRatioTwoSided(x0 - xp1, ((xm1 - xp1) .* (xm1 - x0)) , maxVal, returnInfs);
        fp1 = computeRatioTwoSided(x0 - xm1, ((xp1 - xm1) .* (xp1 - x0)), maxVal, returnInfs);
        f0  = computeRatioTwoSided(2 * x0 - xm1 - xp1, ((x0 - xm1) .* (x0 - xp1)), maxVal, returnInfs); 
        dy(pt, :) = (fm1 .* ym1 + fp1 .* yp1 + f0 .* y0);
    elseif (derMethod == 2) % line least square on three points
        sigmaxy = xm1 .* ym1 + x0 .* y0 + xp1 .* yp1;
        sigmax = xm1 + x0 + xp1;
        sigmay = ym1 + y0 + yp1;
        sigmax2 = xm1 .* xm1 + x0 .* x0 + xp1 .* xp1;
        n = 3;
        dy(pt, :) = computeRatioTwoSided((n * sigmaxy - sigmax .* sigmay) , ...
            (n * sigmax2 - sigmax.^2), maxVal, returnInfs);
    end
end
