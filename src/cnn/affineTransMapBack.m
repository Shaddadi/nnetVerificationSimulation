% % S2 = W*S1 + b
function S1 = affineTransMapBack(S2, params)

    W = params.W; % weights
    b = params.b; % bias
    
    A2 = S2.A;
    d2 = S2.d;
    
    A1 = A2*W;
    d1 = A2*b + d2;
    
    S1.A = A1;
    S1.d = d1;

end