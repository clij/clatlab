% addImages.m
%
% This script demonstrates basic image math  on the GPU in MATLAB.
%
% Author: Robert Haase, rhaase@mpi-cbg.de
%         October 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% initialize CLATLAB
clatlab = init_clatlab();
clop = clatlab.op;

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
input1 = clatlab.push(img);
input2 = clatlab.push(mat);

% reserve memory for output image
sum_image = clatlab.create(input1);

% add images os GPU
clatlab.op.addImages(input1, input2, sum_image);

% pull result image back
result = clatlab.pull(sum_image);
imshow(result, [0 255]);

% clean up
input1.close();
input2.close();
sum_image.close();



