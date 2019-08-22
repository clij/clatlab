% simplePipeline.m
%
% This script shows how to run CLATLAB for GPU accelerated image processing from MATLAB.
%
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% initialize CLATLAB
clatlab = init_clatlab()

% load example data
filename = '../../test/resources/blobs.tif';
img = imread(filename);
% there are issues with unit8/int8 conversion; 
% thus, we convert the image to double
img = double(img);

% show input image in a subplot
subplot(1,2,1), imshow(img, [0 255]);

% import and initialize CLATLAB
clatlab = net.haesleinhuepf.clatlab.CLATLAB.getInstance();

% check on which GPU it's running 
string(clatlab.getGPUName())

% push image to GPU memory
input = clatlab.push(img);
% reserve memory for output image
output = clatlab.create(input);

% blur the image
import java.lang.Float;
clatlab.op().blur(input, output, Float(5), Float(5));

% pull result back from GPU
result = clatlab.pull(output);

% show result
subplot(1,2,2), imshow(result, [0 255]);

% clean up
input.close();
output.close();

