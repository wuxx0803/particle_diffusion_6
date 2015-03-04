%PLEASE SUBMIT MODIFICATIONS AND IMPROVEMENTS!

%File: updatedomainring.m (MATLAB)
%Version: 0.0
%Author: Stewart Nash
%Date: March 1, 2015
%Description: Drawing of particles on grid using their position. This function also draws central ring.

%Note: Particle index means a consecutive list of integers starting with 1.

%>>>>Input Parameters<<<<%
%input_position - position of particles indexed by particle number
%input_size - number of particles in index (maximum index number)
%domain_size - size of grid (array)
%ring_radiu - radius of ring

%>>>>Constants<<<<%

%>>>>Variables<<<<%
%domain_width - number of columns of input grid
%domain_length - number of rows of input grid
%center - center of ring

function output_domain = updatedomainring(input_position, input_size, domain_size, input_flags)
	
	FLAGNO = 1;
	FLAGVALUE = 0;

	domain = zeros(domain_size);
	domain_width = domain_size(1);
	domain_length = domain_size(2);
	
	%Draw particles on domain using their position
	for i = 1 : input_size
		if (input_flags(i, FLAGNO) == FLAGVALUE)
			if (input_position(i, 1) < domain_width && input_position(i, 1) > 0 && input_position(i, 2) < domain_length && input_position(i, 2) > 0)
				domain(ceil(input_position(i, 1)), ceil(input_position(i, 2))) = 1;
			end
		end
	end

	output_domain = domain;
end