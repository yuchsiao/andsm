function data = concatenate_data(data,t,u,x,y,dx)
% CONCATENATE_DATA 

data.t = [data.t, t];
data.u = [data.u, u];
data.x = [data.x, x];
data.y = [data.y, y];
data.dx = [data.dx, dx];