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
clijx = init_clatlab();

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
string(clijx.getGPUName())

% push image to GPU
input = clijx.pushMat(img);

% blur a bit and detect maxima
blurred = clijx.create(input);
detected_spots = clijx.create(input);
clijx.blur(input, blurred, 15, 15, 0);

% spot detection
clijx.detectMaximaBox(blurred, detected_spots, 10);

figure;
imshow(clijx.pullMat(detected_spots), [0 1]);

% convert spots image to spot list
number_of_spots = clijx.sumPixels(detected_spots);
pointlist = clijx.create([number_of_spots, 2]);
clijx.spotsToPointList(detected_spots, pointlist);

distance_matrix = clijx.create([number_of_spots, number_of_spots]);
clijx.generateDistanceMatrix(pointlist, pointlist, distance_matrix);

n_closest_points = 5;
closestPointsIndices = clijx.create([number_of_spots, n_closest_points]);

clijx.nClosestPoints(distance_matrix, closestPointsIndices);

pointCoodinates = clijx.pullMat(pointlist);
pointIndices = clijx.pullMat(closestPointsIndices);

mesh = clijx.create(input);

pointDims = size(pointIndices)

for p = [1:pointDims(1)]
	x1 = pointCoodinates(p, 1);
	y1 = pointCoodinates(p, 2);

	for q = [1, n_closest_points]
		pointIndex = pointIndices(p, q) + 1
		x2 = pointCoodinates(pointIndex, 1);
		y2 = pointCoodinates(pointIndex, 2);

		thickness = 2;
		clijx.drawLine(mesh, x1, y1, 0, x2, y2, 0, thickness);
    end
end

% show result
figure;
imshow(clijx.pullMat(mesh), [0, 1]);

mesh.close();
pointlist.close();
closestPointsIndices.close();
detected_spots.close();
blurred.close();
input.close();


