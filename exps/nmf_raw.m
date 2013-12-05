function [ W, H, fnc_vals ] = nmf_raw( V, k, steps)
fcn = @(V, W, H) 0.5*norm(V-W*H,'fro').^2;

m = size(V, 1);
n = size(V, 2);
% uniform (0,1) random matrices
W = rand(m, k);
H = rand(k, n);
fnc_vals = fcn(V, W, H);
for i=1:steps
    H = H.*(W'*V)./(W'*W*H);
    W = W.*(V*H')./(W*H*H');
    fnc_vals = [fnc_vals;fcn(V, W, H)];
end

end

