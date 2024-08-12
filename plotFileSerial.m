function counter = plotFileSerial(xcol, ycol, linesp, col, directory, runname, middlename, flagnum, serial, name, ext, numberOfSegments, drawPoints)
global hcntr;
if (nargin < 12)
    numberOfSegments = -1;
end

if (nargin < 13)
    drawPoints = 1;
end


if (serial < 0)
    serial = -2;
end
filename = getFileName(directory, runname, middlename, flagnum, name, serial, ext);
fid = fopen(filename, 'r');
len = length(xcol);

counter = 0;
numberOfSegmentsIn = numberOfSegments;

if (numberOfSegments < 0)
    numberOfSegmentsIn = 1;
end
    

while ((fid ~= -1) && (serial ~= -1) && (counter < numberOfSegmentsIn))
    [noteof, numpts, data] = readBlock(fid, col);
    while ((noteof ~= 0)  && (counter < numberOfSegmentsIn))
        for i = 1:len
            plotSolutionBlock(xcol(i), ycol(i), linesp{i}, data, numpts, drawPoints);
        end
        counter = counter + 1;
        
%        if counter == 10000
%            return;
%        end

        hcntr = hcntr + 1;
        if (mod(hcntr , 100) == 0)
            fprintf(1,data(1,9));
        end
        if (numberOfSegments < 0)
            numberOfSegmentsIn = numberOfSegmentsIn + 1;
        end
        [noteof, numpts, data] = readBlock(fid, col);
    end
    serial = serial + 1;
    filename = getFileName(directory, runname, middlename, flagnum, name, serial, ext);
    fclose(fid);
    if (serial ~= -1)
        fid = fopen(filename, 'r');
    end
end
%fclose(fid);
