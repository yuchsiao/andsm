function err = compute_L2_error_(t1,x1,t2,x2)
%* Compute L2 error using tabulation values at t1 for scalar signal

%* Interpolate x2 at t1
% pp = spline(t2, x2);
% x2_t1 = ppval(pp, t1);
% plot(t2,x2,'.',t1,x2_t1,'x')

%* Setup spline func for |x2-x1|^2
% pp = spline(t1, abs(x2_t1-x1).^2);
% plot(t1, sqrt(ppval(pp,t1)));

% err = sqrt(integral(@(t) ppval(pp,t),t1(1),t1(end)));

% x2_t1 = interp1(t2,x2,t1);
% 
% val = ppval(pp,t1(2:end));
% err = sqrt(diff(t1)'*val);

x2_t1 = interp1(t2,x2,t1, 'linear', 'extrap');
dt1 = diff(t1);
intu = dt1'*(x2_t1(2:end)-x1(2:end)).^2;
intl = dt1'*(x2_t1(1:end-1)-x1(1:end-1)).^2;
err = sqrt( (intu+intl)/2 );


% err = sqrt(integral(@(t) abs(interp1(t2,x2,t, 'linear') - interp1(t1,x1,t, 'linear')).^2, t1(1), t1(end)));
