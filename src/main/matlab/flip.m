% flip.m
%
% This script shows how flip an image on the GPU.
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

figure;
subplot(1,2,1), imshow(img, [0, 255]);

% check on which GPU it's running 
string(clx.getGPUName())

% push image to GPU memory
input = clx.push(img);
% reserve memory for output image
output = clx.create(input);

import java.lang.Boolean;

% paste the image a couple of times
clx.op.flip(input, output, Boolean(true), Boolean(false), Boolean(false));

% pull result back from GPU and show it next to input
result = clx.pull(output);
subplot(1,2,2), imshow(result, [0, 255]);

% clean up
input.close();
output.close();
