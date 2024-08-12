%function [Pout, deltaUout] = PvsDisp(obj, syncFilePath, flags2Sgn)
function [edge] = PvsDisp(obj, syncFilePath, flags2Sgn)
global strStrnOut

[path, file, ~] = fileparts(syncFilePath);

if obj.numFields == 0
    STAT = fopen([fullfile(path,file),'.stat'],'r');        
    if STAT > 0
          obj = readStatFile(STAT,obj);
          fclose(STAT);
    else
       THROW(['ERROR:File(',fullfile(path,file),'.stat) not open for access']); 
    end
end

global STDIM; STDIM = 3;

xindex = 2;
tindex = 2 + STDIM - 1;
bindex = tindex + 2;
flgindex = bindex + 4;
szindex = flgindex + 2;
valsindex = szindex + 2;

global m; m = 1; %MIN INDEx
global M; M = 2; %MAX INDEX

minim = @(v1,v2) min([v1 v2]);
maxim = @(v1,v2) max([v1 v2]);

uin0 = obj.find('uin0') + 1;
uin1 = obj.find('uin1') + 1;
s0 = obj.find('s0') + 1;
s1 = obj.find('s1') + 1;

edge = cell(length(flags2Sgn),1);
setter = struct('P',zeros(1,STDIM-1),...
    'U',zeros(1,STDIM-1),...
    'L',[inf inf; -inf -inf],...
    'T',0.0);
edge(:) = {setter};

TXT = fopen([fullfile(path,file),'.txt'],'r');
if TXT > 0
   pcounter = 1; 
   while ~feof(TXT)
      %=================================
      % OPERATION PER SEGMENT
      buf = READ(TXT,'s');      
      if ~feof(TXT)
          numP = READ(TXT,'i');
          try
              X = nan.*ones(numP,STDIM-1);
              T = nan.*ones(numP,1);
              S = nan.*ones(numP,STDIM-1);
              U = nan.*ones(numP,STDIM-1);
          catch e
             disp(e); 
          end
          farg = FGETL(TXT);
          args = strsplit(farg);
          isBoundary = (str2double(args{bindex}) == 1); 
          if isBoundary == 0
              for i = 1:(numP-1)
                 farg = FGETL(TXT);
              end
          else
              %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              flg = str2double(args{flgindex+0});
              fi = find(flags2Sgn==flg);
              %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              X(1,:) = [str2double(args{xindex+0}), str2double(args{xindex+1})];
              T(1) = str2double(args{tindex});
              S(1,:) = [str2double(args{valsindex + s0 - 1}), str2double(args{valsindex + s1 - 1})];
              U(1,:) = [str2double(args{valsindex + uin0 - 1}), str2double(args{valsindex + uin1 - 1})]; 
              try
                edge{fi}.L = [arrayfun(minim,edge{fi}.L(m,:),X(1,:)); arrayfun(maxim,edge{fi}.L(M,:),X(1,:))];
              catch e
                  disp(e);
              end
              for i = 1:(numP-1)
                  farg = FGETL(TXT);
                  args = strsplit(farg); 
                  %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  flg = str2double(args{flgindex+0});
                  fi = find(flags2Sgn==flg);
                  %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
                  X(1+i,:) = [str2double(args{xindex+0}), str2double(args{xindex+1})];
                  T(1+i) = str2double(args{tindex});
                  S(1+i,:) = [str2double(args{valsindex + s0 - 1}), str2double(args{valsindex + s1 - 1})];
                  U(1+i,:) = [str2double(args{valsindex + uin0 - 1}), str2double(args{valsindex + uin1 - 1})];                  
                  edge{fi}.L = [arrayfun(minim,edge{fi}.L(m,:),X(1+i,:)); arrayfun(maxim,edge{fi}.L(M,:),X(1+i,:))];                  
              end             
              %=================================
              % OPERATION PER SEGMENT
              l = sqrt(sum((X(1:(numP-1),:) - X(2:numP,:)).^2,2)); 
              l = [l,l];
              s = (S(1:(numP-1),:) + S(2:numP,:)) ./ 2;
              u = (U(1:(numP-1),:) + U(2:numP,:)) ./ 2;

              try
                  edge{fi}.P = edge{fi}.P + sum(s.*l,1);
                  edge{fi}.U = edge{fi}.U + sum(u.*l,1);
                  edge{fi}.T = sum(T)/numel(T);                  
              catch e
                 disp(e); 
              end
              %=================================    
          end
      end
      %=================================
   pcounter = pcounter + 1;
   end
   fclose(TXT);
else
   THROW(['ERROR:File(',fullfile(path,file),'.txt) not open for access']); 
end

for fi=1:length(edge)
    edge{fi}.L = edge{fi}.L(2,:) - edge{fi}.L(1,:);
end
%==============
%OUTPUT
return;
%==============
end

function out = FGETL(fid)
out = fgetl(fid);
while isempty(out)
    out = fgetl(fid);
end
end

