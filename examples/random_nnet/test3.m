% % input set adjacency method 

clear;
clc;
addpath('../../src')
load NeuralNetwork7_3.mat
network.W = W;
network.b = b;
network.layerNum = length(network.b);

lb = [-1; -1; -1];
ub = [1; 1; 1];
% restricted convex set by bounds
inputDim = length(lb);
S_r = [eye(inputDim),-ub; -eye(inputDim),lb];

randmNum = 10000; 

% unsafe domain y1+48<=0
S_unsafe.A = [1, 0];
S_unsafe.d = 48;

tic
[inputSets, outputSets, acDomains, inputPoints] = ...
    seedComputation(randmNum, lb, ub, network,S_unsafe);
allOutputSets = outputSets;
allInputSets = inputSets;
allAcDomains = acDomains;

% newAcDomains = {1};
% while ~isempty(newAcDomains)
%     [newInputSets, newOutputSets, newAcDomains] = adjacentInput(outputSets, acDomains, allAcDomains, network, S_r);
%     outputSets = newOutputSets;
%     acDomains = newAcDomains;
%     allAcDomains = [allAcDomains, newAcDomains];
%     allOutputSets = [allOutputSets, newOutputSets];
%     allInputSets = [allInputSets, newInputSets];
% end
% toc