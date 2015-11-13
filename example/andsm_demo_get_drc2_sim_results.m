% Get drc2 simulation values into
%
% drc2_t
% drc2_u
% drc2_x
% drc2_y
% drc2_dx
% 
% and concatenate with data

%%

drc2_t = {tout, tout};

% input
drc2_u = {[i1.signals.values, -i3.signals.values], ...
          [i3.signals.values,  i2.signals.values]};

% state
drc2_x = {[v1.signals.values, x1.signals.values, v3.signals.values], ...
          [v3.signals.values, x2.signals.values, v2.signals.values]};

% output
drc2_y = {drc2_x{1}(:,[1,3]), ...
          drc2_x{2}(:,[1,3])};

% der state
n_dx_esti = 3;  % because it is noise-free in this case
drc2_dx = {diff_robust(drc2_t{1},drc2_x{1},n_dx_esti), ...
           diff_robust(drc2_t{2},drc2_x{2},n_dx_esti)};

