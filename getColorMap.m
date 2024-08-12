function [colorCode, colorName] = getColorMap()


colorCell = {'black'	   0	0	0;
 'dark_gray'	100	100	100;   
'green' 0 135 0;
'red'	   255	0	0; % comment out for Coh Trajectory Conv
'blue'	   0	0	255;
'orange'	255	102	0;
'magenta'	255	0	255;
'dark_blue'	   0	0	128;
'brown'	   128	64	0;
'teal'	   0	255	255;
'red2'      203 0   51;
'green_blue'	 0	128	64;
'light_gray'	   192	192	192;
'peach'	   255	128	128;
'yellow'	255	255	0; 
'arghavani'	 128	0	64;  
'dark_gray2'	128	128	128;   
'purple'	128	0	255;
'olive'	   128	128	0;
'blue2'	   64	128	128;
'rosy_pink'	255	128	192;	   
'purple2'	128	0	128;
'black'	   0	0	0};



for i = 1:20
    for j = 1:3
        temp(j) = colorCell{i, j + 1} / 255;
    end
    colorCode{i} = temp;
    
    colorName{i} = colorCell{i,1};
end

% FOR DISS ADAPT IMP FD CASE
% colorCell = {'black'	   0	0	0;
% 'red'	   255	0	0;
% 'green' 0 135 0;
% 'blue'	   0	0	255;
% 'dark_gray'	100	100	100;   
% 'orange'	255	102	0;
% 'magenta'	255	0	255;
% 'red2'      203 0   51;
% 'dark_blue'	   0	0	128;
% 'green_blue'	 0	128	64;
% 'brown'	   128	64	0;
% 'arghavani'	 128	0	64;  
% 'light_gray'	   192	192	192;
% 'teal'	   0	255	255;
% 'dark_gray2'	128	128	128;   
% 'purple'	128	0	255;
% 'olive'	   128	128	0;
% 'yellow'	255	255	0; 
% 'blue2'	   64	128	128;
% 'rosy_pink'	255	128	192;	   
% 'peach'	   255	128	128;
% 'purple2'	128	0	128};



% 
% colorCell = {'black'	   0	0	0;
% 'red'	   255	0	0;
% 'green' 0 135 0;
% 'blue'	   0	0	255;
% 'magenta'	255	0	255;
% 'orange'	255	102	0;
% 'red2'      203 0   51;
% 'dark_gray'	100	100	100;   
% 'dark_blue'	   0	0	128;
% 'green_blue'	 0	128	64;
% 'brown'	   128	64	0;
% 'arghavani'	 128	0	64;  
% 'light_gray'	   192	192	192;
% 'teal'	   0	255	255;
% 'dark_gray2'	128	128	128;   
% 'purple'	128	0	255;
% 'olive'	   128	128	0;
% 'yellow'	255	255	0; 
% 'blue2'	   64	128	128;
% 'rosy_pink'	255	128	192;	   
% 'peach'	   255	128	128;
% 'purple2'	128	0	128};


% colorCell = {'dark_gray'	100	100	100;   
% 'green' 0 135 0;
% 'red'	   255	0	0;
% 'blue'	   0	0	255;
% 'black'	   0	0	0;
% 'orange'	255	102	0;
% 'magenta'	255	0	255;
% 'red2'      203 0   51;
% 'dark_blue'	   0	0	128;
% 'green_blue'	 0	128	64;
% 'brown'	   128	64	0;
% 'arghavani'	 128	0	64;  
% 'light_gray'	   192	192	192;
% 'teal'	   0	255	255;
% 'dark_gray2'	128	128	128;   
% 'purple'	128	0	255;
% 'olive'	   128	128	0;
% 'yellow'	255	255	0; 
% 'blue2'	   64	128	128;
% 'rosy_pink'	255	128	192;	   
% 'peach'	   255	128	128;
% 'purple2'	128	0	128};