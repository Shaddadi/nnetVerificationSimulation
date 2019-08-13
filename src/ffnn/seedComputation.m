function [inputSets, outputSets, acDomains, inputPoints]=...
    seedComputation(randmNum, lb, ub, network, S_unsafe)
    
    % %compute the reachable set for each random input simulation point
    % restricted convex set by bounds
    inputDim = length(lb);
    S_r = [eye(inputDim),-ub; -eye(inputDim),lb];
    A_r = S_r(:,1:end-1);
    d_r = S_r(:,end);
    
    % random input point 
    inputPoints = lb + rand(length(lb),randmNum).*(ub-lb);
    
    % compute activated domain sets
    allInputSets = {};
    [inputSets, outputSets, acDomains]=...
        extractActivatedDomain(inputPoints, allInputSets, S_r, network, S_unsafe);
    

end