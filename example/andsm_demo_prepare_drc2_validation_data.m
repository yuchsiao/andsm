%% Validation data

% Environment setting
RS = 0;

% Init
data.t = {};
data.u = {};
data.x = {};
data.y = {};
data.dx = {};

% Set1,2,3 environments
RL = 3;
n_cycle = 5;

% Set13,14: two tones at f1 and f2
sins = {[0.5, 2e9], [0.5, 3e9]};

[I_IN, max_step_size, t_end] = andsm_demo_prepare_drc2_source_signal(sins, n_cycle);
sim('andsm_demo_drc2_circuit');
andsm_demo_get_drc2_sim_results;
data = concatenate_data(data,drc2_t,drc2_u,drc2_x,drc2_y,drc2_dx);

% Set15,16: single tone modulated
sins = {[1, 2e9]};

[I_IN, max_step_size, t_end] = andsm_demo_prepare_drc2_source_signal(sins, n_cycle);
I_IN.signals.values = I_IN.signals.values .* cos(1e8*2*pi*I_IN.time);
sim('andsm_demo_drc2_circuit');
andsm_demo_get_drc2_sim_results;
data = concatenate_data(data,drc2_t,drc2_u,drc2_x,drc2_y,drc2_dx);
