% blur.m
%
% This script shows how to run CLATLAB for GPU accelerated image processing
% from MATLAB. It applies blurring to an image.
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

% push image to GPU memory
input = clij2.pushMat(img);
% reserve memory for output image
blurred = clij2.create(input);

% blur the image
clij2.gaussianBlur(input, blurred, 5, 5, 0);


% pull result back from GPU and show it next to input
result = clij2.pullMat(blurred);
subplot(1,2,2), imshow(result, [0, 255]);

% clean up
clij2.clear();

