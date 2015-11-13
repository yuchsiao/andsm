%% Prepare Sets

% Environment setting
RS = 0;

% Init
data.t = {};
data.u = {};
data.x = {};
data.y = {};
data.dx = {};

% Set1,2,3 environments
RL = 5;

% Set1: large single tone at f1
sins = {[1, 1e9]};

[I_IN, max_step_size, t_end] = andsm_demo_prepare_drc2_source_signal(sins);
sim('andsm_demo_drc2_circuit');
andsm_demo_get_drc2_sim_results;
data = concatenate_data(data,drc2_t,drc2_u,drc2_x,drc2_y,drc2_dx);

% Set2: small single tone at f2
sins = {[1, 4e9]};

[I_IN, max_step_size, t_end] = andsm_demo_prepare_drc2_source_signal(sins);
sim('andsm_demo_drc2_circuit');
andsm_demo_get_drc2_sim_results;
data = concatenate_data(data,drc2_t,drc2_u,drc2_x,drc2_y,drc2_dx);

% Set3: two tones between f1 and f2
sins = {[0.6, 2e9], [0.4, 2.5e9]};

[I_IN, max_step_size, t_end] = andsm_demo_prepare_drc2_source_signal(sins, 4);
sim('andsm_demo_drc2_circuit');
andsm_demo_get_drc2_sim_results
data = concatenate_data(data,drc2_t,drc2_u,drc2_x,drc2_y,drc2_dx);


% Set4,5,6 environemnts
RL = 2;

% Set4,5,6: repeat 1,2,3 with RL=20
sins = {[1, 1e9]};

[I_IN, max_step_size, t_end] = andsm_demo_prepare_drc2_source_signal(sins);
sim('andsm_demo_drc2_circuit');
andsm_demo_get_drc2_sim_results;
data = concatenate_data(data,drc2_t,drc2_u,drc2_x,drc2_y,drc2_dx);

% Set5: small single tone at f2
sins = {[1, 4e9]};

[I_IN, max_step_size, t_end] = andsm_demo_prepare_drc2_source_signal(sins);
sim('andsm_demo_drc2_circuit');
andsm_demo_get_drc2_sim_results;
data = concatenate_data(data,drc2_t,drc2_u,drc2_x,drc2_y,drc2_dx);

% Set6: two tones between f1 and f2
sins = {[0.6, 2e9], [0.4, 2.5e9]};

[I_IN, max_step_size, t_end] = andsm_demo_prepare_drc2_source_signal(sins, 4);
sim('andsm_demo_drc2_circuit');
andsm_demo_get_drc2_sim_results;
data = concatenate_data(data,drc2_t,drc2_u,drc2_x,drc2_y,drc2_dx);
