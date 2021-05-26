# Augmented Reality Viewer
An AR viewer that displays artificial objects overlaid on images of a real 3D scene using point cloud generated by COLMAP.


Check the example_result.jpg to see how the resulting cube is placed on the scene.

COLMAP generated files:
-----------------------
images.txt -> details about the images taken at various angles at the scene
cameras.txt -> details about the cameras that were used to capture the scene images
points3D.txt -> details of the 3D points created by COLMAP

Directions:

Run the starter.m file to view the 3D cube object projected onto the scene images.

Main matlab files:
------------------
1> starter.m -> Program to run the full process of creating the augmented reality viewer.
2> ransac_procedure.m -> Function that implements RANSAC on the 3d points generated from COLMAP to find the inliers.
3> plane_align.m -> Function that performs the rotation and translation of the original plane to z=0. Also places the cube in the original scene co-ordinates.
4> project_cube_on_image.m -> Function that projects the cube on each image by converting to 2d co-ordinates.
5> convert_3D_points_to_2D.m-> Function that uses the extrinsic and intrinsic parameters to get 2D co-ordinates out of the world 3D co-ordinates.
6> get_all_2D_points.m -> Function that uses convert_3D_points_to_2D function recursively for each point.
