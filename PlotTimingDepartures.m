function [fig_handle] = PlotTimingDepartures(x, y, t, Vg, t_h, t_d)
%Plots the timing schedule for the ferrying optimization problem.
N = length(x);
fig_handle = figure();
hold on
plot([t_d(1) - t_h(1), t_d(1)], [2, 2], 'mo-');
for i = 1:(N-1)
    plot(t(i,1:2), [2*i-1, 2*i-1], 'ro-'); % plot surface intervals
    dist = norm([x(i+1)-x(i), y(i+1)-y(i)]); % calculate distances

    % Plot the travel and sampling intervals
    plot([t_d(i), t_d(i) + dist/Vg], [2*i, 2*i], 'bo-')
    if (t_d(i) + dist/Vg < t(i+1,1))
        plot([t(i+1,1), t(i+1,1) + t_h], [2*i,2*i], 'mo-')
    else
        plot([t_d(i) + dist/Vg, t_d(i) + dist/Vg + t_h], [2*i,2*i], 'mo-')
    end
end

plot(t(N,1:2),[2*N-1, 2*N-1], 'ro-'); % plot last surface interval
leg = legend('sample time', 'initial surface interval', 'travel time');
set(leg, 'Location', 'northwest')
xlabel('time (sec)')
end
