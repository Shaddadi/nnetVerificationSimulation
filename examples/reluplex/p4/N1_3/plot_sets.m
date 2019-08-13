% verify using random samples
fprintf('Printing convex sets ...\n\n')


% input domain plot
figure
S_r = [eye(5),-ub; -eye(5),lb];
A_r = S_r(:,1:end-1);
d_r = S_r(:,end);
polyh_r = Polyhedron('A', A_r, 'b', -d_r);
Vr = polyh_r.V;
subplot(1,2,1)
hold on
Vr1 = Vr(:,[1,2,3]);
polyh_r1 = Polyhedron(Vr1);
polyh_r1.plot('edgealpha',1,'alpha',0.1)

subplot(1,2,2)
hold on
Vr2 = Vr(:,[1,4,5]);
polyh_r2 = Polyhedron(Vr2);
polyh_r2.plot('edgealpha',1,'alpha',0.1)

for n = 1:length(allInputSets)
    P_input = allInputSets{n};
    polyh_input = P_input.C * Polyhedron('A',P_input.A,'b', -P_input.d) + P_input.v;
    Vin = polyh_input.V; 
    
    subplot(1,2,1)
    Vin1 = Vin(:,[1,2,3]);
    polyh_in1 = Polyhedron(Vin1);
    polyh_in1.plot('edgealpha',0.5,'alpha',0.7)

    subplot(1,2,2)
    Vin2 = Vin(:,[1,4,5]);
    polyh_in2 = Polyhedron(Vin2);
    polyh_in2.plot('edgealpha',0.5,'alpha',0.7)

end

% output domain plot
figure

for n = 1:length(allOutputSets)
    P_output = allOutputSets{n};
    polyh_output = P_output.C * Polyhedron('A',P_output.A,'b', -P_output.d) + P_output.v;
    Vout = polyh_output.V;
    subplot(1,2,1)
    hold on
    Vout1 = Vout(:,[1,2,3]);
    polyh_out1 = Polyhedron(Vout1);
    polyh_out1.plot('edgealpha',0.5,'alpha',0.7)

    subplot(1,2,2)
    hold on
    Vout2 = Vout(:,[1,4,5]);
    polyh_out2 = Polyhedron(Vout2);
    polyh_out2.plot('edgealpha',0.5,'alpha',0.7)

end



