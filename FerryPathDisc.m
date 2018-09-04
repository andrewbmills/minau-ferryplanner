function [x, y, t, r] = FerryPathDisc(x_sub, y_sub, t_sub, Vmax, data, power, alpha, h)
% Given arrays of AUV surface locations, this function solves a convex
% optimization problem minimizing the ferry's total travel distance to
% obtain data from each AUV.  We assume that the ferry has to collect all
% of the data from every AUV so that we can calculate a required disc
% radius for full data transfer.  t_sub are the AUV surface intervals, Vmax
% is the fastest speed the ferry can fly (not used), data are the size of
% the AUV data packages in bytes, power is the WiFi link power, alpha is
% the RF loss term, and h is the ferry height.
%
% The output is the sequence of points with their corresponding departure
% times (time for the ferry to leave and travel to the next point).  The
% resultant path is a series of travels between and loiters at the output
% locations.  r are the corresponding comm radii.

% Determine the size of each sub's required disc radius for a full transfer
% of data.
r = (power.*t_sub(:,1)./data).^(1/alpha);
r = sqrt(r.^2 - h^2);
if sum(r <= 0)
    error("The aircraft height is too high to receive all of the data from each sub")
end

% Determine M, the number of waypoints in the path.
N = length(x_sub);
M = 2*N;
t = [t_sub(1,2) - t_sub(1,1); t_sub(1,2)];
for i = 2:N
    t = [t; t_sub(i,2) - t_sub(i,1); t_sub(i,2)];
end

% Generate a matrix to subtract adjacent entries in x and y via matrix
% multiplication.
A = [diag(ones(M-1,1)), zeros(M-1,1)] + [zeros(M-1,1), diag(-ones(M-1,1))];

cvx_begin
    variables x(M) y(M)
    dx = A*x;
    dy = A*y;
    dt = A*t;
    expression d(M-1);
    for i = 1:M-1
        d(i) = norm([dx(i), dy(i)],2);
    end
    minimize(sum(d))
    %d <= Vmax*dt;
    % Disc constraints
    for i = 1:N
        norm([x(2*i-1) - x_sub(i), y(2*i-1) - y_sub(i)], 2) <= r(i);
        norm([x(2*i) - x_sub(i), y(2*i) - y_sub(i)], 2) <= r(i);
    end
cvx_end

end

