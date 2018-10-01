function [fig_handle] = PlotGridRoute(x,y,grid_size,grid_dims,rows,cols)
%Plots the rectangular grid defined by the 2D array grid_size.  Highlights
%the cell indices in the N by 1 arrays rows and cols and plots a straight
%line path through the ordered x and y coordinates.

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
    rectangle('Position', [grid_dims(1)*(cols(i)), grid_dims(2)*...
        (rows(i)), grid_dims(1), grid_dims(2)], 'FaceColor', (190/255)*[1 1 1], 'EdgeColor', 'k')
end

% Plot the optimized straight line path in order
plot(x,y,'b*')
plot(x,y,'b')
plot(x(1), y(1), 'g*');
plot(x(end), y(end), 'r*');
xlabel('East (m)')
ylabel('North (m)')
end

