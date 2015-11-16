function validateData_(data, label)

% If data contain right fields
if ~isfield(data, 't')
    error([label 'Data must have field ''t'' as times']);
end
if ~isfield(data, 'x')
    error([label 'Data must have field ''x'' as states']);
end
if ~isfield(data, 'u')
    error([label 'Data must have field ''u'' as input signals']);
end
if ~isfield(data, 'y')
    error([label 'Data must have field ''y'' as output signals']);
end
if ~isfield(data, 'dx')
    error([label 'Data must have field ''dx'' as time derivatives of states']);
end

nt = length(data.t);
% If data contain at least one set of signals
if nt < 1
    error([label 'Data must contain at least one set of signals']);
end

% If data contain same lengths of fields
if length(data.u)~=nt || length(data.x)~=nt || length(data.dx)~=nt || length(data.y)~=nt
    error([label 'Data must have same length of u, x, y, and dx'])
end





