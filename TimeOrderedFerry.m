function [x, y, t_d, Cost, t_infeasible] = TimeOrderedFerry(Map, t, Vg)
%Takes an N by 4 map matrix containing an ordered list of rendezvous square
%regions in 2 dimensions.  The first and second columns are the x 
%coordinate limits and the third and fourth columns are the y coordinate
%limits.  t is an N by 3 time matrix containing an ordered list of
%rendezvous timing windows and harvesting times.  The first and second
%columns are the surface interval start time (t0,i) and the surface
%interval end time (tf,i) respectively.  The third column is the harvest
%time.  Vg is groundspeed.
%
%The output is the sequence of points with the shortest total
%distance from the first region to the last region.

% The number of rectangular regions in the map
N = size(Map, 1);

% Generate a matrix to subtract adjacent entries in x and y via matrix
% multiplication.
A = [diag(ones(N-1,1)), zeros(N-1,1)] + [zeros(N-1,1), diag(-ones(N-1,1))];

cvx_begin
    variables x(N) y(N) t_d(N,1)
    % Calculate distances
    dx = A*x;
    dy = A*y;
    expression d(N-1);
    for i = 1:N-1
        d(i) = norm([dx(i), dy(i)],2);
    end
    minimize(sum(d))
    % Grid location constraints
    for i = 1:N
        x(i) >= Map(i,1);
        x(i) <= Map(i,2);
        y(i) >= Map(i,3);
        y(i) <= Map(i,4);
    end
    % Travel time constraints
    dt = d/Vg;
    0 <= - A*t_d - t(2:end,3) - dt;
    t_d <= t(:,2);
    t_d >= t(:,1) + t(:,3);
cvx_end

% Save the first resultant cost
Cost = cvx_optval;
t_infeasible = zeros(N-1,1);
% Check to see which constraints are causing an infeasibility if one exists
if cvx_optval == Inf
    cvx_begin
        variables x(N) y(N) t_d(N,1)
        dx = A*x;
        dy = A*y;
        expressions d(N-1)
        for i = 1:N-1
            d(i) = norm([dx(i), dy(i)],2);
        end
        dt = d/Vg;
%         minimize(sum(d) + max(A*t_d + t(2:end,3) + dt))
        maximize(min(-A*t_d - t(2:end,3) - dt))
        % Grid location constraints
        for i = 1:N
            x(i) >= Map(i,1);
            x(i) <= Map(i,2);
            y(i) >= Map(i,3);
            y(i) <= Map(i,4);
        end
        % Travel time constraints
        t_d <= t(:,2);
        t_d >= t(:,1) + t(:,3);
    cvx_end
    dt_inf = dt;
    cvx_begin
        variables x(N) y(N)
        dx = A*x;
        dy = A*y;
        expressions d(N-1)
        for i = 1:N-1
            d(i) = norm([dx(i), dy(i)],2);
        end
        dt = d/Vg;
        minimize(sum(d))
        % Grid location constraints
        for i = 1:N
            x(i) >= Map(i,1);
            x(i) <= Map(i,2);
            y(i) >= Map(i,3);
            y(i) <= Map(i,4);
        end
    cvx_end
    t_infeasible = dt_inf - dt;
end

end