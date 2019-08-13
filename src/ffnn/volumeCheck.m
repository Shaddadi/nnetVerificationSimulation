
% % check if the input convex sets compose the entire input bound

function [endFlag, V, diffV]= volumeCheck(newInputSets, oldV, lb, ub)

    inputDim = length(lb);
    % restricted convex set by bounds
    S_r = [eye(inputDim),-ub; -eye(inputDim),lb];
    A_r = S_r(:,1:end-1);
    d_r = S_r(:,end);
    
    % compute volume of the input set
    newV = [];
    for n = 1:length(newInputSets)
        P_in = newInputSets{n};
        A_in = P_in.A; 
        A = [A_in; A_r];
        d_in = P_in.d;
        d = [d_in; d_r];
        Pin = Polyhedron('A', A,'b', -d);
        newV(end+1) = Pin.volume;
    end
    
    %check if the computed input sets compose the entire input bounds(lb, ub)
    Pb = Polyhedron('A', A_r,'b', -d_r);
    Vb = Pb.volume; epsilon = 1.0e-11;
    V = sum([newV, oldV]);
    diffV = Vb-V;
    if abs(Vb-V) <= epsilon
        endFlag = true;
    else
        endFlag = false;
    end
end