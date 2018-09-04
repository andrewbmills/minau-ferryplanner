function [fig_handle] = PlotFerryPath(x, y, x_sub, y_sub, r, grid_size, grid_dims, rows, cols)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

N = length(rows);

fig_handle = figure();
hold on

% Plot the grid
horiz_x = repmat([0; grid_dims(1)*grid_size(2)], 1, grid_size(1)+1);
horiz_y = repmat(0:grid_dims(2):grid_dims(2)*grid_size(1), 2, 1);
vert_x = repmat(0:grid_dims(1):grid_dims(1)*grid_size(2), 2, 1);
vert_y = repmat([0; grid_dims(2)*grid_size(1)], 1, grid_size(2)+1);
plot(horiz_x, horiz_y, 'k:', vert_x, vert_y, 'k:')

% Highlight the grid spaces that were selected in rows and cols arrays
for i = 1:N
    % The grid spaces are colored in grey
    rectangle('Position', [grid_dims(1)*(cols(i)-1), grid_dims(2)*...
        (rows(i)-1), grid_dims(1), grid_dims(2)], 'FaceColor', (190/255)*[1 1 1], 'EdgeColor', 'k')
end

% Plot the optimized straight line path in order
plot(x_sub(1), y_sub(1), 'g*')
plot(x_sub(end), y_sub(end), 'r*')
plot(x_sub(2:end-1),y_sub(2:end-1),'m*')
plot(x, y, 'b');
t = 0:0.1:2*pi;
for i = 1:N
    plot(x_sub(i) + r(i)*cos(t), y_sub(i) + r(i)*sin(t), 'm-.');
end

end

