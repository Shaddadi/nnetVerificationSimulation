% % compute the reachable sets of one batch simulations 
% @inputSets: computed input convex sets after combining with the input bound
% @outputSets: computed output reachable convex sets 
% @outAcDomains: obtained activated domain sets
function [newInputSets, newOutputSets, newAcDomains, inputPoints] =...
    oneBatchCompute(randmNum, allInputSets, allAcDomains, lb, ub, network)
    % %compute the reachable set for each random input simulation point
    newOutputSets = {};
    Vin = [];
    inputDim = length(lb);
    % restricted convex set by bounds
    S_r = [eye(inputDim),-ub; -eye(inputDim),lb];
    A_r = S_r(:,1:end-1);
    d_r = S_r(:,end);
    
    % random input point 
    inputPoints = lb + rand(length(lb),randmNum).*(ub-lb);
    
    % compute activated domain sets
    [newInputSets, newAcDomains]= extractActivatedDomain(inputPoints, allInputSets, S_r, network);
    
    for n = 1:length(newInputSets)
        fprintf(['Current Output: ', num2str(length(allInputSets)),', ',...
            'New found and Completed: ',num2str(n),'/',num2str(length(newAcDomains)),'\n'])
%         % compute the input domain
%         p_bef_relu = newAcDomains{n};
%         S_in = nnetInputConvexSet(p_bef_relu, network);
%         
%         % construct input set.  
%         A_in = S_in(:,1:end-1); 
%         A = [A_in; A_r];
%         d_in = S_in(:,end);
%         d = [d_in; d_r];
% 
%         C = eye(size(A,2)); v = zeros(size(A,2),1);
%         P_input.A = A; P_input.d = d; %'A' and 'd' denote hyperplanes
%         P_input.C = C; P_input.v = v; %'C' and 'v' denote transformation matrix
%         inputSets{end+1} = P_input;

        P_input = newInputSets{n};
        p_bef_relu = newAcDomains{n};
        % compute output set 
        P_output = nnetOutputConvexSet(P_input, p_bef_relu, network);
        newOutputSets{end+1} = P_output;
    end
    
end
