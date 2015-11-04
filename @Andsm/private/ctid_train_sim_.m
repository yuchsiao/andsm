function [model, err_L2, err_Linf, prev] ...
         = ctid_train_sim_(data, data_val, deg_e, deg_f, deg_h, deg_v, kappa, lambda, ...varargin)
           incremental_stability, prev)

if length(kappa) < 1
    error 'length(kappa) must be greater than 0';
end
if length(lambda) < 1
    error 'length(lambda) must be greater than 0';
end

flag_first_train = true;
if ~isempty(prev)
    flag_first_train = false;
end
 

start_time = now;

nk = length(kappa);
nl = length(lambda);

stacked_data = stack_data_(data);

model = cell(nk, nl);
err_L2 = cell(nk, nl);
err_Linf = cell(nk, nl);

for i = 1:nk
    for j = 1:nl
        cprintf('*key', '_____________\n');
        cprintf('*key', '\n');        
        cprintf('*key', 'CASE %d OF %d\n', (i-1)*nl + j, nk*nl);
        cprintf('*key', '_____________\n');
        cprintf('*key', '\n');        
        cprintf('key', '%s\n', datestr(now, 'yyyy-mm-dd HH:MM:SS'));
        cprintf('key', 'kappa (%d): %g\n', i, kappa(i));
        cprintf('key', 'lambda(%d): %g\n', j, lambda(j));
        cprintf('text', '\n');
        
        clear option;
        option.kappa = kappa(i);
        option.lambda = lambda(j);
        option.incremental_stability = incremental_stability;
        if isfield(data, 'io_scale')
            option.io_scale = data.io_scale;
        end
        if flag_first_train
            flag_first_train = false;
        else
            option.prev = prev;
        end
        [model_tmp, prev] = ctid_(stacked_data, deg_e, deg_f, deg_h, deg_v, option);
        cprintf('text', '\n');
        cprintf('*text', 'Time Elapsed\n');
        disp(model_tmp.sol.time);
        
        cprintf('*text', 'Solution Quality\n');
        disp(model_tmp.sol.qual);
        
        model{i,j} = model_tmp;
        
        [err_L2{i,j}, err_Linf{i,j}] = ctid_sim_error_(model_tmp, data_val);
           
        cprintf('text', '\n');
        cprintf('key','errL2: %4.2f%% (%4.2f%%) \n', err_L2{i,j}.avg * 100, err_L2{i,j}.std * 100);
        cprintf('key','errL%c: %4.2f%% (%4.2f%%) \n', 8734, err_Linf{i,j}.avg * 100, err_Linf{i,j}.std * 100);
        cprintf('text', '\n');
    end
end

cprintf('*key', '_______\n');
cprintf('*key', '\n');       
cprintf('*key', 'SUMMARY\n');
cprintf('*key', '_______\n');
cprintf('*key', '\n');        

end_time = now;

dt_start = datetime(datevec(start_time));
dt_end   = datetime(datevec(end_time));

cprintf('key', 'Since: %s\n', datestr(start_time, 'yyyy-mm-dd HH:MM:SS'));
cprintf('key', 'Until: %s\n', datestr(end_time, 'yyyy-mm-dd HH:MM:SS'));
cprintf('key', 'Time Elapsed: %s\n', char(dt_end-dt_start));
cprintf('text', '\n');




