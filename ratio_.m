function rat = ratio_(numerator, denominator)

max_ret = 1e40;
if (abs(denominator) < 2 * realmin)
    if(abs(numerator)  < 2 * realmin)
        rat = 0;
        return;
    else
        if (((numerator > 0) && (denominator > 0)) || ((numerator < 0) && (denominator < 0)))
            rat = max_ret;
            return;
        else
            rat = -max_ret;
            return;
        end
    end
end

rat = numerator / denominator;

if (rat > max_ret)
    rat = max_ret;
    return;
end
if (rat < -max_ret)
    rat = -max_ret;
    return;
end