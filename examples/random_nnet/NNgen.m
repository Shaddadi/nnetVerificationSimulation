clc;clear
% random NN
S = [2, 1000, 1000, 1000, 2];
for i = 2:length(S)
    w_temp = randn(S(i), S(i-1));
    b_temp = randn(S(i),1);
    W(i-1) = {w_temp};
    b(i-1) = {b_temp};
end
save('network.mat', 'W', 'b')
% network.W = W;
% network.b = b;
% 
% % load network.mat
% % input range
% lb = -ones(1,S(1));
% ub = ones(1,S(1));
% 
% % number of points 
% sample = 1000;
% y = [];
% for i = 1:sample
%     p = diag(rand(S(1),1))*(ub-lb)' + lb';
%     y = [y; networkOutputSingle(p, network)];
% end
% plot(y,0,'*')