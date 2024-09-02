function pt = readConfigCoordinateLimitpt(fid, lim_, limIndex)

tmp = fscanf(fid, '%s', 1);
pt_ = fscanf(fid, '%s', 1);
if (strcmp(pt_, 'fl') == 1)
    pt = lim_(limIndex);
elseif (strcmp(pt_, 'stpt') == 1)
    pt = inf;
else
    pt = str2num(pt_);
    if (length(pt) == 0)
        fprintf(1, 'wrong pt point %s', pt_);
        pause;
    end
end