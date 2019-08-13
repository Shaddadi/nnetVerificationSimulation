function verifyCorrectness(S, p_randm, p_bef_relu, network)
    A = S(:,1:end-1);
    d = S(:,end);
    Polyh = Polyhedron('A', A,'b',-d);


    % % verify correctness, check if all sample points within the input domain locate in the same domain
    % % of coordinate in each layer as the simluation point does.
    num = 1000;
    V = Polyh.V'; 
    P_num = 5; % number of points that are selected for random points
    fprintf('\nVerify correctness... ')
    for n = 1: num
        idx = randi(size(V,2),1,P_num);
        P_select = V(:,idx); % selected V points
        r = rand(1, P_num);
        r = r / sum(r);
        p_temp = P_select*r';
        
        [y, p_bef_temp] = networkOutputSingle(p_temp,network);
        for i = 1:length(p_bef_temp)
            if sign(p_bef_relu{i}) ~= sign(p_bef_temp{i})
                fprintf('fail \n')
                break;
            end
        end
    end
    fprintf('Pass! \n\n')
%     hold off 
end