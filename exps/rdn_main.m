usernum                     = 943;
itemnum                     = 1682;
V_raw                       = rand(usernum, itemnum);
Omega                       = rand(usernum, itemnum) < 0.8;
Omega_test                  = Omega == 0;
% Load Data
V                           = V_raw.*Omega;
V_test                      = V_raw.*Omega_test;
% Mean and l2 normalization
[V_norm, V_avg]             = normalize( V );
[V_test_norm, V_test_avg]   = normalize( V_test );
% Median normalization
%   make the median of each column 0.5
%   make the deviation from median to 0.25
med                      = 0.5;
meidan_deviation            = 0.25;
[V_norm_median, MED, DEVMED]             = normalize_median( V);
[V_test_norm_median, tMED, tDEVMED]        = normalize_median( V_test);

%------------------------
% k Nearest Neighbour
%------------------------
k_range                     = linspace(1, 100, 10);
plot_name                   = '../plots/knn_pseudo/rmse.knn.eps';
knn_main(V_norm, V_avg, V_test, k_range, plot_name);

%------------------------
% NMF Mathworks
% somehow not working
% always output the same value
%------------------------
k                           = 50;
steps                       = 300;
err = [];
for k = k_range
    [W, H, fnc_vals] = nmf_raw(V_norm_median, k, steps);
    W_norm = normalize_median(W);
    [ H_test, fnc_vals ] = nmf_raw_test( V_test_norm_median, W , k, steps);
    [Predict] = denormalize_median(W_norm*H_test, MED, DEVMED);
    err = [err;rmse(Predict, V_test)];
end;
figure(1);plot(k_range, err,'-');saveas(1,'../plots/nmf_pseudo/uniform_rdn.rmse.nmf-denorm_median_true.eps');

err = [];
for k = k_range
    [W, H] = sqrtnmf(V_norm_median, k, 1);
    [Predict] = denormalize_median(W*H, MED, DEVMED);
    err = [err;rmse(Predict, V_test)];
end
figure(1);plot(k_range, err,'-');saveas(1,'../plots/nmf_pseudo/uniform_rdn.rmse.sqrtnmf-denorm_median.eps');


    % try to use S in knn and V to train nmf
[V_norm_2, V_avg_2] = normalize( V_est );
[V_est_2, S_2] = knn(V_norm_2,V_avg_2, k);
err = rmse(V_est_2, V_test);
disp(err);



[W, H] = nmf(V_est_2, nmf_rank_size, 1);
V_hat = (W*H);
err = rmse(V_hat, V_test);
disp(err);


    % smaller dataset  rmse 1.0541
    [Tr_norm, Tr_avg] = normalize( Tr );
    Tr_norm = max (0, Tr_norm);
    [W, H] = nmf(Tr_norm, nmf_rank_size, 1);
    V_hat = (W*H);
    err = rmse(V_hat+Tr_avg, Te);
    disp(err);

%------------------------
% Soft impute
%------------------------

Y = V;
lambda = linspace(0.1, 100, 10);
maxit = 500;
err = [];
Omega = Y~=0;

for i = 1:10
    B_init = zeros(size(Y,1),size(Y,2));
    [B, fks] = soft_impute(Y, B_init, Omega, lambda(i), err, maxit);
    [B_norm] = denormalize_median(B, MED, DEVMED);
    err = [err;rmse(B_norm, V_test)];
end
figure(1);plot(lambda, err,'-');saveas(1,'../plots/soft_impute_pseudo/soft-impute-denorm_median.eps');

    % smaller dataset
    Y = Tr;
    Omega = Y~=0;
    B_init = zeros(size(Y,1),size(Y,2));
    [B, i, fks] = soft_impute(Y, B_init, Omega, lambda, err, maxit);
    err = rmse(B, Te);
    disp(err);

%------------------------
% LDA
%------------------------



%------------------------
% PCA
%------------------------

%------------------------
% ICA
%------------------------