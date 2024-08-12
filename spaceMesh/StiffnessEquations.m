function [C] = StiffnessEquations(rawDataCell)

rawDataLC0 = rawDataCell{1};
rawDataLC1 = rawDataCell{2};

LC0Macro_E11 = cell2mat(rawDataLC0.data{1}(2));
LC0Macro_S11 = cell2mat(rawDataLC0.data{4}(2));
LC0Macro_S22 = cell2mat(rawDataLC0.data{5}(2));

LC1Macro_E22 = cell2mat(rawDataLC1.data{2}(2));
LC1Macro_S11 = cell2mat(rawDataLC1.data{4}(2));
LC1Macro_S22 = cell2mat(rawDataLC1.data{5}(2));

C11 = LC0Macro_S11/LC0Macro_E11;
C21 = LC0Macro_S22/LC0Macro_E11;
C12 = LC1Macro_S11/LC1Macro_E22;
C22 = LC1Macro_S22/LC1Macro_E22;
C = [C11,(C12+C21)/2,0;(C12+C21)/2,C22,0;0,0,(C11-C12)/2];