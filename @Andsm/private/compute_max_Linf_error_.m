function [err_avg, noise_avg] = compute_max_Linf_error_(t1,x1,t2,x2)

%* Check end time
if t1(end) ~= t2(end)
    error 'End times must be the same';
end

n = size(x1,2);
err1 = -inf;
err2 = -inf;

for i = 1:n
    err1 = max(err1, compute_Linf_error_(t1,x1(:,i),t2,x2(:,i)));
    err2 = max(err2, compute_Linf_error_(t2,x2(:,i),t1,x1(:,i)));
end

err_avg   =    (err1 + err2)/2 ; 
noise_avg = abs(err1 - err2)/2 ;
