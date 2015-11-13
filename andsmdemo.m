%ANDSM Brief tutorial and examples.


%% Prepare training data

andsm_demo_prepare_drc2_training_data;
training_data = data;
plot_dataset(training_data, 1:6);
plot_dataset(training_data, 7:12);

%% Prepare validation data

andsm_demo_prepare_drc2_validation_data;
validation_data = data;
plot_dataset(validation_data, 13:16);

%% Create an Andsm object

andsm = Andsm(training_data, validation_data);

%% Traing models for a set of kappas and lambdas

deg_e = 1;
deg_f = 1;
deg_h = 1;
deg_v = 2;

kappa = [1e-4, 1e-3, 1e-2, 1e-1, 1e0, 1e1, 1e2];
lambda = [1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1];

andsm.train([deg_e, deg_f, deg_h, deg_v], kappa, lambda);


%% Traing models for a set of kappas and lambdas
deg_e = 3;
deg_f = 3;
deg_h = 3;
deg_v = 4;

kappa = [1e-4, 1e-3, 1e-2, 1e-1, 1e0, 1e1, 1e2];
lambda = [1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1];

andsm.train([deg_e, deg_f, deg_h, deg_v], kappa, lambda);


%% Retrieve the best model

[model, errModel, ind] = andsm.getBestModel;

%% Simulate a model and plot the result

t = validationData.t{1};
u = validationData.u{1};
y = validationData.y{1};
x0 = [0;0;0];
tol = 'regular';

[tt, uu, xx, yy] = Andsm.sim(model, t, u, x0, tol);

figure;
hold all;
plot(t, y, tt, yy, 'x')


%% Get L2 and Linf errors

% Get raw data of errors
err = andsm.err;

% Get raw data of L2 errors
errL2   = andsm.err.L2;  % or
errL2_2 = andsm.err('l2');  

% Get raw data of Linf errors
errLinf    = andsm.err.Linf;  % or
errLinf_2  = andsm.err('linf');  

% Get avg L2 errors
errL2Avg   = andsm.errL2Avg;  % or
errL2Avg_2 = andsm.err('l2', 'avg');

% Get std L2 errors
errL2Std    = andsm.errL2Std;  % or
errL2Std_2  = andsm.err('l2', 'std');

% Get avg Linf errors
errLinfAvg   = andsm.errLinfAvg;  % or
errLinfAvg_2 = andsm.err('linf', 'avg'); 

% Get std Linf errors
errLinfStd = andsm.errLinfStd;
errLinfStd_2 = andsm.err('linf', 'std');

%% Export 
