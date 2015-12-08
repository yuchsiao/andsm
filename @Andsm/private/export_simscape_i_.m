function export_simscape_i_(model, pathstr, filename, label, option)
% export_simscape_i_ export model into a Simscape model
% 
% Example: 
% 
% export_simscape_i_(model, '~/workspace', 'filename', 'modelname', option)
%
% option may contain
% option.pin_position   a string with length equal to number of ports.
%                       e.g. 'llr' means pin1 on left, pin2 on left,
%                       and pin3 on right. The reference pin is always 
%                       on the same side of pin1 due to the restriction
%                       of Simscape (same side or opposite side).


port_pos = option.pin_position;

% header block
fullfilename = fullfile(pathstr, filename);
fout = fopen([fullfilename, '.ssc'], 'w');
fprintf(fout, 'component %s\n', filename);
fprintf(fout, '%% %s\n', label); 

% nodes block
fprintf(fout, 'nodes\n');
for i = 1:model.m
    switch port_pos(i)
        case 'l'
            pos = 'left';
        case 'r'
            pos = 'right';
        case 't'
            pos = 'top';
        case 'b'
            pos = 'bottom';
        otherwise
            pos = 'left';
    end
    if i == 1
        pos_end = pos;
    end
    fprintf(fout, '    p%d = foundation.electrical.electrical;  %% %d+:%s\n', i, i, pos);
end
fprintf(fout, '    n  = foundation.electrical.electrical;  %% ref:%s\n', pos_end);
fprintf(fout, 'end\n');

% parameters block
fprintf(fout, 'parameters (Access=private)\n');
fprintf(fout, '    unit_i = {1, ''A''};\n');
fprintf(fout, '    unit_v = {1, ''V''};\n');
fprintf(fout, '    unit_s = {1, ''s''};\n');
fprintf(fout, 'end\n');

% variables block
fprintf(fout, 'variables (Access=private)\n');
for i = 1:model.m
    fprintf(fout, '    i%d = {0, ''A''};\n', i);
end
fprintf(fout, '    u = zeros(%d,1);\n', model.m);
fprintf(fout, '    x = zeros(%d,1);\n', model.n);
fprintf(fout, '    y = zeros(%d,1);\n', model.m);
fprintf(fout, 'end\n');

% branches block
fprintf(fout, 'branches\n');
for i = 1:model.m
    fprintf(fout, '    i%d: p%d.i -> n.i;\n', i, i);
end
fprintf(fout, 'end\n');

% equations block
[E,f,h] = generate_func(model);
fprintf(fout, 'equations\n');
for i = 1:model.m
    fprintf(fout, '    u(%d) == i%d ./ unit_i;\n', i, i);
end
fprintf(fout, '    let\n');

fprintf(fout, '        E = ...\n');
for i = 1:length(E)
    fprintf(fout, '            %s ...\n', E{i});
end
fprintf(fout, '            ;\n');

fprintf(fout, '        f = ...\n');
for i = 1:length(f)
    fprintf(fout, '            %s ...\n', f{i});
end
fprintf(fout, '            ;\n');

fprintf(fout, '        h = ...\n');
for i = 1:length(h)
    fprintf(fout, '            %s ...\n', h{i});
end
fprintf(fout, '            ;\n');

fprintf(fout, '    in\n');
fprintf(fout, '        E*x.der == f ./ unit_s;\n');
fprintf(fout, '        y == h;\n');
fprintf(fout, '    end\n');
for i = 1:model.m
    fprintf(fout, '    p%d.v - n.v == y(%d).* unit_v;\n', i, i);
end
fprintf(fout, 'end\n');
fprintf(fout, '\n');
fprintf(fout, 'end\n');

fclose(fout);

end


function [E,f,h] = generate_func(model)
n = model.n;
m = model.m;
% generate f function
str = '';
for i = 1:n
    str = strcat(str, model.f{i}, '; ');
end
f = strcat('[', str, ']');
f = break_line(f);

% generate E function
str = '';
for i = 1:n
    for j = 1:n
        str = strcat(str, model.E{i,j});
        if j~=n
            str = strcat(str, ', ');
        end
    end
    str = strcat(str, '; ');
end
E = strcat('[', str, ']');
E = break_line(E);

% generate h function
str = '';
for i = 1:m
    str = strcat(str, model.h{i}, '; ');
end
h = strcat('[', str, ']');
h = break_line(h);
end


function lines = break_line(line)

% parameter
% width = 1000;
width = 80;

lines = {};

while true
    if length(line)<=width
        lines = [lines, line];
        break;
    end
    ind = strfind(line(1:width), '*');
    % does not consider not found case
    if isempty(ind)
        lines = [lines, line(1:end)];
        break;
    end
    lines = [lines, line(1:ind(end)-1)];
    line = line(ind(end):end);
    
end

end



















