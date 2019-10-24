% maximumProjection.m
%
% This script shows how to run CLATLAB for GPU accelerated image processing
% to draw a maximum projection and visualise it in MATLAB.
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
clop = clijx.op;

% check on which GPU it's running 
string(clijx.getGPUName())

% load example data
filename = '../../test/resources/Nantes_000646.tif';
info = imfinfo(filename);
numberOfImages = numel(info);
image = [];
for i = 1:numberOfImages
    plane = imread(filename,i);
    if i == 1
        image = plane;
    else 
        image = cat(3, image, plane);
    end
end 
% image = permute(image, [1 2 3]);

image = double(image);

% size(image);


% push image to GPU memory
input = clijx.pushMat(image);
originalSize = clijx.getSize(input)

% maximum projection
maximumProjected = clijx.create(originalSize(1:2));
clijx.maximumZProjection(input, maximumProjected);

% pull result back from GPU and show it
figure
imshow(clijx.pullMat(maximumProjected), [0 1000]);

% cleanup
maximumProjected.close();
input.close();
