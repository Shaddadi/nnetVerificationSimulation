
hold on
for n = 1:length(Xs)
    ps = [];
    for i = 1:size(Xs{n},2)
        ptrack = extractActivatedDomainSingle(Xs{n}(:,i),network);
        pend = ptrack{end};
        ps = [ps,pend];
    end
     
    plot(ps(1,:), ps(2,:), '*')
    hold on
end