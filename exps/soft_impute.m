function [B, fks] = soft_impute(Y, B_init, Omega, lambda, err, maxit)
%SOFT_IMPUTE: implementation of soft-impute algorithm
%Args:
%   Y: train matrix
%   Omega: the observed data entries mask, contains only 0,1
%   lambda: soft thresholding value
%   err: err requirement
%   maxit: max iteration times
%Return:
%   B: estimated matrix
%   i: iteration times
%   fk: objective function values when finished, including the init value

% Define obj function
% input: Y, Bs, Omega
%        S: Sigma matrix as the diagonal matrix after SVD,
%        lambda
f = @(Y, B, Omega, S, lambda) 0.5*norm((Y-B).*Omega,'fro')^2+lambda*sum(S(:));

% The opposite projct
Omega_opp = Omega==0;
% f0 objective function value
[U, S, V] = svd(B_init);
fk = f(Y, B_init, Omega, S, lambda);
fks = fk;
B = B_init;

for i=1:maxit
    X = Y.*Omega + B.*Omega_opp;
    [U, S, V] = svd(X, 0);
    S_lambda = max(S-lambda,0);
    B = U*S_lambda*V';
    new_fk = f(Y, B, Omega, S, lambda);
    if abs(new_fk-fk)/fk < err
        break;
    else
        fk = new_fk;
        fks = [fks;fk];
    end
end

end

