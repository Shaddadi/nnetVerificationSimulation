function [newInputSets, newOutputSets, newAcDomains] = ...
    adjacentInput(outputSets, acDomains, allAcDomains, network, S_r)
    newInputSets = {};
    newOutputSets = {};
    newAcDomains = {};
    for n = 1:length(outputSets)
        aOutput = outputSets{n};
        aDomainSet = acDomains{n};
        for ilayer = 1:length(aOutput.Cnet)
            Ci = aOutput.Cnet{ilayer};
            vi = aOutput.vnet{ilayer};
            neuronNum = size(Ci,1);
            
            % check if the set intersects with a hyperplane imposed by neuron
            for j = 1:neuronNum
                hyperp = zeros(2,neuronNum+1); 
                hyperp(:,j) = [1;-1]; % xj  = 0
                Aj = hyperp(:,1:end-1); dj = hyperp(:,end);
                
                % map hyperp 
                newAj = Aj*Ci; newdj = Aj*vi + dj;
                
                % linear programming to check empty sets
                Aout = aOutput.A; dout = aOutput.d;
                f = zeros(1,size(Aout,2));
                %options = optimoptions('Display','off');
                [~,~,exitflag] = linprog(f, [Aout;newAj], -[dout; newdj]);
                if exitflag == 1 % 1 indicates feasibility and -2 indicates infeasibility
                    aNewDomainSet = aDomainSet;
                    aNewDomainSet{ilayer}(j) = aNewDomainSet{ilayer}(j)*(-1);
                    
                    % check if aNewDomainSet exists in acDomains
                    if ~acDomainContain(aNewDomainSet, allAcDomains)
                        newAcDomains(end+1) = {aNewDomainSet};
                        allAcDomains(end+1) = {aNewDomainSet};
                        
                        P_input = nnetInputConvexSet(aNewDomainSet, network, S_r);
                        newInputSets(end+1) = {P_input};
                        P_output = nnetOutputConvexSet(P_input, aNewDomainSet, network);
                        newOutputSets(end+1) = {P_output};
                    end
                end
            end
        end
    end
    
end