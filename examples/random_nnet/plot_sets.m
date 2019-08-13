% verify using random samples
fprintf('Printing convex sets ...\n\n')


% input domain plot
figure
S_r = [eye(3),-ub; -eye(3),lb];
A_r = S_r(:,1:end-1);
d_r = S_r(:,end);
polyh_r = Polyhedron('A', A_r, 'b', -d_r);

subplot(1,2,1)
hold on 
title('Input Domain')
polyh_r.plot('edgealpha',1,'edgecolor','b','alpha',0)

for n = 1:length(allInputSets)
    P_input = allInputSets{n};
    polyh_input = P_input.C * Polyhedron('A',P_input.A,'b', -P_input.d) + P_input.v;
    
    polyh_input.plot('edgealpha',0.5,'alpha',1)
end

% output domain plot
subplot(1,2,2)
hold on
for n = 1:length(allOutputSets)
    P_output = allOutputSets{n};
    polyh_output = P_output.C * Polyhedron('A',P_output.A,'b', -P_output.d) + P_output.v;
    polyh_output.plot('edgealpha',0.5,'alpha',1)
end



