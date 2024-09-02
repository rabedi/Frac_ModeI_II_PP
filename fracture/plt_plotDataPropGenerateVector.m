function getPropVector = plt_plotDataPropGenerateVector(clr, table, szVec, addMarker)

if (nargin < 4)
    addMarker = 0;
end

if (clr == 1)
    addMarker = 0;
end

mrks = {'none', 'o', 's', 'x', '+', '<'};
numMrkChange = 4;
val_markerSize = 6;

if (clr == 1)
    for i = 1:szVec
        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorNameClrTb{i, 2};
    end
else
    if (addMarker == 0)
        i = 1;
        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{1};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{1};
        if (szVec == i)
            return;
        end
        i = i + 1;

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{1};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{2};
        if (szVec == i)
            return;
        end
        i = i + 1;

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{1};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{3};
        if (szVec == i)
            return;
        end
        i = i + 1;    

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{1};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{4};
        if (szVec == i)
            return;
        end
        i = i + 1;    

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{2};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{1};
        if (szVec == i)
            return;
        end
        i = i + 1;    

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{2};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{2};
        if (szVec == i)
            return;
        end
        i = i + 1;    


        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{2};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{3};
        if (szVec == i)
            return;
        end
        i = i + 1;    

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{3};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{1};
        if (szVec == i)
            return;
        end
        i = i + 1;    

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{3};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{2};
        if (szVec == i)
            return;
        end
        i = i + 1;    

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{3};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{3};
        if (szVec == i)
            return;
        end
        i = i + 1;    

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{4};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{1};
        if (szVec == i)
            return;
        end
        i = i + 1;    

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{4};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{2};
        if (szVec == i)
            return;
        end
        i = i + 1;    

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{4};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{3};
        if (szVec > i)
            fprintf(1, 'size %d szVec too large\n', szVel);
        end
    else

        i = 1;
        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{1};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{1};
        if (szVec == i)
            return;
        end
        i = i + 1;

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{1};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{2};
        if (szVec == i)
            return;
        end
        i = i + 1;

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{1};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{3};
        if (szVec == i)
            return;
        end
        i = i + 1;    

        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{1};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{4};
        if (szVec == i)
            return;
        end
        
        i = i + 1;
        getPropVector{i} = plt_plotDataProp;
        getPropVector{i}.val_lineColor = table.colorBWTb{2};
        getPropVector{i}.val_lineStyle = table.lineStyleTb{1};
        if (szVec == i)
            return;
        end

        j = i;
        for i = j + 1:szVec
            getPropVector{i} = plt_plotDataProp;
            getPropVector{i}.val_lineColor = table.colorBWTb{1};
            getPropVector{i}.val_lineStyle = table.lineStyleTb{1};

            getPropVector{i}.val_marker = mrks{i - j + 1};
            getPropVector{i}.val_markerEdgeColor = getPropVector{i}.val_lineColor;
            getPropVector{i}.val_markerFaceColor = 'none';
            getPropVector{i}.val_markerSize = val_markerSize;
        end            
            %mrkNum = (i - mod(i, numMrkChange))/numMrkChange;
            %getPropVector{i}.val_marker = mrks{mrkNum + 1};
            %getPropVector{i}.val_markerEdgeColor = getPropVector{i}.val_lineColor;
            %getPropVector{i}.val_markerFaceColor = 'none';
            %getPropVector{i}.val_markerSize = val_markerSize;
    end
end

