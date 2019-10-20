% meanFilter.m
%
% This script shows how to apply a mean filter to an image on the GPU.
%
% Author: Robert Haase, rhaase@mpi-cbg.de
%         October 2019
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

% push image to GPU memory
input = clx.push(img);
% reserve memory for output image
blurred = clx.create(input);

% blur the image
clx.op.meanBox(input, blurred, 5, 5, 0);

% pull result back from GPU and show it next to input
result = clx.pull(blurred);
subplot(1,2,2), imshow(result, [0, 255]);

% clean up
input.close();
blurred.close();

