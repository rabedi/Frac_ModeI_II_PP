function loc = getLegendLocation(aloc)

if (strcmp(aloc, 'n') == 1)
    loc = 'North';
elseif (strcmp(aloc, 's') == 1)
    loc = 'South';
elseif (strcmp(aloc, 'e') == 1)
    loc = 'East';
elseif (strcmp(aloc, 'w') == 1)
    loc = 'West';
elseif (strcmp(aloc, 'nw') == 1)
    loc = 'NorthWest';
elseif (strcmp(aloc, 'ne') == 1)
    loc = 'NorthEast';
elseif (strcmp(aloc, 'se') == 1)
    loc = 'SouthEast';
elseif (strcmp(aloc, 'sw') == 1)
    loc = 'SouthWest';
elseif (strcmp(aloc, 'no') == 1)
    loc = 'NorthOutside';
elseif (strcmp(aloc, 'so') == 1)
    loc = 'SouthOutside';
elseif (strcmp(aloc, 'eo') == 1)
    loc = 'EastOutside';
elseif (strcmp(aloc, 'wo') == 1)
    loc = 'WestOutside';
else
    loc = 'Best';
end