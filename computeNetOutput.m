function output = computeNetOutput(P, p_bef_relu, network)
    layer = length(network.b);
    C = eye(P.Dim); v = zeros(P.Dim,1);
    for i=1:layer-1 %last layer is linear 
        W = network.W{i};
        b = network.b{i};
        C =W*C; v = W*v+b;
        
        M = ones(length(p_bef_relu{i}),1);
        M([p_bef_relu{i}<0]) = 0;
        M = diag(M);
        C =M*C; v = M*v;
    end
    
    C =network.W{layer}*C; 
    v = network.W{layer}*v+network.b{layer};
    output = C*P + v;
end