% find num pixels on which pertubations most likely results in misclassification
function S_r = selectPixelsCNN(input_p, num, epsilon, network)
    [~, acDomain]= cnnInputPointSingle(input_p, network);
    layer2 = acDomain{2}; % before relu layer
    diff2 = layer2 - mean(layer2);
    [~, I]= sort(diff2, 'descend');
    Inum = I(1:num); % find the index of the first num max elements
    
    pixels = Pixels(Inum, network.params{1});
    
    inputDim = length(input_p);
    ub = zeros(inputDim,1);
    ub(pixels) = epsilon;
    ub = ub + input_p;
    ub(ub>1) = 1;
    
    lb = zeros(inputDim,1);
    lb(pixels) = -epsilon;
    lb = lb + input_p;
    lb(lb<0) = 0;
    
    S_r.A = [speye(inputDim); -speye(inputDim)];
    S_r.d = [-ub; lb];
    S_r.Ae = [];
    S_r.de = [];
    S_r.lb = lb;
    S_r.pixels = pixels;
    S_r.ub = ub;
end

function pixels = Pixels(Inum, params)
    siz = params.size; % filter size
    stride = params.stride; % filter stride
    dim1 = params.dim1;
    dim2 = params.dim2;
    row1 = dim1(1); % image row size before ... 
    depth1 = dim1(3); % image depth before ... 
    row2 = dim2(1); % image row size after ... 
    depth2 = dim2(3);
    
    pixels = [];
    for i = 1:length(Inum)
        [r,c,d] = getID(Inum(i), row2, depth2);
        xs_temp = getBlock(r, c, siz, stride, row1, depth1);
        pixels = [pixels, xs_temp];
    end
    pixels = unique(pixels);


end

function [r,c,d] = getID(id, row, depth)
    id = id-1;
    r = fix(id/(row*depth))+1;
    remd = rem(id, row*depth);
    
    c = fix(remd/depth)+1;
    d = rem(remd, depth)+1;
end

function xs = getBlock(r, c, siz, stride, row1, depth1)

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