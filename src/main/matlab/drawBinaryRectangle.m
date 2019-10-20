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
clx = init_clatlab();

% check on which GPU it's running 
string(clx.getGPUName())

% reserve memory for output image
binary_img = clx.create([100 100]);

% blur the image
import java.lang.Float;
clx.op.set(binary_img, Float(0));

% draw a rectangle
clx.op.drawBox(binary_img, Float(10), Float(15), Float(20), Float(30));

% pull result back from GPU and show it next to input
result = clx.pull(binary_img);
imshow(result, [0 1]);

% clean up
binary_img.close();

