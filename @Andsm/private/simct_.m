function [tt, uu, xx, yy] = simct_(model, time, input, init, varargin)

% Throw error messages if integration tolerance cannot be met
warning('error', 'MATLAB:ode23t:IntegrationTolNotMet');

n = model.n;  % number of states
m = model.m;  % number of inputs and outputs
tend = time(end);  % ending time

option = odeset;
if length(varargin)>=1
    option = varargin{1};
end

% generate f function
str = '';
for i = 1:n
    str = strcat(str, model.f{i}, '; ');
end
str = strcat('@(x,u) [', str, ']');
f = str2func(str);
ftx = @(t,x) f(x, interp1(time, input, t, 'spline'));

% generate E function
str = '';
for i = 1:n
    for j = 1:n
        str = strcat(str, model.E{i,j});
        if j~=n
            str = strcat(str, ', ');
        end
    end
    str = strcat(str, '; ');
end
str = strcat('@(t,x) [', str, ']');
E = str2func(str);

% generate h function
str = '';
for i = 1:m
    str = strcat(str, model.h{i}, '; ');
end
str = strcat('@(x,u) [', str, ']');
h = str2func(str);
htx = @(t,x) h(x, interp1q(time, input, t));

% simulate state equation
option.Mass = E;

init = init(:);
[tt,xx] = ode23t(ftx, [0, tend], init, option);

% simulate output equation
yy = zeros(length(tt), m);
for i=1:length(tt)
    yy(i,:) = htx(tt(i), xx(i,:));
end
% generate input uu corresponding to tt
uu = interp1q(time, input, tt);








