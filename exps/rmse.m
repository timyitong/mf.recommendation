function  rmse  = rmse(Y, B)
% RMSE Calculation Function
% Args:
    % Y, test matrix
    % B, estimated matrix
    % Omega, observed data entries mask, should contains only 0,1
Omega = B~=0;
fbs = ((Y - B).*Omega).^2;
rmse = sqrt( sum(fbs(:)) / sum(Omega(:)) );
end


% function  err  = rmse( V, V_test )
% %RMSE Summary of this function goes here
% %   Detailed explanation goes here
%     nonz = V_test~=0;
%     len = sum( nonz(:));
%     err_m = (V.*nonz-V_test).^2;
%     err = sqrt(sum(err_m(:))/len);
% end