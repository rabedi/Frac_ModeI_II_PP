function out = ReadVDatStatsFile(filePath )
%READVDATSTATSFILE reads .vds file based on known format
global DIM; DIM = 3;
%close all;
addpath '../';
addpath('aux_functions');
fid = fopen(filePath, 'r');
if fid <= 0
    msg = sprintf('file{%s} not accessible.\n',filePath);
    THROW(msg);
end



out = struct('serial', -1,...
    'count', 1,...
    'measure', 0.0,...
    'ncomp', 0,...
    'names', {{}},...
    'min', {{}},...
    'max', {{}},...
    't_min', inf,...
    't_max', -inf,...
    'mean', [],...
    'stdev', [],...
    'covariance', [],...
    'energyActive', 0,...
    'energy',[]);



%BEGIN READ
buf = READ(fid,'s');
if strcmpi(buf,'{') == 1
    buf = READ(fid,'s');
    while strcmpi(buf,'}') ~= 1
        if strcmpi(buf,'count') == 1
            out.count = READ(fid,'i');
        elseif strcmpi(buf,'measure') == 1
            out.measure = READ(fid,'d');
        elseif strcmpi(buf,'ncomp') == 1
            out.ncomp = READ(fid,'i');
            %resizing
            out.names = cell(out.ncomp,1);
            out.min = ext_struct(out.ncomp,1);
            out.max = ext_struct(out.ncomp,1);
            out.mean = NaN.*ones(out.ncomp,1);
            out.stdev = NaN.*ones(out.ncomp,1);
            out.covariance = NaN.*ones(out.ncomp);
            
            buf = READ(fid,'s');
            if strcmpi(buf,'{')==1
                buf = READ(fid,'s');
                while strcmpi(buf,'}') ~= 1                    
                    if strcmpi(buf,'i')==1
                        % I BLOCK READ
                        for I = 1:out.ncomp
                            buf = READ(fid,'s');
                            [~,status]=str2num(buf);
                            if status ~= 1
                                THROW('Invalid index.\n');
                            end
                            
                            index = str2num(buf) + 1;
                            
                            buf = READ(fid,'s');
                            if strcmpi(buf,'{')==1
                                buf = READ(fid,'s');
                                while strcmpi(buf,'}') ~= 1 
                                    if strcmpi(buf,'name')==1
                                        out.names{index} = READ(fid,'s');
                                    elseif strcmpi(buf,'min')==1
                                        out.min{index}.val = READ(fid,'d');
                                        READ(fid,'d');
                                        out.min{index}.X = READ(fid,'d',DIM);
                                        %out.min{index}.t = READ(fid,'d');
                                        READ(fid,'d');                                        
                                        %out.t_min = min([out.t_min, out.min{index}.t]);
                                        %out.t_max = max([out.t_max, out.min{index}.t]);
                                    elseif strcmpi(buf,'max')==1
                                        out.max{index}.val = READ(fid,'d');
                                        READ(fid,'d');
                                        out.max{index}.X = READ(fid,'d',DIM);
                                        %out.max{index}.t = READ(fid,'d');
                                        READ(fid,'d');
                                        %out.t_min = min([out.t_min, out.max{index}.t]);
                                        %out.t_max = max([out.t_max, out.max{index}.t]);
                                    elseif strcmpi(buf,'mean')==1
                                        out.mean(index) = READ(fid,'d');
                                    elseif strcmpi(buf,'stdev')==1
                                        out.stdev(index) = READ(fid,'d');
                                        out.covariance(index,index) = (out.stdev(index)*out.stdev(index));
                                    elseif strcmpi(buf,'}') ~= 1 
                                        THROW('Invalid option.\n');
                                    end                                    
                                    buf = READ(fid,'s');
                                end
                            else
                               THROW('block must begin with "{" character.\n')  
                            end
                        end
                    elseif strcmpi(buf,'ij')==1
                        % IJ BLOCK READ                        
                        for IJ = 1:(out.ncomp*out.ncomp)
                            buf = READ(fid,'s');
                            [~,status]=str2num(buf);
                            if status ~= 1
                                THROW('Invalid index.\n');
                            end
                            
                            indexI = str2num(buf) + 1;
                            indexJ = READ(fid,'i') + 1;
                            buf = READ(fid,'s');
                            if strcmpi(buf,'{')==1
                                buf = READ(fid,'s');
                                while strcmpi(buf,'}') ~= 1 
                                    if strcmpi(buf,'var')==1
                                        out.covariance(indexI,indexJ) = READ(fid,'d');                                    
                                    elseif strcmpi(buf,'}') ~= 1 
                                        THROW('Invalid option.\n');
                                    end                                    
                                    buf = READ(fid,'s');
                                end
                            else
                               THROW('block must begin with "{" character.\n')  
                            end
                        end
                    elseif strcmpi(buf,'}')~=1
                        THROW('Invalid option.\n');
                    end
                    buf = READ(fid,'s');
                end
            else
               THROW('block must begin with "{" character.\n') 
            end
        elseif strcmpi(buf,'}') ~= 1
            THROW('Invalid option.\n');
        end
        buf = READ(fid,'s');
    end
else
    THROW('File must begin with "{" character.\n');
end
fclose(fid);
end

function estruct = ext_struct(nr,nc)
global DIM
    estruct = cell(nr,nc);
    for i = 1:nr
        for j = 1:nc
            estruct{i,j} = struct('val',NaN, 'X',zeros(DIM,1));%, 't',0.0);
        end
    end
end

