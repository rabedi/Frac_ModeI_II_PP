%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Free form file reading
%
%Created 4/11/2016
%
% single line comments are preceeded by '#' 
%(NB: ensure to add white space between text and # character)

% comment blocks are preceeded by '#{' and ended with '#}'
% (NB: for comment block, a space is required between end characters and
% active file fields. 
% It is recommended to start a new line after comment
% block end characters)
%
%'numReads' can either be a specified value or string of containing braces
% if numReads is not specified it is set to default =1
% if numReads is defined as integer value it is set to that input
% if numReads is defined as string, the string must contain start and end
% braces for vector containment e.g. numReads = '[ ]'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = READ(FID,readType,numReads)
    if nargin < 3
        numReads = 1;
    end

    if nargin < 2
       readType = 's'; 
    end
    
    if isnumeric(numReads)
        if numReads > 1
            tempOut = cell(1,numReads);
            for i = 1:numReads
                tempOut{i} = READ_SPEC(FID,readType);
            end
        else
            tempOut = READ_SPEC(FID,readType);
        end

        if strcmp(readType,'s')
            %continue...
        else
            if numReads > 1
                tempOut = cell2mat(tempOut);
            else
                %continue...
            end
        end
    else
        leftBrac = numReads(1);
        rightBrac = numReads(length(numReads));
        tempOut = {};
        closedBrac = [leftBrac,rightBrac];
        
        buf = READ(FID,'s');
        if strcmp(buf,leftBrac) ~= 1
            THROW(['ERROR: vector must start with ',leftBrac]);
        elseif strcmp(buf,closedBrac) == 1
            %Leaves vector empty.....
        else
            ind = 1;
            buf = READ(FID,'s');
            while strcmp(buf,rightBrac) ~= 1
                if strcmp(readType,'s')
                    tempOut{ind} = buf;
                else
                    tempOut{ind} = str2num(buf);
                end
                ind = ind + 1;
                buf = READ(FID,'s');
            end
            
            if strcmp(readType,'s')
            %continue...
            else
               tempOut = cell2mat(tempOut);
            end
        end  
    end
    
    out = tempOut;
end

function out = READ_SPEC(fid,readType)
CsLbegin = '#';
CmLbegin = '#{';
CmLend = '#}';

if nargin < 2
   readType = 's'; 
end

    if fid > 0
        out = fscanf(fid,'%s',1);
        if feof(fid) && (strcmp(out,'\n') ~= 1)
           errorMsg = strcat('EOF reached');
%           fprintf(1,'%s\n',errorMsg);
           return;
%          pause;
        end
        
        while isempty(out) || any(isspace(out)) || (strcmp(out,'\n') == 1)
            out = fscanf(fid,'%s',1);
        end
        
        tempstrArray = char(out);
        lenArray = length(tempstrArray);
        if strcmp(tempstrArray(1),CsLbegin) == 1
           if lenArray == 1
               buf = textscan(fid,'%[^\n]',1);
               out = READ(fid,readType);
           elseif strcmp(tempstrArray(1:2),CmLbegin) ~= 1 %single line read comment
               buf = textscan(fid,'%[^\n]',1);   
               out = READ(fid,readType);
           else %comment block
               if isempty(strfind(out,CmLend))
                    buf = fscanf(fid,'%s',1);
               else
                    buf = out;
               end
               if feof(fid) && strcmp(out,'\n') ~= 1
                    errorMsg = strcat('ERROR: Comment block not properly terminated');
                    fprintf(1,'%s',errorMsg);
                    pause;
               end
               
               while isempty(strfind(buf,CmLend))
                   buf = fscanf(fid,'%s',1);
                   if feof(fid)
                      errorMsg = strcat('ERROR: Comment block not properly terminated');
                      fprintf(1,'%s',errorMsg);
                      pause;
                   end
               end
               out = READ(fid,readType);
           end
        else
            out = READ_SPECIFIC(readType,out);
            return;
        end
    else
        errorMsg = strcat('ERROR: File not open for access');
        fprintf(1,'%s',errorMsg);
        pause;
    end
%ref: http://matlab.izmiran.ru/help/techdoc/ref/textscan.html
end

function out = READ_SPECIFIC(Type,in)

if strcmp(Type,'b') == 1 %boolean
    [buf,status] = str2num(in);
    if status == 1
       if buf == 1 || buf == 0 
            num = buf;
       end
    else
        if strcmpi(in(1),'y') == 1 || strcmpi(in(1),'n') == 1 || strcmpi(in,'true') == 1 || strcmpi(in,'false') == 1 || strcmpi(in,'on') == 1 || strcmpi(in,'off') == 1
            if strcmpi(in(1),'y') == 1 || strcmpi(in,'true') == 1 || strcmpi(in,'on') == 1
                num = 1;
            else
                num = 0;
            end
        else
%         errorMsg = strcat('ERROR:(',in,') is not boolean type');
%         fprintf(1,'%s',errorMsg);
%         pause;
            msg = sprintf('ERROR:(%s) is not boolean type',in);
            THROW(msg);
        end
    end
    out = num;
    return;
elseif strcmp(Type,'s') ~= 1
%    format = ['%',Type];
    [buf,status] = str2num(in);    
    if status == 1
       num = buf;
    else
        errorMsg = strcat('ERROR:(',in,') is not numeric');
        fprintf(1,'%s',errorMsg);
        pause;
    end
    out = num;
    return;
end
    
    out = in;
    return;
end

% function out = READ(fid,readType)
% CsLbegin = '#';
% CmLbegin = '#{';
% CmLend = '#}';
% 
% if nargin < 2
%    readType = 's'; 
% end
% 
%     if fid > 0
%         out = textscan(fid,'%s',1);
%         if feof(fid)
%            errorMsg = strcat('ERROR: EOF reached');
%            fprintf(1,'%s',errorMsg);
%            pause;
%         end
%         
%         while isempty(out) || isspace(out{1})
%             out = textscan(fid,'%s',1);
%         end
%         
%         tempstrArray = char(out{1});
%         lenArray = length(tempstrArray);
%         if strcmp(tempstrArray(1),CsLbegin) == 1
%            if lenArray == 1
%                buf = textscan(fid,'%[^\n]');
%                out = READ(fid,readType);
%            elseif strcmp(tempstrArray(1:2),CmLbegin) ~= 1 %single line read comment
%                buf = textscan(fid,'%[^\n]');
%                out = READ(fid,readType);
%            else %comment block
%                buf = textscan(fid,'%s',1);
%                if feof(fid)
%                     errorMsg = strcat('ERROR: Comment block not properly terminated');
%                     fprintf(1,'%s',errorMsg);
%                     pause;
%                end
%                
%                while isempty(strfind(buf,CmLend))
%                    buf = textscan(fid,'%s',1);
%                    if feof(fid)
%                       errorMsg = strcat('ERROR: Comment block not properly terminated');
%                       fprintf(1,'%s',errorMsg);
%                       pause;
%                    end
%                end
%                out = READ(fid,readType);
%            end
%         else
%             out = READ_SPECIFIC(readType,char(out{1}));
%             return;
%         end
%     else
%         errorMsg = strcat('ERROR: File not open for access');
%         fprintf(1,'%s',errorMsg);
%         pause;
%     end
% %ref: http://matlab.izmiran.ru/help/techdoc/ref/textscan.html
% end