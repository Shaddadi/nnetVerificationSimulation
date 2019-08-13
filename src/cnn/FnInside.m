function y = FnInside(p, P) % check if a point p is inside the convext set P
    x = P.A*p + P.d;
    if find(x>1.0e-10)
        y = false;
    else
        y = true;
    end
end