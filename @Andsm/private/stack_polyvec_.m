function result = stack_polyvec_(c)
%* Reshape polyvec cell into a vector

result = [];
for i=1:length(c)
    result = [result; c{i}];
end
