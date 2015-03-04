%PLEASE SUBMIT MODIFICATIONS AND IMPROVEMENTS!

%File: updatemask.m (MATLAB)
%Version: 0.1
%Author: Stewart Nash
%Date: March 1, 2015
%Description: Drawing of central ring on grid mask. Grid mask must be masked with domain for final image.

%Note: Particle index means a consecutive list of integers starting with 1.

%>>>>Input Parameters<<<<%
%input_position - position of particles indexed by particle number
%input_size - number of particles in index (maximum index number)
%domain_size - size of grid (array)
%ring_radiu - radius of ring

%>>>>Constants<<<<%
%THICKNESS - line thickness of central ring

%>>>>Variables<<<<%
%domain_width - number of columns of input grid
%domain_length - number of rows of input grid
%center - center of ring

function output_domain = updatemask(domain_size, ring_radius)
	
	THICKNESS = 0.75;
    THICKNESS = THICKNESS * ring_radius;

	domain_mask = zeros(domain_size);
	domain_width = domain_size(1);
	domain_length = domain_size(2);
	center = [domain_width / 2, domain_length / 2];
	
	%Draw central ring on the grid using its radius
	for i = 1 : domain_width
		for j = 1 : domain_length
			if (abs((i - center(1))^2 + (j - center(2))^2 - ring_radius^2) < THICKNESS)
				domain_mask(i, j) = 1;
			end
		end
	end
	
	output_domain = domain_mask;
	
end