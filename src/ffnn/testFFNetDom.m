function  [x_extreme, d, counter] = testFFNetDom(dom1, network, S_r, S_unsafe)
   counter = "";
    % % check if there are counter examples in the track
    P_input = nnetInputConvexSet(dom1, network, S_r);
    P_output = nnetOutputConvexSet(P_input, dom1, network);
    [x_extreme, d, counter] = findFFnetExtreme(P_output, S_unsafe);
    if counter == "counter" 
        d = 0;
        return
    elseif counter == "invalid"
        x_extreme = [];
        d = [];
        return
    end     

end