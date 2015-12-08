function [err_l2, err_linf] = ctid_sim_error_(model, data_val)

K = length(data_val.t);

err_l2.data = zeros(1,K);
err_linf.data = zeros(1,K);

tind = cell(size(data_val.t));

if isfield(data_val, 'from_time')  % new version of data_val
    for k = 1:length(data_val.t)
        if isempty(data_val.from_time{k})
            data_val.from_time{k} = 0;
            tind{k} = data_val.t{k} >= 0;
        else
            tind{k} = data_val.t{k} >= data_val.from_time{k};
        end
    end
else  % backward compatible: validate everything
    data_val.from_time = cell(1, length(data_val.t));
    for k = 1:length(data_val.t)
        data_val.from_time{k} = 0;
        tind{k} = data_val.t{k} >= 0;
    end
end

for k = 1:length(data_val.t)
    try
        [tt, ~, ~, yy] = simct_(model, data_val.t{k}, data_val.u{k}, data_val.x{k}(1,:)');
        err_l2_tmp  = compute_avg_l2_error_(data_val.t{k}(tind{k}),data_val.y{k}(tind{k},:),tt(tt>data_val.from_time{k}),yy(tt>data_val.from_time{k},:));
        err_linf_tmp= compute_max_linf_error_(data_val.t{k}(tind{k}),data_val.y{k}(tind{k},:),tt(tt>data_val.from_time{k}),yy(tt>data_val.from_time{k},:));
    catch
        err_l2_tmp = inf;
        err_linf_tmp = inf;
    end
    y_L2   = compute_avg_l2_error_(  data_val.t{k}(tind{k}), data_val.y{k}(tind{k},:), data_val.t{k}(tind{k}), zeros(size(data_val.y{k}(tind{k},:))));
    y_Linf = compute_max_linf_error_(data_val.t{k}(tind{k}), data_val.y{k}(tind{k},:), data_val.t{k}(tind{k}), zeros(size(data_val.y{k}(tind{k},:))));

    err_l2.data(k) = err_l2_tmp / y_L2;
    err_linf.data(k) = err_linf_tmp / y_Linf;

end

err_l2.avg = mean(err_l2.data);
err_l2.std  = std(err_l2.data);

err_linf.avg = mean(err_linf.data);
err_linf.std = std(err_linf.data);
