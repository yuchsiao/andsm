function exportVerilogaI_(model, pathstr, filename, option)


if nargin < 4
    option = [];
end

if isfield(option, 'pinName')
    if length(option.pinName) ~= model.m+1
        error('ERROR: Length of pinName must be m+1');
    end
    pinName = option.pinName;
else
    pinName = cell(1, model.m+1);
    for i = 1:model.m
        pinName{i} = ['p' num2str(i)];
    end
    pinName{model.m+1} = 'g';
end

% header block
fullfilename = fullfile(pathstr, filename);
fout = fopen([fullfilename, '.va'], 'w');
fprintf(fout, '`include "constants.vams"\n');
fprintf(fout, '`include "disciplines.vams"\n');
fprintf(fout, '\n');
fprintf(fout, 'module %s(', filename);
for i = 1:model.m
    fprintf(fout, '%s, ', pinName{i});
end
fprintf(fout, '%s);\n', pinName{model.m+1});

% io pins
fprintf(fout, 'inout ');
for i = 1 : model.m
    fprintf(fout, '%s, ', pinName{i});
end
fprintf(fout, '%s;\n', pinName{model.m+1});

% electrical nodes
fprintf(fout, 'electrical ');
for i = 1 : model.m+1
    fprintf(fout, '%s, ', pinName{i});
end
for i = 1 : model.n-1
    fprintf(fout, 'n%d, ', i);
end
fprintf(fout, 'n%d;\n', model.n);
fprintfBreakLine(fout);

% real declaration 
fprintfReal(fout, 'u', model.m);
fprintfReal(fout, 'x', model.n);
fprintfReal(fout, 'e', model.n);
fprintfReal(fout, 'f', model.n);
fprintfReal(fout, 'h', model.m);
fprintfBreakLine(fout);

% analog block
fprintf(fout, 'analog begin\n');
fprintf(fout, '    @(initial_step) begin\n');
fprintfInitialV(fout, pinName{model.m+1}, model.n);
fprintf(fout, '    end\n');
fprintfBreakLine(fout);

% assign current input to u
for i = 1 : model.m
    fprintf(fout, '    u%d = I(%s, %s);\n', i, pinName{i}, pinName{model.m+1});
end
fprintfBreakLine(fout);

% assign node voltage to x
for i = 1 : model.n
    fprintf(fout, '    x%d = V(n%d, %s);\n', i, i, pinName{model.m+1});
end
fprintfBreakLine(fout);

% e section
for i = 1 : model.n
    fprintf(fout, '    e%d = ', i);
    str = transformString2VerilogAFormula(model.e{i});
    fprintf(fout, '%s;\n', str);
end
fprintfBreakLine(fout);

% f section
for i = 1 : model.n
    fprintf(fout, '    f%d = ', i);
    str = transformString2VerilogAFormula(model.f{i});
    fprintf(fout, '%s;\n', str);
end
fprintfBreakLine(fout);

% h section
for i = 1 : model.m
    fprintf(fout, '    h%d = ', i);
    str = transformString2VerilogAFormula(model.h{i});
    fprintf(fout, '%s;\n', str);
end
fprintfBreakLine(fout);

% setup ode
for i = 1 : model.n
    fprintf(fout, '    I(n%d, %s) <+ -ddt(e%d);\n', i, pinName{model.m+1}, i);
end
fprintfBreakLine(fout);

for i = 1 : model.n
    fprintf(fout, '    I(n%d, %s) <+ f%d;\n', i, pinName{model.m+1}, i);
end
fprintfBreakLine(fout);

% assign voltage output
for i = 1 : model.m
    fprintf(fout, '    V(%s, %s) <+ h%d;\n', pinName{i}, pinName{model.m+1}, i);
end

% close analog block
fprintf(fout, 'end\n');
fprintfBreakLine(fout);

% close module
fprintf(fout, 'endmodule\n');

fclose(fout);
end



function fprintfReal(fout, label, n)
fprintf(fout, 'real %s1', label);
for i = 2 : n
    fprintf(fout, ', %s%d', label, i);
end
fprintf(fout, ';\n');
end

function fprintfBreakLine(fout)
fprintf(fout, '\n');
end

function fprintfInitialV(fout, refLabel, n)
for i = 1 : n
    fprintf(fout, '        V(n%d, %s) <+ 0.0;\n', i, refLabel);
end
end

function str = transformString2VerilogAFormula(str)
str = strrep(str, '(', '');
str = strrep(str, ')', '');
str = strrep(str, '^', '**');
end
