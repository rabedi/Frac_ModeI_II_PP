function plotDissimilarBars(plotNo, areSimilar, finalTime)


if (nargin == 0)
    plotNo = -1;
end
%plotNo 
% < 0 plot all
% 1 = v's
% 2 = u,s
% 3 = stresses
% 4 = delv
% 5 = delu
% line style
lStyle = '--';%':';
lClr = 'k';%'g';

lStyleL = '--';%'-.';
lStyleR = '--';%'--';
lClrL = 'k';%'r';
lClrR = 'k';%'b';

if (areSimilar == 0)
    i = 1;
    t(i) = 0.0;
    vl(i) = 0.1;
    vr(i) = 0.0;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = -.01;
    ur(i) = 0.0;

    i = i + 1;
    t(i) = 0.1;
    vl(i) = 0.1;
    vr(i) = 0.0;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = 0.0;
    ur(i) = 0.0;

    i = i + 1;
    t(i) = 0.1;
    vl(i) = 0.04117647059;
    vr(i) = 0.04117647059;
    sl(i) = -0.04117647059;
    sr(i) = -0.04117647059;
    ul(i) = 0.0;
    ur(i) = 0.0;

    i = i + 1;
    t(i) = 0.1 + 0.2;
    vl(i) = 0.04117647059;
    vr(i) = 0.04117647059;
    sl(i) = -0.04117647059;
    sr(i) = -0.04117647059;
    ul(i) = 0.04117647059 * 0.2;
    ur(i) = 0.04117647059 * 0.2;

    i = i + 1;
    t(i) = 0.1 + 0.2;
    vl(i) = 0.08961937716;
    vr(i) = 0.08961937716;
    sl(i) = -7.266435986e-3;
    sr(i) = -7.266435986e-3;
    ul(i) = 0.04117647059 * 0.2;
    ur(i) = 0.04117647059 * 0.2;

    i = i + 1;
    t(i) = 0.1 + 0.2857142857;
    vl(i) = 0.08961937716;
    vr(i) = 0.08961937716;
    sl(i) = -7.266435986e-3;
    sr(i) = -7.266435986e-3;
    ul(i) = ul(i - 1) + vl(i) * (t(i) - t(i - 1));
    ur(i) = ur(i - 1) + vr(i) * (t(i) - t(i - 1));


    i = i + 1;
    t(i) = 0.1 + 0.2857142857;
    vl(i) = -0.01764705882;
    vr(i) =  0.08235294118;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = ul(i - 1) + vl(i) * (t(i) - t(i - 1));
    ur(i) = ur(i - 1) + vr(i) * (t(i) - t(i - 1));

    i = i + 1;
    t(i) = 0.1 + 0.4;
    vl(i) = -0.01764705882;
    vr(i) =  0.08235294118;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = ul(i - 1) + vl(i) * (t(i) - t(i - 1));
    ur(i) = ur(i - 1) + vr(i) * (t(i) - t(i - 1));

    i = i + 1;
    t(i) = 0.1 + 0.4;
    vl(i) = -0.01764705882;
    vr(i) =  0.09688581315;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = ul(i - 1) + vl(i) * (t(i) - t(i - 1));
    ur(i) = ur(i - 1) + vr(i) * (t(i) - t(i - 1));

    i = i + 1;
    t(i) = 0.1 + 0.4857142857;
    vl(i) = -0.01764705882;
    vr(i) =  0.09688581315;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = ul(i - 1) + vl(i) * (t(i) - t(i - 1));
    ur(i) = ur(i - 1) + vr(i) * (t(i) - t(i - 1));

    i = i + 1;
    t(i) = 0.1 + 0.4857142857;
    vl(i) =  0.07923875433;
    vr(i) =  0.08235294118;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = ul(i - 1) + vl(i) * (t(i) - t(i - 1));
    ur(i) = ur(i - 1) + vr(i) * (t(i) - t(i - 1));

    i = i + 1;
    t(i) = 0.1 + 0.5714285714;
    vl(i) =  0.07923875433;
    vr(i) =  0.08235294118;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = ul(i - 1) + vl(i) * (t(i) - t(i - 1));
    ur(i) = ur(i - 1) + vr(i) * (t(i) - t(i - 1));


    i = i + 1;
    t(i) = 0.1 + 0.5714285714;
    vl(i) = -0.01764705882;
    vr(i) =  0.08235294118;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = ul(i - 1) + vl(i) * (t(i) - t(i - 1));
    ur(i) = ur(i - 1) + vr(i) * (t(i) - t(i - 1));

    i = i + 1;
    t(i) = 0.1 + 0.6;
    vl(i) = -0.01764705882;
    vr(i) =  0.08235294118;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = ul(i - 1) + vl(i) * (t(i) - t(i - 1));
    ur(i) = ur(i - 1) + vr(i) * (t(i) - t(i - 1));

else
    g0 = .01;
    c = 100;
    L = 10;
    T = L / c;
    v0 = 0.1;
    t0 = g0 / v0;
    rho = 0.01;
    crho = c * rho;
    
    i = 1;
    t(i) = 0.0;
    vl(i) = v0;
    vr(i) = 0.0;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = -g0;
    ur(i) = 0.0;
    
    
    i = 2;
    t(i) = t0;
    vl(i) = v0;
    vr(i) = 0.0;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = 0.0;
    ur(i) = 0.0;
    
    
    i = 3;
    t(i) = t0;
    vl(i) = v0 / 2;
    vr(i) = v0 / 2;
    sl(i) = -crho * v0 / 2;
    sr(i) = -crho * v0 / 2;
    ul(i) = 0.0;
    ur(i) = 0.0;
    
    i = 4;
    t(i) = t0 + 2 * T;
    vl(i) = v0 / 2;
    vr(i) = v0 / 2;
    sl(i) = -crho * v0 / 2;
    sr(i) = -crho * v0 / 2;
    ul(i) = T * v0;
    ur(i) = T * v0;

    
    i = 5;
    t(i) = t0 + 2 * T;
    vl(i) = 0.0;
    vr(i) = v0;
    sl(i) = 0.0;
    sr(i) = 0.0;
    ul(i) = T * v0;
    ur(i) = T * v0;
  
    
   if (finalTime < t(5))
       finalTime
       t5 = t(5)
       fprintf(1, 'finalTime too small\n');
       pause;
       pause;
   else
        i = 6;
        t(i) = finalTime;
        vl(i) = 0.0;
        vr(i) = v0;
        sl(i) = 0.0;
        sr(i) = 0.0;
        ul(i) = ul(i - 1) + vl(i) * (t(i) - t(i - 1));
        ur(i) = ul(i - 1) + vr(i) * (t(i) - t(i - 1));
   end
end    

if (plotNo < 0)
    figure(1);
end
if ((plotNo < 0) || (plotNo == 1))
    hold on;
    plot(t,vl, 'LineStyle', lStyleL, 'Color', lClrL);
    hold on;
    plot(t,vr, 'LineStyle', lStyleR, 'Color', lClrR);
end

if (plotNo < 0)
    figure(2);
end
if ((plotNo < 0) || (plotNo == 2))
    hold on;
    plot(t,ul, 'LineStyle', lStyleL, 'Color', lClrL);
    hold on;
    plot(t,ur, 'LineStyle', lStyleR, 'Color', lClrR);
end


if (plotNo < 0)
    figure(3);
end
if ((plotNo < 0) || (plotNo == 3))
    hold on;
    plot(t,sl, 'LineStyle', lStyle, 'Color', lClr);
end


if (plotNo < 0)
    figure(4);
end
if ((plotNo < 0) || (plotNo == 4))
    delv = vr - vl;
    hold on;
    plot(t,delv, 'LineStyle', lStyle, 'Color', lClr);
end

if (plotNo < 0)
    figure(5);
end
if ((plotNo < 0) || (plotNo == 5))
    delu = ur - ul;
    hold on;
    plot(t,delu, 'LineStyle', lStyle, 'Color', lClr);
end
