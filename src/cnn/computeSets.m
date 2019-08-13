% compute activated domain sets and their input convex sets
function [newInputSets, newOutputSets, newCounterSets]= ...
    computeSets(inputPoints, allInputSets, S_r, network, S_unsafe)
    global totalSets
    newInputSets = {};
    newOutputSets = {};
    newCounterSets = {};
    
    for i = 1:size(inputPoints,2)
        p = inputPoints(:,i);
        %imagedis(p); [outputs, ~]= cnnInputPointSingle(p, network); softmax(outputs{end})
        flag_all = true;
        for j = 1:length(allInputSets)
            Pj = allInputSets{j};
            if FnInside(p, Pj)
                flag_all = false;
                break;
            end    
        end
        
        if flag_all
            totalSets = totalSets+1 ; 
            fprintf("The number of total found sets: %d \n", totalSets)
            [~, acDomain] = cnnInputPointSingle(p, network);
            [P_input, network] = cnnInputSetSingle(acDomain, network, S_r, p);
            P_output = cnnOutputSetSingle(P_input, network);
            
            [S_inter, exitflag] = cnnVerifyOutput(P_output, S_r, S_unsafe);
            allInputSets(end+1) = {P_input};
            if exitflag==1
                newCounterSets(end+1) = {S_inter};
                newInputSets(end+1) = {P_input};
                newOutputSets(end+1) = {P_output};
                break;
            end
        end
    end
end
    
    
function y = FnInside(p, P) % check if a point p is inside the convext set P
    x = P.A*p + P.d;
    if find(x>0)
        y = false;
    else
        y = ture;
    end
end