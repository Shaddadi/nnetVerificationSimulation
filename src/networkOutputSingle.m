%% Compute the single output of the layer y = f(x)
function [y, p_bef_relu] = networkOutputSingle(input,network) 

layerNum = length(network.b);
for i=1:1:layerNum-1
    p_temp = network.W{i}*input + network.b{i};
    p_bef_relu(i) = {p_temp};
    input =  activeFun(network.W{i}*input + network.b{i});    
end

y = network.W{layerNum}*input + network.b{layerNum};

end

function y = activeFun(x) 
     y = poslin(x);
end
