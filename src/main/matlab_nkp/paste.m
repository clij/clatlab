% paste.m
%
% This script shows how paste one image into another on the GPU.
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

% check on which GPU it's running 
string(clijx.getGPUName())

% push image to GPU memory
input = clijx.pushMat(img);
% reserve memory for output image
result = clijx.create([2048, 2048]);

clijx.set(result, 0);

% paste the image a couple of times
clijx.paste(input, result, 100, 100);
clijx.paste(input, result, 1000, 1000);
clijx.paste(input, result, 0, 300);

% pull result back from GPU and show it next to input
output = clijx.pullMat(result);
imshow(output, [0, 255]);

% clean up
input.close();
result.close();

