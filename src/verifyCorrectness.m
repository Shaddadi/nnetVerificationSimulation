function verifyCorrectness(S, p_randm, p_bef_relu, network)
    A = S(:,1:end-1);
    d = S(:,end);
    Polyh = Polyhedron('A', A,'b',-d);

%     figure 
%     hold on 
%     plot(Polyh)
%     plot(p_randm(1), p_randm(2),'*')

    % % verify correctness, check if all sample points within the Polyh locate in the same domain
    % % of coordinate in each layer as the simluation point does.
    num = 1000;
    V = Polyh.V';
    P = [];
    fprintf('\nVerify correctness... ')
    for n = 1: num
        r = rand(1, size(V,2));
        r = r / sum(r);
        p_temp = V*r';
%         plot(p_temp(1),p_temp(2),'c*')
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