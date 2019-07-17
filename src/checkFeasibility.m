function checkFeasibility(p, S)
    A = S(:,1:end-1);
    d = S(:,end);
    
    % check p
    Polyh = Polyhedron('A', A,'b',-d);
    fprintf('isEmptySet: %d \n', Polyh.isEmptySet)
    fprintf('contains: %d \n', Polyh.contains(p))
    
    figure
    hold on 
    plot3(p(1),p(2),p(3),'*')
    Polyh.plot('edgealpha',0.1,'alpha',0.5)
    hold off 
end 