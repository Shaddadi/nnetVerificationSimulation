function network = extractFFnnWeights(weights)
    n = 1;
    W = {}; b = {};
    while n<length(weights)
        W(end+1) = {double(weights{n}')};
        n = n+1;
        b(end+1) = {double(weights{n}')};
        n = n+1;
    end
    network.W = W;
    network.b = b;
    network.layerNum = length(weights)/2;
end