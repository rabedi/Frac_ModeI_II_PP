function [z_, zx_, zy_, teta_] = testFunction(x_, y_)

a0 = 12;
a = 2.0;
b = 3.0;
c = 2.0;
d = 1.0; 
e = -1.0;
z_ = a0 + a * x_ + b * y_ + c .* x_ .* y_ + d * x_ .* x_ + e * y_ .* y_;
zx_ = a + c .* y_ + 2.0 * d * x_;
zy_ = b + c .* x_ + 2.0 * e * y_;


z_ = (x_ - 0.5) .* (x_ - 0.5) + (y_ - 0.5) .* (y_ - 0.5);
zx_ = 2.0 * (x_ - 0.5);
zy_ = 2.0 * (y_ - 0.5);




teta_ = atan2(-zx_, zy_);
