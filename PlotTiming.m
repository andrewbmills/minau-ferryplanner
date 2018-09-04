function [t_d_log, fig_handle] = PlotTiming(x, y, t, Vg, t_h)
%Plots the timing schedule for the ferrying optimization problem.

N = length(x);
fig_handle = figure();
hold on

t_d_log = zeros(N,1);
t_d = t(1,1) + t(1,3);
t_d_log(1) = t_d;
for i = 1:(N-1)
    plot(t(i,1:2), [2*i-1, 2*i-1], 'bo-'); % plot surface intervals
    dist = norm([x(i+1)-x(i), y(i+1)-y(i)]); % calculate distances
    % Determine when the aircraft will arrive to the next node location
    if (t_d + dist/Vg < t(i+1,1))
        t_arr = t(i+1,1);
    else
        t_arr = t_d + dist/Vg;
    end
    % Plot the travel and sampling intervals
    plot([t_arr - dist/Vg, t_arr], [2*i, 2*i], 'ro-')
    plot([t_arr, t_arr + t_h], [2*i,2*i], 'mo-')
    % Determine the next departure time
    t_d = t_arr + t_h;
    t_d_log(i+1) = t_d;
end
plot(t(N,1:2),[2*N-1, 2*N-1], 'bo-');
leg = legend('surface interval', 'travel time', 'sample time');
set(leg, 'Location', 'northwest')
xlabel('time')
end
