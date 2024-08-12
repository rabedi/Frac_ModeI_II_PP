classdef fracSegs < handle
    %fracSeg provides container to categoerize fracture segments based on
    %flag
    %   provides fields to enable deformation based FEM solution post
    %   processing
    %
    %Created: 4/12/2016
    
    properties(Access = public)
        numP = 0;
        dat;   %struct('X',[],'b',[],'styp',[],'flg',[],'flds',[])
        time;
    end
    
    properties(Access = private)
       timeInd = 3; 
    end
    
    methods(Access = public)
        function obj = fracSegs(np) %Should call with no input arguments
            if nargin < 1
                obj.dat = {};
                %proceed...
            else
               obj.numP = np;
               obj.dat = cell(1,np);
            end
        end
        
        function ti = getTimeIndex(obj)
            ti = obj.timeInd;
        end
        
        function read(obj,fid)
           if fid > 0
           buf = READ(fid); 
           if ~feof(fid)
               obj.numP = READ(fid,'i');
               for (i = 1:obj.numP)
                   obj.dat{i} = struct('X',[],'b',[],'styp',[],'flg',[],'flds',[]);
                   
                   buf = READ(fid);
                   obj.dat{i}.X = [];
                   for (j = 1:obj.timeInd) 
                       obj.dat{i}.X(j)= READ(fid,'d'); 
                   end
                   obj.time = obj.dat{i}.X(obj.timeInd);
                   obj.dat{i}.X = obj.dat{i}.X(1:obj.timeInd-1);
                   
                   buf = READ(fid); obj.dat{i}.b = READ(fid,'i');
                   buf = READ(fid); obj.dat{i}.styp = READ(fid,'i');
                   buf = READ(fid); obj.dat{i}.flg = READ(fid,'i');
                   buf = READ(fid); tempsz = READ(fid,'i');
                   
                   buf = READ(fid);
                   obj.dat{i}.flds = [];
                   try
                       for (j = 1:tempsz)
                           obj.dat{i}.flds(j) = READ(fid,'d');
                       end
                   catch e
                      disp(e); 
                   end
               end
           end
           else
               THROW('ERROR:File not open for access');
           end
        end
        
        function readBoundaries(obj,fid)
           if fid > 0
           buf = READ(fid); 
           if ~feof(fid)
               obj.numP = READ(fid,'i');
               for (i = 1:obj.numP)
                   obj.dat{i} = struct('X',[],'b',[],'styp',[],'flg',[],'flds',[]);
                   
                   vec = strsplit(fgetl(fid));
                   
                   buf = READ(fid);
                   obj.dat{i}.X = [];
                   for (j = 1:obj.timeInd) 
                       obj.dat{i}.X(j)= READ(fid,'d'); 
                   end
                   obj.time = obj.dat{i}.X(obj.timeInd);
                   obj.dat{i}.X = obj.dat{i}.X(1:obj.timeInd-1);
                   
                   buf = READ(fid); obj.dat{i}.b = READ(fid,'i');
                   buf = READ(fid); obj.dat{i}.styp = READ(fid,'i');
                   buf = READ(fid); obj.dat{i}.flg = READ(fid,'i');
                   buf = READ(fid); tempsz = READ(fid,'i');
                   
                   buf = READ(fid);
                   obj.dat{i}.flds = [];
                   try
                       for (j = 1:tempsz)
                           obj.dat{i}.flds(j) = READ(fid,'d');
                       end
                   catch e
                      disp(e); 
                   end
               end
           end
           else
               THROW('ERROR:File not open for access');
           end
        end
 
    end
    
end

