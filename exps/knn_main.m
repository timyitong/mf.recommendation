function [ output_args ] = knn_main( V_norm, V_avg, V_test, k_range, plot_name)
% user-user
err = [];
for k=k_range
    [V_est, S] = knn(V_norm,V_avg, k);
    err = [err;rmse(V_est, V_test)];
end
figure(1); plot(k_range, err,'.-');
saveas(1, plot_name, 'psc2');

end

