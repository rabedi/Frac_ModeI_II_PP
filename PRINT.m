%Function implemented to reduce time and computational cost of matlab print
%function
function PRINT(arg1, arg2)

if nargin < 2
    OutputName = arg1;
    FigH = gcf();
else
    FigH = arg1;
    OutputName = arg2;
end

unitz = 'normalized';
drawnow;
fig_Renderer     = get(FigH, 'Renderer');
fig_Paperposmode = get(FigH, 'PaperPositionMode');
fig_PaperOrient  = get(FigH, 'PaperOrientation');
fig_Invhardcopy  = get(FigH, 'InvertHardcopy');
set(FigH, ...
   'Color', 'white', ... %PC
   'PaperPositionMode', 'auto', ...
   'PaperOrientation',  'landscape', ...%PC
   'InvertHardcopy',    'off');

   % Simulate PRINT command (save time for writing and reading image file):
   % Set units of axes and text from PIXELS to POINTS to keep their sizes
   % independent from from the output resolution:
   % See: graphics/private/preparehg.m
   root_SHH     = get(0, 'ShowHiddenHandles');
   set(0, 'ShowHiddenHandles', 'on');
   text_axes_H  = [findobj(FigH, 'Type', 'axes'); ...
         findobj(FigH, 'Type', 'text')];
   pixelObj     = findobj(text_axes_H, 'Units',     'pixels');
   fontPixelObj = findobj(text_axes_H, 'FontUnits', 'pixels');
   set(pixelObj,     'Units',     'points');
   set(fontPixelObj, 'FontUnits', 'points'); %'points'->units
   % Set image driver:
   if strcmpi(fig_Renderer, 'painters')
      imageDriver = '-dzbuffer';
   else
      imageDriver = ['-d', fig_Renderer];
   end
   fig_ResizeFcn = get(FigH, 'ResizeFcn');
   set(FigH, 'ResizeFcn', '');
   % "Normal" is the only erasemode, which can be rendered!
   % See: NOANIMATE.
   ver = version;
   if ( all(ver(1) >= [7, 8]) )  % Faster method for modern FINDOBJ:
      EraseModeH = findobj(FigH, 'EraseMode', 'normal', '-not');
   else
      EraseModeH = [ ...
         findobj(FigH, 'EraseMode', 'xor'); ...
         findobj(FigH, 'EraseMode', 'none'); ...
         findobj(FigH, 'EraseMode', 'background')];
   end
   EraseMode = get(EraseModeH, {'EraseMode'});
   set(EraseModeH, 'EraseMode', 'normal');
   % Get image as RGB array:
   ResolutionStr = '-r300';
   %2019
   rgbArray = print(FigH, '-RGBImage'); %imageDriver, ResolutionStr); % May be obsolete
%   rgbArray = hardcopy(FigH, imageDriver, ResolutionStr); % May be obsolete
   % Restore units of axes and text objects, and EraseMode:
   set(pixelObj,     'Units',     'pixels');
   set(fontPixelObj, 'FontUnits', 'pixels');
   set(EraseModeH, {'EraseMode'}, EraseMode);
   set(0, 'ShowHiddenHandles', root_SHH);
   set(FigH, 'ResizeFcn', fig_ResizeFcn);
   
   imwrite(rgbArray,OutputName);
   
   % ref: http://www.mathworks.com/matlabcentral/answers/56433-is-there-a-computationally-fast-way-to-save-figures-as-pictures
    %ref: http://www.mathworks.com/help/matlab/ref/figure-properties.html#prop_PaperPosition
end

%Function implemneted to monitor status screen while plotting
function STATUS(maxpts,poc) %poc := point of completion

marker = '#';
space = ' ';
str = '';
for i=1:maxpts
    if i <= poc
        str = [str,marker];
    else
        str = [str,space];
    end
end

bar = str;

bar = ['Status[',bar,']'];

if poc ~= 0
    for i=1:length(bar)
        fprintf(1,'\b');
    end
else
    fprintf(1,'\n');
end
fprintf(1,'%s',bar);

if poc == maxpts
    pause(1);
    for i=1:length(bar)+1
        fprintf(1,'\b');
    end
end

end

