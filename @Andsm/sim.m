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
                err_struct.message = 'Type of tolerance is ''regular'', (''high'', ''stringent'', ''conservative''), (''low'', ''liberal''), ''very low'', or user defined structure with absTol and relTol fields.';
                err_struct.identifier = 'Andsi:sim:wrong_tolerance_specifier';
                error(err_struct);
        end
    else
        if ~(isfield(tol, 'abs_tol') && isfield(tol, 'rel_tol'))
            err_struct.message = 'Argument ''tol'' must have fields ''abs_tol'' and ''rel_tol''.';
            err_struct.identifier = 'Andsi:sim:wrong_tolerance_format';
            error(err_struct);
        end
        opt.RelTol = tol.rel_tol;
        opt.AbsTol = tol.abs_tol;
    end
end

[tt, uu, xx, yy] = simct_(model, t, u, x0, opt);