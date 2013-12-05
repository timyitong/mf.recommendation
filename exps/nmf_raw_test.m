function [ H, fnc_vals ] = nmf_raw_test( V, W , k, steps)
n = size(V, 2);
H = rand(k, n);
fnc = @(V, W, H) 0.5*norm(V-W*H,'fro').^2;
fnc_vals = fnc(V, W, H);
for i=1:steps
   H = H.*(W'*V)./(W'*W*H);
   fnc_vals = [fnc_vals;fnc(V, W, H)];
end

end