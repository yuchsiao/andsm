function [option, prev] = ctid_(data, deg_e, deg_f, deg_h, deg_v, option)
tic;
%* Check and setup arguments
if deg_v < 0
    error 'deg_v must be greater than or equal to 2';
end
deg_v = deg_v - 2;

%* Parameters
thres = 1e-8;
kappa = 1e0;
lambda = 1e-2;

if isfield(option, 'kappa')
    kappa = option.kappa;
end
if isfield(option, 'lambda')
    lambda = option.lambda;
end
if isfield(option, 'thres')
    thres = option.thres;
end
flag_io_scale = true;
if isfield(option, 'io_scale')
    flag_io_scale = option.io_scale;
end
flag_incremental_stability = false;
if isfield(option, 'incremental_stability')
    flag_incremental_stability = option.incremental_stability;
end

%* Process raw data
[data, io_scale, der_scale] = preprocess_data(data);
if ~flag_io_scale
    io_scale = ones(size(io_scale));
end
option.io_scale = io_scale;
option.der_scale = der_scale;

%* Init sdp variables
m  = size(data.u,2);
n  = size(data.x,2);
N  = size(data.u,1);

q = sdpvar(n,1);
x = sdpvar(n,1);
u = sdpvar(m,1);

d = sdpvar(n,1);
v = sdpvar(n,1);
w = sdpvar(n,1);

[P, cp, mp] = polymat_(x,deg_v,n);
cpv = stack_polymat_(cp);
mpv = stack_polymat_(mp);

[Pis, cpis, mpis] = polymat_(x,deg_v,n);
cpisv = stack_polymat_(cpis);
mpisv = stack_polymat_(mpis);


[e, ce, me] = polyvec_(x,deg_e,n);
[f, cf, mf] = polyvec_([x;u],deg_f,n);
[h, ch, mh] = polyvec_([x;u],deg_h,m);
E = diffvec_(e, x);
%* Does not help in speed
% cE = cell(n,n);
% mE = cell(n,n);
% for i = 1:n
%     for j = 1:n
%         [cE{i,j}, mE{i,j}] = coefficients(E(i,j), x);
%     end
% end

cev = stack_polyvec_(ce);
cfv = stack_polyvec_(cf);
chv = stack_polyvec_(ch);

mev = stack_polyvec_(me);
mfv = stack_polyvec_(mf);
mhv = stack_polyvec_(mh);

tau = sdpvar(1,1);
rho = sdpvar(1,1);
zeta = sdpvar(length(cev)+length(cfv)+length(chv),1);

%* Setup constraints
if isfield(option, 'prev')
    prev = option.prev;
    
    Cons = prev.Cons;
    q = prev.q;
    x = prev.x;
    u = prev.u;
    d = prev.d;
    v = prev.v;
    w = prev.w;
    
    P = prev.P;
    cp = prev.cp;
    mp = prev.mp;
    cpv = prev.cpv;
    mpv = prev.mpv;
    
    Pis = prev.Pis;
    cpis = prev.cpis;
    mpis = prev.mpis;
    cpisv = prev.cpisv;
    mpisv = prev.mpisv;
    
    e = prev.e;
    ce = prev.ce;
    me = prev.me;
    f = prev.f;
    cf = prev.cf;
    mf = prev.mf;
    h = prev.h;
    ch = prev.ch;
    mh = prev.mh;
    E = prev.E;
    cev = prev.cev;
    cfv = prev.cfv;
    chv = prev.chv;
    mev = prev.mev;
    mfv = prev.mfv;
    mhv = prev.mhv;
    tau = prev.tau;
    rho = prev.rho;
    zeta = prev.zeta;
else
    Cons = prepare_cons(data, x, u, q, d, v, w, e, E, f, h, P, Pis, tau, rho, zeta, cev, cfv, chv, cf, ch, mf, mh, ...
                        flag_incremental_stability);
%     Cons = prepare_cons(data, x, u, q, e, E, f, h, P, tau, rho, zeta, cev, cfv, chv, cf, cE, ch, mf, mE, mh);
end

%* Setup obj func
Obj = tau*tau + kappa * rho*rho + lambda * sum(zeta);

%* Setup optimization options
level = 2;
ops = setup_sdp_option(level);
                  
%* solve sos
pre_time = toc;
tic;
solinfo = solvesos(Cons, Obj, ops, [cfv; cev; chv; cpv; cpisv; tau; rho]);
solving_time = toc;
tic;
%% Clean up results and store in option

format long;

% e = sd(replace(e, cev, clean(double(cev), thres)/der_scale));
e_expr = cell(size(e));
for i = 1:n
    tmp = sd(replace(e(i), cev, clean(value(cev), thres)/der_scale(i) ));
    e_expr{i} = tmp{1};
end

% E = sd(replace(E, cev, clean(double(cev), thres)/der_scale));
E_expr = cell(size(E));
for i = 1:n
    tmp = sd(replace(E(:,i), cev, clean(value(cev), thres)/der_scale(i) )); 
    for j = 1:n
        E_expr{j,i} = tmp{j,1};
    end
end

%* Fastest version

f_scaled = replace(f, cfv, clean(value(cfv), thres));
f_expr = sd(replace(f_scaled, u, u./io_scale));
%* Scaled original
% f_scaled = replace(f, u, u./io_scale);
% f_expr = sd(replace(f_scaled, cfv, clean(double(cfv), thres)));
%* Original
% f_expr = sd(replace(f, cfv, clean(double(cfv), thres)));

h_scaled = replace(h, chv, clean(value(chv), thres));
h_expr = sd(replace(h_scaled, u, u./io_scale)./io_scale);
%* Scaled original
% h_scaled = replace(h, u, u./io_scale)./io_scale;
% h_expr = sd(replace(h_scaled, chv, clean(double(chv), thres)));
%* Original
% h_expr = sd(replace(h, chv, clean(double(chv), thres)));

P_expr = sd(replace(P, cpv, clean(value(cpv), thres)));
Pis_expr = sd(replace(Pis, cpv, clean(value(cpisv), thres)));

option.n = n;
option.m = m;
option.deg_e = deg_e;
option.deg_f = deg_f;
option.deg_h = deg_h;

option.f = f_expr;
option.f_coeff = clean(value(cfv), thres);
option.f_mono  = sd(mfv);

option.e = e_expr;
option.E = E_expr;
option.e_coeff = clean(value(cev), thres);
option.e_mono  = sd(mev);

option.h = h_expr;
option.h_coeff = clean(value(chv), thres);
option.h_mono  = sd(mhv);

option.P = P_expr;
option.P_coeff = clean(value(cpv), thres);
option.P_mono  = sd(mpv);

option.Pis = Pis_expr;
option.Pis_coeff = clean(value(cpisv), thres);
option.Pis_mono  = sd(mpisv);

option.sol.info = solinfo;

option.sol.qual.pfeas = solinfo.solveroutput.res.info.MSK_DINF_INTPNT_PRIMAL_FEAS;
option.sol.qual.dfeas = solinfo.solveroutput.res.info.MSK_DINF_INTPNT_DUAL_FEAS;
option.sol.qual.status = solinfo.solveroutput.res.info.MSK_DINF_INTPNT_OPT_STATUS;
option.sol.qual.pobj = solinfo.solveroutput.res.info.MSK_DINF_INTPNT_PRIMAL_OBJ;
option.sol.qual.dobj = solinfo.solveroutput.res.info.MSK_DINF_INTPNT_DUAL_OBJ;

prev.Cons = Cons;
prev.q = q;
prev.x = x;
prev.u = u;
prev.d = d;
prev.v = v;
prev.w = w;

prev.P = P;
prev.cp = cp;
prev.mp = mp;
prev.cpv = cpv;
prev.mpv = mpv;

prev.Pis = Pis;
prev.cpis = cpis;
prev.mpis = mpis;
prev.cpisv = cpisv;
prev.mpisv = mpisv;

prev.e = e;
prev.ce = ce;
prev.me = me;
prev.f = f;
prev.cf = cf;
prev.mf = mf;
prev.h = h;
prev.ch = ch;
prev.mh = mh;
prev.E = E;
prev.cev = cev;
prev.cfv = cfv;
prev.chv = chv;
prev.mev = mev;
prev.mfv = mfv;
prev.mhv = mhv;
prev.tau = tau;
prev.rho = rho;
prev.zeta = zeta;
prev.der_scale = der_scale;

post_time = toc;

option.sol.time.prep = pre_time;
option.sol.time.yalmip = solving_time - solinfo.solveroutput.res.info.MSK_DINF_OPTIMIZER_TIME;
option.sol.time.mosek = solinfo.solveroutput.res.info.MSK_DINF_OPTIMIZER_TIME;
option.sol.time.post = post_time;

format

%* may fail occasionally
% [primalfeas,dualfeas] = checkset(Cons);
% option.primalfeas = primalfeas;
% option.dualfeas = dualfeas;

end

%%
function [data, io_scale, der_scale] = preprocess_data(data)
% Scale t differently for each state
% data: dx, x, u, y

dx_tilde = data.dx;
x_tilde  = data.x;
u_tilde  = data.u;
y_tilde  = data.y;

m = size(u_tilde, 2);
n = size(x_tilde, 2);
io_scale  = zeros(m, 1);
der_scale = zeros(n, 1);
x_scale = zeros(n,1);

%* Rescale state (inactive)
for i = 1:n
   x_scale(i)    = norm(x_tilde(:,i));
   x_scale(i)    = 1;
   x_tilde(:,i)  = (x_tilde(:,i)+eps) /x_scale(i);
   dx_tilde(:,i) = (dx_tilde(:,i)+eps)/x_scale(i);
end

%* Compute der_scale
for i = 1:n
    der_scale(i) = norm(dx_tilde(:,i))/norm(x_tilde(:,i)); 
    dx_tilde(:,i) = dx_tilde(:,i)/der_scale(i);
end

%* Compute io_scale
for i = 1:m
    io_scale(i) = sqrt(norm(u_tilde(:,i))/norm(y_tilde(:,i)));
%     io_scale(i) = 2;
    u_tilde(:,i) = (u_tilde(:,i)+eps)/io_scale(i);
    y_tilde(:,i) = (y_tilde(:,i)+eps)*io_scale(i);
end

data.dx = dx_tilde;
data.x = x_tilde;
data.u = u_tilde;
data.y = y_tilde;

end

function [data, io_scale, der_scale] = preprocess_data_alpha(data)
% Scale t to alpha t

dx_tilde = data.dx;
x_tilde  = data.x;
u_tilde  = data.u;
y_tilde  = data.y;

m = size(u_tilde, 2);
n = size(x_tilde, 2);
io_scale  = zeros(1, m);
der_scale = ones(1, n);

%* Compute der_scale
der_scale = der_scale * norm(dx_tilde(:)) / norm(x_tilde(:));

%* Compute io_scale
for i = 1:m
    io_scale(i) = sqrt(norm(u_tilde(:,i))/norm(y_tilde(:,i)));
end

data.dx = dx_tilde;

end

%%
function Cons = prepare_cons(data, x, u, q, d, v, w, e, E, f, h, P, Pis, tau, rho, zeta, cev, cfv, chv, cf, ch, mf, mh,...
                             flag_incremental_stability)
% function Cons = prepare_cons(data, x, u, q, e, E, f, h, P, tau, rho, zeta, cev, cfv, chv, cf, cE, ch, mf, mE, mh)

%* Pamameters
posdef = 1e-8;

m  = size(data.u,2);
n  = size(data.x,2);
N  = size(data.x,1);

dx_tilde = data.dx;
x_tilde  = data.x;
u_tilde  = data.u;
y_tilde  = data.y;

%* Setup constraints
sigma = u'*h;

Cons = [];

decreasingConstraint = 2*sigma + 2*(x)'*(e-f) -(x)'*P*(x) +(q)'*P*(q) -2*(q)'*(e+f);
if flag_incremental_stability
    epsilon = 1e-8;
    e_plus = replace(e, x, x+d);
    f_plus = replace(f, x, x+d);
    de = e_plus - e;
    df = f_plus - f;

%     p = 1+ u'*u + x'*x;
%     w = v + (1e-3*sum(u.^3));
    
    incremental_stability_constraint = 2*d'*(de-df) - d'*Pis*d...
                                      -2*w'*(de+df) + w'*Pis*w...
                                      -2*epsilon*(d'*d);
%     incremental_stability_constraint = 2*d'*(de-df) - d'*Pis*d...
%                                       -2*v'*(de+df) + v'*Pis*v...
%                                       +2*epsilon*(-2*w'*de + w'*Pis*w);

    Cons = [Cons, sos(incremental_stability_constraint)];
end

%* Setup objective func
state_err = sdpvar(n*N,1);
output_err = sdpvar(m*N,1);
for i = 1:N
    if mod(i, 200)==0
        disp([datestr(now, 'yyyy-mm-dd HH:MM:SS') ' : ' num2str(i), ' of ' num2str(N)]);
        java.lang.System.gc();
        java.lang.Runtime.getRuntime().gc;
    end
    
    % fs = replace(f, [x;u], [x_tilde(i,:)';u_tilde(i,:)']);
    fs = sdpvar(n,1);
    for j = 1:n
        fs(j) = replace(mf{j}, [x;u], [x_tilde(i,:)';u_tilde(i,:)'])' * cf{j}; 
    end
    
    Es = replace(E, x, x_tilde(i,:)');
    %* Does not help in speed
    %Es = sdpvar(n,n);
    %for j = 1:n
    %    for k = 1:n
    %        Es(j,k) = replace(mE{j,k}, x, x_tilde(i,:)')' * cE{j,k};
    %    end
    %end
    
    % hs = replace(h, [x;u], [x_tilde(i,:)';u_tilde(i,:)']);
    hs = sdpvar(m,1);
    for j = 1:m
        hs(j) = replace(mh{j}, [x;u], [x_tilde(i,:)';u_tilde(i,:)'])' * ch{j};
    end
   
   %* Append constraints
    state_err((i-1)*n+1 : i*n) = Es*dx_tilde(i,:)'-fs;
    output_err((i-1)*m+1 : i*m) = y_tilde(i,:)'-hs;
end

%* l1 cost and constraint
c = [cev; cfv; chv];

v = sdpvar(n,1);
Cons = [Cons, cone(state_err, tau), cone(output_err, rho), ...
        sos(v'*(E+E.')*v - posdef*eye(size(E))), ...
        sos(decreasingConstraint), ...
        -zeta <= c <= zeta, ...
        zeta >= 0 ];

end

function ops = setup_sdp_option(level)

if level == 1
    ops = sdpsettings('solver', 'mosek', ...
                  'mosek.MSK_DPAR_INTPNT_CO_TOL_DFEAS',    1e-8, ...% (1e-8)
                  'mosek.MSK_DPAR_INTPNT_CO_TOL_PFEAS',    1e-8, ...% (1e-8)
                  'mosek.MSK_DPAR_INTPNT_CO_TOL_REL_GAP',  1e-7, ... % (1e-7)
                  'mosek.MSK_DPAR_INTPNT_CO_TOL_MU_RED',   1e-8, ... % (1e-8)
                  'mosek.MSK_DPAR_INTPNT_CO_TOL_NEAR_REL', 1e3, ...  % (1e3)
                  'mosek.MSK_DPAR_INTPNT_CO_TOL_INFEAS',   1e-10, ...% (1e-10)
                  'savesolveroutput',1);
elseif level == 2
    ops = sdpsettings('solver','mosek', ...
                  'mosek.MSK_DPAR_INTPNT_CO_TOL_DFEAS',    1e-10, ...% (1e-8)
                  'mosek.MSK_DPAR_INTPNT_CO_TOL_PFEAS',    1e-10, ...% (1e-8)
                  'mosek.MSK_DPAR_INTPNT_CO_TOL_REL_GAP',  1e-8, ... % (1e-7)
                  'mosek.MSK_DPAR_INTPNT_CO_TOL_MU_RED',   1e-9, ... % (1e-8)
                  'mosek.MSK_DPAR_INTPNT_CO_TOL_NEAR_REL', 1e3, ...  % (1e3)
                  'mosek.MSK_DPAR_INTPNT_CO_TOL_INFEAS',   1e-10, ...% (1e-10)
                  'savesolveroutput',1, ...
                  'mosek.MSK_IPAR_LOG',0, ...
                  'verbose', 1);

end

end


