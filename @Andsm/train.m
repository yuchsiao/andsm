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
    if length(config.prev.u) ~= size(self.trainingData.u{1}, 2)
        error 'ERROR: Port sizes of previous solver state and training data are not compatible';
    end
    if length(config.prev.x) ~= size(self.trainingData.x{1}, 2)
        error 'ERROR: State sizes of previous solver state and training data are not compatible';
    end
    % Check if deg is compatible
    if ~(all(size(config.prev.deg) == size(deg)) && all(config.prev.deg == deg))
        error 'ERROR: Degrees of arguments and previous solver state are not the same';
    end
end
if ~isfield(config, 'isIncrementallyStable')
    config.isIncrementallyStable = true;
end

% Use self.prev if self.deg = deg
if all(size(self.deg) == size(deg)) && all(self.deg == deg)
    config.prev = self.prev;
end

% Unpack deg
degE = deg(1);
degF = deg(2);
degH = deg(3);
degV = deg(4);

% Train and sim
[self.model, self.errL2, self.errLinf, self.prev] ...
    = ctid_train_sim_(self.trainingData, self.validationData, ...
                      degE, degF, degH, degV, kappa, lambda, ...
                      config.isIncrementallyStable, config.prev);
                  
% Append deg to self.prev
self.prev.deg = deg;

% Training done. 
% Save parameters
self.kappa = kappa;
self.lambda = lambda;
self.deg = deg;
                  
% Select the best model
[minErrPerColumn, minErrRowIndex] = min(self.err('l2', 'avg'));
[~, self.jBestModel] = min(minErrPerColumn);
self.iBestModel = minErrRowIndex(self.jBestModel);

[~, errL2, errLinf, index] = self.getBestModel();

errL2Std = self.err('l2', 'std');
errLinfStd = self.err('linf', 'std');

cprintf('*key', 'ACCURACY OF BEST MODEL ');
cprintf('key', '(%d,%d)\n', index(1), index(2));
cprintf('key', '%c : %g\n', 954, self.kappa(index(1)));
cprintf('key', '%c : %g\n', 955, self.lambda(index(2)));
cprintf('key', 'L2: %4.2f%% (%4.2f%%)\n', errL2 * 100, errL2Std(index(1), index(2)) * 100);
cprintf('key', 'L%c: %4.2f%% (%4.2f%%)\n', 8734, errLinf * 100, errLinfStd(index(1), index(2)) * 100);

