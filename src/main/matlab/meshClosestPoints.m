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
clx = init_clatlab();

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
string(clx.getGPUName())

% push image to GPU
input = clx.push(img);

% blur a bit and detect maxima
import java.lang.Float;
blurred = clx.create(input);
detected_spots = clx.create(input);

clx.op.blur(input, blurred, Float(15), Float(15), Float(0));

string(blurred)

import java.lang.Integer;
clx.op.detectMaximaBox(blurred, detected_spots, Integer(10));

figure;
imshow(clx.pull(detected_spots), [0 1]);

% convert spots image to spot list
number_of_spots = clx.op.sumPixels(detected_spots);
pointlist = clx.create([number_of_spots, 2]);
clx.op.spotsToPointList(detected_spots, pointlist);

distance_matrix = clx.create([number_of_spots, number_of_spots]);
clx.op.generateDistanceMatrix(pointlist, pointlist, distance_matrix);

n_closest_points = 5;
closestPointsIndices = clx.create([number_of_spots, n_closest_points]);

clx.op.nClosestPoints(distance_matrix, closestPointsIndices);

pointCoodinates = clx.pull(pointlist);
pointIndices = clx.pull(closestPointsIndices);

mesh = clx.create(input);

pointDims = size(pointIndices)

for p = [1:pointDims(1)]
	x1 = pointCoodinates(p, 1);
	y1 = pointCoodinates(p, 2);

	for q = [1, n_closest_points]
		pointIndex = pointIndices(p, q) + 1
		x2 = pointCoodinates(pointIndex, 1);
		y2 = pointCoodinates(pointIndex, 2);

		thickness = 2;
		clx.op.drawLine(mesh, Float(x1), Float(y1), Float(0), Float(x2), Float(y2), Float(0), Float(thickness));
    end
end

% show result
figure;
imshow(clx.pull(mesh), [0, 1]);

mesh.close();
pointlist.close();
closestPointsIndices.close();
detected_spots.close();
blurred.close();
input.close();


