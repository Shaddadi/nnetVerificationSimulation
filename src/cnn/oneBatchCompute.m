function [newInputSets, newOutputSets, newCounterSets, inputPoints] =...
    oneBatchCompute(randmNum, allInputSets, S_r, network, S_unsafe)

    % %compute the reachable set for each random input simulation point
    % that has unique activated domain
    
    % random input point 
    lb = S_r.lb;
    ub = S_r.ub;
    inputPoints = lb + rand(length(lb),randmNum).*(ub-lb);
    
    % compute activated domain sets and their input convex sets
    [newInputSets, newOutputSets, newCounterSets]= computeSets(inputPoints, allInputSets, S_r, network, S_unsafe);
end