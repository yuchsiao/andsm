%ANDSM Brief tutorial and examples.
%


%% Create an Andsm object
andsm = Andsm(trainingData, validationData);

%% Traing models for a set of kappas and lambdas
degE = 1;
degF = 1;
degH = 1;
degV = 2;

kappas = [1e-4, 1e-3, 1e-2, 1e-1, 1e0, 1e1, 1e2];
lambdas = [1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1];

andsm.train([degE, degF, degH, degV], kappas, lambdas)


%% Traing models for a set of kappas and lambdas
degE = 3;
degF = 3;
degH = 3;
degV = 4;

kappas = [1e-4, 1e-3, 1e-2, 1e-1, 1e0, 1e1, 1e2];
lambdas = [1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1];

andsm.train([degE, degF, degH, degV], kappas, lambdas);


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
