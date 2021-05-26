function [coeffs, x1,y1,z1] = ransac_procedure(M,N,points,threshold)
%%Input required
%M: number of points in points.txt from COLMAP
%N: number of iterations we need to run
%points: Array of points in points.txt
%threshold: a threshold value for checking inliers
%
%
%%output
%coeffs: coefficients a,b,c,d of equation ax+by+cz+d = 0
%x1: x co-ordinates of inliers
%y1: y co-ordinates of inliers
%z1: z co-ordinates of inliers

global_inlier_count = 0;
global_inlier_idx = zeros(1,M);

for i = 1:1:N
    rand_idx1 = randi(M);
    rand_idx2 = randi(M);
    rand_idx3 = randi(M);
    %Select 3 random points to create a plane
    p1 = points(rand_idx1,:);
    p2 = points(rand_idx2,:);
    p3 = points(rand_idx3,:);
    points_arr = [p1;p2;p3];
    %Fit a plane to the points
    coeff = get_plane_coefficients_for_fitting(points_arr(:,1),points_arr(:,2),points_arr(:,3));
    unit_normal_vec = [coeff(1) coeff(2) coeff(3)]/sqrt((coeff(1)^2)+(coeff(2)^2)+(coeff(3)^2));
    inliers = 0;
    inlier_idx = zeros(1,M);
    for j = 1:1:M
        point = points(j,:);
        plane_to_point_vec = p1-point;
        dist = abs(dot(plane_to_point_vec,unit_normal_vec));
        if(dist<threshold)
            inliers = inliers+1;
            inlier_idx(1,j) = 1;
        end
    end
    %inliers
    if(inliers>global_inlier_count)
        global_inlier_count = inliers;
        global_inlier_idx = inlier_idx;
    end
end
%Fit 3D plane to the points using fit
coeffs = get_plane_coefficients_for_fitting(points(:,1), points(:,2), points(:,3));

x1 = zeros(global_inlier_count,1);
y1 = zeros(global_inlier_count,1);
z1 = zeros(global_inlier_count,1);
x2 = zeros(M-global_inlier_count,1);
y2 = zeros(M-global_inlier_count,1);
z2 = zeros(M-global_inlier_count,1);
c1 = 1;
c2 = 1;
for i=1:1:M
    if global_inlier_idx(1,i) == 1
        x1(c1,1) = points(i,1);
        y1(c1,1) = points(i,2);
        z1(c1,1) = points(i,3);
        c1 = c1+1;
    else
        x2(c2,1) = points(i,1);
        y2(c2,1) = points(i,2);
        z2(c2,1) = points(i,3);
        c2 = c2+1;
    end
end

figure(1)
scatter3(x1, y1, z1, 'r', '+')
hold on
scatter3(x2, y2, z2, 'b', '.')

[x3, y3] = meshgrid(-5:0.1:5); % Generate x and y data
z3 = -1/coeffs(1,3)*(coeffs(1,1)*x3 + coeffs(1,2)*y3 + coeffs(1,4)); % Solve for z data
surf(x3, y3, z3) %Plot the surface

%[x3 y3] = meshgrid(-5:0.1:5); % Generate x and y data
%z3 = zeros(size(x3,1)); % Solve for z data
%surf(x3, y3, z3, 'FaceColor', 'g') %Plot the surface

hold off
grid on
legend('inliers', 'outliers');