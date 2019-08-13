function P = nnetOutputConvexSet(P, p_bef_relu, network)
    layer = length(network.b);
    C = P.C; v = P.v;
    
    for i=1:layer-1 %last layer is linear 
        W = network.W{i};
        b = network.b{i};
        C =W*C; v = W*v+b;
        P.Cnet(i) = {C}; P.vnet(i) = {v};
        
        M = ones(length(p_bef_relu{i}),1);
        M([p_bef_relu{i}<0]) = 0;
        M = diag(M);
        C =M*C; v = M*v;
    end
    
    C =network.W{layer}*C; 
    v = network.W{layer}*v+network.b{layer};
    P.Cnet(layer) = {C}; P.vnet(layer) = {v};
    
    P.C = C; P.v = v;

end