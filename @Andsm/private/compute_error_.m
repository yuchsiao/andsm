function [errl2, errlinf] = compute_error_(t1, x1, t2, x2)

try
    err_l2_tmp  = compute_avg_L2_error_(t1,x1,t2,x2);
    err_linf_tmp= compute_max_Linf_error_(t1,x1,t2,x2);
catch
    err_l2_tmp = inf;
    err_linf_tmp = inf;
end
y_L2   = compute_avg_L2_error_(  t2, x2, t2, zeros(size(x2)));
y_Linf = compute_max_Linf_error_(t2, x2, t2, zeros(size(x2)));

errl2   = err_l2_tmp / y_L2;
errlinf = err_linf_tmp / y_Linf;
