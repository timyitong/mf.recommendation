function [ V_norm, Med, DevMed ] = normalize_median( V )
%   make the median of each column 0.5
%   make the deviation from median to 0.25
%   truncate each element intot he range of [0.0001, 1]

m = size(V, 1);
n = size(V, 2);
Med = zeros(m, 1);
DevMed = zeros(m,1);

for i=1:m
    non_zero_elements = V(i,V(i, :)~=0);
    med = median(non_zero_elements);
    Med(i) = med;
    % set median to 0.5
    V(i, :) = V(i, :)/med*0.5;
    dev_med = median(abs(non_zero_elements-0.5));
    DevMed(i) = dev_med;
    if (dev_med ~= 0)
        % set the median of the deviation to the median to 0.25
        V(i, V(i, :)~=0) = 0.5+(V(i, V(i, :)~=0)-0.5)*(0.25/dev_med);
    end
    % truncate each element
    for j=1:n
        if (V(i, j) > 1)
            V(i, j) = 1;
        end
        if (V(i, j) < 0.0001)
            V(i, j) = 0.0001;
        end
    end
end

V_norm = V;
V_norm(isnan(V_norm)) = 0.0001;
end

