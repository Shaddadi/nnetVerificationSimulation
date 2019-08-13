% % filter layer mapping 
% @ S2: convex sets of current layer 
% @ dim2: size of the image in current layer 
% @ dim1: size of the image in previous layer
% @ params: weight matrix and bias of the filter
% @ stride: filter stride
% @ S1: computed convex set of the previous layer
function S1= filterMapBack(S2, params)
    W = params.W;
    b = params.b;
    
    A2 = S2.A; 
    d2 = S2.d;
    S1.A = A2*W; 
    S1.d = A2*b + d2;

end

