% @ S2: convex sets of current layer 
% @ dim2: size of the image in current layer 
% @ dim1: size of the image in previous layer
% @ params: size of the pool
% @ depth: image depth
% @ S1: computed convex set of the previous layer
function [S1, W_linear] = maxPoolMapBack(S2, params, acDomain)

    siz = params.size; % pool size
    stride = params.stride; % pool stride
    dim1 = params.dim1;
    dim2 = params.dim2;
    row1 = dim1(1); % image row size before ... 
    depth = dim1(3); % image depth before ... 
    row2 = dim2(1); % image row size after ... 

    A2 = S2.A; d2 = S2.d; % convex parameters Ax+d<=0
    A1_s1 = sparse((siz*siz-1)*row2*row2*depth, row1*row1*depth); 
    d1_s1 = zeros((siz*siz-1)*row2*row2*depth, 1); 
    A1 = zeros(size(A2,1), row1*row1*depth); % A1 and d1 store modified A2 and d2
    d1 = zeros(size(A2,1), 1); 
    
    w_linear = sparse(row2*row2*depth, row1*row1*depth); % linear weights
    b_linear = sparse(row2*row2*depth, 1); 
    n = 1;
    for i = 1: row2
        for j = 1:row2  
            for d = 1:depth
                xs = getBlockMaxP(i, j, d, siz, stride, row1, depth);
                xact = acDomain(i,j,d);
                
                % add x - xact <=0 to S1
                for x = xs
                    if x ~=xact
                       A1_s1(n, x) = 1;
                       A1_s1(n, xact) = -1;
                       n=n+1;
                    end
                end
                
                % % map A2 and d2 to A1 and d1
                xid = idConvert([i, j, d], row2, depth); % x id in the layer 2
                A1(:, xact) = A2(:, xid);
                w_linear(xid, xact) = 1;             
            end         
        end
    end
    
    d1 = d2;
    S1.A = [A1_s1; sparse(A1)];
    S1.d = [d1_s1; d1];
    
    W_linear.W = w_linear;
    W_linear.b = b_linear;
end