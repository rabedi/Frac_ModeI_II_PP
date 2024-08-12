classdef zpplot_plotConfigurationParameters
    properties
        numLC = [];
        numSVE = [];
        outputBaseLocation = '';
        baseProcessedName = 'zpp_';
        baseRawName = 'zppr_';
        plotTypes = cell(0);
        processedDataParameterNames = cell(0);
        processedDataLatexNames = cell(0);
        rawDataParameterNames = cell(0);
        rawDataLatexNames = cell(0);
        critPointDataNames = cell(0);
        critPointLatexNames = cell(0);
    end
    methods(Static)
        function objout = ReadConfig(fid)
            [buf, neof] = fscanf(fid, '%s', 1);
            if (strcmp(buf, '{') == 0)
                buf
                THROW('invalid format\n');
            end
            buf = READ(fid, 's');
            while (strcmp(buf, '}') == 0)
                if (strcmp(buf, 'numLC') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.numLC(cntr) = str2num(buf);
                        buf = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'numSVE') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.numSVE(cntr) = str2num(buf);
                        buf = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'outputBaseLocation') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.outputBaseLocation = buf;
                        buf = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'baseProcessedName') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.baseProcessedName = buf;
                        buf = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'baseRawName') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.baseRawName = buf;
                        buf = READ(fid, 's');
                    end
                    buf = READ(fid, 's');
                elseif (strcmp(buf, 'plotTypes') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.plotTypes{cntr} = buf;
                        buf = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'processedDataParameterNames') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.processedDataParameterNames{cntr} = buf;
                        buf = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'processedDataLatexNames') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.processedDataLatexNames{cntr} = buf;
                        buf = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'rawDataParameterNames') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.rawDataParameterNames{cntr} = buf;
                        buf = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'rawDataLatexNames') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.rawDataLatexNames{cntr} = buf;
                        buf = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'critPointDataNames') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.critPointDataNames{cntr} = buf;
                        buf = READ(fid, 's');
                    end
                elseif (strcmp(buf, 'critPointLatexNames') == 1)
                    buf = READ(fid, 's');
                    if (strcmp(buf, '{') == 0)
                        buf
                        THROW('block should start with {\n');
                    end
                    buf = READ(fid, 's');
                    cntr = 0;
                    while (strcmp(buf, '}') == 0)
                        cntr = cntr + 1;
                        obj.critPointLatexNames{cntr} = buf;
                        buf = READ(fid, 's');
                    end
                else
                    buf
                    THROW('Invalid key\n');
                end
                buf = READ(fid, 's');
            end
            objout = obj;
        end
    end
end