function newdoms = nextFFnetTrack(x_extreme, dom1, network)
   newdoms = {};
   dom2 = extractActivatedDomainSingle(x_extreme, network);  
    for n = 1:length(dom1)
        for i = 1:length(dom1{n})
            v2 = dom2{n}(i);
            v1 = dom1{n}(i);
            if (abs(v2)<=1.0e-10)&&(abs(v1)>1.0e-10) % v1 != 0 and v2 = 0
                dom_temp = dom1;
                dom_temp{n}(i) = -sign(v1);
                newdoms(end+1) = {dom_temp};
            end
        end
    end
end