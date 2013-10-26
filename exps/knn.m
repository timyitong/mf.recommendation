function [V_est, S] = knn( V_norm, V_avg, k)
%KNN Summary of this function goes here
% always carry out row-row sim
    nrow = size(V_norm,1);
    S = zeros(nrow,nrow);
    [n, d] = knnsearch(V_norm, V_norm, 'k', k, 'distance', 'cosine');
    for i=1:nrow
        S(i,n(i,:)) = 1-d(i,:);
    end
    norms = repmat(sum(S,2)-sum(diag(S),2), 1, nrow);
    S = S./norms;
    
    V_est = S*V_norm+V_avg;
end

