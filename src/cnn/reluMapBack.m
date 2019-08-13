function [S1, weights_linear] = reluMapBack(S2, acDomain)
    % remove negative sign

    nonAcDomain = [acDomain<0];
    S2.A(:, nonAcDomain)=0;
    
    [Ap, dp] = acDomainRange(acDomain);
    S1.A = [S2.A; Ap];
    S1.d = [S2.d; dp];
    
    w_linear = speye(length(acDomain));
    b_linear = sparse(length(acDomain),1);
    w_linear(nonAcDomain, nonAcDomain) = 0;
    weights_linear.W = w_linear;
    weights_linear.b = b_linear;
    
%     S1 = zeros(length(acDomain)+size(S2,1), size(S2,2));
%     nonAcDomain = [acDomain<0];
%     S1(:,nonAcDomain) = 0;
end

function [Ap, dp] = acDomainRange(acDomain)
    % create point's range according to the sign 
    sign_p = sign(acDomain);
    neuron_num = length(sign_p);

    Ap = sparse(1:neuron_num,1:neuron_num, -sign_p, neuron_num, neuron_num);
    dp = sparse(neuron_num,1);
end