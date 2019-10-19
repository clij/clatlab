% automaticThreshold.m
%
% This script shows how to run CLATLAB for GPU accelerated image processing
% from MATLAB. It applies tresholding  an image.
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

% show input image in a subplot
figure;
subplot(1,2,1), imshow(img, [0 255]);

% check on which GPU it's running 
string(clatlab.getGPUName())

% push image to GPU memory
input = clatlab.push(img);
% reserve memory for output image
thresholded = clatlab.create(input);

% apply a threshold to it
clop.automaticThreshold(input, thresholded, "Otsu");

% pull result back from GPU and show it next to input
result = clatlab.pull(thresholded);
subplot(1,2,2), imshow(result, [0 1]);

% clean up
input.close();
thresholded.close();

