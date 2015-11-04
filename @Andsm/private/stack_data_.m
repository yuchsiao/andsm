function stacked_data = stack_data_(data)

u = data.u;
x = data.x;
y = data.y;
dx = data.dx;

uu = [];
xx = [];
yy = [];
dxx = [];

for i = 1:length(u)
    uu = [uu; u{i}];
    xx = [xx; x{i}];
    yy = [yy; y{i}];
    dxx = [dxx; dx{i}];
end

% stacked_data = {dxx, xx, uu, yy};

stacked_data.dx = dxx;
stacked_data.x = xx;
stacked_data.u = uu;
stacked_data.y = yy;
