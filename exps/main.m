train_filename = '~/Dev/pilot_exp_rec/data/ml-100k/u1.base';
test_filename = '~/Dev/pilot_exp_rec/data/ml-100k/u1.test';
usernum = 943;
itemnum = 1682;

V = read_movielens_data(train_filename, usernum, itemnum);
[V_norm, V_avg] = normalize( V );

V_test = read_movielens_data(test_filename, usernum, itemnum);
[V_test_norm, V__test_avg] = normalize( V_test );

% Load small movie lens data
% Tr
% Te
load('~/Box Documents/convex optimazation/hw2/data/train.mat');
load('~/Box Documents/convex optimazation/hw2/data/test.mat');

%------------------------
% k Nearest Neighbour
%------------------------
k = 30;

% user-user
[V_est, S] = knn(V_norm,V_avg, k);

err = rmse(V_est, V_test);
disp(err);

% item-item
[V_est, S] = knn(V_norm',V_avg', k);

V_est = V_norm*S+V_avg;
err = rmse(V_est, V_test);
disp(err);

%------------------------
% NMF Mathworks
% somehow not working
% always output the same value
%------------------------
nmf_rank_size = 500;
[W, H] = nmf(S, nmf_rank_size, 1);
V_hat = (W*H)*V_norm+V_avg;
err = rmse(V_hat, V_test);
disp(err);

nmf_rank_size = 100;
[W, H] = sqrtnmf(S, nmf_rank_size, 1);
V_hat = (W*H)*V_norm+V_avg;
err = rmse(V_hat, V_test);
disp(err);

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
lambda = 100;
maxit = 500;
err = 0.0001;
Omega = Y~=0;
B_init = zeros(size(Y,1),size(Y,2));
[B, i, fks] = soft_impute(Y, B_init, Omega, lambda, err, maxit);
err = rmse(B, V_test);
disp(err);

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