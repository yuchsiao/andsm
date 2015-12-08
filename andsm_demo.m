%ANDSM Brief tutorial and examples

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

%% Training models for a set of kappas and lambdas 
%  low-degree, quick training but not accurate

deg_e = 1;
deg_f = 1;
deg_h = 1;
deg_v = 2;

kappa = [1e-4, 1e-3, 1e-2, 1e-1, 1e0, 1e1, 1e2];
lambda = [1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1];

andsm.train([deg_e, deg_f, deg_h, deg_v], kappa, lambda);


%% Training models for a set of kappas and lambdas
%  higher-degree training for accurate models

deg_e = 3;
deg_f = 3;
deg_h = 3;
deg_v = 4;

kappa = [1e-4, 1e-3, 1e-2, 1e-1, 1e0, 1e1, 1e2];
lambda = [1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1];

andsm.train([deg_e, deg_f, deg_h, deg_v], kappa, lambda);


%% Retrieve the best model

[model, err, ind] = andsm.get_best_model

% To access all generated models
andsm.model

% The best model 'model' is the same as
andsm.model{ind}

%% Simulate a model and plot the result

t = validation_data.t{3};
u = validation_data.u{3};
y = validation_data.y{3};
x0 = [0;0;0];
tol = 'regular';
% Tolerance (tol) can be a string or a structure:
% 'regular' is equivalent to
%   tol.rel_tol = 1e-3;
%   tol.abs_tol = 1e-6;
% 'high', 'stringent', 'conservative' is equivalent to
%   tol.rel_tol = 1e-4;
%   tol.abs_tol = 1e-8;
% 'low', 'liberal' is equivalent to
%   tol.rel_tol = 1e-2;
%   tol.abs_tol = 1e-4;
% 'very low' is equivalent to
%   tol.rel_tol = 1e-1;
%   opt.abs_tol = 1e-2;

[tt, uu, xx, yy] = Andsm.sim(model, t, u, x0, tol);

figure;
hold all;
plot(t, y, tt, yy, 'x')
xlabel('Time (s)');
ylabel('Voltage (V)');
legend('ref: y_1', 'ref: y_2', 'model: y_1', 'model: y_2');

%% Get L2 and Linf error information

% Get raw data of errors
err = andsm.err;

% Get raw data of L2 errors
err_l2   = andsm.err.l2;  % or
err_l2_2 = andsm.err('l2');  

% Get raw data of Linf errors
err_linf    = andsm.err.linf;  % or
err_linf_2  = andsm.err('linf');  

% Get avg L2 errors
err_l2_avg   = andsm.err_l2_avg;  % or
err_l2_avg_2 = andsm.err('l2', 'avg');

% Get std L2 errors
err_l2_std    = andsm.err_l2_std;  % or
err_l2_std_2  = andsm.err('l2', 'std');

% Get avg Linf errors
err_linf_avg   = andsm.err_linf_avg;  % or
err_linf_avg_2 = andsm.err('linf', 'avg'); 

% Get std Linf errors
err_linf_std   = andsm.err_linf_std;  % or
err_linf_std_2 = andsm.err('linf', 'std');

%% Export generated models to MATLAB Simscape model file

% Set up pin positions
%   In this example, drc2 has three pins in the schematic: 
%   left pin, right pin, and reference pin
%   Due to MATLAB restriction, the reference pin is set to be 
%   the same side of the first pin.
option.pin_position = 'lr'; % pin1: left, pin2: right, pin_ref: as 
                            % (default) all left
option.label = 'drc2_111';  % (optional) model label for simulink
                            % (default) the same as filename 'drc2_model'

% Create +drc2 folder
mkdir +drc2
% Export model file in +drc2 folder ('simscape', 'simulink', or 'ssc')
andsm.export('+drc2/drc2_model', 'simscape', 'i', option);
% Build ssc library
ssc_build drc2
% Library file 'drc2_lib.slx' is generated

% Similarly, if input of the model is voltage, then 
% andsm.export('+drc2/drc2_model', 'simscape', 'v', option);

%% Export generated models to Verilog A model file

% Set up pin names
% (default) p1, p2, g
option.pin_name = {'p_left', 'p_right', 'p_ref'};

% Create va folder
mkdir va
% Export model file in va folder with input as current
andsm.export('va/drc2_model', 'veriloga', 'i', option);

% Similarly, when applicable, model can be exported as voltage input
% andsm.export('va/drc2_model_v', 'veriloga', 'v', option);

%% MISC

% Get kappa vector
andsm.get_kappa

% Get lambda vector
andsm.get_lambda

% Get solver state
%  Solver state is used such that when models are trained against 
%  different kappas and lambdas, training_data are only loaded 
%  into variables once.
%  Because of the way MATLAB is implemented, loading data into high-order
%  polynomials typically takes tremendous time, in many cases even longer
%  than MOSEK solving a SDP problem.
%  To avoid reloading data every time when changing kappa and lambda, 
%  the objective function with variable replaced with data is cached
%  and being reused over and over, as long as training and validation
%  data are the same. 
%  This process has been automated so users may rarely need to check in
%  what are loaded internally.
%  For the completeness, we preserve this API for reference.
andsm.get_solver_state





