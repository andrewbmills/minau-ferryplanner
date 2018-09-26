% MinAu Surfacing and Ferry Path Optimization
clear all
close all
%% Read in the problem parameters from .json or randomize them

readIn = 0;

% Read from file
if readIn
    filenameIn = 'example_OLinput.json';
    [grid_size, grid_dims, rows, cols, Map, t, Vg, t_h, dataSize, alpha, ...
        id_AUV] = importFerryJSON(filenameIn);
    N = length(dataSize);
    power = (54*10^6)*(20)^alpha*ones(N,1);
    h = 100;
    % Sort rendezvous windows if they are out of order
    [~,idx] = sort(t(:,1));
    t = t(idx,:);
    id_AUV = id_AUV(idx,:);
    rows = rows(idx,:);
    cols = cols(idx,:);
    Map = Map(idx,:);
    dataSize = dataSize(idx,:);
else
% Randomized
    Vg = 10; % m/s
    grid_size = [8,10]; % [rows, cols]
    grid_dims = [250, 250]; % [width, height] (meters)
    N = 8; % number of sub rendezvous
    t_h = 30; % time to collect data from each AUV in seconds (design variable)
    h = 100; % meters
    alpha = 2.5;
    power = (54*10^6)*(20)^alpha*ones(N,1); % WiFi data rate is 54 Mbps, we'll assume that's at 20 meters
    r_des = 150; % meters
    r_des = sqrt(r_des.^2 + h^2);
    dataSize = t_h*power./(r_des.^alpha);
    [rows, cols, Map, t] = SampleGrid(grid_size, grid_dims, N, Vg, t_h);
    id_AUV = ones(N,1);
end

%% Determine feasible AUV surface locations

[x_AUV, y_AUV, t_d, cvx_optval, t_infeasible] = TimeOrderedFerry(Map, t, Vg);
if cvx_optval == Inf
    warning("Surfacing optimization returned infeasible, returning shortest possible path instead.")
    warning("Consider widening surfacing windows or increasing ferry speed.")
end

%% Plot the results from AUV surface location optimization

PlotGridRoute(x_AUV, y_AUV, grid_size, grid_dims, rows, cols);
PlotTimingDepartures(x_AUV, y_AUV, t, Vg, t_h, t_d);

%% Determine feasible path for ferry

t_AUV = [t(:,3), t_d];
[x_ferry, y_ferry, t_ferry, r_comm] = FerryPathDisc(x_AUV, y_AUV, t_AUV, Vg, dataSize, power, alpha, h);
PlotFerryPath(x_ferry, y_ferry, x_AUV, y_AUV, r_comm, grid_size, grid_dims, rows, cols);

%% Output to JSON

inputArgs.gridDescription.gridSquareN = grid_size(1);
inputArgs.gridDescription.gridSquareE = grid_size(2);
inputArgs.gridDescription.squareLengthE = grid_dims(1);
inputArgs.gridDescription.squareLengthN = grid_dims(2);
AUV = [id_AUV, x_AUV, y_AUV, [t_AUV(:,2) - t_AUV(:,1), t_AUV(:,2)]];
ferry = [x_ferry, y_ferry, h*ones(length(x_ferry),1), t_ferry];
filenameOut = 'example1_CUoutput.json';
WriteFerryJSON(inputArgs.gridDescription, ...
    AUV, ferry, r_comm, filenameOut, cvx_optval, t_infeasible);