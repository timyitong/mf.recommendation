function [ B ] = denormalize_median( V, Med, DevMed )
m = size(V, 1);
n = size(V, 2);
B = zeros(size(V));
for i = 1:m
    dev_med = DevMed(i);
    med = Med(i);
    % set back the median from 0.5
    b_median = median(V(i,:));
    B(i, :) = V(i, :)/b_median*med;
    non_zero_elements = B(i,B(i, :)~=0);
    b_devmedian = median(abs(non_zero_elements-med));
    if (dev_med ~= 0)
        % set back the median of the deviation from the median of 0.25
        B(i, V(i, :)~=0) = (B(i, V(i, :)~=0)-med)*(dev_med/b_devmedian)+med;
    end
%     m1 = min(B);
%     m2 = max(B);
%     B(i, :) = 5*(B(i, :)-m1)/(m2-m1);
    % truncate each element
    for j=1:n
        if (B(i, j) > 5)
            B(i, j) = 5;
        end
        if (B(i, j) < 0.0001)
            B(i, j) = 0.0001;
        end
    end
end

end

