function stress_strain_curves(filePath,doPlot)
%FORMAT '# Time\tEdgeFlag\tL\tPn\tPt\tUx\tUy\t...\n'
%close all; clc;
addpath('../');
if exist(filePath,'file') ~= 2
   THROW(['file:=[',filePath,'] does not exist.']); 
end

ssext = '.ssdat';
[path,file,~] = fileparts(filePath);
ssFile = fullfile(path,[file,ssext]);

if nargin < 2
    doPlot = 0;
end

A = load(filePath);

b = 2;
r = 8;
t = 14;
l = 20;
%==========================================================================
if (length(A) == 0)
    fprintf(1, 'file %s is empty\n', filePath);
    THROW('Error file empty\n');
end
    
    
    
time = A(:,1);

%L0 = A(:,r+1);
%L1 = A(:,t+1);
%2019
L1 = A(:,r+1);
L0 = A(:,t+1);


pnR = A(:,r+2);
ptR = A(:,r+3);
pnL = A(:,l+2);
ptL = A(:,l+3);
pnT = A(:,t+2);
ptT = A(:,t+3);
pnB = A(:,b+2);
ptB = A(:,b+3);

U0R = A(:,r+4);
U1R = A(:,r+5);
U0L = A(:,l+4);
U1L = A(:,l+5);
U0T = A(:,t+4);
U1T = A(:,t+5);
U0B = A(:,b+4);
U1B = A(:,b+5);
%==========================================================================
%==========================================================================
s00R = pnR ./ L1; 
s01R = ptR ./ L1;
s00L = pnL ./ L1;
s01L = ptL ./ L1;
e00 = (U0R-U0L) ./ (L0.*L1);
e01 = (U1R-U1L) ./ (L0.*L1);

s11T = pnT ./ L0; 
s10T = -ptT ./ L0;
s11B = pnB ./ L0;
s10B = -ptB ./ L0;
e11 = (U1T-U1B) ./ (L0.*L1);
e10 = (U0T-U0B) ./ (L0.*L1);
%==========================================================================
%==========================================================================
%PLOTTING
if doPlot == 1
figure(1)
subplot(1,2,1)
plot(e00,s00L,'-or',e00,s00R,'-ob')
legend({'$edge 5:L$','$edge 3:R$'},'Interpreter','latex');
xlabel('$\epsilon_{xx}$','Interpreter','latex')
ylabel('$\sigma_{xx}$','Interpreter','latex')
subplot(1,2,2)
plot(e11,s11T,'-or',e11,s11B,'-ob')
legend({'$edge 4:T$','$edge 2:B$'},'Interpreter','latex');
xlabel('$\epsilon_{yy}$','Interpreter','latex')
ylabel('$\sigma_{yy}$','Interpreter','latex')

figure(2)
subplot(1,2,1)
plot(e01,s01L,'-or',e01,s01R,'-ob')
legend({'$edge 5:L$','$edge 3:R$'},'Interpreter','latex');
xlabel('$\epsilon_{xy}$','Interpreter','latex')
ylabel('$\sigma_{xy}$','Interpreter','latex')
subplot(1,2,2)
plot(e10,s10T,'-or',e10,s10B,'-ob')
legend({'$edge 4:T$','$edge 2:B$'},'Interpreter','latex');
xlabel('$\epsilon_{yx}$','Interpreter','latex')
ylabel('$\sigma_{yx}$','Interpreter','latex')

figure(3)
subplot(1,2,1)
plot(time,s00L,'-or',time,s00R,'-ob')
legend({'$edge 5:L$','$edge 3:R$'},'Interpreter','latex');
xlabel('$time, t$','Interpreter','latex')
ylabel('$\sigma_{xx}$','Interpreter','latex')
subplot(1,2,2)
plot(time,s11T,'-or',time,s11B,'-ob')
legend({'$edge 4:T$','$edge 2:B$'},'Interpreter','latex');
xlabel('$time, t$','Interpreter','latex')
ylabel('$\sigma_{yy}$','Interpreter','latex')

figure(4)
subplot(1,2,1)
plot(time,s01L,'-or',time,s01R,'-ob')
legend({'$edge 5:L$','$edge 3:R$'},'Interpreter','latex');
xlabel('$time, t$','Interpreter','latex')
ylabel('$\sigma_{xy}$','Interpreter','latex')
subplot(1,2,2)
plot(time,s10T,'-or',time,s10B,'-ob')
legend({'$edge 4:T$','$edge 2:B$'},'Interpreter','latex');
xlabel('$time, t$','Interpreter','latex')
ylabel('$\sigma_{yx}$','Interpreter','latex')

figure(5)
subplot(1,2,1)
plot(time,e00,'-or')
xlabel('$time, t$','Interpreter','latex')
ylabel('$\epsilon_{xx}$','Interpreter','latex')
subplot(1,2,2)
plot(time,e11,'-or')
xlabel('$time, t$','Interpreter','latex')
ylabel('$\epsilon_{yy}$','Interpreter','latex')

figure(6)
subplot(1,2,1)
plot(time,e01,'-or')
xlabel('$time, t$','Interpreter','latex')
ylabel('$\epsilon_{xy}$','Interpreter','latex')
subplot(1,2,2)
plot(time,e10,'-or')
xlabel('$time, t$','Interpreter','latex')
ylabel('$\epsilon_{yx}$','Interpreter','latex')
end

sid = fopen(ssFile,'w');
% t s00L s00R s01L s01R e00 e01 s11T s11B s10T s10B e11 e10
ALL = [time s00L s00R s01L s01R e00 e01 s11T s11B s10T s10B e11 e10];
fmt = [repmat('%.20f ', 1, size(ALL,2)-1), '%4d\n'];
fprintf(sid,fmt, ALL.');
end
