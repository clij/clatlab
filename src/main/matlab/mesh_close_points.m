% statistics.m
%
% This script shows how to get pixel statistics from an image
% and from selected pixels.
%
%
% In order to make this script run, you need to install CLATLAB an
% run it from matlab. Tested with Matlab 2019b
%         https://clij.github.io/clatlab/
%
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

% initialize CLATLAB
clij2 = init_clatlab();
clij2.clear();

% load example data
filename = '../../test/resources/blobs.tif';
img = imread(filename);
% there are issues with unit8/int8 conversion; 
% thus, we convert the image to double
img = double(img);

% show input image in a subplot
figure;
subplot(1,2,1), imshow(img, [0 255]);

% check on which GPU it's running 
string(clij2.getGPUName())

% push image to GPU
input = clij2.pushMat(img);

% blur a bit and detect maxima
blurred = clij2.create(input);
detected_spots = clij2.create(input);
clij2.blur(input, blurred, 5, 5, 0);

% spot detection
clij2.detectMaximaBox(blurred, detected_spots, 10);

% draw a Voronoi diagram
voronoi_image = clij2.create(input);
clij2.voronoiOctagon(detected_spots, voronoi_image);

figure;
imshow(clij2.pullMat(voronoi_image), [0 1]);

% invert the Voronoi diagram, label the objects and extend them so that
% they touch
inverted_voronoi_image = clij2.create(input);
clij2.binaryNot(voronoi_image, inverted_voronoi_image);

cca = clij2.create(input);
clij2.connectedComponentsLabelingDiamond(inverted_voronoi_image, cca);

cca_extended  = clij2.create(input);
clij2.maximum2DBox(cca, cca_extended, 1, 1);

% generate a touch matrix
number_of_objects = clij2.sumOfAllPixels(detected_spots);

%                                           + 1 because background counts 
touch_matrix = clij2.create(number_of_objects + 1, number_of_objects + 1);
clij2.generateTouchMatrix(cca_extended, touch_matrix);

% show touch matrix
figure;
imshow(clij2.pullMat(touch_matrix), [0, 1]);

% draw a mesh connecting touching neighbors
pointlist = clij2.create(number_of_objects, 2);
clij2.spotsToPointList(detected_spots, pointlist);

mesh = clij2.create(input);
clij2.set(mesh, 0);
clij2.touchMatrixToMesh(pointlist, touch_matrix, mesh);

figure;
imshow(clij2.pullMat(mesh), [0, 1]);

% clean up by the end
clij2.clear();


