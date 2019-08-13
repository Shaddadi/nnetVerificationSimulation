function [P_input,network] = cnnInputSetSingle(acDomain, network, S_r, p)

    params = network.params;
    layers = network.layers;
    
    acDomain_relu = acDomain{length(layers)-1};
    S2 = nnetCreateRange(acDomain_relu);
    
    for n = (length(layers)-2):-1:1 % the last layer is a linear activation function 
        layer = layers(n);
        switch layer
            case "conv"
                S1 = filterMapBack(S2, params{n}); 
            case "relu"
                [S1, W_linear] = reluMapBack(S2, acDomain{n});
                network.params(n) = {W_linear};
            case "flatten"
                 W_linear = [];
            case "maxp" 
                [S1, W_linear] = maxPoolMapBack(S2, params{n}, acDomain{n});
                network.params{n}.W = W_linear.W;
                network.params{n}.b = W_linear.b;
            case "affinetrans"
                S1= affineTransMapBack(S2, params{n});
        end
        S2 = S1;
    end
    
    % % handle n = length(layers)-1; length(layers); assume they are relu and affine transformation
    % relu
    w_linear = speye(length(acDomain_relu));
    b_linear = sparse(length(acDomain_relu),1);
    nonAcDomain = [acDomain_relu<0];
    w_linear(nonAcDomain, nonAcDomain) = 0;
    W_linear.W = w_linear;
    W_linear.b = b_linear;
    network.params(length(layers)-1) = {W_linear};
    
    
    % construct input set.  
    A_r = S_r.A;
    d_r = S_r.d;
    A_in = S1.A; 
    A = [A_in; A_r];
    d_in = S1.d;
    d = [d_in; d_r];
%     A = S1.A; 
%     d = S1.d;
    
    C = speye(size(A,2)); v = sparse(size(A,2),1);
    P_input.A = A; P_input.d = d; %'A' and 'd' denote hyperplanes
    P_input.C = C; P_input.v = v; %'C' and 'v' denote transformation matrix            
    P_input.Cnet= {}; P_input.vnet = {}; % store C and v of each layer before relu 
end


function Sp = nnetCreateRange(acDomain) % for the domain before the relu function
    sign_p = sign(acDomain);
    neuron_num = length(sign_p);
    % % create point's range according to the sign 
    %A_p = -diag(sign_p);
    A_p = sparse(1:neuron_num,1:neuron_num, -sign_p, neuron_num, neuron_num);
    d_p = sparse(neuron_num,1);
    Sp.A = A_p;
    Sp.d = d_p; 
end