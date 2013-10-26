function [ V_norm, V_avg ] = normalize( V )
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here
    nzero = sum(V~=0,2);
    V_avg = repmat(sum(V,2)./nzero,1,size(V,2));
    V_norm = V-V_avg.*(V~=0);
end

