% maximumProjection.m
%
% This script shows how to run CLATLAB for GPU accelerated image processing
% to draw a maximum projection and visualise it in MATLAB.
%
% In order to make this script run, you need to install CLATLAB
%         https://clij.github.io/clatlab/
% 
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize CLATLAB
clatlab = init_clatlab();

% check on which GPU it's running 
string(clatlab.getGPUName())

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
input = clatlab.push(image);
originalSize = clatlab.op().getSize(input)

% maximum projection
maximumProjected = clatlab.create(originalSize(1:2));
clatlab.op().maximumZProjection(input, maximumProjected);

% pull result back from GPU and show it
figure
imshow(clatlab.pull(maximumProjected), [0 1000]);

% cleanup
maximumProjected.close();
input.close();
