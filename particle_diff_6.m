%PLEASE SUBMIT MODIFICATIONS AND IMPROVEMENTS!

%File: particle_diff_6.m (MATLAB)
%Version: 0.0
%Author: Stewart Nash
%Date: March 1, 2015
%Description: 2-Dimensional simulation of non-interacting particles originating in region with constant velocity. A reflecting boundary is present. A deflecting ring is present in the center.

%Note: Particle index means a consecutive list of integers starting with 1.

%>>>>Conversion Factors<<<<%
%_degree - Degree conversion factor
%_radian - Radian conversion factor

cf_degree = 360;
cf_radian = 2 * 3.14159265359; 
cf_nanosecond = 1;
cf_micrometer = 1;

%>>>>Configuration<<<<%

s_FRAMERATE = 3;
s_FLAGNUMBER = 1;

%>>>>Flags<<<<%

f_withinring = 1;

%>>>>Constants<<<<%
%DEGREES - Degree conversion factor
%RADIANS - Radian conversion factor

%MAX_PARTICLES - Maximum number of particles
%GRID_SIZE - Grid size for square grid
%TERMINAL_SPEED - Maximum particle speed
%TIME_STEPS - Number of time steps to run
%TIME_INCREMENT  - Number of time steps per frame (to advance particle position)
%DIMENSION - Dimension of space
%RING_RADIUS - Radius of central ring

C_PI =  3.14159265358979323846264338327950288419716939937510582;
DEGREES = 360;
RADIANS = 2 * C_PI;

MAX_PARTICLES = 50;
GRID_SIZE = 400;
TERMINAL_SPEED = 4;
%TERMINAL_SPEED = 0.482 * _micrometer / _nanosecond;
TIME_STEPS = 3000;
TIME_INCREMENT  = 1;
DIMENSION = 2;
RING_RADIUS = 100;

%Create video file and main figure window.
aviobj = avifile('example_06.avi', 'compression', 'None');
main_figure = figure;

%Create a random number of particles and set size of grid (a 2-by-2 square matrix).
particlenumber = ceil(MAX_PARTICLES * rand);
domainsize = [GRID_SIZE GRID_SIZE];

%>>>>Variables<<<<%
%domain - Grid
%domain_2 - Grid which will be displayed, a copy of 'domain'
%particleflags - flags for particles indexed by particle number; flag description given by flag name
%particleposition - position of particles indexed by particle number
%particleangle - angle of particles velocity vector which is indexed by particle number
%particlespeed - speed of particles (magnitude of velocity vector) which is indexed by particle number
%particlevelocity - velocity of particles indexed by particle number

%Allocate variables.
domain = zeros(domainsize);
domain_mask = domain;
domain_2 = domain;
particleflags = zeros(particlenumber, s_FLAGNUMBER);
particleposition = zeros(particlenumber, DIMENSION);
particleangle = zeros(particlenumber, 1);
particlespeed = zeros(particlenumber, 1);
particlevelocity = zeros(particlenumber, DIMENSION);

%Initialize variables to random values.
particleposition = (ceil(rand(particlenumber, DIMENSION) .* GRID_SIZE));
%Set flags
%The f_withingring flag is set if the particle is within the radius of the ring from the center point
for i = 1 : particlenumber
	if (sqrt((particleposition(i, 1) - domainsize(1) / 2)^2 + (particleposition(i, 2) - domainsize(2) / 2)^2) < RING_RADIUS)
		particleflags(i, f_withinring) = 1;
	end
end
particlespeed = (rand(particlenumber, 1) .* TERMINAL_SPEED);
particleangle = (rand(particlenumber, 1) .* RADIANS);

%Update velocity vector and note location of particles in domain.
particlevelocity = updatevelocityring(particlespeed, particleangle, particlenumber, particleflags);
domain = updatedomainring(particleposition, particlenumber, domainsize, particleflags);
domain_mask = updatemask(domainsize, RING_RADIUS);
%'domain_2' will have a visually expanded particle size.
domain_2 = enlarge(domain, domainsize);
domain_2 = enlarge(domain_2, domainsize);
domain_2 = or(domain_2, domain_mask);
%Display image and save to video file.
imshow(domain_2)
aviobj = addframe(aviobj, main_figure);

%Iterate the previous process through a number of time steps.
for i = 1 : TIME_STEPS
	[particleposition, particleangle] = updatepositioncirc(particleflags, particlespeed, particleangle, particleposition, TIME_INCREMENT, particlenumber, RING_RADIUS, domainsize);
	%Update velocity as the particle angle may have been changed.
	particlevelocity = updatevelocityring(particlespeed, particleangle, particlenumber, particleflags);
    domain = updatedomainring(particleposition, particlenumber, domainsize, particleflags);
    domain_2 = enlarge(domain, domainsize);
    domain_2 = enlarge(domain_2, domainsize);
	domain_2 = or(domain_2, domain_mask);
    if (mod(i, s_FRAMERATE) == 0)
    	imshow(domain_2)
    	aviobj = addframe(aviobj, main_figure);
    end
end

%Close video file.
aviobj = close(aviobj);
