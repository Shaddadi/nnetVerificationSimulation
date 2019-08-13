% % input set adjacency method 

clear;
clc;
addpath('../../../../src')
load ACASXU_run2a_1_3_batch_2000.mat
network.W = W;
network.b = b;
network.layerNum = length(network.b);

lb = [1500; -0.06; 3.1; 1000; 700];
ub = [1800; 0.06; 3.14; 1200; 800];
% normalize input
for i=1:5
    lb(i) = (lb(i) - means_for_scaling(i))/range_for_scaling(i);
    ub(i) = (ub(i) - means_for_scaling(i))/range_for_scaling(i);   
end

randmNum = 100; 

[inputSets, outputSets, acDomains, inputPoints] = ...
    seedComputation(randmNum, lb, ub, network);
allOutputSets = outputSets;
allAcDomains = acDomains;
while ~ISEMPTY(newAcDomains)
    [newOutputSets, newAcDomains] = adjacentInput(outputSets, allAcDomains, network, S_r);
    outputSets = newOutputSets;
    allAcDomains = [allAcDomains, newAcDomains];
    allOutputSets = [allOutputSets, newOutputSets];
end