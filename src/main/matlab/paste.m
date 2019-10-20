% paste.m
%
% This script shows how paste one image into another on the GPU.
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
result = clx.create([2048, 2048]);

import java.lang.Float;
import java.lang.Integer;
clx.op.set(result, Float(0));

% paste the image a couple of times
clx.op.paste(input, result, Integer(100), Integer(100));
clx.op.paste(input, result, Integer(1000), Integer(1000));
clx.op.paste(input, result, Integer(0), Integer(300));

% pull result back from GPU and show it next to input
output = clx.pull(result);
imshow(output, [0, 255]);

% clean up
input.close();
result.close();

