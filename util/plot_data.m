function plot_data(t,u,x,y,varargin)

% if size(u)~=size(x) || size(x)~=size(y)
%     error 'u, x, y must be of the same length';
% end

m = 1;
n = length(u);

if nargin == 5
    dx = varargin{1};
    m = 2;
end

figure;

for i = 1:n
    subplot(m,n,i);
    hold all;
    if ~isempty(u)
        plot(repmat(t{i},1,size(u{i},2)),u{i}, '-.');
    end
    if ~isempty(x)
        plot(repmat(t{i},1,size(x{i},2)),x{i});
    end
    if ~isempty(y)
        plot(repmat(t{i},1,size(y{i},2)),y{i}, 'x', 'MarkerSize', 2);
    end
end

if m == 2
    for i = 1:n
        subplot(m,n,i+n);
        hold all;
        plot(repmat(t{i},1,size(dx{i},2)),dx{i});
    end
end
        

