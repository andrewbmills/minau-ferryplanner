function [rows,cols,Map,t] = SampleGrid(grid_size,grid_dims,N,Vg,t_h)
% Randomly sample N grid squares from a rectangular grid space defined by a
% 2D array (grid_size) of rows and columns.  This function returns the row
% and column indices of sampled grid spaces as well as their
% nondimensionalized x and y limits arranged in the N by 4 Map matrix.  t
% is a matrix of time windows that center on the time it takes to travel
% between the centers of the ordered grid locations traveling at Vg.  The
% timing windows are at minimum t_h and at max 5*t_h long.

% Randomly select a row vector of N unique integers
% Index goes left to right across the first row and then up a row (repeat)
ind = randperm(prod(grid_size), N)';

% Calculate the corresponding row and column indices
rows = ceil(ind/grid_size(2));
cols = mod(ind, grid_size(2));
cols(cols==0) = grid_size(2);

% Create Map matrix
x_low = grid_dims(1)*(cols-1);
x_high = grid_dims(1)*cols;
y_low = grid_dims(2)*(rows-1);
y_high = grid_dims(2)*rows;
Map = [x_low, x_high, y_low, y_high];

% Create time window matrix (with random noise)
x_center = (x_low + x_high)/2;
y_center = (y_low + y_high)/2;
dt = t_h*(2*rand(N,1) + 2);
t = zeros(N,2);
t(1,1) = 0;
t(1,2) = t(1,1) + dt(1);
t(1,3) = t_h;
for i=2:N
    dist = norm([x_center(i) - x_center(i-1), y_center(i)-y_center(i-1)]);
    t_mid = mean(t(i-1,1:2)) + dist/Vg;
    t(i,1) = t_mid - dt(i)/2;
    t(i,2) = t_mid + dt(i)/2;
    t(i,3) = t_h;
end

end