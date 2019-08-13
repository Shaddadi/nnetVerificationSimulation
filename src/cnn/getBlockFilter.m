% % getting variables that are mapped to the variable of current layer from
% the previous layer
% @ c: column id of current layer
% @ r: row id of current layer
% @ siz: window size
% @ stride: window stride
% @ dim: dimension of the image matrix in the previous layer
function xs = getBlockFilter(r, c, siz, stride, row1, depth1)

    if siz ~= 3
        fprint('The filter size is not 3x3!')
        exit;
    end

    siz_m = [1,1,1,2,2,2,3,3,3;1,2,3,1,2,3,1,2,3];%combvec(1:siz, 1:siz); % for the 3x3 size
 
    xs = [];
    xs_temp = [row1*depth1*stride, depth1*stride]*[r,c]' + ...
            [row1*depth1, depth1]*siz_m - (stride+1)*row1*depth1-(stride+1)*depth1;
    for d = 1:depth1
        %idx_start = (d-1)*siz*siz +1; 
        %idx_end = idx_start + siz*siz-1;
        xs(end+1,:) = xs_temp + d;
    end
    
    xs = reshape(xs, 1,[]);

end 