function [result, coeff, mono] = polyvec_(x,d,n)
%* Generate a column vector of polynomials
%* without the constant terms (including coefficients and monomials)
%* INPUT
%* - x: variable
%* - d: degree of polynomials
%* - n: length of the column vector
%* OUTPUT
%* - result: the column vector of polynomials
%* - coeff : coeff cell without the coeff for the constant term
%* - mono  : monomial cell without the monomial for the constant term

result = sdpvar(n,1);
coeff = cell(n,1);
mono  = cell(n,1);

for i = 1:n
    [~,c,m] = polynomial(x,d);
    coeff{i} = c(2:end);       % remove const term
    mono{i}  = m(2:end);       % remove const term
    
    if n==1  % an ad-hoc solution to some bug in 2013b+yalmip
        result = c(2:end)'*m(2:end);
        break;
    else
        result(i) = c(2:end)'*m(2:end);
    end
end

