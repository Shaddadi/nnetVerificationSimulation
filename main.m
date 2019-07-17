% neural network verification based on simulation
clear;
clc;

load network.mat
network.W = W;
network.b = b;
% random input point 
lb = [-1,;-1]; 
ub = [1; 1];
%p_randm = lb + rand(2,1).*(ub-lb);
p_randm = [0.288636260387383;-0.242781234679463];

tic
% compute the input domain
[y, p_bef_relu] = networkOutputSingle(p_randm,network);
S = nnetInputPointRange(p_bef_relu, network);

% compute nnet output domain
A = S(:,1:end-1);
b = S(:,end);
polyh_input = Polyhedron('A',A,'b',-b);
polyh_input = polyh_input.minHRep();
polyh_output = computeNetOutput(polyh_input, p_bef_relu, network);
toc

% verify correctness of the proposed method 
verifyCorrectness(S, p_randm, p_bef_relu, network)

% verify using random samples
fprintf('Printing domain and random samples...\n\n')
figure
subplot(1,2,1)
title('Input domain')
hold on
plot(polyh_input)
num = 5000; p_output = [];
V = polyh_input.V';
for n=1:num
    r = rand(1, size(V,2));
    r = r / sum(r);
    p_temp = V*r';
    plot(p_temp(1),p_temp(2),'b*')
    y = networkOutputSingle(p_temp,network);
    p_output = [p_output, y];
end
hold off
subplot(1,2,2)
title('Output Domain')
hold on 
plot(polyh_output)
plot(p_output(1,:),p_output(2,:),'b*')
hold off 