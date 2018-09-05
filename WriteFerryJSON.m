function WriteFerryJSON(gridDescription, AUV, ferry, comm, filename)
%Writes Ferry and Surfacing Algorithm outputs to a JSON file.
% Inputs - 
%   - gridDescription:
%       grid information directly from the input file
%   - Map:
%       Each row corresponds to a grid cell where an AUV will surface.
%       Columns 1 and 2 are the x (East) limits and 3 and 4 are the y 
%       (North) limits of the grid cells.
%       The cells are in their surfacing window order.
%   - AUV:
%       Column 1 is the AUV id number
%       Column 2 is the x (East) surface locations
%       Column 3 is the y (North) surface locations
%       Columns 4 and 5 are the surface start and end times in seconds.
%   - ferry:
%       Column 1 is the x (East) ferry path locations
%       Column 2 is the y (North) ferry path locations
%       Column 3 is the ferry height path locations
%       Column 4 is the departure time from the same ferry path locations
%   - comm:
%       Column 1 is the calculated comm radii for the AUV surface locations
%       

struct.gridDescription = gridDescription;

% Parse AUV arguments
struct.auvSurfacing.auvId = AUV(:,1);
struct.auvSurfacing.positionE = AUV(:,2);
struct.auvSurfacing.positionN = AUV(:,3);
struct.auvSurfacing.startTime = AUV(:,4);
struct.auvSurfacing.endTime = AUV(:,5);

% Parse ferry arguments
struct.ferryPath.pathE = ferry(:,1);
struct.ferryPath.pathN = ferry(:,2);
struct.ferryPath.pathD = -ferry(:,3);
struct.ferryPath.departTime = ferry(:,4);

% Parse comm model info
struct.comm_radii = comm;

% Write to JSON file
text = jsonencode(struct);
text = prepjson(text);
fileID = fopen(filename, 'w');
fprintf(fileID, text);
fclose(fileID);

end

