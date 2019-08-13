function exitflag = isinside(dom, doms)
    if isempty(doms)
        exitflag = false;
        return
    end
    exitflag = true;
    for i = 1:length(doms)
        domi = doms{i};
        if ~isequaldom(dom, domi.dom)
            exitflag = false;
            break;
        end    
    end
end
function y = isequaldom(d1, d2)
    y = true;
    for n = 1:length(d1)
        if ~isequal(d1{n}, d2{n})
            y = false;
            break;
        end
    end
end