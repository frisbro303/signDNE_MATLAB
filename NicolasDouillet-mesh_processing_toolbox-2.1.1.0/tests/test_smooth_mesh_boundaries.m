% Test smooth_mesh_boundaries_and_holes

clear all;

addpath('../src');
addpath('../data');


% load('kitten_big_hole.mat');
load('kitten_components.mat');

show_mesh_boundaries_and_holes(V,T);
shading interp;
camlight left;
alpha(0.5);
view(180,0);
axis off;

boundaries = detect_mesh_boundaries_and_holes(T);

nb_iterations = 2;
ngb_degre = 6;
V_out = smooth_mesh_boundaries_and_holes(V,boundaries,nb_iterations,ngb_degre);

show_mesh_boundaries_and_holes(V_out,T);
shading interp;
camlight left;
alpha(0.5);
view(180,0);
axis off;