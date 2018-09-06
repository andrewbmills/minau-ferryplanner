function [x, y, cvx_optval] = OrderedFerry(Map)
%Takes an N by 4 map matrix containing an ordered list of rendezvous square
%regions in 2 dimensions.  The first and second columns are the x 
%coordinate limits and the third and fourth columns are the y coordinate
%limits.  The output is the sequence of points with the shortest total
%distance from the first region to the last region.

% The number of rectangular regions in the map
N = size(Map, 1);

% Generate a matrix to subtract adjacent entries in x and y via matrix
% multiplication.
A = [diag(ones(N-1,1)), zeros(N-1,1)] + [zeros(N-1,1), diag(-ones(N-1,1))];


cvx_begin
    variables x(N) y(N)
    dx = A*x;
    dy = A*y;
    expression d(N-1);
    for i = 1:N-1
        d(i) = norm([dx(i), dy(i)],2);
    end
    minimize(sum(d))
    for i = 1:N
        x(i) >= Map(i,1);
        x(i) <= Map(i,2);
        y(i) >= Map(i,3);
        y(i) <= Map(i,4);
    end
cvx_end

end

