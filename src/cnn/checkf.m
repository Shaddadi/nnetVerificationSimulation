function checkf(S)
    A = S.A;
    d = S.d;
    f = zeros(1, size(A,2));
    x = linprog(f, A, -d);
end