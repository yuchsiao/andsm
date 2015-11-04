function plot_dataset(data, varargin)

if ~isempty(varargin)
    ind = varargin{1};
    N = length(ind);
    
    data_tmp.t = {};
    data_tmp.u = {};
    data_tmp.x = {};
    data_tmp.y = {};
    data_tmp.dx = {};
    
    for i = 1:N
        data_tmp.t = [data_tmp.t, data.t{i}];
        data_tmp.u = [data_tmp.u, data.u{i}];
        data_tmp.x = [data_tmp.x, data.x{i}];
        data_tmp.y = [data_tmp.y, data.y{i}];
        data_tmp.dx = [data_tmp.dx, data.dx{i}];
    end
    plot_data(data_tmp.t,data_tmp.u, data_tmp.x, data_tmp.y, data_tmp.dx);    
    for i = 1:N
        subplot(2,N,i);
        title(['Set ', num2str(ind(i))]);
    end
else
    plot_data(data.t,data.u, data.x, data.y, data.dx);    
end

