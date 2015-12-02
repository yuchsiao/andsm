function train(self, deg, kappa, lambda, config)

if length(kappa) < 1
    error 'length(kappa) must be greater than 0';
end
if length(lambda) < 1
    error 'length(lambda) must be greater than 0';
end

% Setup config
if nargin <= 4
    config = [];
end
if ~isfield(config, 'prev')
    config.prev = [];
else
    % Check if size is compatible
    if length(config.prev.u) ~= size(self.training_data.u{1}, 2)
        error 'ERROR: Port sizes of previous solver state and training data are not compatible';
    end
    if length(config.prev.x) ~= size(self.training_data.x{1}, 2)
        error 'ERROR: State sizes of previous solver state and training data are not compatible';
    end
    % Check if deg is compatible
    if ~(all(size(config.prev.deg) == size(deg)) && all(config.prev.deg == deg))
        error 'ERROR: Degrees of arguments and previous solver state are not the same';
    end
end
if ~isfield(config, 'is_incrementally_stable')
    config.is_incrementally_stable = true;
end

% Use self.prev if self.deg = deg
if all(size(self.deg) == size(deg)) && all(self.deg == deg)
    config.prev = self.prev;
end

% Unpack deg
deg_e = deg(1);
deg_f = deg(2);
deg_h = deg(3);
deg_v = deg(4);

% Train and sim
[self.model, self.err_l2, self.err_linf, self.prev] ...
    = ctid_train_sim_(self.training_data, self.validation_data, ...
                      deg_e, deg_f, deg_h, deg_v, kappa, lambda, ...
                      config.is_incrementally_stable, config.prev);
                  
% Append deg to self.prev
self.prev.deg = deg;

% Training done. 
% Save parameters
self.kappa = kappa;
self.lambda = lambda;
self.deg = deg;
                  
% Select the best model
[min_err_per_column, min_err_row_index] = min(self.err('l2', 'avg'));
[~, self.j_best_model] = min(min_err_per_column);
self.i_best_model = min_err_row_index(self.j_best_model);

[~, err, index] = self.get_best_model();

cprintf('*key', 'ACCURACY OF BEST MODEL ');
cprintf('key', '(%d,%d)\n', index(1), index(2));
cprintf('key', '%c : %g\n', 954, self.kappa(index(1)));  % kappa
cprintf('key', '%c : %g\n', 955, self.lambda(index(2))); % lambda
cprintf('key', 'L2: %4.2f%% (%4.2f%%)\n', err.l2_avg * 100, err.l2_std * 100);
cprintf('key', 'L%c: %4.2f%% (%4.2f%%)\n', 8734, err.linf_avg * 100, err.linf_std * 100);

