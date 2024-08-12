function [markerStyle, markerName] = getMarkerStyle()

markerCell = {'none'                  'none';  
'Cross'                               'x'	;
'Plus sign'                           '+';	
'Diamond'                             'd';	
'Circle'                              'o';	
'Square'                              's';	
'Asterisk'                            '*';
'Upward-pointing triangle'            '^';
'Five-pointed star (pentagram)'       'p';
'Downward-pointing triangle'          'v';
'Six-pointed star (hexagram)'         'h';
'Right-pointing triangle'             '>';
'Left-pointing triangle'              '<';
'Point'                               '.'};

for i = 1:14
    markerStyle{i} = markerCell{i,2};
    markerName{i} = markerCell{i,1}; 
end