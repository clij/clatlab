% drawBinaryRectangle.m
%
% This script shows how to draw a recangle in a binary image on the GPU.
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

% check on which GPU it's running 
string(clijx.getGPUName())

% reserve memory for output image
binary_img = clijx.create([100 100]);

% blur the image
clijx.set(binary_img, 0);

% draw a rectangle
clijx.drawBox(binary_img, 10, 15, 20, 30);

% pull result back from GPU and show it next to input
result = clijx.pullMat(binary_img);
imshow(result, [0 1]);

% clean up
binary_img.close();

