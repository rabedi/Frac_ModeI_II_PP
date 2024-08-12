function scaleMatlabFig(figHandle, whichAxes, scale)

if nargin < 3
   scale = 1.0; 
end

if nargin < 2
   whichAxes = 'all'; 
end

if nargin < 1
   figHandle = gcf(); 
end

if isempty(figHandle)
    error('Empty Figure handle.');
elseif ~isvalid(figHandle)
    error('Invalid figure handle');
end

axesObjs = get(figHandle, 'Children');  %axes handles
axHandle = findall(figHandle,'type','axes');
dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes

dims = 3;
for i = 1:length(dataObjs)
   if ~isempty(dataObjs{i})
      Xd = cell(length(dataObjs{i}),dims); 
      ht = cell(length(dataObjs{i}),1);
      for j = 1:length(dataObjs{i})
         ht{j} = dataObjs{i}(j);
         
         Xd{j,1} = get(ht{j},'XData');
         Xd{j,2} = get(ht{j},'YData');
         Xd{j,3} = get(ht{j},'ZData');
         
         try
             if ~isa(ht{j},'matlab.graphics.primitive.Patch')
                 ht{j}.XDataSource = ['Xd{',num2str(j),',1}'];
                 ht{j}.YDataSource = ['Xd{',num2str(j),',2}'];
                 if ~isempty(Xd{j,3})
                    ht{j}.ZDataSource = ['Xd{',num2str(j),',3}'];
                 end
             end
         catch excep
            disp(excep); 
         end
         
         if strcmpi(whichAxes,'none') ~= 1
             if ~isempty(Xd{j,3})
                 if strcmpi(whichAxes,'z')==1 || strcmpi(whichAxes,'all')==1
                    Xd{j,3} = scale.*Xd{j,3};  
                    if isa(ht{j},'matlab.graphics.primitive.Patch') == 1
                        set(ht{j},'ZData',Xd{j,3});
                    end
                 end
             end 
             if ~isempty(Xd{j,2})
                 if strcmpi(whichAxes,'y')==1 || strcmpi(whichAxes,'all')==1
                     Xd{j,2} = scale.*Xd{j,2};
                     if isa(ht{j},'matlab.graphics.primitive.Patch') == 1 
                        set(ht{j},'YData',Xd{j,2});
                    end
                 end
             else
                 error('y axis cannot  be empty.');
             end 
             if ~isempty(Xd{j,1})
                 if strcmpi(whichAxes,'x')==1 || strcmpi(whichAxes,'all')==1
                     Xd{j,1} = scale.*Xd{j,1};
                     if isa(ht{j},'matlab.graphics.primitive.Patch') == 1
                        set(ht{j},'XData',Xd{j,1});
                    end
                 end
             else
                 error('x axis cannot  be empty.');
             end
         end
         
         if isa(ht{j},'matlab.graphics.chart.primitive.Contour') == 1
            ht{j}.LevelList = scale.*ht{j}.LevelList;
         end
      end 
      refreshdata(dataObjs{i},'caller')
       
%       if strcmpi(whichAxes,'z')==1 || strcmpi(whichAxes,'all')==1                 
%         axHandle.ZLim = scale.*axHandle.ZLim;
%       end
%       if strcmpi(whichAxes,'y')==1 || strcmpi(whichAxes,'all')==1                 
%         axHandle.YLim = scale.*axHandle.YLim;
%       end
%       if strcmpi(whichAxes,'x')==1 || strcmpi(whichAxes,'all')==1                 
%         axHandle.XLim = scale.*axHandle.XLim;
%       end
  end
end
end
