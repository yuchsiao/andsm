function dx = diff_robust(t,x,N,varargin)
%DIFF_ROBUST   Robust numerical differentiation of degree 2
%   using Lanczos or Holoborodko methods
%
%   x: multi-dimensional signal, time x dimension
%   t: time or time step
%   N: filter length
%   [method]: 'lanc', 'lanczos', 'holo', 'holoborodko'. default: 'holo'

% argin
method = 'holo';
if length(varargin) > 1
    disp('Usage: diff_robust(signals, time, [method])')
elseif length(varargin) == 1
    method = varargin{1};
end

% argin guard
if even(N)
    error 'Length of filter must be odd';
end

% pre-process argin
[m,n] = size(x);
flag_transpose = false;
if n>m
    x = x.';
    flag_transpose = true;
end
t = t(:);

dim = size(x,2);
dx = zeros(size(x));

for i = 1:dim
    if strcmpi(method,'lanc') || strcmpi(method,'lanczos')
        dx(:,i) = diff_lanczos(x(:,i),t,N);
    elseif strcmpi(method,'holo') || strcmpi(method,'holoborodko')
        dx(:,i) = diff_holoborodko(x(:,i),t,N);
    else
        dx(:,i) = diff_lanczos(x(:,i),t,N);
    end
end

% post-process output dx
if flag_transpose
   dx = dx.'; 
end

