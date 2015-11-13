function [I_IN, max_step_size, t_end] = andsm_demo_prepare_drc2_source_signal(sins, varargin)
% ANDSM_DEMO_PREPARE_DRC2_SOURCE_SIGNAL prepares drc2 training signals
%
% [I_IN, max_step_size, t_end] = prepare_drc2_training(sins)
% [I_IN, max_step_size, t_end] = prepare_drc2_training(sins n_cycle)
% 
% sins: cell array of amptitudes and frequencies
% n_cycle: number of sinusoid cycles
%
% Example:
% [I_IN, max_step_size, t_end] = prepare_drc2_training(50, {[1, 1e9], [0.2, 4e9]})

n_cycle = 2;

if ~isempty(varargin)
    n_cycle = varargin{1};
end

n_sins = length(sins);
amp = zeros(1,n_sins);
freq = zeros(1,n_sins);

for i = 1:length(sins)
    amp(i) = sins{i}(1);
    freq(i) = sins{i}(2);
end

freq_high = max(freq(amp~=0));
freq_low  = min(freq(amp~=0));

max_step_size = 1/freq_high /20;
t_end = 1/freq_low *n_cycle;

N = 1000;
tvec = linspace(0, 1/freq_low*n_cycle, N)';

Iin = 0;

for i = 1:n_sins
    Iin = Iin + amp(i) * sin(2*pi*freq(i)*tvec);
end

I_IN.signals.values = Iin;
I_IN.time = tvec;
