% % getting variables that are mapped to the variable of current layer from
% the previous layer
% @ c: column id of current layer
% @ r: row id of current layer
% @ siz: window size
% @ stride: window stride
% @ dim: dimension of the image matrix in the previous layer
function xs = getBlockMaxP(c, r, d, siz, stride, dim1, depth1)

    if siz ~= 2
        fprint('The pool size is not 2x2!')
        exit;
    end
    siz_m = [1,1,2,2;1,2,1,2]; % for the 2x2 pool

    xs = [dim1*depth1*stride, depth1*stride,1]*[c,r,d]' + ...
        [dim1*depth1, depth1]*siz_m - (stride+1)*dim1*depth1-(stride+1)*depth1;

end 