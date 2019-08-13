% % find the closest point to the unsafe domain 

clear;
clc;
addpath('../../src/ffnn')
load NeuralNetwork7_3.mat
network.W = W;
network.b = b;
network.layerNum = length(network.b);

lb = [-1; -1; -1];
ub = [1; 1; 1];
% restricted convex set by bounds
inputDim = length(lb);
S_r = [eye(inputDim),-ub; -eye(inputDim),lb];

% unsafe domain y1+48<=0
S_unsafe.A = [-1, 0];
S_unsafe.d = 13.11;

% load input_p.mat;
alpha = 1.0e-10;
M = 4;
for num = 1:100
    dbest = 10000;
    % random input point 
    input_p = lb + rand(length(lb),1).*(ub-lb);
    dom_init= extractActivatedDomainSingle(input_p, network);  
    doms = {dom_init};
    d_all = [];
    while ~isempty(doms)
        xbest = [];
        for i = 1:length(doms)
            domi = doms{i};
            [x, d, counter] = testFFNetDom(domi, network, S_r, S_unsafe);
            if counter == "counter"
                fprintf("\nCounterexamples are found!\n\n")
                return;
            elseif counter == "invalid"
                continue;
            end
            if ~any((d_all<=d+alpha)&(d_all>=d-alpha))
                d_all(end+1) = d;
                if d < dbest
                    dbest = d;
                    dombest = domi;
                    xbest = x;
                end
            end
        end
        if isempty(xbest)
            doms = {};
        else
            doms = nextFFnetTrack(xbest, dombest, network);
        end
    end
end