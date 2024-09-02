s = 2;
for p = s:2
    tic
    n = power(10,p);

    x = rand(1,n);
    y = rand(1,n);
    z = rand(1,n);

    xVals = 0:(1/sqrt(n)):1;
    [X,Y] = meshgrid(xVals);
    Z = griddata(x,y,z,X,Y);
    pp(p - s + 1) = p;
    t1(p - s + 1) =  toc;
    v = 0:0.1:1;
    [mC,hC] = contour(X, Y, Z, v);
    
%     set(get(get(hC,'Annotation'),'LegendInformation'),...
%     'IconDisplayStyle','Children');
%     %{
%     Assigns each line object's DisplayName property a string 
%     based on the value of the contour interval it represents
%     %}
%     k =1; ind = 1; hLines = get(hC,'Children');
%     while k < size(mC,2),
%        set(hLines(ind),'DisplayName',num2str(mC(1,k)))
%        k = k+mC(2,k)+1; ind = ind+1;
%     end 
% % Display the legend using DisplayName labels
% legend('show')
    tt(p - s + 1) = toc;
    t2(p - s + 1) = tt(p - s + 1) - t1(p - s + 1);
end

pp
t1
t2
tt
figure(2);
plot(pp,log(t1),'-b');
hold on;
plot(pp,log(t2),'-r');
hold on;
plot(pp,log(tt),'-k');
legend({'t1','t2','tt'});
