% % check if the same point track exists in AcDomains
function exitflag = acDomainContain(aAcDomain, allAcDomains)
        domainFlag = true; % indicate this domain is different from the rest
        layerNum = length(aAcDomain);
        for j = 1:length(allAcDomains)
            for m = 1:layerNum-1 % assume the last layer is linear          
                layerFlag = false;
                if ~isequal(aAcDomain{m}, allAcDomains{j}{m})                    
                    layerFlag = true; % indicate this domain is different from allAcDomains{j}
                    break;
                end
            end
            if layerFlag
                continue;
            else
                domainFlag = false;
                break;
            end
        end
        
        if domainFlag
            exitflag = false; % aAcDomain is not contained 
        else
            exitflag = true; % aAcDomain is contained 
        end
end