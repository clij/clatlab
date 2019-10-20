% outline.m
%
% This script shows how to get the outline of a binary image on the GPU.
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
thresholded = clx.create(input);
outline_img = clx.create(input);

% blur the image
import java.lang.Float;
clx.op.blur(input, blurred, Float(5), Float(5));

% apply a threshold to it
clx.op.automaticThreshold(blurred, thresholded, "Otsu");

% get the outline
clx.op.binaryEdgeDetection(thresholded, outline_img);

% pull result back from GPU and show it next to input
result = clx.pull(outline_img);
subplot(1,2,2), imshow(result, [0 1]);

% clean up
input.close();
blurred.close();
thresholded.close();

