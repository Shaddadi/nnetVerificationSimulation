function checkFeasibility(p,S)
    A = S(:,1:end-1);
    d = S(:,end);
    
%     X = [];
%     for n = 1:size(A,1)
%         x = A(n,:)*p+d(n);
%         X = [X,x];
%         if x>0
%             fprintf('Hyperplane check: not feasible\n\n')
%             return
%         end
%     end
%     fprintf('Hyperplane check: feasible\n\n')
    
    fprintf('LinearProgram check: ')
    f = ones(size(A,2),1);
    x = linprog(f,A,-d);
    
%     % check p
    Polyh = Polyhedron('A', A,'b',-d);
    fprintf('isEmptySet check: %d \n', Polyh.isEmptySet)
%     fprintf('contains: %d \n', Polyh.contains(p))
%     
%     figure
%     hold on 
%     plot3(p(1),p(2),p(3),'*')
%     Polyh.plot('edgealpha',0.1,'alpha',0.5)
%     hold off 
end 