% simplePipeline.m
%
% This script shows how to run CLATLAB for GPU accelerated image processing from MATLAB.
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
subplot(1,2,1), imshow(img, [0 255]);

% check on which GPU it's running 
string(clijx.getGPUName())

% push image to GPU memory
input = clijx.pushMat(img);
% reserve memory for output image
output = clijx.create(input);

% blur the image
clijx.blur(input, output, 5, 5);

% pull result back from GPU
result = clijx.pullMat(output);

% show result
subplot(1,2,2), imshow(result, [0 255]);

% clean up
input.close();
output.close();

