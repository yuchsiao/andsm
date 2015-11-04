function val = err(self, errType, stats)

if nargin <= 1
    errType = '';
end
if nargin <= 2
    stats = '';
end
errType = lower(errType);
stats = lower(stats);

err.L2 = [];
err.Linf = [];
switch errType
    case 'l2'
        err.L2 = self.errL2;
    case 'linf'
        err.Linf = self.errLinf;
    otherwise
        err.L2 = self.errL2;
        err.Linf = self.errLinf; 
end

switch stats
    case {'avg', 'average'}
        [m, n] = size(err.L2);
        val.L2 = zeros(m, n);
        for i = 1 : m
            for j = 1 : n
                val.L2(i,j) = err.L2{i,j}.avg;
            end
        end
        [m, n] = size(err.Linf);
        val.Linf = zeros(m, n);
        for i = 1 : m
            for j = 1 : n
                val.Linf(i,j) = err.Linf{i,j}.avg;
            end
        end
    case 'std'
        [m, n] = size(err.L2);
        val.L2 = zeros(m, n);
        for i = 1 : m
            for j = 1 : n
                val.L2(i,j) = err.L2{i,j}.std;
            end
        end
        [m, n] = size(err.Linf);
        val.Linf = zeros(m, n);
        for i = 1 : m
            for j = 1 : n
                val.Linf(i,j) = err.Linf{i,j}.std;
            end
        end
    otherwise
        val.L2 = err.L2;
        val.Linf = err.Linf;
end

if isempty(val.L2)
    val = rmfield(val, 'L2');
end
if isempty(val.Linf)
    val = rmfield(val, 'Linf');
end

if length(fieldnames(val)) == 1
    fieldName = fieldnames(val);
    val = getfield(val, fieldName{1});
end
    


