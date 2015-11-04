function result = stack_polymat_(c)
%* Reshape polymat coeff cell into vector
%* only consists of upper triangular entries
n = size(c,1);
result = [];

for i=1:n
    for j=i:n
        result = [result; c{i,j}];
    end
end
