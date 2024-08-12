function [C] = AverageStiffnessCalculation(RVENumberString,SVENumberString,AverageDataPath)

for i = 1:2
    LCstring = strcat('LC',num2str(i-1));
    filename = strcat(AverageDataPath,RVENumberString,SVENumberString,LCstring,'.out');
    [E,S] = ImportAverageStressStrainFile(filename);
     EAve(:,i) = E;
     SAve(:,i) = S;
end

C11 = SAve(1,1)/EAve(1,1);
C21 = SAve(2,1)/EAve(1,1);
C12 = SAve(1,2)/EAve(2,2);
C22 = SAve(2,2)/EAve(2,2);
C = [C11,(C12+C21)/2,0;(C12+C21)/2,C22,0;0,0,(C11-C12)/2];