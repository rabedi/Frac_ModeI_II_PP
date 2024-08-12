classdef pp_stat_pos
    properties
        fldNames;
        Dind, crind, strind, baind, saind, caind, staind, slaind, pfind, dfind, dsind, delu0ind, s0ind, delv0ind, u0ind;
        v0ind;
        STDIM, xindex, tindex, bindex, flgindex, szindex, valsindex;
        u0indabs, v0indabs, s0indabs, delu0indabs, delv0indabs;
        interiorFracPosSt, interiorFracPosEn;   % start and end positions for things that are averaged inside the domain (on fracture surfaces) 
    end
    methods
        function objout = Initialize(obj, statFileIn)
            fid = fopen(statFileIn, 'r');
            if (fid < 0)
                msg = ['Cannot open', statFileIn, '\n'];
                THROW(msg);
            end
            buf = fscanf(fid, '%s', 3);
            numFields = fscanf(fid, '%d', 1);
            for fld = 1:numFields
                buf = fscanf(fid, '%s', 1);
                obj.fldNames{fld} = fscanf(fid, '%s', 1);
            end
            obj.Dind = find(not(cellfun('isempty', strfind(obj.fldNames, 'D'))));
            obj.crind = find(not(cellfun('isempty', strfind(obj.fldNames, 'cr'))));
            obj.strind = find(not(cellfun('isempty', strfind(obj.fldNames, 'str'))));
            obj.baind = find(not(cellfun('isempty', strfind(obj.fldNames, 'ba'))));
            obj.saind = find(not(cellfun('isempty', strfind(obj.fldNames, 'sa'))));
            obj.caind = find(not(cellfun('isempty', strfind(obj.fldNames, 'ca'))));
            obj.staind = find(not(cellfun('isempty', strfind(obj.fldNames, 'sta'))));
            obj.slaind = find(not(cellfun('isempty', strfind(obj.fldNames, 'sla'))));
            obj.pfind = find(not(cellfun('isempty', strfind(obj.fldNames, 'pf'))));
            obj.dfind = find(not(cellfun('isempty', strfind(obj.fldNames, 'df'))));
            obj.dsind = find(not(cellfun('isempty', strfind(obj.fldNames, 'ds'))));
            ln = length(obj.dsind);
            if (ln == 2)
                obj.dsind = obj.dsind(1);
            end
            obj.delu0ind = find(not(cellfun('isempty', strfind(obj.fldNames, 'delu0'))));
            obj.s0ind = find(not(cellfun('isempty', strfind(obj.fldNames, 's0'))));
            obj.delv0ind = find(not(cellfun('isempty', strfind(obj.fldNames, 'delv0'))));
            obj.u0ind = find(not(cellfun('isempty', strfind(obj.fldNames, 'uin0'))));
            obj.v0ind = obj.delv0ind;
            fclose(fid);
            obj.STDIM = 3;
            obj.xindex = 2;
            obj.tindex = 2 + obj.STDIM - 1;
            obj.bindex = obj.tindex + 2;
            obj.flgindex = obj.bindex + 4;
            obj.szindex = obj.flgindex + 2;
            obj.valsindex = obj.szindex + 2;
            obj.u0indabs = obj.valsindex + obj.u0ind - 1;
            obj.v0indabs = obj.valsindex + obj.v0ind - 1;
            obj.s0indabs = obj.valsindex + obj.s0ind - 1;
            obj.delu0indabs = obj.valsindex + obj.delu0ind - 1;
            obj.delv0indabs = obj.valsindex + obj.delv0ind - 1;

            obj.interiorFracPosSt = obj.valsindex + obj.Dind - 1;
            obj.interiorFracPosEn = obj.valsindex + obj.dsind - 1;
            objout = obj;
        end
        function toFile(obj, fid, nbegline)
            if nargin < 2
                nbegline = 0;
            end
            gen_printTab(fid, nbegline);
            fprintf(fid, '{\n');

            gen_printTab(fid, nbegline);
            fprintf(fid, 'fldNames\t');
            gen_toFile_vecString(fid, obj.fldNames);
            
            gen_printTab(fid, nbegline);
            fprintf(fid, 'Dind\t%d\n', obj.Dind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'crind\t%d\n', obj.crind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'strind\t%d\n', obj.strind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'baind\t%d\n', obj.baind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'saind\t%d\n', obj.saind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'caind\t%d\n', obj.caind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'staind\t%d\n', obj.staind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'slaind\t%d\n', obj.slaind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'pfind\t%d\n', obj.pfind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'dfind\t%d\n', obj.dfind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'delu0ind\t%d\n', obj.delu0ind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 's0ind\t%d\n', obj.s0ind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'delv0ind\t%d\n', obj.delv0ind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'u0ind\t%d\n', obj.u0ind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'v0ind\t%d\n', obj.v0ind);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'STDIM\t%d\n', obj.STDIM);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'xindex\t%d\n', obj.xindex);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'tindex\t%d\n', obj.tindex);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'bindex\t%d\n', obj.bindex);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'flgindex\t%d\n', obj.flgindex);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'szindex\t%d\n', obj.szindex);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'valsindex\t%d\n', obj.valsindex);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'u0indabs\t%d\n', obj.u0indabs);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'v0indabs\t%d\n', obj.v0indabs);
            gen_printTab(fid, nbegline);
            fprintf(fid, 's0indabs\t%d\n', obj.s0indabs);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'delu0indabs\t%d\n', obj.delu0indabs);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'delv0indabs\t%d\n', obj.delv0indabs);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'interiorFracPosSt\t%d\n', obj.interiorFracPosSt);
            gen_printTab(fid, nbegline);
            fprintf(fid, 'interiorFracPosEn\t%d\n', obj.interiorFracPosEn);

            gen_printTab(fid, nbegline);
            fprintf(fid, '}\n');
        end
        function objout = fromFile(obj, fid)
            [buf, neof] = fscanf(fid, '%s', 1);
            if (strcmp(buf, '{') == 0)
                buf
                THROW('invalid format\n');
            end
            [buf, neof] = fscanf(fid, '%s', 1);
            while ((strcmp(buf, '}') == 0) && (neof))
                if (strcmp(buf, 'fldNames') == 1)
                    obj.fldNames = gen_fromFile_vecString(fid);
                elseif (strcmp(buf, 'Dind') == 1)
                    obj.Dind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'crind') == 1)
                    obj.crind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'strind') == 1)
                    obj.strind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'baind') == 1)
                    obj.baind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'saind') == 1)
                    obj.saind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'caind') == 1)
                    obj.caind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'staind') == 1)
                    obj.staind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'slaind') == 1)
                    obj.slaind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'pfind') == 1)
                    obj.pfind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'dfind') == 1)
                    obj.dfind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'dsind') == 1)
                    obj.dsind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'delu0ind') == 1)
                    obj.delu0ind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 's0ind') == 1)
                    obj.s0ind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'delv0ind') == 1)
                    obj.delv0ind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'u0ind') == 1)
                    obj.u0ind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'v0ind') == 1)
                    obj.v0ind = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'STDIM') == 1)
                    obj.STDIM = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'xindex') == 1)
                    obj.xindex = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'tindex') == 1)
                    obj.tindex = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'bindex') == 1)
                    obj.bindex = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'flgindex') == 1)
                    obj.flgindex = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'szindex') == 1)
                    obj.szindex = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'valsindex') == 1)
                    obj.valsindex = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'u0indabs') == 1)
                    obj.u0indabs = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'v0indabs') == 1)
                    obj.v0indabs = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 's0indabs') == 1)
                    obj.s0indabs = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'delu0indabs') == 1)
                    obj.delu0indabs = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'delv0indabs') == 1)
                    obj.delv0indabs = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'interiorFracPosSt') == 1)
                    obj.interiorFracPosSt = fscanf(fid, '%d', 1);
                elseif (strcmp(buf, 'interiorFracPosEn') == 1)
                    obj.interiorFracPosEn = fscanf(fid, '%d', 1);
                else
                    buf
                    THROW('Invalid key\n');
                end
                [buf, neof] = fscanf(fid, '%s', 1);
            end                
            objout = obj;
        end
        function indFld = getIndexFromWord(obj, wordAfterSpecifier)
            indFld = nan;
            sz = length(wordAfterSpecifier);
            if (sz == 0)
                return;
            end
            if (wordAfterSpecifier(1) == 'd')
                if (sz == 1)
                    indFld = obj.Dind;
                    return;
                end
                if (wordAfterSpecifier(2) == 'f')
                    indFld = obj.dfind;
                    return;
                end
                if (wordAfterSpecifier(2) == 's')
                    indFld = obj.dsind;
                    return;
                end
                indFld = obj.Dind;
                return;
            elseif (wordAfterSpecifier(1) == 'c')
                if (sz == 1)
                    indFld = nan;
                    return;
                elseif (wordAfterSpecifier(2) == 'r')
                        indFld = obj.crind;
                        return;
                elseif (wordAfterSpecifier(2) == 'a')
                        indFld = obj.caind;
                        return;
                else
                    indFld = nan;
                    return;
                 end
            elseif (wordAfterSpecifier(1) == 's')
                if (sz < 2)
                    indFld = nan;
                    return;
                elseif (wordAfterSpecifier(2) == 'a')
                        indFld = obj.saind;
                        return;
                elseif (wordAfterSpecifier(2) == 'l')
                        indFld = obj.slaind;
                        return;
                elseif (wordAfterSpecifier(2) == 't')
                    if (sz < 3)
                        indFld = nan;
                        return;
                    end
                    if (wordAfterSpecifier(3) == 'a')
                        indFld = obj.staind;
                        return;
                    elseif (wordAfterSpecifier(3) == 'r')
                        indFld = obj.strind;
                        return;
                    else
                        indFld = nan;
                        return;
                    end
                else
                    indFld = nan;
                    return;
                end
            elseif (wordAfterSpecifier(1) == 'b')
                if ((sz >= 2) && (wordAfterSpecifier(2) == 'a'))
                    indFld = obj.baind;
                    return;
                end
                indFld = nan;
                return;
            elseif (wordAfterSpecifier(1) == 'p')
                if ((sz >= 2) && (wordAfterSpecifier(2) == 'f'))
                    indFld = obj.pfind;
                    return;
                end
                indFld = nan;
                return;
            end                    
        end
    end
end