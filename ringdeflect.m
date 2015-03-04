%PLEASE SUBMIT MODIFICATIONS AND IMPROVEMENTS!

%File: ringdeflect.m (MATLAB)
%Version: 0.0
%Author: Stewart Nash
%Date: February 28, 2015
%Description: Function deflects particles which have gone inside or outside of ring.

function [output_position_x, output_position_y, output_angle] = ringdeflect(input_position_x, input_position_y, input_angle, input_radius, input_center_x, input_center_y)

%>>>>Constants<<<<%

    C_PI =  3.14159265358979323846264338327950288419716939937510582;
    DEFLECTION_ERROR = 0; %0.0000000000000000001;

%>>>>Variables<<<<%    
    
	slope = tan(input_angle);
	intercept = input_position_y - slope * input_position_x;
	b = intercept;
	m = slope;
	cx = input_center_x;
	cy = input_center_y;
	r = input_radius;
	x1 = input_position_x;
	y1 = input_position_y;
	angle_i = input_angle;
	
	%The point on the circumference of the ring or circle at which the particle entered or exited is found by the simultaneous solution of the equation of the ring and the line along which the particle travels.
	a1 = m^2 + 1;
	b1 = 2 * ( m * b - m * cy - cx);
	c1 = cx^2 + (b - cy)^2 - r^2;
	%Quadratic formula
	x2 = (-b1 + sqrt(b1^2 - 4 * a1 * c1)) / (2 * a1);
	x3 = (-b1 - sqrt(b1^2 - 4 * a1 * c1)) / (2 * a1);
	y2 = m * x2 + b;
	y3 = m * x3 + b;
	
	d2 = sqrt((x1 - x2)^2 + (y1 - y2)^2);
	d3 = sqrt((x1 - x3)^2 + (y1 - y3)^2);
	
	%The point on the ring circumference which is closer is the correct point.	
	if (d2 < d3)
		x0 = x2;
		y0 = y2;
		d = d2;
	else
		x0 = x3;
		y0 = y3;
		d = d3;
    end
    d = d + DEFLECTION_ERROR;
	
	%The angle of reflection is symmetric with the angle of incidence across the tangent to the circle at the reflection point.	
	%Find the angle of the normal which is directed from the center to the circumference.
	%Unfortunately, MATLAB restricts inverse tangent from -90 degrees to 90 degrees
	dy0 = y0 - cy;
	dx0 = x0 - cx;
	m0 = dy0 / dx0;
	if (dy0 >= 0 && dx0 >= 0) %Quadrant I in Cartesian space
		angle_n = atan(m0);
	elseif (dy0 >= 0 && dx0 <= 0) %Quadrant II in Cartesian space
		angle_n = atan(m0) + C_PI;
	elseif (dy0 <= 0 && dx0 <= 0) %Quadrant III in Cartesian space
		angle_n = atan(m0) + C_PI;
	elseif (dy0 <= 0 & dx0 >= 0) %Quadrant IV in Cartesian space
		angle_n = atan(m0) + 2 * C_PI;
	else
		fprintf('ERROR (ringdeflect.m): Error in slope-angle conversion of normal. Results may not be accurate.\n');
		angle_n = atan(m0);   
	end
	
	%The tangent is 90 degrees ahead of the normal.
	angle_t = angle_n + C_PI / 2;
	
	%Angles should be between zero and two times pi
%	while (angle_t < 0)
%		angle_t = angle_t + 2 * C_PI;
%	end
	while (angle_t > 2 * C_PI)
		angle_t = angle_t - 2 * C_PI;
    end		

	%The reflection will differ by quadrant.
	if (angle_n >= 0 && angle_n <= C_PI / 2) %Quadrant I
		if (angle_i >= angle_t && angle_i <= angle_t + C_PI / 2)
			angle_r = 2 * angle_t - angle_i;
		elseif (angle_i >= angle_t + C_PI / 2 && angle_i <= angle_t + C_PI)
			angle_r = 2 * angle_t + 2 * C_PI - angle_i;
			while (angle_r > 2 * C_PI)
				angle_r = angle_r - 2 * C_PI;
			end	
		else
			fprintf('ERROR (ringdeflect.m): Error computing deflection angle. Incident angle is out of range. Results may not be accurate.\n')
			angle_r = 2 * angle_t - angle_i;		
		end
	elseif (angle_n >= C_PI / 2 && angle_n <= C_PI) %Quadrant II
		if (angle_i >= angle_t && angle_i <= angle_t + C_PI / 2)
			angle_r = 2 * angle_t - angle_i;
		elseif (angle_i >= 0 && angle_i <= angle_t - C_PI)
			angle_r = 2 * angle_t - 2 * C_PI - angle_i;
		elseif (angle_i >= angle_t + C_PI / 2 && angle_i <= 2 * C_PI)
			angle_r = 2 * angle_t - angle_i;			
		else
			fprintf('ERROR (ringdeflect.m): Error computing deflection angle. Incident angle is out of range. Results may not be accurate.\n')
			angle_r = 2 * angle_t - angle_i;		
		end		
	elseif(angle_n >= C_PI && angle_n <= 3 * C_PI / 2) %Quadrant III
		if (angle_i >= angle_t - 3 * C_PI / 2 && angle_i <= angle_t - C_PI)
			angle_r = 2 * angle_t - 2 * C_PI - angle_i;
		elseif (angle_i >= 0 && angle_i <= angle_t - 3 * C_PI / 2)
			angle_r = 2 * angle_t - 2 * C_PI - angle_i;
		elseif (angle_i >= angle_t && angle_i <= 2 * C_PI)
			angle_r = 2 * angle_t - angle_i;			
		else
			fprintf('ERROR (ringdeflect.m): Error computing deflection angle. Incident angle is out of range. Results may not be accurate.\n')
			angle_r = 2 * angle_t - angle_i;		
		end		
	elseif(angle_n >= 3 * C_PI / 2 && angle_n <= 2 * C_PI) %Quadrant IV
		if (angle_i >= angle_t && angle_i <= angle_t + C_PI / 2)
			angle_r = 2 * angle_t - angle_i;
			while (angle_r < 0)
				angle_r = angle_r + 2 * C_PI;
			end		            
		elseif (angle_i >= angle_t + C_PI / 2 && angle_i <= angle_t + C_PI)
			angle_r = 2 * angle_t + 2 * C_PI - angle_i;
			while (angle_r > 2 * C_PI)
				angle_r = angle_r - 2 * C_PI;
			end				
		else
			fprintf('ERROR (ringdeflect.m): Error computing deflection angle. Incident angle is out of range. Results may not be accurate.\n')
			angle_r = 2 * angle_t - angle_i;		
		end	
	else
		fprintf('ERROR (ringdeflect.m): Error computing deflection angle. Normal angle is out of range. Results may not be accurate.\n')
		angle_r = 2 * angle_t - angle_i;
	end
	
%	if (input_angle >= angle_t && input_angle <= angle_t + C_PI / 2)
%		angle_r = 2 * angle_t - input_angle;
%	elseif(input_angle >= 0 && input_angle <= angle_t - C_PI)
%		angle_r = 2 * angle_t - C_PI - input_angle;
%	elseif(input_angle >= angle_t + C_PI / 2 && input_angle <= 2 * C_PI)
%		angle_r = 2 * angle_t - C_PI - input_angle;
%	else
%		fprintf('ERROR (ringdeflect.m): Error in input angle. Results may be inaccurate.\n');
%		angle_r = 2 * angle_t - input_angle;
%	end
	
	%Project from the point on the ring circumference the distance that the particle has travelled in or out at the angle of reflection
	x = x0 + d * cos(angle_r);
	y = y0 + d * sin(angle_r);
	
    %Error will be introduced for some particles within the circle; because of approximation errors, they have an imaginary component. This component is discarded.
%	output_position_x = real(x);
%	output_position_y = real(y);
%	output_angle = real(angle);
    output_position_x = x;
	output_position_y = y;
	output_angle = angle_r;
    
    if angle_r < 0
        fprintf('ERROR (ringdeflect.m): Error in output angle. Angle less than zero.\n');
    end
	
end