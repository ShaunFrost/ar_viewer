function [x_new, y_new] = get_all_2D_points(x,y,z,K,R,t)
%get_all_2D_points run 2d conversion on all points
x_new = zeros(size(x));
y_new = zeros(size(x));
for i = 1:1:size(x,1)
    [x_new(i,1), y_new(i,1)] = convert_3D_points_to_2D(K,R,t,x(i,1),y(i,1),z(i,1));
end
end
