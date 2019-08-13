% compute the output and activated domain given an input point
% @input: dim (i,j,d);
function [outputs, acDomains]= cnnInputPointSingle(input, network)
    params = network.params;
    layers = network.layers;
    outputs = {};
    acDomains = {};
    for n = 1:length(layers)
        layer = layers(n);
        switch layer
            case "conv"
                [output, acDomain] = convfilter(input, params{n});
            case "relu"
                [output, acDomain] = relu(input);
            case "maxp" 
                [output, acDomain] = maxp(input, params{n});
            case "flatten" 
                [output, acDomain] = flatten(input);
            case "affinetrans"
                [output, acDomain] = affinetrans(input,params{n});
        end
        outputs(end+1) = {output};
        acDomains(end+1) = {acDomain};
        input = output;
    end
end

function [output, acDomain] = convfilter(inputs, params)

    W = params.W;
    b = params.b;
    output = W*inputs + b;
    
    acDomain = [];
end


function [output, acDomain] = relu(inputs)
    output = inputs;
    output(output<0) = 0;

    acDomain = inputs;
    
end 

function [output, acDomain] = maxp(inputs, params)
    siz = params.size; % pool size
    stride = params.stride; % stride
    dim1 = params.dim1;
    dim2 = params.dim2;
    row1 = dim1(1); % image row size before ... 
    depth1 = dim1(3); % image depth before ... 
    row2 = dim2(1); % image row size after ... 
    depth2 = dim2(3);
    
    inputs = reshape(inputs, depth1,row1,row1);
    inputs = permute(inputs,[3,2,1]);
    
    output = []; acDomain = [];
    for d = 1:depth2 % depth
        input = inputs(:,:,d);
        output_temp = zeros(row2, row2);
        for r = 1:row2
            for c = 1:row2
                r_in = ((r-1)*stride+1):((r-1)*stride+siz);
                c_in = ((c-1)*stride+1):((c-1)*stride+siz);
                image_block = input(r_in, c_in);
                [Mr, Ir] = max(image_block);
                [Mc, Ic] = max(Mr); % maxpool
                output_temp(r,c) = Mc;
                id = [Ir(Ic)+r_in(1)-1, Ic + c_in(1)-1, d];
                acDomain(r,c,d) = idConvert(id, row1,depth1);
            end
        end
        output(:,:,end+1) = output_temp;
    end
    output(:,:,1) = [];
    
    output = permute(output, [3,2,1]);
    output = reshape(output,[],1);

end

function [output, acDomain] = flatten(inputs)
   
    output = inputs;
    acDomain = [];
end

function [output, acDomain] = affinetrans(inputs,params)

    weights = params.W;
    bias = params.b;
    
    output = weights*inputs + bias;
    acDomain = [];
end