function val = err(self, err_type, stats)

if nargin <= 1
    err_type = '';
end
if nargin <= 2
    stats = '';
end
err_type = lower(err_type);
stats = lower(stats);

err.l2 = [];
err.linf = [];
switch err_type
    case 'l2'
        err.l2 = self.err_l2;
    case 'linf'
        err.linf = self.err_linf;
    otherwise
        err.l2 = self.err_l2;
        err.linf = self.err_linf; 
end

switch stats
    case {'avg', 'average'}
        [m, n] = size(err.l2);
        val.l2 = zeros(m, n);
        for i = 1 : m
            for j = 1 : n
                val.l2(i,j) = err.l2{i,j}.avg;
            end
        end
        [m, n] = size(err.linf);
        val.linf = zeros(m, n);
        for i = 1 : m
            for j = 1 : n
                val.linf(i,j) = err.linf{i,j}.avg;
            end
        end
    case 'std'
        [m, n] = size(err.l2);
        val.l2 = zeros(m, n);
        for i = 1 : m
            for j = 1 : n
                val.l2(i,j) = err.l2{i,j}.std;
            end
        end
        [m, n] = size(err.linf);
        val.linf = zeros(m, n);
        for i = 1 : m
            for j = 1 : n
                val.linf(i,j) = err.linf{i,j}.std;
            end
        end
    otherwise
        val.l2 = err.l2;
        val.linf = err.linf;
end

if isempty(val.l2)
    val = rmfield(val, 'l2');
end
if isempty(val.linf)
    val = rmfield(val, 'linf');
end

if length(fieldnames(val)) == 1
    fieldname = fieldnames(val);
    val = getfield(val, fieldname{1});
end
    


