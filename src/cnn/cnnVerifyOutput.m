

function [S_inter, exitflag] = cnnVerifyOutput(S_output, S_r, S_unsafe)

    S_inter = [];
    
    Aout = S_output.A;
    dout = S_output.d;
    C = S_output.C;
    v = S_output.v;
    
    Ausf = S_unsafe.A;
    dusf = S_unsafe.d;
    
    Aback = Ausf*C;
    dback = Ausf*v + dusf;
    
    f = zeros(1, size(Aout,2));
    A = [Aout; Aback];
    d = [dout; dback];
    [~, ~, exitflag] = linprog(f, A, -d);
    if exitflag
        S_inter.A = A;
        S_inter.d = d;
    end
end