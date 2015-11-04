function [tt, uu, xx, yy] = sim(model, t, u, x0, tol) 

% Default tolerance
opt = odeset;
opt.RelTol = 1e-3;
opt.AbsTol = 1e-6;

% User-defined tolerance
if nargin >= 5
    if ischar(tol)
        switch lower(tol)
            case 'regular'
                opt.RelTol = 1e-3;
                opt.AbsTol = 1e-6;
            case {'high', 'stringent', 'conservative'}
                opt.RelTol = 1e-4;
                opt.AbsTol = 1e-8;
            case {'low', 'liberal'}
                opt.RelTol = 1e-2;
                opt.AbsTol = 1e-4;
            case 'very low'
                opt.RelTol = 1e-1;
                opt.AbsTol = 1e-2;
            otherwise
                errStruct.message = 'Type of tolerance is ''regular'', (''high'', ''stringent'', ''conservative''), (''low'', ''liberal''), ''very low'', or user defined structure with absTol and relTol fields.';
                errStruct.identifier = 'Andsi:sim:wrongToleranceSpecifier';
                error(errStruct);
        end
    else
        if ~(isfield(tol, 'absTol') && isfield(tol, 'relTol'))
            errStruct.message = 'Argument ''tol'' must have fields ''absTol'' and ''relTol''.';
            errStruct.identifier = 'Andsi:sim:wrongToleranceFormat';
            error(errStruct);
        end
        opt.RelTol = tol.relTol;
        opt.AbsTol = tol.absTol;
    end
end

[tt, uu, xx, yy] = simct_(model, t, u, x0, opt);