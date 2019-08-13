function  network = createNnet(cnn, weights, input_dim)
    params = {}; n = 1;
    dim1 = 0; % the dim of images before procession
    dim2 = input_dim; %  the dim of images after procession
    for layer = cnn
        switch layer
            case "conv"
                W = double(weights{n}); b = double(weights{n+1});
                siz = 3; stride = 1;
                dim1 = dim2;                 
                row2 = (dim1(1)-siz)/stride + 1; depth2 = size(W,4);
                dim2 = [row2, row2, depth2]; % last element is the number of filters
                
                params_temp = convfilter( W, b, siz, stride, dim1, dim2);
                params_temp.size = siz;
                params_temp.stride = stride;
                params_temp.dim1 = dim1;
                params_temp.dim2 = dim2;
                
                n = n+2;
            case "relu"
                params_temp.W = [];
                params_temp.b = [];
                dim1 = dim2;
                dim2 = dim1;
            case "maxp" 
                params_temp.W = []; 
                params_temp.b = [];
                siz = 2; stride = 2;
                params_temp.size = siz; 
                params_temp.stride = stride;
                dim1 = dim2;
                params_temp.dim1 = dim1;
                row2 = (dim1(1)-siz)/stride + 1;
                depth2 = dim1(3);
                params_temp.dim2 = [row2, row2, depth2]; % depth doesn't change
            case "flatten"
                params_temp.W = []; 
                params_temp.b = [];
                dim1 = dim2;
                dim2 = dim1(1)*dim1(2)*dim1(3);
            case "affinetrans"
                params_temp.W = double(weights{n})'; 
                params_temp.b = double(weights{n+1})';
                dim1 = size(params_temp.W',2);
                dim2 = size(params_temp.W',1);
                n = n+2;
        end  
        params(end+1) = {params_temp};
    end
    network.params = params;
    network.layers = cnn;
end

function weights_linear = convfilter( W, b, siz, stride, dim1, dim2)

    row1 = dim1(1); % image row size before ... 
    depth1 = dim1(3); % image depth before ... 
    row2 = dim2(1); % image row size after ... 
    depth2 = dim2(3);
    
    weights = zeros(row2*row2*depth2, row1*row1*depth1);
    bias = zeros(row2*row2*depth2, 1);
    n = 1;
    for i = 1:row2
        for j = 1:row2
            xs = getBlockFilter(i, j, siz, stride, row1, depth1);
            for d2 = 1:depth2
                W_temp = W(:,:,:, d2);
                W_temp = permute(W_temp,[3 2 1]);
                w_temp = reshape(W_temp, 1, []);

                weights(n, xs) = w_temp;
                bias(n) = b(d2);
                n = n+1;
            end
        end
    end
    
    weights_linear.W = sparse(weights);
    weights_linear.b = sparse(bias);

end