function [grid_size, grid_dims, rows, cols, Map, t, Vg, t_h, dataSize, ...
    alpha, id_AUV, power] = importFerryJSON(filename)
    
    fileID = fopen(filename);
    text = fread(fileID, '*char')';
    fclose(fileID);
%     text = text(4:end);
    inputArgs = jsondecode(text);
    grid_size = [inputArgs.gridDescription.gridSquareN, ...
        inputArgs.gridDescription.gridSquareE];
    grid_dims = inputArgs.gridDescription.squareLength*ones(1,2);
    
    alpha = inputArgs.parameters.commModel.dataDropoffRate;
    dataSize = [inputArgs.rendezvous.dataSize]';
    N = size(dataSize,1);
    power = (54*10^6)*(20)^alpha*ones(N,1); % 54 Mbps @ 20 meters
    Vg = inputArgs.parameters.ferry.speed;
    
    id_AUV = [inputArgs.rendezvous.auvId]';
    cols = [inputArgs.rendezvous.gridE]';
    rows = [inputArgs.rendezvous.gridN]';
    x_low = grid_dims(1)*(cols);
    x_high = grid_dims(1)*(cols+1);
    y_low = grid_dims(2)*(rows);
    y_high = grid_dims(2)*(rows+1);
    Map = [x_low, x_high, y_low, y_high];
    
    %% Determine harvest window timings
    R_comm_desired = grid_dims(1)/2; % The radius we'd like to communicate at (meters).  Initially set to half a grid width.
    t_h_desired = dataSize./(power/(R_comm_desired^alpha)); % data rate (P/R^alpha) is in bits per second
    t_start = [inputArgs.rendezvous.startTime]';
    t_end = [inputArgs.rendezvous.endTime]';
    dt = t_end - t_start;
    t_h = max(min(dt, t_h_desired), ones(N,1)); % Ensures feasibility, windows are at least one second long
    t = [t_start, t_end, t_h];
end

