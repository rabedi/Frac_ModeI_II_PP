function [lineStyle, lineStyleName] = getLineStyle()

lineCell = {'Solid line'                               '-'	;
'Dashed line'                             '--';	
'Dash-dot line'                           '-.';	
'Dotted line'                              ':'};	

for i = 1:4
    lineStyle{i} = lineCell{i,2};
    lineStyleName{i} = lineCell{i,1}; 
end