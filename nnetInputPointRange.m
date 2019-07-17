% compute the range of input point 
function S = nnetInputPointRange(p_bef_relu, network)
    layer = length(network.b);
    S = nnetCreateRange(layer-1, p_bef_relu, network);
    for n = (layer-1):-1:1 % the last layer is a linear activation function 
        S = nnetPointRangeLayer(S, n, p_bef_relu, network);
    end
end

function Sp_pre = nnetPointRangeLayer(Sp, layer, p_bef_relu, network)   
    A_p = Sp(:,1:end-1);
    d_p = Sp(:,end);
    % backwards affine transformation 
    W = network.W{layer}; b = network.b{layer};
    A_p_pre = A_p*W;
    d_p_pre = A_p*b + d_p;
    Sp_pre = [A_p_pre, d_p_pre];
    
    if layer == 1
        return
    end

    % backwards relu function 
    [Sp_pre_layer, sign_pre] = nnetCreateRange(layer-1, p_bef_relu, network);
    
    % remove negative sign
    idx_negative = [sign_pre<0];
    Sp_pre(:,idx_negative) = 0;
    
    % add the range in layer(layer-1)
    Sp_pre = [Sp_pre; Sp_pre_layer];
    
end

function [Sp, sign_p] = nnetCreateRange(layer, p_bef_relu, network)
    p = p_bef_relu{layer};
    sign_p = sign(p);

    % create point's range according to the sign 
    neuron_num = length(network.b{layer});
    A_p = -diag(sign_p);
    d_p = zeros(neuron_num,1);
    Sp = [A_p, d_p];
end
