function plotLEFMHistories(time, Load, SigmaForce, KIstatic, KIdynamic, ldotCrack, lCrack, StaticRadius, DynamicRadius, DynamicRadiusSigmaAdjusted , DynamicRadiusVelocitySigmaAdjusted, subName, flags)

timeRed = time(flags);
LoadRed = Load(flags);
SigmaForceRed = SigmaForce(flags);
figure(201);
plot(time, Load, time, SigmaForce);
legend({'load', 'sigmaFrc'});
legend('boxoff');
title('load values');
xlabel('time');
ylabel('stress');
hold on;
plot(timeRed, LoadRed, 'LineStyle', 'none', 'Marker', 'x');
hold on;
plot(timeRed, SigmaForceRed, 'LineStyle', 'none', 'Marker', 'x');
print('-dpdf', [subName, 'stresses.pdf']);


figure(202);

KIstaticRed = KIstatic(flags);
KIdynamicRed = KIdynamic(flags);

plot(time, KIstatic, time, KIdynamic);
legend({'KIs', 'Kid'});
legend('boxoff');
title('stress intensity factors');
xlabel('time');
ylabel('KI');
hold on;
plot(timeRed, KIstaticRed, 'LineStyle', 'none', 'Marker', 'x');
hold on;
plot(timeRed, KIdynamicRed, 'LineStyle', 'none', 'Marker', 'x');
print('-dpdf', [subName, 'KI.pdf']);


figure(203);
plot(time, StaticRadius, time, DynamicRadius);
legend({'rs_stat', 'rs_dyn'});
legend('boxoff');
title('LEFM process zone size');
xlabel('time');
ylabel('rs');
print('-dpdf', [subName, 'LEFM_processZoneSize.pdf']);


figure(204);
plot(time, ldotCrack);
%legend({'vCr/cR'});
%legend('boxoff');
title('crack velocity');
xlabel('time');
ylabel('vCr/cR');
print('-dpdf', [subName, 'crackVelocity.pdf']);


figure(205);
plot(time, lCrack);
%legend({'lCr'});
%legend('boxoff');
title('crack tip location');
xlabel('time');
ylabel('position');
print('-dpdf', [subName, 'crackPosition.pdf']);



figure(206);
plot(time, log10(KIdynamic));
%legend({'Kid'});
%legend('boxoff');
title('dynamic stress intensity factor');
xlabel('time');
ylabel('log(KI)');
print('-dpdf', [subName, 'KIdyn.pdf']);

figure(207);
plot(time, log10(DynamicRadius), time, log10(DynamicRadiusSigmaAdjusted), time, log10(DynamicRadiusVelocitySigmaAdjusted));
legend({'rsStrs', 'rsStrsMod', 'rsVelMod'});
legend('boxoff');
title('LEFM dynamic process zone size');
xlabel('time');
ylabel('rs');
print('-dpdf', [subName, 'dynamic_LEFM_processZoneSize.pdf']);






for i = 201:207
    close(i);
end
