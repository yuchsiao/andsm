function result = diffvec_(vec, x)

n = length(x);
result = [];
for i = 1:n
    v = x(i);
    result = [result, jacobian(vec,v)];
end