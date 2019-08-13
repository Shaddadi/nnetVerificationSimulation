function output = cnnOutputSetSingle(input, network)
    params = network.params;
    layers = network.layers;
    for n = 1:length(layers)
        layer = layers(n);
        switch layer
            case "conv"
                output = convfilter(input, params{n});
            case "relu"
                output = relu(input,params{n});
            case "maxp" 
                output = maxp(input, params{n});
            case "flatten" 
                % do nothing
            case "affinetrans"
                output = affinetrans(input, params{n});
        end
        input = output;
    end
end

function P = convfilter(P, params)
    C = P.C; v = P.v;
    W = params.W;
    b = params.b;
    C =W*C; v = W*v+b;
    
    P.C = C; P.v = v;
end

function P = relu(P, params)
    C = P.C; v = P.v;
    W = params.W;
    C =W*C; v = W*v;
    
    P.C = C; P.v = v;
end

function P = maxp(P, params)
    C = P.C; v = P.v;
    W = params.W;
    C =W*C; v = W*v;
    
    P.C = C; P.v = v;
end 

function P = affinetrans(P, params)
    C = P.C; v = P.v;
    W = params.W;
    b = params.b;
    C =W*C; v = W*v+b;
    P.C = C; P.v = v;
end 