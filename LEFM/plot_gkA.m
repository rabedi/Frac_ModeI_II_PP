function plot_gkA(E, rho, nu)
if nargin < 1
    E = 3.24;
end

if nargin < 2
    rho = 1.19;
end

if nargin < 3
    nu = 0.35;
end

[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);
cMax = 0.99999 * cs;
num = 100;
v = 0:cMax/num:cMax;
len = length(v);
scaledv = 0;

for i = 1:len
    [gvI(i), kvI(i), AI(i)] = comptuteGvKvAvI(v(i), nu, cd, cs, cr, scaledv);
    [gvII(i), kvII(i), AII(i)] = comptuteGvKvAvII(v(i), nu, cd, cs, cr, scaledv);
	[gvIII(i), kvIII(i), AIII(i)] = comptuteGvKvAvIII(v(i), nu, cd, cs, cr, scaledv);
end
v2cr = v / cr;

plot(v2cr, gvI, '-r');
hold on;
plot(v2cr, gvII, '-b');
hold on;
plot(v2cr, gvIII, '-g');
legend({'gI', 'gII', 'gIII'});
print('-dpng', 'g.png');



hold on;
plot(v2cr, kvI, '.-r');
hold on;
plot(v2cr, kvII, '.-b');
hold on;
plot(v2cr, kvIII, '.-g');
legend({'gI', 'gII', 'gIII', 'kI', 'kII', 'kIII'});
print('-dpng', 'gk.png');


figure(2);
a = 0.05;
num1 = floor(a * num);
num2 = floor((1 - a) * num);
plot(v2cr(num1:num2), AI(num1:num2), '-r');
hold on;
plot(v2cr(num1:num2), AII(num1:num2), '-b');
hold on;
plot(v2cr(num1:num2), AIII(num1:num2), '-g');
set(gca, 'XScale', 'log');
legend({'AI', 'AII', 'AIII'});
print('-dpng', 'A.png');
