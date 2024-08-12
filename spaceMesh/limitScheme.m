classdef limitScheme < handle
    
    properties(Access = public)
        index;              %reference index
        numberDistPts;      %integer value
        clrmap;             %string value; colormap for color retrieval
        nInf;               %integer boolean which indicates if negative Inf is to be added to levels
        pInf;               %integer boolean which indicates if positive Inf is to be added to levels
        distLevels;         %struct('level',[],'lStyle',[],'lClr',[],'lWidth',[])
        
        damageLevelsFlag;
        includeRefinementClrs;
        pltDmgdUnDmaged;
        
    end
 
    methods(Access = public)
        function obj = limitScheme()
            obj.index = -1;
            obj.damageLevelsFlag = 2;
            obj.includeRefinementClrs = 0;
            obj.numberDistPts = -1;
            obj.clrmap = 'jet';
            obj.nInf = 0;
            obj.pInf = 0;
            obj.distLevels = struct('level',[],'lStyle',[],'lClr',[],'lWidth',[]);
        end
        
        function read(obj,fid)
            head = '{';
            tail = '}';
            
            temphead = READ(fid);
            if strcmp(temphead,head) == 1
                 obj.index = READ(fid,'i');
                 buf = READ(fid);
                 obj.damageLevelsFlag = READ(fid,'i');
                 buf = READ(fid);
                 obj.includeRefinementClrs = READ(fid,'i');
                 buf = READ(fid);
                 obj.numberDistPts = READ(fid,'i');
                 buf = READ(fid);
                 clrmapActive = READ(fid,'i');
                 buf = READ(fid);
                 obj.clrmap = READ(fid,'s');
                 buf = READ(fid);
                 obj.nInf = READ(fid,'i');
                 buf = READ(fid);
                 obj.pInf = READ(fid,'i');
                 
                 for (i = 1:5) buf = READ(fid); end

                 obj.distLevels.level = [];
                 obj.distLevels.lClr = {};
                 obj.distLevels.lStyle = {};
                 obj.distLevels.lWidth = [];
                 
                 if obj.damageLevelsFlag ~= 3 % Not added option for range based points with colorbar color definitions
                     maxCount = obj.numberDistPts;
                 else
                     maxCount = 2;
                 end
                 
                 if clrmapActive == 1
                    Index2Colormap = mapClr(obj.clrmap,obj.numberDistPts); 
                 end
                 
                 i = 1;
                 while (i < maxCount + 1)
                     %READ IN OF TEMP VALUE HOLDERS========================
                     tmplevel = READ(fid,'i');
                     if clrmapActive == 0
                        tmplClr = readClr(fid);
                     else
                        tmplClr = READ(fid,'i');
                     end
                     tmplStyle = READ(fid,'s');
                     tmplWidth = READ(fid,'i');
                     %=====================================================
                     %
                     %
                     if obj.pInf == 1 && i == 1 %Add positive infinity if active
                         obj.distLevels.level(i) = +Inf;
                         if clrmapActive == 0
                             obj.distLevels.lClr{i} = tmplClr;
                         else
                             obj.distLevels.lClr{i} = Index2Colormap(tmplClr,:);
                         end
                         obj.distLevels.lStyle{i} = tmplStyle;
                         obj.distLevels.lWidth(i) = tmplWidth;
                         maxCount = maxCount + 1;
                         i = i + 1;
                     end%==================================================
                     
                     
                  
                     obj.distLevels.level(i) = tmplevel;
                     if clrmapActive == 0
                         obj.distLevels.lClr{i} = tmplClr;
                     else
                         obj.distLevels.lClr{i} = Index2Colormap(tmplClr,:);
                     end
                     obj.distLevels.lStyle{i} = tmplStyle;
                     obj.distLevels.lWidth(i) = tmplWidth;
                     
                     
                     
                     %=====================================================
                     %block for range based input of points
                     if obj.damageLevelsFlag == 3 && i == 1 && clrmapActive == 1
                         incrementalDistPts = obj.numberDistPts - 2;
                         for (j = 1:incrementalDistPts)
                             i = i + 1;
                             maxCount = maxCount + 1;
                             %
                             obj.distLevels.level(i) = tmplevel;
                             obj.distLevels.lClr{i} = Index2Colormap(tmplClr,:);
                             obj.distLevels.lStyle{i} = tmplStyle;
                             obj.distLevels.lWidth(i) = tmplWidth;       
                         end                        
                     end
                     %=====================================================
                     
                     
                     if obj.nInf == 1 && i == maxCount %Add negative infinity if active
                         i = i + 1;
                         maxCount = maxCount + 1;
                         obj.distLevels.level(i) = -Inf;
                         if clrmapActive == 0
                             obj.distLevels.lClr{i} = tmplClr;
                         else
                             obj.distLevels.lClr{i} = Index2Colormap(tmplClr,:);
                         end
                         obj.distLevels.lStyle{i} = tmplStyle;
                         obj.distLevels.lWidth(i) = tmplWidth;
                     end%==================================================
                     
                     i = i + 1;
                 end
                 obj.numberDistPts = maxCount;
                 if obj.damageLevelsFlag == 3 %switch flag to use rest of function unchanged
                                              %treating the levels as distinct levels with flag -2
                     obj.damageLevelsFlag = -2;
                 end

                 obj.levelSet();
                 
                 buf = READ(fid);
                 obj.pltDmgdUnDmaged = READ(fid,'i');
                 temptail = READ(fid);
                 if strcmp(temptail,tail) == 1
                     %proceed....
                 else
                   errMsg = strcat('ERROR: Block must end with "}"');
                   fprintf(1,'%s',errMsg);
                   pause; 
                 end
                 
            else
               errMsg = strcat('ERROR: Block must start with "{"');
                   fprintf(1,'%s',errMsg);
                   pause; 
            end
        end
        
    end
    
    methods(Access = private)
       function levelSet(obj)
           testVal = abs(obj.damageLevelsFlag);
           switch(testVal)
               case 1
                   switch(obj.damageLevelsFlag)
                       case -1
                           obj.distLevels.level = obj.distLevels.level(obj.numberDistPts);
                       otherwise
                           obj.distLevels.level = obj.distLevels.level(1);
                   end
                   obj.numberDistPts = 1;
                   
                   temp = obj.distLevels.lClr{1};
                   obj.distLevels.lClr = {};
                   obj.distLevels.lClr{1} = temp;
                   
                   temp = obj.distLevels.lStyle{1};
                   obj.distLevels.lStyle = {};
                   obj.distLevels.lStyle{1} = temp;
                   
                   obj.distLevels.lWidth = obj.distLevels.lWidth(1);
               case 2
                   switch(obj.damageLevelsFlag)
                       case 2
                            num = obj.numberDistPts;
                            tmp1 = obj.distLevels.level(1);
                            tmp2 = obj.distLevels.level(num);
                            obj.distLevels.level = [];
                            obj.distLevels.level(1) = tmp1;
                            obj.distLevels.level(2) = tmp2;
                            
                            obj.numberDistPts = 2;
                            
                            tmp1 = obj.distLevels.lClr{1};
                            tmp2 = obj.distLevels.lClr{num};
                            obj.distLevels.lClr = {};
                            obj.distLevels.lClr{1} = tmp1;
                            obj.distLevels.lClr{2} = tmp2;
                            
                            tmp1 = obj.distLevels.lStyle{1};
                            tmp2 = obj.distLevels.lStyle{num};
                            obj.distLevels.lStyle = {};
                            obj.distLevels.lStyle{1} = tmp1;
                            obj.distLevels.lStyle{2} = tmp2;
                            
                            tmp1 = obj.distLevels.lWidth(1);
                            tmp2 = obj.distLevels.lWidth(num);
                            obj.distLevels.lWidth = [];
                            obj.distLevels.lWidth(1) = tmp1;
                            obj.distLevels.lWidth(2) = tmp2; 
                       otherwise
                           %... do nothing and use all levels specified in
                           %config file
                   end
                   
               otherwise
                   errMsg = strcat('ERROR:(',obj.damageLevelsFlag,') not a valid flag');
                   fprintf(1,'%s',errMsg);
                   pause;
           end
       end
    end
    
end