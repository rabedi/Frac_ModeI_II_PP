function    [time,time2, timeTot] = testDraw(n, factor, option)
m = factor * n;
tic;
if (option == 0)
    x = zeros(1,m);
    y = zeros(1,m);
end


for i = 1:n
    x(i) = rand(1,1);
    y(i) = rand(1,1);
end
time = toc;

if (option == 0)
    plot(x(1:n),y(1:n),'-k');
else
    plot(x,y,'-k');
end
timeTot = toc;
time2 = timeTot - time;
