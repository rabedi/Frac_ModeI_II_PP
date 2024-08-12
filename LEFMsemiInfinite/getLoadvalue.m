function load = getLoadvalue(time, rampTime, p0, alpha, stopTime)

if ((time < 0) || (time > stopTime))
    load = 0.0;
elseif (time < rampTime)
    tt = time / rampTime;
    load = p0 * tt * tt * (-2.0 * tt + 3.0);
else
    load = p0 + alpha * (time - rampTime);
end