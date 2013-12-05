function [ output_args ] = plot_score_dist( V, save_dir, num )
%PLOT_SCORE_DIST Summary of this function goes here
%   Detailed explanation goes here
for k=num  
    zz = V(k, V(k, :)~=0);
    figure(1);
    plot(zz, '-');
    file = strcat(save_dir, num2str(k),'.eps')
    saveas(1, file, 'psc2');
end
end

