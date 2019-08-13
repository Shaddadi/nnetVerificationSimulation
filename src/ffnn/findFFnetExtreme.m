function [x, d, counter] = findFFnetExtreme(S_output, S_unsafe)
    counter = "";
    Aout = S_output.A;
    dout = S_output.d;
    C = S_output.C;
    v = S_output.v;
    
    Ausf = S_unsafe.A;
    dusf = S_unsafe.d;
    
    Aback = Ausf*C;
    dback = Ausf*v + dusf;
    
    
    %Aout = sparse(Aout);
    [xmin,~,exitflag] = linprog(Aback, Aout, -dout); % min value
    % check if the track is invalid (out of boundary)
    if exitflag~=1
        x = [];
        d = [];
        counter = "invalid";
    end
    % find the minimual distance
    % check if there are counter examples in the track
    dmin = Ausf*(C*xmin+v)+dusf;
    if dmin>0
        x = xmin;
        d = dmin;
    else
        x = xmin;
        d = 0;
        counter = "counter";
    end
   
end