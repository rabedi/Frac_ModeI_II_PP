function out = ReadVDatStatsFileMatrix(out, filePath, s)
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

count = -1;
measure = 0.0;
ncomp = 0.0;
vals = [];
covs = [];

ttemp = [inf -inf];

m = 1;
M = 2;
mu = 3;
sig = 4;
num_stats = 4;

%BEGIN READ
buf = READ(fid,'s');
if strcmpi(buf,'{') == 1
    buf = READ(fid,'s');
    while strcmpi(buf,'}') ~= 1
        if strcmpi(buf,'count') == 1
            count = READ(fid,'i');
        elseif strcmpi(buf,'measure') == 1
            measure = READ(fid,'d');
        elseif strcmpi(buf,'ncomp') == 1
            ncomp = READ(fid,'i');
            %resizing
            if isempty(out.names)
                out.names = cell(1,ncomp);
            end
            vals = nan.*ones(num_stats,ncomp);
            covs = nan.*ones(ncomp,ncomp);
            
            buf = READ(fid,'s');
            if strcmpi(buf,'{')==1
                buf = READ(fid,'s');
                while strcmpi(buf,'}') ~= 1                    
                    if strcmpi(buf,'i')==1
                        % I BLOCK READ
                        for I = 1:ncomp
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
                                        vals(m,index) = READ(fid,'d');
                                        READ(fid,'d');
                                        READ(fid,'d',DIM);
                                        READ(fid,'d');                                        
                                    elseif strcmpi(buf,'max')==1
                                        vals(M,index) = READ(fid,'d');
                                        READ(fid,'d');
                                        READ(fid,'d',DIM);
                                        READ(fid,'d');
                                    elseif strcmpi(buf,'mean')==1
                                        vals(mu,index) = READ(fid,'d');
                                    elseif strcmpi(buf,'stdev')==1
                                        vals(sig,index) = READ(fid,'d');
                                        covs(index,index) = (vals(sig,index)*vals(sig,index));
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
                        for IJ = 1:(ncomp*ncomp)
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
                                        covs(indexI,indexJ) = READ(fid,'d');                                    
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

%========================
out.vals(:,:,s) = vals;
out.covs(:,:,s) = covs;
out.count(s) = count;
out.measure(s) = measure; 
%========================

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

