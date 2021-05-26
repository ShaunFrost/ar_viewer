function [rectangle_original_plane] = plane_align(a, b, c, d, x1, y1, z1)
%plane_align align the inliers fitted plane to z=0. Create a cube and
%project to the original scene plane

%% Translate to eliminate d
%(x1, y1, z1) -> (x1, y1, z1 - d/c) to get ax + by + cz = 0
z1_translated = z1 + (d/c);

%% Rotate the plane to align as z=0
v = [-a; -b; -c];
v = v/norm(v);
k = [0; 0; 1];

ct = dot(v,k)/norm(v);
st = sqrt(1-(ct*ct)); 
u = cross(v,k);
u = u/norm(u);
u1 = u(1);
u2 = u(2);

rotation_matrix = [
    ct+u1*u1*(1-ct)     u1*u2*(1-ct)       u2*st;
    u1*u2*(1-ct)        ct+u2*u2*(1-ct)    -u1*st;
    -u2*st              u1*st              ct
];

points_rotated = rotation_matrix*[x1';y1';z1_translated'];

%% Shift the center of the rotated plane to origin
points_shifted_final = points_rotated;

for i = 1:size(points_rotated,2)
    points_shifted_final(1,i) = points_rotated(1,i) - ((min(points_rotated(1,:))+max(points_rotated(1,:)))/2);
    points_shifted_final(2,i) = points_rotated(2,i) - ((min(points_rotated(2,:))+max(points_rotated(2,:)))/2);
end

new_coeffs = get_plane_coefficients_for_fitting(points_rotated(1,:)', points_rotated(2,:)', points_rotated(3,:)');

%% Define the cube on z=0 plane
rectangle_points = [
        0.4,0.4,0;
        0.4,-0.4,0;
        -0.4,-0.4,0;
        -0.4,0.4,0;
        0.4,0.4,0.4;
        0.4,-0.4,0.4;
        -0.4,-0.4,0.4;
        -0.4,0.4,0.4
    ];
surface1 = transpose(rectangle_points(1:4,:));
surface2 = transpose(rectangle_points(5:8,:));
surface3 = transpose(rectangle_points([2 6 7 3],:));
surface4 = transpose(rectangle_points([2 6 5 1],:));
surface5 = transpose(rectangle_points([3 7 8 4],:));
surface6 = transpose(rectangle_points([3 7 6 2],:));


figure(1)

%% plot original inlier points
scatter3(x1, y1, z1, 'r', '+')

hold on

%% plot original outlier points
%scatter3(x2, y2, z2, 'b', '.')

%% plot the fitted plane to inliers
[x3 y3] = meshgrid(-5:0.1:5);
z3 = -1/c*(a*x3 + b*y3 + d);
surf(x3, y3, z3)

%% plot the inlier points after translation
%scatter3(x1, y1, z1_translated, 'b', '.');

%% plot the plane after translation
%[x3 y3] = meshgrid(-5:0.1:5); % Generate x and y data
%z3 = -1/c*(a*x3 + b*y3); % Solve for z data
%surf(x3, y3, z3) %Plot the surface

%% plot the plane z = 0 
[x3 y3] = meshgrid(-5:0.1:5); % Generate x and y data
z3 = zeros(size(x3,1)); % Solve for z data
surf(x3, y3, z3, 'FaceColor', 'g') %Plot the surface

%% plot the inlier points after rotation
scatter3(points_shifted_final(1,:)', points_shifted_final(2,:)', points_shifted_final(3,:)', 'b', '.');

%% plot the plane after rotation
%[x3 y3] = meshgrid(-5:0.1:5); % Generate x and y data
%z3 = -1/new_coeffs(1,3)*(new_coeffs(1,1)*x3 + new_coeffs(1,2)*y3 + new_coeffs(1,4)); % Solve for z data
%surf(x3, y3, z3, 'FaceColor', 'r') %Plot the surface

%% plot the 3D cube centered at origin
fill3(surface1(1,:),surface1(2,:),surface1(3,:),1,'FaceAlpha', 0.2);
fill3(surface2(1,:),surface2(2,:),surface2(3,:),2,'FaceAlpha', 0.2);
fill3(surface3(1,:),surface3(2,:),surface3(3,:),3,'FaceAlpha', 0.2);
fill3(surface4(1,:),surface4(2,:),surface4(3,:),4,'FaceAlpha', 0.2);
fill3(surface5(1,:),surface5(2,:),surface5(3,:),5,'FaceAlpha', 0.2);
fill3(surface6(1,:),surface6(2,:),surface6(3,:),6,'FaceAlpha', 0.2);

%% Rotate the cube to original plane
%New cube co-ordinates = R'*(old cube co-ordinates + centroid) - initial_translation
centroid_back_shift = rectangle_points;
for i = 1:size(rectangle_points,1)
    centroid_back_shift(i,1) = rectangle_points(i,1) + ((min(points_rotated(1,:))+max(points_rotated(1,:)))/2);
    centroid_back_shift(i,2) = rectangle_points(i,2) + ((min(points_rotated(2,:))+max(points_rotated(2,:)))/2);
end
back_rotated = transpose(rotation_matrix)*transpose(centroid_back_shift);
rectangle_original_plane = transpose([back_rotated(1,:); back_rotated(2,:); back_rotated(3,:)-(d/c)]);

%% Plot the 3D cube on the original plane
surface1 = transpose(rectangle_original_plane(1:4,:));
surface2 = transpose(rectangle_original_plane(5:8,:));
surface3 = transpose(rectangle_original_plane([2 6 7 3],:));
surface4 = transpose(rectangle_original_plane([2 6 5 1],:));
surface5 = transpose(rectangle_original_plane([3 7 8 4],:));
surface6 = transpose(rectangle_original_plane([3 7 6 2],:));
fill3(surface1(1,:),surface1(2,:),surface1(3,:),1,'FaceAlpha', 0.2);
fill3(surface2(1,:),surface2(2,:),surface2(3,:),2,'FaceAlpha', 0.2);
fill3(surface3(1,:),surface3(2,:),surface3(3,:),3,'FaceAlpha', 0.2);
fill3(surface4(1,:),surface4(2,:),surface4(3,:),4,'FaceAlpha', 0.2);
fill3(surface5(1,:),surface5(2,:),surface5(3,:),5,'FaceAlpha', 0.2);
fill3(surface6(1,:),surface6(2,:),surface6(3,:),6,'FaceAlpha', 0.2);

hold off
grid on