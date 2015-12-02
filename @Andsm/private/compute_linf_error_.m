function err = compute_Linf_error_(t1,x1,t2,x2)
%* Compute Linf error using tabulation values at t1 grids

%* Interpolate x2 at t1
% pp = spline(t2, x2);
% x2_t1 = ppval(pp, t1);
x2_t1 = interp1(t2, x2, t1, 'linear');

%* Compute Linf error
err = max(abs(x2_t1 - x1)); 

