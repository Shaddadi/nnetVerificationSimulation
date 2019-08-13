clear
clc
addpath('../../src/cnn/reachability_computation') 
load mnist_cnn.mat
cnn = ["conv","relu","conv","relu","maxp","flatten","affinetrans","relu","affinetrans"];
input_dim = [28,28,1];
network = createNnet(cnn, weights, input_dim);

load threes_label.mat
input_p = threes(2,:)'; % input point 
p = reshape(input_p, 28,28)';

figure  % plot images                                        
colormap(gray)
imagesc(p)

tic
[outputs, acDomains] = cnnInputPointSingle(input_p, network);
output = outputs{end};
softmax(output)
toc



