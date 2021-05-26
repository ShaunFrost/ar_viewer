T = readtable('points3D.csv');
points = table2array(T(:,2:4));
M = size(points,1);
N = 200;%No. of iterations
threshold = 0.05;
[coeffs, x, y, z] = ransac_procedure(M, N, points, threshold); %get inliers, plane coefficients from RANSAC

a = coeffs(1);
b = coeffs(2);
c = coeffs(3);
d = coeffs(4);
rectangle_original_plane = plane_align(a, b, c, d, x, y, z); %get the cube co-ordinates on original plane

project_cube_on_image(x,y,z,rectangle_original_plane);