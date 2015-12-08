function [err_avg, noise_avg] = compute_avg_l2_error_(t1,x1,t2,x2, varargin)
% err_avg =   ( sqrt(sum( || sim y_i - ref y_i ||^2 ) ) / T
%             + sqrt(sum( || ref y_i - sim y_i ||^2 ) ) / T  )/2
% noise_avg = ( sqrt(sum( || sim y_i - ref y_i ||^2 ) ) / T
%             - sqrt(sum( || ref y_i - sim y_i ||^2 ) ) / T  )/2

%* Check end time
if t1(end) ~= t2(end)
    error 'End times must be the same';
end
tend = t1(end);

unit = 1;
if nargin >= 5
    unit = varargin{1};
end

n = size(x1,2);
err1_sq = 0;
err2_sq = 0;

for i = 1:n
    err1_sq = err1_sq + compute_l2_error_(t1,x1(:,i),t2,x2(:,i)).^2;
    err2_sq = err2_sq + compute_l2_error_(t2,x2(:,i),t1,x1(:,i)).^2;
end

err_avg = (sqrt(err1_sq) + sqrt(err2_sq))/2 /tend*unit; 
noise_avg = abs(sqrt(err1_sq) - sqrt(err2_sq))/2 /tend*unit;
