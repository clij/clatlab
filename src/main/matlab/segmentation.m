% segmentation.m
%
% This script shows how to run CLATLAB for GPU accelerated image processing
% from MATLAB. It applies blurring, tresholding and connected components
% labelling to an image.
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
string(clijx.getGPUName())

% push image to GPU memory
input = clijx.pushMat(img);
% reserve memory for output image
blurred = clijx.create(input);
thresholded = clijx.create(input);
labelled = clijx.create(input);

% blur, threshold and label the image
clijx.blur(input, blurred, 5, 5, 0);
clijx.automaticThreshold(blurred, thresholded, "Otsu");
clijx.connectedComponentsLabeling(thresholded, labelled);


% pull result back from GPU and show it next to input
result = clijx.pullMat(labelled);
number_of_found_objects = clijx.maximumOfAllPixels(labelled);
lookuptable = rand(number_of_found_objects, 3);
subplot(1,2,2), imshow(result, lookuptable);

% clean up
input.close();
blurred.close();
thresholded.close();
labelled.close();

