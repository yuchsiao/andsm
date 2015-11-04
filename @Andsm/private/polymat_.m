function [result, coeff, mono] = polymat_(x,d,n)
%* Generate a symm n-by-n matrix 
%* in which each entry is a polynomial of degree d
%* INPUT
%* - x: variable
%* - d: degree of polynomials
%* - n: size of matrix
%* OUTPUT
%* - result: symm matrix of polynomials of degree d
%* - coeff : coeff cell of size n by n 
%* - mono  : monomonial cell of size n by n 

result = sdpvar(n,n);
coeff = cell(n);
mono  = cell(n);

if n==1
    [result,c,m] = polynomial(x,d);
    coeff{1,1} = c;
    mono{1,1}  = m;
    return;
end

for i = 1:n
    for j=i:n
        [p,c,m] = polynomial(x,d);
        result(i,j) = p;
        coeff{i,j} = c;
        mono{i,j}  = m;
    end
end

for i = 1:n
    for j=1:i-1
        result(i,j) = result(j,i);
        coeff{i,j} = coeff{j,i};
        mono{i,j}  = mono{j,i};
    end
end
