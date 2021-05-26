function [x,y] = convert_3D_points_to_2D(K,R,t,u,v,w)
%covert_3D_points_to_2D project 3d points to 2d image plane
lambdap = K * [R t] * [u; v; w; 1];
p = lambdap/lambdap(3,1);
x = p(1,1);
y = p(2,1);
end

