%PLEASE SUBMIT MODIFICATIONS AND IMPROVEMENTS!

%File: updatepositioncirc.m (MATLAB)
%Version: 0.1
%Author: Stewart Nash
%Date: March 1, 2015
%Description: Function returns position of indexed particles given indexed velocity, current position, time increment, index size, and grid size. It also updates the angle for deflected particles.

%Note: Particle index means a consecutive list of integers starting with 1.

function [output_position, output_angle] = updatepositioncirc(input_flags, input_speed, input_angle, input_position, input_time, input_size, input_radius, domain_size)

    %>>>>Constants<<<<%
    %DIMENSION - Number of spatial dimensions
    %RADIANS - Radian conversion factor

    C_PI =  3.14159265358979323846264338327950288419716939937510582;
    RADIANS = 2 * C_PI;
    DIMENSION = 2;
	FLAGNO = 1;
	FLAGVALUE = 0;	

    %>>>>Input Parameters<<<<%
	%input_flags - particle flags indexed by particle number
    %input_speed - speed of particles indexed by particle number
    %input_angle - angle of particles indexed by particle number
    %input_position - current position indexed by particle number
    %input_time - time increment to advance over
    %input_size - number of indexed particles, the maximum index number
    %domain_size - dimensions of grid

    %>>>>Variables<<<<%
    %out_of_border - indicates that particle has gone out of bounds of box; it will be deflected off the border
    %position - holds position of particles during function processing
    %angle - holds angle particle is travelling
    %velocity - holds velocity of particle
    %domain_width - number of columns of input grid
    %domain_length - number of rows of input grid

	%Allocate variables
	position = zeros(input_size, DIMENSION);
	angle = zeros(input_size, 1);
	velocity = zeros(input_size, DIMENSION);
	out_of_border = 0;
	cross_ring = 1;
	
	%Initialize variables
	angle = input_angle;
	velocity = updatevelocity(input_speed, input_angle, input_size);
	domain_width = domain_size(1);
	domain_length = domain_size(2);	
	center = [domain_width / 2, domain_length / 2];
	
	%Update position of particles using distance travelled
	for i = 1 : input_size
		position(i, 1) = input_position(i, 1) + velocity(i, 1) * input_time;
		if (position(i, 1) < 0 || position(i, 1) > domain_width)
			out_of_border = 1;
		end
		position(i, 2) = input_position(i, 2) + velocity(i, 2) * input_time;
		if (position(i, 2) < 0 || position(i, 2) > domain_length)
			out_of_border = 1;
		end
	end
	
	%Deflect particles which have gone out of the border
	while out_of_border
		out_of_border = 0;
		for i = 1 : input_size
			%Deflect from left wall
			if (position(i, 1) < 0)
				out_of_border = 1;				
				position(i, 1) = abs(position(i, 1));
				if (angle(i) >= C_PI/2 && angle(i) <= C_PI)
					angle(i) = C_PI - angle(i);
				elseif (angle(i) >= C_PI && angle(i) <= 3*C_PI/2)
					angle(i) = 3 * C_PI - angle(i);
				else
					fprintf('ERROR (updatepositioncirc.m): Left wall deflection angle outside of range. Results may be inaccurate.\n');
					angle(i) = C_PI - angle(i);
				end
			end
			%Deflect from right wall
			if (position(i, 1) > domain_width)
				out_of_border = 1;
				position(i, 1) = 2 * domain_width - position(i, 1);
				if (angle(i) >= 0 && angle(i) <= C_PI/2)
					angle(i) = C_PI - angle(i);
				elseif (angle(i) >= 3*C_PI/2 && angle(i) <= 2*C_PI)
					angle(i) = 3 * C_PI - angle(i);
				else
					fprintf('ERROR (updatepositioncirc.m): Right wall deflection angle outside of range. Results may be inaccurate.\n');
					angle(i) = C_PI - angle(i);
				end
			end
			%Deflect from bottom (top)
			if (position(i, 2) < 0)
				out_of_border = 1;
				position(i, 2) = abs(position(i, 2));
				angle(i) = 2 * C_PI - angle(i);
			end
			%Deflect from top (bottom)
			if (position(i, 2) > domain_length)
				out_of_border = 1;
				position(i, 2) = 2 * domain_length - abs(position(i, 2));
				angle(i) = 2 * C_PI - angle(i);
			end			
		end
	end
	
	%Deflect particles which have gone inside of ring
	while cross_ring
		cross_ring = 0;
		for i = 1 : input_size
			if (input_flags(i, FLAGNO) == FLAGVALUE)
				if (sqrt((position(i, 1) - center(1))^2 + (position(i, 2) - center(2))^2) < input_radius)
					cross_ring = 1;
					[position(i, 1), position(i, 2), angle(i)] = ringdeflect(position(i, 1), position(i, 2), angle(i), input_radius, center(1), center(2));
				end			
			end
		end
	end
	output_position = position;
	output_angle = angle;
end