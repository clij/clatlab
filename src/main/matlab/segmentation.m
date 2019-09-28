% segmentation.m
%
% This script shows how to run CLATLAB for GPU accelerated image processing
% from MATLAB. It applies blurring, tresholding and connected components
% labelling to an image.
%
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
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
blurred = clatlab.create(input);
thresholded = clatlab.create(input);
labelled = clatlab.create(input);

% blur the image
import java.lang.Float;
clop.blur(input, blurred, Float(5), Float(5));

% apply a threshold to it
clop.automaticThreshold(blurred, thresholded, "Otsu");

% connected components labelling
clop.connectedComponentsLabeling(thresholded, labelled);

% pull result back from GPU and show it next to input
result = clatlab.pull(labelled);
number_of_found_objects = clop.maximumOfAllPixels(labelled);
lookuptable = rand(number_of_found_objects, 3);
subplot(1,2,2), imshow(result, lookuptable);

% clean up
input.close();
blurred.close();
thresholded.close();
labelled.close();

