% outline.m
%
% This script shows how to get the outline of a binary image on the GPU.
%
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

% show input image in a subplot
figure;
subplot(1,2,1), imshow(img, [0 255]);

% check on which GPU it's running 
string(clijx.getGPUName())

% push image to GPU memory
input = clijx.pushMat(img);
% reserve memory for output image
blurred = clijx.create(input);
thresholded = clijx.create(input);
outline_img = clijx.create(input);

% blur the image
clijx.blur(input, blurred, 5, 5);

% apply a threshold to it
clijx.automaticThreshold(blurred, thresholded, "Otsu");

% get the outline
clijx.binaryEdgeDetection(thresholded, outline_img);

% pull result back from GPU and show it next to input
result = clijx.pullMat(outline_img);
subplot(1,2,2), imshow(result, [0 1]);

% clean up
input.close();
blurred.close();
thresholded.close();

