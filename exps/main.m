%------------------------
% MOVIE_LENS DATASET
%------------------------
train_filename              = '../data/ml-100k/u1.base';
test_filename               = '../data/ml-100k/u1.test';
usernum                     = 943;
itemnum                     = 1682;
% Load Data
V                           = read_movielens_data(train_filename, usernum, itemnum);
V_test                      = read_movielens_data(test_filename, usernum, itemnum);
% Mask of V
Omega                       = V~=0;
Omega_test                  = V_test~=0;

% Mean and l2 normalization
[V_norm, V_avg]             = normalize( V );
[V_test_norm, V_test_avg]   = normalize( V_test );

% Median normalization
%   make the median of each column 0.5
%   make the deviation from median to 0.25
[V_norm_median, V_med, V_devmed]             = normalize_median( V);
[V_test_norm_median]        = normalize_median( V_test);

%------------------------
% k Nearest Neighbour
%------------------------
k_range                     = round(linspace(1, 800, 10));
plot_name                   = '../plots/knn/rmse-knn-800.eps';
knn_main(V_norm, V_avg, V_test, k_range, plot_name);

%------------------------
% NMF Mathworks
% somehow not working
% always output the same value
%------------------------
k                           = 50;
steps                       = 300;

err = [];
for k = large_k_range
    [W, H, fnc_vals] = nmf_raw(V_norm_median, k, steps);
    % W_norm = normalize_median(W);
    % [ H_test, fnc_vals ] = nmf_raw_test( V_test_norm_median, W , k, steps);
    [ V_predict ] = denormalize_median( W*H, V_med, V_devmed );
    err = [err;rmse(V_predict, V_test)];
end
figure(1);plot(k_range, err, '-'); saveas(1, '../plots/nmf/rmse-median_norm-800.eps');

%-------Sparse NMF ----
alpha = 0.3;
fname = 'snmf';
showflag = 0;
k = 50;
err = [];
for  k = k_range
    [W, H, objhistory] = snmf( V_norm_median, k, alpha, fname, showflag );
    [ V_predict ] = denormalize_median( W*H, V_med, V_devmed );
    err = [err;rmse(V_predict, V_test)];
end
figure(2);plot(k_range, err, '-'); saveas(1, '../plots/nmf/rmse-snmf-100.eps');

%-------local NMF ----
alpha = 0.3;
fname = 'snmf';
showflag = 0;
beta = 0.3;
k = 50;
err = [];
for  k = k_range
    [W, H, objhistory] = lnmf( V_norm_median, k, alpha,beta, fname, showflag );
    [ V_predict ] = denormalize_median( W*H, V_med, V_devmed );
    err = [err;rmse(V_predict, V_test)];
end
figure(2);plot(k_range, err, '-'); saveas(1, '../plots/nmf/rmse-snmf-100.eps');



%===================
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

%Version 1: median normalization

Y = V_norm_median;
lambda = linspace(0.1, 100, 10);
maxit = 500;
epsilon = 0.0001;
Omega = Y~=0;
err = [];

for i = 1:10
    B_init = randn(size(Y));
    [B, fks] = soft_impute(Y, B_init, Omega, lambda(i), epsilon, maxit);
    [ B_norm ] = denormalize_median( B, V_med, V_devmed );
    err = [err; rmse(B_norm, V_test)];

%     [B_med] = normalize_median(B); 
%     err = [err; rmse(B_med, V_test_norm_median)];
end
figure(1);plot(lambda, err, '-'); saveas(1, '../plots/soft_impute/rmse-soft-Ymedian-800.eps');


%Version 1: median normalization

Y = V;
lambda = linspace(0.1, 100, 10);
maxit = 500;
epsilon = 0.0001;
Omega = Y~=0;
err = [];

for i = 1:10
    B_init = randn(size(Y));
    [B, fks] = soft_impute(Y, B_init, Omega, lambda(i), epsilon, maxit);
    [ B_norm ] = denormalize_median( B, V_med, V_devmed );
    err = [err; rmse(B_norm, V_test)];

%     [B_med] = normalize_median(B); 
%     err = [err; rmse(B_med, V_test_norm_median)];
end
figure(2);plot(lambda, err, '-'); saveas(2, '../plots/soft_impute/rmse.soft_Y.eps');


%------------------------
% LDA
%------------------------
% cluster movies into clusters
err = [];

large_k_range = [1    90   179   267   356   445   534];

for k = large_k_range %1:5:100
    alpha = real(load(strcat('../lda-c/lda-0.2/results/ml.movie.model',num2str(k),'.alpha')))';
    N = size(alpha, 1);
    beta = real(load(strcat('../lda-c/lda-0.2/results/ml.movie.model',num2str(k),'.beta')))'; % each column is the probability for given movie into a topic's probability
    % movie_topic = (alpha*ones(1, itemnum)).*beta;
    movie_topic = beta;
    user_topic = V*movie_topic';
    % for i = 1:usernum
    %     user_topic(i,:) = user_topic(i,:)/sum(user_topic(i,:));
    % end

    movie_avg = ones(1,itemnum);
    for i = 1:itemnum
        nonzeros = V(V(:,i) ~= 0,i);
        movie_avg(1,i) = mean(nonzeros);
        if (isnan(movie_avg(1,i)))
            movie_avg(1,i) = 0;
        end
    end
    topic_avg = movie_avg*movie_topic';

    Predict = user_topic*movie_topic;

    Predict_norm = ones(size(Predict));
    for i = 1:size(Predict, 1)
        Predict(i, :) = Predict(i, :) - mean(Predict(i, :));
        Predict_norm(i,:) = Predict(i, :) / norm(Predict(i, :));
        Predict_norm(i,:) = Predict_norm(i,:) / (max(Predict_norm(i,:))-min(Predict_norm(i,:))) * 5;
        Predict_norm(i,:) = Predict_norm(i,:) + V_avg(i,:);
    end

    % Predict_norm = denormalize_median(Predict, V_med, V_devmed);
    err = [err;rmse(Predict_norm, V_test)];
end

plot(large_k_range, err);

%------------------------
% PCA
%------------------------


%------------------------
% ICA
%------------------------