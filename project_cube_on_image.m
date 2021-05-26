function[] = project_cube_on_image(wc_x,wc_y,wc_z,rectangle_original_plane)

cameras = load('cameras.mat');
images = load('images.mat');

phi_x = str2double(cameras.f);
phi_y = str2double(cameras.f);
gamma = str2double(cameras.k);
delta_x = str2double(cameras.x);
delta_y = str2double(cameras.y);

K = [   
        phi_x   gamma   delta_x;
        0       phi_y   delta_y;
        0       0       1
    ];

num_of_images = size(images.qw,2);

for i = 1:1:num_of_images-32
    image_name = strcat('./all_images/',images.images(i,1:23));
    image = imread(image_name);
    quat = [images.qw(i) images.qx(i) images.qy(i) images.qz(i)];
    R = quat2rotm(quat);
    t = [images.tx(i); images.ty(i); images.tz(i)];
    [x_2D, y_2D] = get_all_2D_points(wc_x,wc_y,wc_z,K,R,t);
    
    [x_cube, y_cube] = get_all_2D_points(rectangle_original_plane(:,1),rectangle_original_plane(:,2),rectangle_original_plane(:,3),K,R,t);
    figure(i);
    imshow(image);
    axis on
    hold on;
    scatter(x_2D,y_2D,'b', '+');
    %scatter(x_cube,y_cube,'g', 'o');
    fill(x_cube(1:4,:),y_cube(1:4,:),'r','FaceAlpha', 1);
    fill(x_cube([2 6 7 3],:),y_cube([2 6 7 3],:),'r','FaceAlpha', 0.2);
    fill(x_cube([2 6 5 1],:),y_cube([2 6 5 1],:),'r','FaceAlpha', 0.2);
    fill(x_cube([3 7 8 4],:),y_cube([3 7 8 4],:),'r','FaceAlpha', 0.2);
    fill(x_cube([3 7 6 2],:),y_cube([3 7 6 2],:),'r','FaceAlpha', 0.2);
    fill(x_cube(5:8,:),y_cube(5:8,:),'r','FaceAlpha', 0.4);   
    hold off;
end