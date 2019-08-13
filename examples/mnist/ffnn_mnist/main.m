% % find the closest point to the unsafe domain 

clear;
clc;
addpath('../../../src/ffnn')
load mnist_ffnn.mat
network = extractFFnnWeights(weights);

load ones_label.mat
p = ones_label(2,:);
epsilon = 0.2;
lb = p' - epsilon;
lb(lb<0)=0;
ub = p' + epsilon;
ub(ub>1)=1;

% restricted convex set by bounds
inputDim = length(lb);
S_r = [eye(inputDim),-ub; -eye(inputDim),lb];

% unsafe domain x1 >= val
% domain of the target label is the unsafe for the label 3
target_label = 2;
label_value = 1;
output_dim = 10;
% x_label - x_target<=0
Ausf = zeros(1,output_dim);
Ausf(target_label+1) = -1; % starting from label 0
Ausf(label_value+1) = 1; % starting from label 0
S_unsafe.A = Ausf;
S_unsafe.d = 0;

% load input_p.mat;
alpha = 1.0e-10;
M = 4;
for num = 1:10
    dbest = 10000;
    % random input point 
    input_p = lb + rand(length(lb),1).*(ub-lb);
    dom_init= extractActivatedDomainSingle(input_p, network);  
    doms = {dom_init};
    d_all = [];
    while ~isempty(doms)
        for i = 1:length(doms)
            domi = doms{i};
            [x, d, counter] = testFFNetDom(domi, network, S_r, S_unsafe);
            if counter == "counter"
                fprintf("Counter example found\n")
                imagedis(x)
                return;
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
        doms = nextFFnetTrack(xbest, dombest, network);
    end
end