function dx = diff_lanczos(x,t,N)
% N: filter length
% x: signal
% t: time or time step

x = x(:);
t = t(:);

len = length(x);
coeff = get_coeff(N);
M = (N-1)/2;

dx = zeros(size(x));
for i = M+1 : len-M
    weight = get_time_step(t,i,N);    
    dx(i) = (coeff.*weight)*x(i-M:i+M);
end

% for the first and last one, use forward and backward difference
dx(1) = (x(2)-x(1))/(t(2)-t(1));
dx(end) = (x(end)-x(end-1))/(t(end)-t(end-1));

for i = 2:M
    m = i-1;
    coeff = get_coeff( 2*m+1 );
    weight = get_time_step(t,i,2*m+1);
    dx(i) = (coeff.*weight)*x(1:2*m+1);
end
for i =len-M+1:len-1
    m = len-i;
    coeff = get_coeff( 2*m+1 );
    weight = get_time_step(t,i,2*m+1);
    dx(i) = (coeff.*weight)*x(i-m:len);
end


end

function weight = get_time_step(t, i, N)
% weight =: 1./time_step
M = (N-1)/2;
time_step = (t(i+1:i+M) - flipud(t(i-M:i-1)))./(1:M)'/2;
weight = [1./flipud(time_step); 0; 1./time_step]';
end

function coeff = get_coeff(N)

coeff = zeros(1,N);

M = (N-1)/2;

for k = 1:M
   coeff(k+M+1) = 3*k/(M*(M+1)*(2*M+1)); 
end
coeff(1:M) = -fliplr(coeff(M+2:end));
end