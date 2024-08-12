function visualizeFrames(fileNameBase,ext,workingDir,serialStart,serialInc,serialEnd)
fileNameBaseARG_POS = 1;
extARG_POS          = 2;
serialStartARG_POS  = 4;
serialIncARG_POS    = 5;
serialEndARG_POS    = 6;
workingDirARG_POS   = 3;

FRAMERATE = 2;
QUALITY = 100;
PROFILE = 'Motion JPEG AVI';

freeRead = 0;
if nargin < serialStartARG_POS
   serialStart = -1;
   serialInc = -1;
   serialEnd = -1;
   freeRead = 1;
end

if nargin < workingDirARG_POS
   workingDir = pwd; 
end

if nargin < extARG_POS
   ext = 'png'; 
end

if nargin > workingDirARG_POS
    if (nargin < serialIncARG_POS)
        THROW('Not enough argument inputs: "serialInc" & "serialEnd" missing');
    elseif (nargin < serialEndARG_POS)
        THROW('Not enough argument inputs: "serialStart" missing');
    end
end
    

    if (exist(workingDir,'dir')~=0)
       foldercontent = dir(workingDir);
        if (numel(foldercontent) > 2)%# folder exists and is not empty
            
            %shuttleVideo = VideoReader('shuttle.avi');
            if freeRead == 1;
                file = [fileNameBase,'*.',ext];
                imageNames = dir(fullfile(workingDir,file));
                imageNames = {imageNames.name}';
                
                %Ensures that name fits expression format(wildcard may add 
                %unwanted files that are admissible based on search).......
                expr = [fileNameBase,'+[0-9]+[a-zA-Z_0-9-=+| \s]+.',ext]; %ref:http://www.mathworks.com/help/matlab/ref/regexp.html#inputarg_expression
                imageNames = regexp(imageNames,expr,'match');
                imageNames = vertcat(imageNames{:});
                %..........................................................
            else
                imageNames = {};
                pos = 1;
                for s = serialStart:serialInc:serialEnd
                    file = [fileNameBase,sprintf('%010d',s),'.',ext];
                    tmpIM = dir(fullfile(workingDir,file));
                    if ~isempty(tmpIM)
                        imageNames{pos} = tmpIM.name;
                        pos = pos + 1;
                    else
                        continue;
                    end
                end
                imageNames = imageNames';
            end
        
            %Construct a VideoWriter object, which creates a Motion-JPEG AVI file by default.
            outputName = fileNameBase;
            writerObj = VideoWriter(fullfile(workingDir,outputName),PROFILE);

            writerObj.FrameRate = FRAMERATE;
            writerObj.Quality = QUALITY;
            
%             % set the seconds per image
%             secsPerImage = [5 10 15];
            
            open(writerObj)
            
             % load the images
            for ii = 1:length(imageNames)
               img{ii,1} = imread(fullfile(workingDir,imageNames{ii}));
            end
            
            % write the frames to the video
            for ii = 1:length(img)
                % convert the image to a frame
               frame = im2frame(img{ii});
               writeVideo(writerObj, frame);

            end 
            
            close(writerObj)
            
%             %--------------------------------------
%             ii = 1;
%             str = [workingDir,'_copy-',num2str(ii)];
%             while (exist(str, 'dir')~=0)
%                 ii = ii+1;
%                 str = [workingDir,'_copy-',num2str(ii)];
%             end
%             movefile(workingDir,str)
%             %---------------------------------------
            
%             shuttleAvi = VideoReader(fullfile(workingDir,'shuttle_out.avi'));
%             
%             ii = 1;
%             while hasFrame(shuttleAvi)
%                mov(ii) = im2frame(readFrame(shuttleAvi));
%                ii = ii+1;
%             end
%             
%             f = figure;
%             f.Position = [150 150 shuttleAvi.Width shuttleAvi.Height];
%             ax = gca;
%             ax.Units = 'pixels';
%             ax.Position = [0 0 shuttleAvi.Width shuttleAvi.Height];
%             image(mov(1).cdata,'Parent',ax)
%             axis off
%             
%             movie(mov,1,shuttleAvi.FrameRate)
            
            %credit: http://www.mathworks.com/help/matlab/examples/convert-between-image-sequences-and-video.html
            %ref: http://www.mathworks.com/matlabcentral/answers/153925-how-to-make-a-video-from-images
    
            
        end
    end
    
    
end