
hold on
for n = 1:length(Xs)
    ps = [];
    for i = 1:size(Xs{n},2)
        ptrack = extractActivatedDomainSingle(Xs{n}(:,i),network);
        pend = ptrack{end};
        ps = [ps,pend];
    end
    M = eye(5)*range_for_scaling(6);
    v = ones(5,1)*means_for_scaling(6);
    ps = M*ps + v;
    plot3(ps(1,:), ps(2,:), ps(3,:),'c*')
    hold on
end