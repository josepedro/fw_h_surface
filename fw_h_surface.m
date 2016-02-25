%% FW-H surface points getter
% Pattern => matrix(1,5) => y = 1 and x = 5
% Files name of density have to named of pattern <time_step>_matrix_density.dat
function results = fw_h_surface(center_surface, distance_center, matrix_density, matrix_velocity_x, matrix_velocity_y)

	% set total number of cells in y and x 
	[ny nx] = size(matrix_density);
	
	% to face 1 (left)
	for (y = ny/2 - distance_center : ny/2 + distance_center - 1)
        x = nx/2 - distance_center;


    end
    % to face 2 (top)
    for (x = nx/2 - distance_center : nx/2 + distance_center - 1)
         y = ny/2 + distance_center;

    end
    % to face 3 (right)
    for (y = ny/2 + distance_center :-1: ny/2 - distance_center + 1)
        x = ny/2 + distance_center;

    end
    % to face 4 (bottom)
    for (x = nx/2 + distance_center :-1: nx/2 - distance_center + 1)
        y = ny/2 - distance_center;

    end

    results = 0;