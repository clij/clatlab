% crop.m
%
% This script shows how crop an image on the GPU.
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

% check on which GPU it's running 
string(clx.getGPUName())

% push image to GPU memory
input = clx.push(img);
% reserve memory for output image
output = clx.create([50, 50]);

import java.lang.Integer;

% paste the image a couple of times
clx.op.crop(input, output, Integer(20), Integer(20));

% pull result back from GPU and show it next to input
result = clx.pull(output);
imshow(result, [0, 255]);

% clean up
input.close();
output.close();

