function export_veriloga_v_(model, pathstr, filename, option)


if nargin < 4
    option = [];
end

if isfield(option, 'pin_name')
    if length(option.pin_name) ~= model.m+1
        error('ERROR: Length of pin_name must be m+1');
    end
    pin_name = option.pin_name;
else
    pin_name = cell(1, model.m+1);
    for i = 1:model.m
        pin_name{i} = ['p' num2str(i)];
    end
    pin_name{model.m+1} = 'g';
end

% header block
fullfilename = fullfile(pathstr, filename);
fout = fopen([fullfilename, '.va'], 'w');
fprintf(fout, '`include "constants.vams"\n');
fprintf(fout, '`include "disciplines.vams"\n');
fprintf(fout, '\n');
fprintf(fout, 'module %s(', filename);
for i = 1:model.m
    fprintf(fout, '%s, ', pin_name{i});
end
fprintf(fout, '%s);\n', pin_name{model.m+1});

% io pins
fprintf(fout, 'inout ');
for i = 1 : model.m
    fprintf(fout, '%s, ', pin_name{i});
end
fprintf(fout, '%s;\n', pin_name{model.m+1});

% electrical nodes
fprintf(fout, 'electrical ');
for i = 1 : model.m+1
    fprintf(fout, '%s, ', pin_name{i});
end
for i = 1 : model.n-1
    fprintf(fout, 'n%d, ', i);
end
fprintf(fout, 'n%d;\n', model.n);
fprintf_break_line(fout);

% real declaration 
fprintf_real(fout, 'u', model.m);
fprintf_real(fout, 'x', model.n);
fprintf_real(fout, 'e', model.n);
fprintf_real(fout, 'f', model.n);
fprintf_real(fout, 'h', model.m);
fprintf_break_line(fout);

% analog block
fprintf(fout, 'analog begin\n');
fprintf(fout, '    @(initial_step) begin\n');
fprintf_initial_v(fout, pin_name{model.m+1}, model.n);
fprintf(fout, '    end\n');
fprintf_break_line(fout);

% assign current input to u
for i = 1 : model.m
    fprintf(fout, '    u%d = V(%s, %s);\n', i, pin_name{i}, pin_name{model.m+1});
end
fprintf_break_line(fout);

% assign node voltage to x
for i = 1 : model.n
    fprintf(fout, '    x%d = V(n%d, %s);\n', i, i, pin_name{model.m+1});
end
fprintf_break_line(fout);

% e section
for i = 1 : model.n
    fprintf(fout, '    e%d = ', i);
    str = transform_string2veriloga_formula(model.e{i});
    fprintf(fout, '%s;\n', str);
end
fprintf_break_line(fout);

% f section
for i = 1 : model.n
    fprintf(fout, '    f%d = ', i);
    str = transform_string2veriloga_formula(model.f{i});
    fprintf(fout, '%s;\n', str);
end
fprintf_break_line(fout);

% h section
for i = 1 : model.m
    fprintf(fout, '    h%d = ', i);
    str = transform_string2veriloga_formula(model.h{i});
    fprintf(fout, '%s;\n', str);
end
fprintf_break_line(fout);

% setup ode
for i = 1 : model.n
    fprintf(fout, '    I(n%d, %s) <+ -ddt(e%d);\n', i, pin_name{model.m+1}, i);
end
fprintf_break_line(fout);

for i = 1 : model.n
    fprintf(fout, '    I(n%d, %s) <+ f%d;\n', i, pin_name{model.m+1}, i);
end
fprintf_break_line(fout);

% assign voltage output
for i = 1 : model.m
    fprintf(fout, '    I(%s, %s) <+ h%d;\n', pin_name{i}, pin_name{model.m+1}, i);
end

% close analog block
fprintf(fout, 'end\n');
fprintf_break_line(fout);

% close module
fprintf(fout, 'endmodule\n');

fclose(fout);
end



function fprintf_real(fout, label, n)
fprintf(fout, 'real %s1', label);
for i = 2 : n
    fprintf(fout, ', %s%d', label, i);
end
fprintf(fout, ';\n');
end

function fprintf_break_line(fout)
fprintf(fout, '\n');
end

function fprintf_initial_v(fout, ref_label, n)
for i = 1 : n
    fprintf(fout, '        V(n%d, %s) <+ 0.0;\n', i, ref_label);
end
end

function str = transform_string2veriloga_formula(str)
str = strrep(str, '(', '');
str = strrep(str, ')', '');
str = strrep(str, '^', '**');
end
