function plane_coefficients = get_plane_coefficients_for_fitting(x,y,z)
%get_plane_coefficients_for_fitting This function fits a plane to the points
%   INPUT
%   x : x co-ordinates of all points
%   y : y co-ordinates of all points
%   z : z co-ordinates of all points
%   OUTPUT
%   plane_coefficients the plane coeefeicients [a,b,c,d] in the form ax+by+cz+d = 0
plane_coefficients = zeros(1,4);
design_matrix = [x y ones(size(z))];
coeffs = design_matrix\z;
plane_coefficients(1,1) = coeffs(1);
plane_coefficients(1,2) = coeffs(2);
plane_coefficients(1,3) = -1;
plane_coefficients(1,4) = coeffs(3);
end

