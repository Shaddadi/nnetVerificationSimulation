clear
clc
addpath('../../src/cnn/reachability_computation') 
load mnist_cnn.mat
cnn = ["conv","relu","conv","relu","maxp","flatten","affinetrans","relu","affinetrans"];
input_dim = [28,28,1];
network = createNnet(cnn, weights,input_dim);

load twos_label.mat
input_p = twos(2,:)'; % input point 
% load input_p.mat
num = 150; epsilon = 1;

% select pixels and create the restricted convex set
S_r = selectPixelsCNN(double(input_p), num, epsilon, network);
imagedis(S_r.lb)
imagedis(S_r.ub)


% domain of the target label is the unsafe for the label 3
target_label = 3;
label_value = 2;
output_dim = 10;
% x_label - x_target<=0
Ausf = zeros(1,output_dim);
Ausf(target_label+1) = -1; % starting from label 0
Ausf(label_value+1) = 1; % starting from label 0
S_unsafe.A = Ausf;
S_unsafe.d = 0;

batchNum = 1; randmNum = 10000;
allCounterSetss = {};
allInputSets = {};
allOutputSets = {};
allInputP = [];
global totalSets;
totalSets = 0;
for i = 1:batchNum
    [newInputSets, newOutputSets, newCounterSets, inputPoints] =...
        oneBatchCompute(randmNum, allInputSets, S_r, network, S_unsafe);

    allInputSets = [allInputSets, newInputSets];
    allCounterSetss = [allCounterSetss, newCounterSets];
    allOutputSets = [allOutputSets, newOutputSets];
end





