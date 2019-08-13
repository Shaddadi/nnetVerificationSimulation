% compute the range of input point 
function P_input = nnetInputConvexSet(p_bef_relu, network, S_r)
    layer = length(network.b);
    S = nnetCreateRange(layer-1, p_bef_relu, network);
    for n = (layer-1):-1:1 % the last layer is a linear activation function 
        S = nnetPointRangeLayer(S, n, p_bef_relu, network);
    end
    
    % construct input set.  
    A_r = S_r(:,1:end-1);
    d_r = S_r(:,end);
    A_in = S(:,1:end-1); 
    A = [A_in; A_r];
    d_in = S(:,end);
    d = [d_in; d_r];
    
    C = eye(size(A,2)); v = zeros(size(A,2),1);
    P_input.A = A; P_input.d = d; %'A' and 'd' denote hyperplanes
    P_input.C = C; P_input.v = v; %'C' and 'v' denote transformation matrix            
    P_input.Cnet= {}; P_input.vnet = {}; % store C and v of each layer before relu 
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
    Sp_pre_temp = Sp_pre;
    Sp_pre_temp(:,idx_negative) = 0;
    
    % add the range in layer(layer-1)
    Sp_pre = [Sp_pre_temp; Sp_pre_layer];
    
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
