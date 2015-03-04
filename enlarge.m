%PLEASE SUBMIT MODIFICATIONS AND IMPROVEMENTS!

%File: enlarge.m (MATLAB)
%Version: 0.1
%Author: Stewart Nash
%Date: February 27, 2015
%Description: Increases visual size of particle on grid by turning on adjacent and diagonal pixels

%Note: Particle index means a consecutive list of integers starting with 1.

%>>>>Input Parameters<<<<%
%input_domain - grid
%domain_size - dimensions of grid

%>>>>Variables<<<<%
%domain_width - number of columns of input grid
%domain_length - number of rows of input grid

function output_domain = enlarge(input_domain, domain_size)
	domain_width = domain_size(1);
	domain_length = domain_size(2);
    domain = input_domain;
    domain_2 = domain;
    for i = 1 : domain_width
        for j = 1 : domain_length
            if (i == 1)
                if (j == 1)
                    if (domain(i+1, j) || domain(i, j+1))
                        domain_2(i, j) = 1;
                    end
					if (domain(i+1, j+1))
						domain_2(i, j) = 1;
					end					
                end
                if (j > 1 && j < domain_length)
                    if (domain(i+1, j) || domain(i, j+1) || domain(i, j-1))
                        domain_2(i, j) = 1;
                    end
					if (domain(i+1, j-1) || domain(i+1, j+1))
						domain_2(i, j) = 1;
					end					
                end
                if (j == domain_length)
                    if (domain(i+1, j) || domain(i, j - 1))
                        domain_2(i,j) = 1;
                    end
					if (domain(i+1, j-1))
						domain_2(i, j) = 1;
					end					
                end
            end
            if (i > 1 && i < domain_width)         
                if (j == 1)
                    if (domain(i+1, j) || domain(i-1,j) || domain(i,j + 1))
                        domain_2(i, j) = 1;
                    end
					if (domain(i-1, j+1) || domain(i+1, j+1))
						domain_2(i, j) = 1;
					end
                end
                if (j > 1 && j < domain_length)
                    if (domain(i+1, j) || domain(i-1, j) || domain(i,j+1) || domain(i, j-1))
                        domain_2(i, j) = 1;
                    end
					if (domain(i-1, j-1) || domain(i+1, j-1) || domain(i-1, j+1) || domain(i+1, j+1))
						domain_2(i, j) = 1;
					end					
                end
                if (j == domain_length)
                    if (domain(i+1, j) || domain(i-1,j) || domain(i, j - 1))
                        domain_2(i,j) = 1;
                    end
					if (domain(i-1, j-1) || domain(i+1, j-1))
						domain_2(i, j) = 1;
					end					
                end            
            end
            if (i == domain_width)
                 if (j == 1)
                    if (domain(i-1,j) || domain(i,j + 1))
                        domain_2(i,j) = 1;
                    end
					if (domain(i-1, j+1))
						domain_2(i, j) = 1;
					end					
                end
                if (j > 1 && j < domain_length)
                    if (domain(i-1,j) || domain(i,j + 1) || domain(i, j - 1))
                        domain_2(i,j) = 1;
                    end
					if (domain(i-1, j-1) || domain(i-1, j+1))
						domain_2(i, j) = 1;
					end					
                end
                if (j == domain_length)
                    if (domain(i-1,j) || domain(i, j - 1))
                        domain_2(i,j) = 1;
                    end
					if (domain(i-1, j-1))
						domain_2(i, j) = 1;
					end					
                end             
            end      
        end
    end

    output_domain = domain_2;
end