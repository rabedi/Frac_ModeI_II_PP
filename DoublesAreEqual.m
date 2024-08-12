function equal  = DoublesAreEqual(d1, d2, tol)
den = abs(d1);
if (abs(d2) > den)	den = abs(d2);  end
if (den < 1.0) den = 1.0;   end
equal = abs((d1 - d2)/tol )<den;
