% neural network verification based on simulation
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

randmNum = 100000; endFlag = false;
allAcDomains = {};
allInputSets = {};
allOutputSets = {};
allInputP = [];
V = 0;
tic
while ~endFlag
    [inputSets, outputSets, newAcDomains, inputPoints] = ...
        oneBatchCompute(randmNum, allInputSets, allAcDomains, lb, ub, network);

    allAcDomains = [allAcDomains, newAcDomains];
    allInputSets = [allInputSets, inputSets];
    allOutputSets = [allOutputSets, outputSets];
    allInputP = [allInputP;inputPoints];

    [endFlag, V, diffV] = volumeCheck(inputSets, V, lb, ub);
    toc
end




% % verify correctness of the proposed method 
% verifyCorrectness(S_in, p_randm, p_bef_relu, network)

% verify using random samples
fprintf('Printing domains and random samples...\n\n')

num = 1000; p_output = []; p_input = [];
polyh_input = P_input.C * Polyhedron('A',P_input.A,'b', -P_input.d) + P_input.v;
polyh_output = P_output.C * Polyhedron('A',P_output.A,'b', -P_output.d) + P_output.v;
polyh_r = Polyhedron('A', A_r, 'b', -d_r);
V = polyh_input.V'; 
P_num = 5; % number of points that are selected for random points

for n=1:num
    idx = randi(size(V,2),1,P_num);
    P_select = V(:,idx); % selected V points

    r = rand(1, P_num);
    r = r / sum(r);
    p_temp = P_select*r'; 
    p_input = [p_input, p_temp];
    p_bef_relu = networkOutputSingle(p_temp,network);
    p_output = [p_output, p_bef_relu{network.layerNum}];
end

% input domain plot
figure
title('Input domain')
Vin = polyh_input.V; 
Vr = polyh_r.V;
subplot(1,2,1)
hold on

Vin1 = Vin(:,[1,2,3]);
polyh_in1 = Polyhedron(Vin1);
polyh_in1.plot('edgealpha',0.5,'alpha',0.7)

Vr1 = Vr(:,[1,2,3]);
polyh_r1 = Polyhedron(Vr1);
polyh_r1.plot('edgealpha',1,'alpha',0.1)

pin = p_input([1,2,3],:);
plot3(pin(1,:),pin(2,:),pin(3,:),'b*')
hold off

subplot(1,2,2)
hold on
Vin2 = Vin(:,[1,4,5]);
polyh_in2 = Polyhedron(Vin2);
polyh_in2.plot('edgealpha',0.5,'alpha',0.7)

Vr2 = Vr(:,[1,4,5]);
polyh_r2 = Polyhedron(Vr2);
polyh_r2.plot('edgealpha',1,'alpha',0.1)

pin = p_input([1,4,5],:);
plot3(pin(1,:),pin(2,:),pin(3,:),'b*')

hold off

% output domain plot
figure
title('Output domain')
Vout = polyh_output.V;
subplot(1,2,1)
hold on
Vout1 = Vout(:,[1,2,3]);
polyh_out1 = Polyhedron(Vout1);
polyh_out1.plot('edgealpha',0.5,'alpha',0.7)
pout = p_output([1,2,3],:);
plot3(pout(1,:),pout(2,:),pout(3,:),'b*')
hold off

subplot(1,2,2)
hold on
Vout2 = Vout(:,[1,4,5]);
polyh_out2 = Polyhedron(Vout2);
polyh_out2.plot('edgealpha',0.5,'alpha',0.7)
pout = p_output([1,4,5],:);
plot3(pout(1,:),pout(2,:),pout(3,:),'b*')
hold off


