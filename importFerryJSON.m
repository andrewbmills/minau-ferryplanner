function [grid_size, grid_dims, rows, cols, Map, t, Vg, t_h, dataSize, ...
    alpha, id_AUV] = importFerryJSON(filename)
    
    fileID = fopen(filename);
    text = fread(fileID, '*char')';
    fclose(fileID);
    text = text(4:end);
    inputArgs = jsondecode(text);
    grid_size = [inputArgs.gridDescription.gridSquareN, ...
        inputArgs.gridDescription.gridSquareE];
    grid_dims = inputArgs.gridDescription.squareLength*ones(1,2);
    
    alpha = inputArgs.parameters.commModel.dataDropoffRate;
    dataSize = [inputArgs.rendezvous.dataSize]';
    Vg = inputArgs.parameters.ferry.speed;
    
    id_AUV = [inputArgs.rendezvous.auvId]';
    cols = [inputArgs.rendezvous.gridE]';
    rows = [inputArgs.rendezvous.gridN]';
    x_low = grid_dims(1)*(cols-1);
    x_high = grid_dims(1)*cols;
    y_low = grid_dims(2)*(rows-1);
    y_high = grid_dims(2)*rows;
    Map = [x_low, x_high, y_low, y_high];
    t_h = 5; % seconds
    t = [[inputArgs.rendezvous.startTime]', [inputArgs.rendezvous.endTime]', ...
        t_h*ones(length(id_AUV), 1)];
end

