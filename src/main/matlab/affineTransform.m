% affineTransform.m
%
% This script demonstrates how to apply an affine transform to an image 
% on the GPU in MATLAB.
%
% In order to make this script run, you need to install CLATLAB an
% run it from matlab. Tested with Matlab 2019b
%         https://clij.github.io/clatlab/
%
% Author: Robert Haase, rhaase@mpi-cbg.de
%         October 2019
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

% push image to GPU memory
input = clijx.pushMat(img);

% reserve memory for output image
transformed = clijx.create(input);

% define transform
import net.imglib2.realtransform.AffineTransform2D;
import java.lang.Math;

at = AffineTransform2D();
at.translate([-input.getWidth() / 2, -input.getHeight() / 2]);
at.rotate(45.0 / 180.0 * Math.PI);
at.scale(0.5);
at.translate([input.getWidth() / 2, input.getHeight() / 2]);

% transform image os GPU
clijx.affineTransform2D(input, transformed, at);

% pull result image back
result = clijx.pullMat(transformed);
imshow(result, [0 255]);

% clean up
input.close();
transformed.close();



