% % Compute the single output of the layer y = f(x)
function p_bef_relu = extractActivatedDomainSingle(input,network) 

    layerNum = network.layerNum;
    for i=1:1:layerNum-1 % assume the last layer is linear 
        p_temp = network.W{i}*input + network.b{i};
        p_bef_relu(i) = {p_temp};
        input =  activeFun(network.W{i}*input + network.b{i});    
    end

    input = network.W{layerNum}*input + network.b{layerNum};
    p_bef_relu(layerNum) = {input};
    
end

function y = activeFun(x) 
     y = poslin(x);
end
