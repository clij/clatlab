% addImages.m
%
% This script demonstrates basic image math  on the GPU in MATLAB.
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
image_dimensions = size(img)

ramp = 1:image_dimensions(1)
mat = ramp' * ramp ./ 100


% push image to GPU memory
input1 = clijx.pushMat(img);
input2 = clijx.pushMat(mat);

% reserve memory for output image
sum_image = clijx.create(input1);

% add images os GPU
clijx.addImages(input1, input2, sum_image);

% pull result image back
result = clijx.pullMat(sum_image);
imshow(result, [0 255]);

% clean up
input1.close();
input2.close();
sum_image.close();



