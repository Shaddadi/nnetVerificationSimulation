% % detect and extract different activated domains from simulation points track 
% @outpAcDomains: activated domains sets including the inputAcDomains and newfound
% activated domains sets 
% @newFoundFlag: (True, False), it indicates if new activated domains are found
% function newAcDomains = extractActivatedDomain(inputPoints, oldAcDomains, network)
%     newAcDomains = {};
%     allAcDomains = oldAcDomains;
%     
%     layerNum = network.layerNum;
%     for i = 1:size(inputPoints,2)
%         [~,p_sign]= extractActivatedDomainSingle(inputPoints(:,i), network);
%         
%         % check if the same point track exists in AcDomains
%         domainFlag = true;
%         for j = 1:length(allAcDomains)
%             for m = 1:layerNum-1 % assume the last layer is linear          
%                 layerFlag = false;
%                 if ~isequal(p_sign{m}, allAcDomains{j}{m})                    
%                     layerFlag = true;
%                     break;
%                 end
%             end
%             if layerFlag
%                 continue;
%             else
%                 domainFlag = false;
%                 break;
%             end
%         end
%         
%         if domainFlag
%             newAcDomains(end+1)= {p_sign}; %newfound activated domain sets
%             allAcDomains(end+1)= {p_sign};
%         end
%     end
%     
% end

function [newInputSets, newOutputSets, newAcDomains] =...
    extractActivatedDomain(inputPoints, allInputSets, S_r, network, S_unsafe)
    newInputSets = {};
    newOutputSets = {};
    newAcDomains = {};
    for i = 1:size(inputPoints,2)
        fprintf(['points: ', num2str(i),'/',num2str(size(inputPoints,2)),'\n'])
        p = inputPoints(:,i);
        flag_all = true;
        for j = 1:length(allInputSets)
            Pin = allInputSets{j};
            flag_p = FnInside(p, Pin);
            if flag_p
                flag_all = false;
                break;
            end
        end
        
        if flag_all
            p_track= extractActivatedDomainSingle(inputPoints(:,i), network);         
            P_input = nnetInputConvexSet(p_track, network, S_r);
            P_output = nnetOutputConvexSet(P_input, p_track, network);
            x = nnetVerifyOutput(P_output, S_unsafe);
            p_track2 = extractActivatedDomainSingle(x, network); 
            
           
            newInputSets(end+1) = {P_input};
            newOutputSets(end+1) = {P_output};
            allInputSets(end+1) = {P_input};
            newAcDomains(end+1) = {p_track};
        end
    end
end

function y = FnInside(p, Pin)
    x = Pin.A*p + Pin.d;
    if sum([x<=0]) == length(x)
        y = true;
    else
        y = false;
    end
end